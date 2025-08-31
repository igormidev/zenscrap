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
              referenceTestData: ReferenceTestData.include(
                scrappableTestResult: ScrappableTestResult.include(),
              ),
            ),
          ),
        ));
    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account found for the authenticated user.',
      );
    }

    // Filter out deleted scrappables
    final scrappables = accountInfo.scrappables ?? <Scrappable>[];
    return scrappables.where((s) => s.isDeleted != true).toList();
  }

  Future<Scrappable> getScrappableById(
      Session session, String scrappableId) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw ZenScrapException(
        title: 'User Not Authenticated',
        description: 'You must be logged in to access your scrappables.',
      );
    }

    // Parse the UUID string
    final uuid = UuidValue.fromString(scrappableId);

    // First check if the user owns this scrappable
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account found for the authenticated user.',
      );
    }

    // Find the scrappable with all necessary includes
    final scrappable = await Scrappable.db.findById(
      session,
      uuid,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
          scrappableTestResult: ScrappableTestResult.include(),
        ),
      ),
    );

    if (scrappable == null) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The requested scrappable does not exist.',
      );
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The requested scrappable does not exist.',
      );
    }

    // Verify the user owns this scrappable
    if (scrappable.accountId != accountInfo.id) {
      throw ZenScrapException(
        title: 'Access Denied',
        description: 'You do not have permission to access this scrappable.',
      );
    }

    return scrappable;
  }
}
