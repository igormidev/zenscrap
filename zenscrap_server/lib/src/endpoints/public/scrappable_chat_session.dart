import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
    scrapRedraftSessions = {};
final Map<RedraftSrappableSessionId, ChatController> chatSessions = {};
final Map<RedraftSrappableSessionId, ReferenceTestData> cacheTestData = {};

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<void> createSession(
    Session session, {
    required Scrappable scrappable,
  }) async {
    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();
    chatSessions[sessionUuid] = ChatController.create();
  }

  Stream<ChatResponse> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) {
    final subject = scrapRedraftSessions[sessionUuid];
    if (subject == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionUuid.',
      );
    }
    return subject.stream;
  }

  Future<void> disposeSession(
    Session session, {
    required RedraftSrappableSessionId sessionId,
  }) async {
    chatSessions.remove(sessionId);
    final subject = scrapRedraftSessions.remove(sessionId);
    await subject?.close();
    cacheTestData.remove(sessionId);
  }

  Future<void> sendPromptMessage(
    Session session, {
    required RedraftSrappableSessionId sessionId,
    required String userPrompt,
  }) async {
    session.addWillCloseListener((session) async {
      await disposeSession(session, sessionId: sessionId);
    });

    final chatController = chatSessions[sessionId];
    if (chatController == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionId.',
      );
    }
    final testData = cacheTestData[sessionId];
    if (testData == null) {
      throw ZenScrapException(
        title: 'Cache Test Data Not Found',
        description: 'No cache test data found for session $sessionId.',
      );
    }

    final StreamController<ChatResponse> chatSeason =
        StreamController<ChatResponse>();
    final StreamSubscription<ChatResponse> subscription =
        chatSeason.stream.listen((ChatResponse chatResponse) {});
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
        await subscription.cancel();
        await chatSeason.close();
      }

      await disposeSession(session, sessionId: sessionId);
    }
  }
}
