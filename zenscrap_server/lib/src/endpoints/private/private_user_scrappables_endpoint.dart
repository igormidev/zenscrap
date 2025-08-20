import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateUserScrappablesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Scrappable>> call(Session session) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw ZenScrapException(
        title: 'User Not Authenticated',
        description: 'You must be logged in to access your scrappables.',
      );
    }

    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(session,
        where: (p0) => p0.userInfoId.equals(userId),
        include: AccountInfo.include(
          scrappables: Scrappable.includeList(
            include: Scrappable.include(
              targetRequest: ScrappableRequest.include(),
            ),
          ),
        ));
    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account found for the authenticated user.',
      );
    }

    return accountInfo.scrappables ?? <Scrappable>[];
  }
}
