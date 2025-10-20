import 'dart:async';
import 'package:collection/collection.dart';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_claude_code_sdk_impl.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_codex_sdk_impl.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
typedef ThinkingSessionId = String;

final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
    _scrapRedraftSessions = {};
final Map<ThinkingSessionId, StreamController<String>> _thinkingStream = {};
final Map<RedraftSrappableSessionId, IChatController> _chatSessions = {};
final Map<int, RedraftSrappableSessionId> _scrappableOpenedSessionsIds = {};
final Map<RedraftSrappableSessionId, int> _cacheScrappableIds = {};
final Map<RedraftSrappableSessionId, ReferenceTestData> _cacheRefTestData = {};
final Map<RedraftSrappableSessionId, ScrappingBeeExtractLogic?>
    _cacheScrappingBeeExtractLogic = {};
final Map<RedraftSrappableSessionId, ScrappableRequest>
    _cacheScrappableRequest = {};

ScrappingBeeExtractLogic? getTestExtractRules(int scrappableId) {
  return _cacheScrappingBeeExtractLogic[
      _scrappableOpenedSessionsIds[scrappableId]];
}

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<void> commitCurrentEditState(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) async {
    final int? scrappableId = _cacheScrappableIds[sessionUuid];
    if (scrappableId == null) {
      throw ZenScrapException(
        title: 'Cache Scrappable ID Not Found',
        description: 'No cache scrappable ID found for session $sessionUuid.',
      );
    }
    final int? userId = (await session.authenticated)?.userId;
    final ReferenceTestData? testData = _cacheRefTestData[sessionUuid];
    final ScrappingBeeExtractLogic? scrappingBeeExtractLogic =
        _cacheScrappingBeeExtractLogic[sessionUuid];
    final ScrappableRequest? scrappableRequest =
        _cacheScrappableRequest[sessionUuid];
    if (testData == null ||
        scrappingBeeExtractLogic == null ||
        scrappableRequest == null) {
      throw ZenScrapException(
        title: 'Cache Test Data Not Found',
        description: 'No cache test data found for session $sessionUuid.',
      );
    }
    await session.db.transaction((transaction) async {
      try {
        final Scrappable? scrappable;
        if (userId == null) {
          // If not authenticated, should only be able to modify scrappables that are not attached to any account
          scrappable = await Scrappable.db.findFirstRow(session,
              where: (t) =>
                  t.id.equals(scrappableId) & t.accountId.equals(null),
              transaction: transaction);
        } else {
          final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
            session,
            where: (p0) => p0.userInfoId.equals(userId),
            transaction: transaction,
          );
          final accountId = accountInfo?.id;

          scrappable = await Scrappable.db.findFirstRow(session,
              where: (t) =>
                  t.id.equals(scrappableId) & t.accountId.equals(accountId),
              transaction: transaction);

          if (scrappable == null) {
            throw defaultAuthenticationException;
          }
        }

        if (scrappable == null) {
          throw ZenScrapException(
            title: 'Scrappable Not Found or Access Denied',
            description:
                'Unable to find scrappable with id $scrappableId or you do not have permission to modify it.',
          );
        }

        await Scrappable.db.updateRow(
            session,
            scrappable.copyWith(
              extractRulesUpdatedAt: DateTime.now(),
            ),
            transaction: transaction);

        await ScrappingBeeExtractLogic.db.updateRow(
            session, scrappingBeeExtractLogic,
            transaction: transaction);
        await ScrappableRequest.db
            .updateRow(session, scrappableRequest, transaction: transaction);
        await ByteTestData.db
            .updateRow(session, testData.byteData!, transaction: transaction);
        await ReferenceTestData.db
            .updateRow(session, testData, transaction: transaction);
        print('Committed changes for scrappable $scrappableId');
      } catch (e, s) {
        session.log(
          'Failed to commit changes for session $sessionUuid',
          exception: e,
          stackTrace: s,
          level: LogLevel.error,
        );
        rethrow;
      }
    });
  }

  Future<void> disposeSession(
    Session session, {
    required RedraftSrappableSessionId sessionId,
  }) {
    return _disposeSession(sessionId: sessionId);
  }

  Future<CreateSessionResponse> createSession(
    Session session, {
    required int scrappableId,
  }) async {
    final int? userId = (await session.authenticated)?.userId;
    final Scrappable? scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    final ReferenceTestData? referenceTestData = scrappable?.referenceTestData;
    final ScrappableRequest? scrapperRequest = scrappable?.targetRequest;
    final ScrappingBeeExtractLogic? scrappingBeeExtractLogic =
        scrappable?.scrappingBeeExtractRules;
    if (scrappable == null) {
      session.log(
        'No scrappable found with id $scrappableId.',
        level: LogLevel.error,
      );
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'No scrappable found with id $scrappableId.',
      );
    }

    final doesScrappableHasOwner = scrappable.accountId != null;
    if (doesScrappableHasOwner) {
      final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.userInfoId.equals(userId),
      );
      if (accountInfo == null || accountInfo.id != scrappable.accountId) {
        throw ZenScrapException(
          title: 'Authentication Required',
          description:
              'You must be the owner of this scrappable to create a session for it.',
        );
      }
    }

    if (referenceTestData == null) {
      session.log(
        'No reference test data found for scrappable with id ${scrappable.id}.',
        level: LogLevel.error,
      );
      throw ZenScrapException(
        title: 'Reference Test Data Not Found',
        description:
            'No reference test data found for scrappable with id ${scrappable.id}.',
      );
    }
    if (scrapperRequest == null) {
      session.log(
        'No target request found for scrappable with id ${scrappable.id}.',
        level: LogLevel.error,
      );
      throw ZenScrapException(
        title: 'Target Request Not Found',
        description:
            'No target request found for scrappable with id ${scrappable.id}.',
      );
    }
    final bool isAlreadyAnyOpenedSession =
        _scrappableOpenedSessionsIds.containsKey(scrappable.id!);
    if (isAlreadyAnyOpenedSession) {
      throw ZenScrapException(
        title: 'Session Already Opened',
        description:
            'There is already an opened session for this scrappable.\nPlease close the existing session before creating a new one.',
      );
    }

    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    _scrappableOpenedSessionsIds[scrappable.id!] = sessionUuid;
    _scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();
    _chatSessions[sessionUuid] = ChatControllerCodexSdkImpl.startChat(
      // _chatSessions[sessionUuid] = ChatControllerClaudeCodeSdkImpl.startChat(
      scrappableId: scrappable.id!,
      scrapperRequest: scrapperRequest,
      referenceTestData: referenceTestData,
      currentFetchSettings: scrappable.scrappingBeeExtractRules,
    );
    _cacheRefTestData[sessionUuid] = referenceTestData;
    _cacheScrappingBeeExtractLogic[sessionUuid] = scrappingBeeExtractLogic;
    _cacheScrappableRequest[sessionUuid] = scrapperRequest;
    final duration = const Duration(hours: 1);
    final response = CreateSessionResponse(
      expiresIn: duration,
      sessionId: sessionUuid,
    );
    session.log('Created session $sessionUuid for scrappable ${scrappable.id}');
    await session.serverpod.futureCallWithDelay(
      'dispose_temporary_scrappable',
      response,
      duration + Duration(minutes: 1),
    );
    session.log('Scheduled dispose for session $sessionUuid');
    _cacheScrappableIds[sessionUuid] = scrappable.id!;
    await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(
            testEndpointAvailableUntil: DateTime.now().add(duration)));
    session.log('Updated scrappable ${scrappable.id} expiration');
    return response;
  }

  Stream<ChatResponse> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) {
    session.log('Listening to session $sessionUuid');
    session.addWillCloseListener((session) async {
      await _disposeSession(sessionId: sessionUuid);
    });
    final subject = _scrapRedraftSessions[sessionUuid];
    if (subject == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionUuid.',
      );
    }
    return subject.stream;
  }

  Future<void> changeChatModel(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
    required AiModel aiModel,
  }) async {
    final sessionNotFount = ZenScrapException(
      title: 'Session Not Found',
      description: 'No active session found for uuid $sessionUuid.',
    );
    if (_chatSessions.containsKey(sessionUuid) == false) {
      throw sessionNotFount;
    }
    final scrappableId = _scrappableOpenedSessionsIds.entries
        .firstWhereOrNull((element) => element.value == sessionUuid)
        ?.key;
    if (scrappableId == null) {
      throw sessionNotFount;
    }

    // Validate plan for powerful model
    if (aiModel == AiModel.powerful) {
      final authenticationInfo = await session.authenticated;
      if (authenticationInfo == null) {
        throw ZenScrapException(
          title: 'Authentication Required',
          description: 'You must be logged in to use Gemini 2.5 Pro.',
        );
      }

      final userId = authenticationInfo.userId;
      final account = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(userId),
      );

      if (account == null) {
        throw ZenScrapException(
          title: 'Account Not Found',
          description: 'Could not find account information.',
        );
      }

      // Check if user has at least Pro plan
      if (account.planTier == PlanTier.none ||
          account.planTier == PlanTier.basic) {
        throw ZenScrapException(
          title: 'Upgrade Required',
          description:
              'You need at least a Pro plan to use Gemini 2.5 Pro. Upgrade your plan to access advanced AI models.',
        );
      }
    }

    _chatSessions.remove(sessionUuid);
    await _chatSessions[sessionUuid]?.changeModel(aiModel);
  }

  Stream<String> sendPromptMessage(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String userPrompt,
  }) async* {
    session.log('Received message for session $sessionId');
    final chatController = _chatSessions[sessionId];
    if (chatController == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionId.',
      );
    }

    if (!_cacheRefTestData.containsKey(sessionId) ||
        !_cacheScrappableRequest.containsKey(sessionId) ||
        !_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
      throw ZenScrapException(
        title: 'Cache Test Data Not Found',
        description: 'No cache test data found for session $sessionId.',
      );
    }

    final ThinkingSessionId thinkingSessionId = uuid.v7();
    _thinkingStream[thinkingSessionId] = StreamController<ThinkingSessionId>();

    // Put future call
    await session.serverpod.futureCallWithDelay(
      'session_prompt',
      SessionPrompt(
        sessionId: sessionId,
        userPrompt: userPrompt,
        thinkingSessionId: thinkingSessionId,
      ),
      const Duration(seconds: 1),
    );

    yield* _thinkingStream[thinkingSessionId]!.stream;
  }
}

Future<void> disposeFromScrappableId(int scrappableId) async {
  final sessionId = _scrappableOpenedSessionsIds[scrappableId];
  if (sessionId != null) await _disposeSession(sessionId: sessionId);
}

Future<void> _disposeSession({
  required RedraftSrappableSessionId sessionId,
}) async {
  _chatSessions.remove(sessionId);
  final subject = _scrapRedraftSessions.remove(sessionId);
  await subject?.close();
  _cacheScrappableIds.remove(sessionId);
  _cacheRefTestData.remove(sessionId);
  _cacheScrappingBeeExtractLogic.remove(sessionId);
  _cacheScrappableRequest.remove(sessionId);
  _scrappableOpenedSessionsIds.removeWhere((key, value) => value == sessionId);
}

class TestScrappableDisposeFutureCall
    extends FutureCall<CreateSessionResponse> {
  @override
  Future<void> invoke(
    Session session,
    CreateSessionResponse? object,
  ) async {
    if (object == null) return;
    await _disposeSession(sessionId: object.sessionId);
  }
}

class SessionPromptFutureCall extends FutureCall<SessionPrompt> {
  @override
  Future<void> invoke(Session session, SessionPrompt? object) async {
    if (object == null) return;
    final ThinkingSessionId thinkingSessionId = object.thinkingSessionId;
    final String sessionId = object.sessionId;
    final String userPrompt = object.userPrompt;

    final chatController = _chatSessions[sessionId];
    if (chatController == null) {
      _scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage: 'Session not found or has been closed.',
        ),
      );
      return;
    }

    final testData = _cacheRefTestData[sessionId];
    final scrapperRequest = _cacheScrappableRequest[sessionId];
    final scrappingBeeExtractLogic = _cacheScrappingBeeExtractLogic[sessionId];
    if (testData == null ||
        scrapperRequest == null ||
        !_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
      _scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage: 'Session test data not found or has been closed.',
        ),
      );
      return;
    }

    final StreamController<String> llmThinking = StreamController<String>();
    final StreamController<ChatResponse> chatSeason =
        StreamController<ChatResponse>();

    final StreamSubscription<ChatResponse> subsChatSeason =
        chatSeason.stream.listen((ChatResponse chatResponse) {
      _scrapRedraftSessions[sessionId]?.add(chatResponse);
      if (chatResponse is NewExtractRuleResponse) {
        if (_cacheRefTestData.containsKey(sessionId)) {
          _cacheRefTestData[sessionId] = chatResponse.referenceTestData;
        }
        if (_cacheScrappableRequest.containsKey(sessionId)) {
          _cacheScrappableRequest[sessionId] = chatResponse.scrapperRequest;
        }
        if (_cacheScrappingBeeExtractLogic.containsKey(sessionId)) {
          _cacheScrappingBeeExtractLogic[sessionId] =
              chatResponse.scrappingBeeExtractLogic;
        }
      }
    });

    final StreamSubscription<String> subLlmThinking = llmThinking.stream.listen(
      (event) {
        _thinkingStream[thinkingSessionId]?.add(event);
      },
    );

    chatSeason.add(MessageTextResponse(
      role: PromptRole.user,
      messageText: userPrompt,
    ));

    try {
      await chatController.sendMessage(
        session: session,
        chatSeason: chatSeason,
        userPrompt: userPrompt,
        referenceTestData: testData,
        scrapperRequest: scrapperRequest,
        scrappingBeeExtractLogic: scrappingBeeExtractLogic,
        thinkingStream: llmThinking,
      );
    } catch (e, s) {
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage: 'An error occurred while sending the message:\n$e',
      ));
      session.log(
        'Error occurred while sending message: $e',
        exception: e,
        level: LogLevel.error,
        stackTrace: s,
      );
      rethrow;
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!chatSeason.isClosed) {
        await subsChatSeason.cancel();
        await chatSeason.close();
      }
      if (!llmThinking.isClosed) {
        await subLlmThinking.cancel();
        await llmThinking.close();
      }

      await _thinkingStream[thinkingSessionId]?.close();
      _thinkingStream.remove(thinkingSessionId);
    }
  }
}
