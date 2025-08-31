import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_gemini_api_impl.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/endpoints/public/marketplace_endpoint.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
    _scrapRedraftSessions = {};
final Map<RedraftSrappableSessionId, IChatController> _chatSessions = {};
final Map<RedraftSrappableSessionId, ReferenceTestData> _cacheTestData = {};
final Map<ScrappableId, RedraftSrappableSessionId>
    _scrappableOpenedSessionsIds = {};

String? getTestExtractRules(ScrappableId scrappableId) {
  final ReferenceTestData? testData =
      _cacheTestData[_scrappableOpenedSessionsIds[scrappableId]];
  return testData?.scrappableTestResult?.testExtractRule;
}

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<CreateSessionResponse> createSession(
    Session session, {
    required String scrappableId,
  }) async {
    final Scrappable? scrappable = await Scrappable.db.findById(
      session,
      UuidValue.fromString(scrappableId),
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
          scrappableTestResult: ScrappableTestResult.include(),
        ),
      ),
    );
    final ReferenceTestData? referenceTestData = scrappable?.referenceTestData;
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
    final bool isAlreadyAnyOpenedSession =
        _scrappableOpenedSessionsIds.containsKey(scrappable.id.toString());
    if (isAlreadyAnyOpenedSession) {
      throw ZenScrapException(
        title: 'Session Already Opened',
        description:
            'There is already an opened session for this scrappable.\nPlease close the existing session before creating a new one.',
      );
    }

    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    _scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();
    _chatSessions[sessionUuid] = ChatControllerGeminiApiImpl.create(
      scrappableId: scrappable.id,
      referenceTestData: referenceTestData,
    );
    _cacheTestData[sessionUuid] = referenceTestData;
    final duration = const Duration(hours: 1);
    final response =
        CreateSessionResponse(expiresIn: duration, sessionId: sessionUuid);
    await session.serverpod.futureCallWithDelay(
      'dispose_temporary_scrappable',
      response,
      duration + Duration(minutes: 1),
    );
    await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(
          testEndpointAvailableUntil: DateTime.now().add(duration),
        ));
    return response;
  }

  Stream<ChatResponse> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) {
    session.addWillCloseListener((session) async {
      print('disposed session $sessionUuid');
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

  Future<void> sendPromptMessage(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String userPrompt,
  }) async {
    final chatController = _chatSessions[sessionId];
    if (chatController == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionId.',
      );
    }
    final testData = _cacheTestData[sessionId];
    if (testData == null) {
      throw ZenScrapException(
        title: 'Cache Test Data Not Found',
        description: 'No cache test data found for session $sessionId.',
      );
    }

    final StreamController<ChatResponse> chatSeason =
        StreamController<ChatResponse>();
    final StreamSubscription<ChatResponse> subscription =
        chatSeason.stream.listen((ChatResponse chatResponse) {
      _scrapRedraftSessions[sessionId]?.add(chatResponse);
      if (chatResponse is NewExtractRuleResponse) {
        if (_cacheTestData.containsKey(sessionId)) {
          _cacheTestData[sessionId] = chatResponse.referenceTestData;
        }
      }
    });

    chatSeason.add(MessageTextResponse(
      role: PromptRole.user,
      messageText: userPrompt,
    ));

    try {
      await chatController.sendMessage(
        session: session,
        chatSeason: chatSeason,
        userPromt: userPrompt,
        referenceTestData: testData,
      );
    } catch (e, s) {
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage: 'An error occurred while sending the message: $e',
      ));
      session.log(
        'Error occurred while sending message: $e',
        exception: e,
        level: LogLevel.error,
        stackTrace: s,
      );
      rethrow;
    } finally {
      if (!chatSeason.isClosed) {
        await Future.delayed(const Duration(milliseconds: 300));
        await subscription.cancel();
        await chatSeason.close();
      }
    }
  }
}

Future<void> _disposeSession({
  required RedraftSrappableSessionId sessionId,
}) async {
  _chatSessions.remove(sessionId);
  final subject = _scrapRedraftSessions.remove(sessionId);
  await subject?.close();
  _cacheTestData.remove(sessionId);
  _scrappableOpenedSessionsIds.remove(sessionId);
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
