import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class DeleteScrappableEndpoint extends Endpoint {
  Future<bool> call(
    Session session, {
    required int scrappableId,
    required SupportedLanguage language,
  }) async {
    // Get the authenticated user ID (might be null if not logged in)
    final userId = session.authenticated?.authUserId;

    // Find the scrappable
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
    );

    if (scrappable == null) {
      throw createTranslatedException('scrappable_not_found', language);
    }

    // Check if already deleted
    if (scrappable.isDeleted == true) {
      throw createTranslatedException('already_deleted', language);
    }

    // Check permissions
    if (scrappable.accountId != null) {
      // Scrappable has an owner - check if current user is the owner
      if (userId == null) {
        throw createTranslatedException('authentication_required_delete', language);
      }

      // Get the account info for the logged-in user
      final userAccount = await AccountInfo.db.findFirstRow(
        session,
        where: (p) => p.authUserId.equals(userId),
      );

      if (userAccount == null || userAccount.id != scrappable.accountId) {
        throw createTranslatedException('permission_denied_delete', language);
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
      throw createTranslatedException('delete_failed', language);
    }
  }
}