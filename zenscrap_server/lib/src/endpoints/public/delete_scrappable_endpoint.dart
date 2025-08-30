import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class DeleteScrappableEndpoint extends Endpoint {
  Future<bool> call(
    Session session, {
    required String scrappableId,
  }) async {
    // Get the authenticated user ID (might be null if not logged in)
    final userId = (await session.authenticated)?.userId;

    // Parse the UUID
    final UuidValue scrappableUuid;
    try {
      scrappableUuid = UuidValue.fromString(scrappableId);
    } catch (e) {
      throw ZenScrapException(
        title: 'Invalid Scrappable ID',
        description: 'The provided scrappable ID is not valid.',
      );
    }

    // Find the scrappable
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableUuid,
    );

    if (scrappable == null) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The scrappable with the provided ID does not exist.',
      );
    }

    // Check if already deleted
    if (scrappable.isDeleted == true) {
      throw ZenScrapException(
        title: 'Already Deleted',
        description: 'This scrappable has already been deleted.',
      );
    }

    // Check permissions
    if (scrappable.accountId != null) {
      // Scrappable has an owner - check if current user is the owner
      if (userId == null) {
        throw ZenScrapException(
          title: 'Authentication Required',
          description: 'You must be logged in to delete this scrappable.',
        );
      }

      // Get the account info for the logged-in user
      final userAccount = await AccountInfo.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(userId),
      );

      if (userAccount == null || userAccount.id != scrappable.accountId) {
        throw ZenScrapException(
          title: 'Permission Denied',
          description: 'You do not have permission to delete this scrappable.',
        );
      }
    }

    // Perform soft delete
    scrappable.isDeleted = true;

    try {
      await Scrappable.db.updateRow(session, scrappable);
      return true;
    } catch (e) {
      session.log(
        'Failed to delete scrappable: $e',
        level: LogLevel.error,
      );
      throw ZenScrapException(
        title: 'Delete Failed',
        description: 'Failed to delete the scrappable. Please try again.',
      );
    }
  }
}