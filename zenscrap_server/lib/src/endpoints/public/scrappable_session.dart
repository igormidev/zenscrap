import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ZenScrapRedraftState>>
    scrapRedraftSessions = {};

class ScrappableSessionEndpoint extends Endpoint {
  final Uuid uuid = Uuid();

  Stream<ZenScrapRedraftState> listenToScrappableRedraftSession(
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

  Future<void> sendRedraftState(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) async {
    scrapRedraftSessions[sessionUuid];
  }
}
