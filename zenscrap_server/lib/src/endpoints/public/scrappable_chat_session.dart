import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
    _scrapRedraftSessions = {};
final Map<RedraftSrappableSessionId, ChatController> chatSessions = {};
final Map<RedraftSrappableSessionId, ReferenceTestData> _cacheTestData = {};

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<RedraftSrappableSessionId> createSession(
    Session session, {
    required Scrappable scrappable,
  }) async {
    final ReferenceTestData? referenceTestData =
        (scrappable.referenceTestData ??
            await ReferenceTestData.db.findFirstRow(
              session,
              where: (p0) =>
                  p0.scrappable.id.equals(scrappable.id) |
                  p0.id.equals(scrappable.referenceTestDataId),
            ));
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
    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    _scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();
    chatSessions[sessionUuid] = ChatController.create(
      scrappableId: scrappable.id,
      referenceTestData: referenceTestData,
    );
    _cacheTestData[sessionUuid] = referenceTestData;
    return sessionUuid;
  }

  Stream<ChatResponse> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) {
    session.addWillCloseListener((session) async {
      await _disposeSession(session, sessionId: sessionUuid);
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

  Future<void> _disposeSession(
    Session session, {
    required RedraftSrappableSessionId sessionId,
  }) async {
    chatSessions.remove(sessionId);
    final subject = _scrapRedraftSessions.remove(sessionId);
    await subject?.close();
    _cacheTestData.remove(sessionId);
  }

  Future<void> sendPromptMessage(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String userPrompt,
  }) async {
    final chatController = chatSessions[sessionId];
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
    } finally {
      if (!chatSeason.isClosed) {
        await Future.delayed(const Duration(milliseconds: 300));
        await subscription.cancel();
        await chatSeason.close();
      }
    }
  }
}
