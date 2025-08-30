import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class EditScrappableEndpoint extends Endpoint {
  Future<bool> call(
    Session session, {
    required String scrappableId,
    required String name,
    required String description,
    ScraperCategory? category,
    bool? willHideFromMarketplace,
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

    // Check permissions
    if (scrappable.accountId != null) {
      // Scrappable has an owner - check if current user is the owner
      if (userId == null) {
        throw ZenScrapException(
          title: 'Authentication Required',
          description: 'You must be logged in to edit this scrappable.',
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
          description: 'You do not have permission to edit this scrappable.',
        );
      }
    }
    // If scrappable.accountId is null, anyone can edit it (no owner)

    // Validate input
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();

    if (trimmedName.isEmpty) {
      throw ZenScrapException(
        title: 'Invalid Name',
        description: 'Scrappable name cannot be empty.',
      );
    }

    if (trimmedName.length > 50) {
      throw ZenScrapException(
        title: 'Name Too Long',
        description: 'Scrappable name must be 50 characters or less.',
      );
    }

    if (trimmedDescription.isEmpty) {
      throw ZenScrapException(
        title: 'Invalid Description',
        description: 'Scrappable description cannot be empty.',
      );
    }

    if (trimmedDescription.length > 220) {
      throw ZenScrapException(
        title: 'Description Too Long',
        description: 'Scrappable description must be 220 characters or less.',
      );
    }

    // Update the scrappable
    scrappable.name = trimmedName;
    scrappable.description = trimmedDescription;
    
    // Update category if provided
    if (category != null) {
      scrappable.category = category;
    }
    
    // Update willHideFromMarketplace if provided
    if (willHideFromMarketplace != null) {
      // Check if user has Ultra plan permission
      if (userId == null) {
        throw ZenScrapException(
          title: 'Authentication Required',
          description: 'You must be logged in to hide scrappables from marketplace.',
        );
      }
      
      // Get the account info for plan check
      final userAccount = await AccountInfo.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(userId),
      );
      
      if (userAccount == null || userAccount.planTier != PlanTier.ultra) {
        throw ZenScrapException(
          title: 'Ultra Plan Required',
          description: 'Hiding scrappables from marketplace is only available for Ultra plan users.',
        );
      }
      
      scrappable.willHideFromMarketplace = willHideFromMarketplace;
    }

    try {
      await Scrappable.db.updateRow(session, scrappable);
      return true;
    } catch (e) {
      session.log(
        'Failed to update scrappable: $e',
        level: LogLevel.error,
      );
      throw ZenScrapException(
        title: 'Update Failed',
        description: 'Failed to update the scrappable. Please try again.',
      );
    }
  }
}
