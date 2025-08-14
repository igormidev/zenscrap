import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ChatResponse>>
    scrapRedraftSessions = {};

class ScrappableChatSession extends Endpoint {
  final Uuid uuid = Uuid();

  Future<void> createSession(
    Session session, {
    required Scrappable scrappable,
  }) async {
    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    scrapRedraftSessions[sessionUuid] = ReplaySubject<ChatResponse>();
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
  }) async {}
}
