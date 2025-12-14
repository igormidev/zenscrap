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
    // Auto-fix configuration parameters
    bool? autoFixEnabled,
    int? autoFixConsecutiveErrorThreshold,
    AiModel? autoFixPreferredAiModel,
    // Special value to indicate "auto mode" (null preference) for AI model
    // When true, sets preferredAiModel to null (auto mode)
    bool? autoFixUseAutoAiModel,
  }) async {
    // Get the authenticated user ID (might be null if not logged in)
    final userId = session.authenticated?.userId;

    // Find the scrappable with its AutoFixConfig
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        autoFixConfig: AutoFixConfig.include(),
      ),
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

      // Update AutoFixConfig if parameters provided and config exists
      final autoFixConfig = scrappable.autoFixConfig;
      if (autoFixConfig != null) {
        final hasAutoFixChanges = autoFixEnabled != null ||
            autoFixConsecutiveErrorThreshold != null ||
            autoFixPreferredAiModel != null ||
            autoFixUseAutoAiModel != null;

        if (hasAutoFixChanges) {
          // Validate consecutive error threshold if provided
          if (autoFixConsecutiveErrorThreshold != null) {
            if (autoFixConsecutiveErrorThreshold < 1) {
              throw createTranslatedException(
                'auto_fix_threshold_too_low',
                language,
              );
            }
            if (autoFixConsecutiveErrorThreshold > 1000) {
              throw createTranslatedException(
                'auto_fix_threshold_too_high',
                language,
              );
            }
          }

          // Update the config fields
          if (autoFixEnabled != null) {
            autoFixConfig.enabled = autoFixEnabled;
          }
          if (autoFixConsecutiveErrorThreshold != null) {
            autoFixConfig.consecutiveErrorThreshold =
                autoFixConsecutiveErrorThreshold;
          }
          // Handle AI model preference
          if (autoFixUseAutoAiModel == true) {
            // Set to null for auto mode
            autoFixConfig.preferredAiModel = null;
          } else if (autoFixPreferredAiModel != null) {
            autoFixConfig.preferredAiModel = autoFixPreferredAiModel;
          }

          await AutoFixConfig.db.updateRow(session, autoFixConfig);

          session.log(
            'Updated AutoFixConfig for scrappable ${scrappable.id}: '
            'enabled=${autoFixConfig.enabled}, '
            'threshold=${autoFixConfig.consecutiveErrorThreshold}, '
            'aiModel=${autoFixConfig.preferredAiModel}',
            level: LogLevel.info,
          );
        }
      }

      return true;
    } catch (e) {
      session.log(
        'Failed to update scrappable: $e',
        level: LogLevel.error,
      );
      if (e is ZenScrapException) {
        rethrow;
      }
      throw createTranslatedException('update_failed', language);
    }
  }
}
