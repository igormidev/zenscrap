import 'package:collection/collection.dart';
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
    final testData = cacheTestData[sessionId];
    if (testData == null) {
      throw ZenScrapException(
        title: 'Cache Test Data Not Found',
        description: 'No cache test data found for session $sessionId.',
      );
    }

    final responses = await chatController.sendMessage(
      userPromt: userPrompt,
      referenceTestData: testData,
    );

    final NewExtractRuleResponse? lastChat = responses.lastWhereOrNull(
      (response) => response is NewExtractRuleResponse,
    ) as NewExtractRuleResponse?;

    if (lastChat != null) {
      await ReferenceTestData.db.updateRow(
        session,
        lastChat.referenceTestData,
      );
    }

    for (final response in responses) {
      scrapRedraftSessions[sessionId]!.add(response);
    }
  }
}
