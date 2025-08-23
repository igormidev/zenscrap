import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class MarketplaceEndpoint extends Endpoint {
  Future<List<Scrappable>> getItems(Session session) async {
    return Scrappable.db.find(
      session,
      where: (s) => s.isPrivate.equals(false),
      // order by most recent created at
      orderBy: (p0) => p0.createdAt,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
      ),
    );
  }
}
