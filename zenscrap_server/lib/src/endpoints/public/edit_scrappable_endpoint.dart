import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class EditScrappableEndpoint extends Endpoint {
  Future<bool> call(
    Session session, {
    required int scrappableId,
    required String name,
    required String description,
    required SupportedLanguage language,
    ScraperCategory? category,
    bool? willHideFromMarketplace,
  }) async {
    // Get the authenticated user ID (might be null if not logged in)
    final userId = session.authenticated?.userId;

    // Find the scrappable
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
    );

    if (scrappable == null) {
      throw createTranslatedException('scrappable_not_found', language);
    }

    // Check permissions
    if (scrappable.accountId != null) {
      // Scrappable has an owner - check if current user is the owner
      if (userId == null) {
        throw createTranslatedException('authentication_required_edit', language);
      }

      // Get the account info for the logged-in user
      final userAccount = await AccountInfo.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(userId),
      );

      if (userAccount == null || userAccount.id != scrappable.accountId) {
        throw createTranslatedException('permission_denied_edit', language);
      }
    }
    // If scrappable.accountId is null, anyone can edit it (no owner)

    // Validate input
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();

    if (trimmedName.isEmpty) {
      throw createTranslatedException('invalid_name', language);
    }

    if (trimmedName.length > 50) {
      throw createTranslatedException(
        'name_too_long',
        language,
        params: {'maxLength': '50'},
      );
    }

    if (trimmedDescription.isEmpty) {
      throw createTranslatedException('invalid_description', language);
    }

    if (trimmedDescription.length > 220) {
      throw createTranslatedException(
        'description_too_long',
        language,
        params: {'maxLength': '220'},
      );
    }

    // Update the scrappable
    scrappable.name = trimmedName;
    scrappable.description = trimmedDescription;

    // Update category if provided
    if (category != null) {
      scrappable.category = category;
    }
    scrappable.generalInfosUpdatedAt = DateTime.now();

    // Update willHideFromMarketplace if provided
    if (willHideFromMarketplace != null) {
      // Check if user has Ultra plan permission
      if (userId == null) {
        throw createTranslatedException('authentication_required_marketplace', language);
      }

      // Get the account info for plan check
      final userAccount = await AccountInfo.db.findFirstRow(
        session,
        where: (p) => p.userInfoId.equals(userId),
      );

      if (userAccount == null || userAccount.planTier != PlanTier.ultra) {
        throw createTranslatedException('ultra_plan_required_marketplace', language);
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
      throw createTranslatedException('update_failed', language);
    }
  }
}
