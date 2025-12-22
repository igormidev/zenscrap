import 'dart:developer' as developer;

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../auth/send_email.dart';
import '../generated/protocol.dart';
import 'auto_fix_email_templates.dart';

/// Service for sending auto-fix related email notifications.
///
/// This service handles all email notifications related to the auto-fix system,
/// including notifications when:
/// - AI repair is started (in_progress)
/// - AI repair succeeds
/// - AI repair fails (exhausted attempts)
/// - Scraper breaks with auto-fix disabled
class AutoFixNotificationService {
  // Base URL for the application - should be configured via environment
  static const String _baseUrl = 'https://zenscrap.com';

  /// Notifies the user that an auto-fix session has started.
  ///
  /// This should be called when an [AutoFixSession] is created with
  /// status = in_progress and the scraper's [AutoFixConfig.enabled] is true.
  static Future<bool> notifyAutoFixStarted({
    required Session session,
    required Scrappable scrappable,
    required AutoFixSession autoFixSession,
  }) async {
    final email = await _getUserEmail(session, scrappable);
    if (email == null) {
      developer.log(
        'Cannot send auto-fix started notification: no email found for scrappable ${scrappable.id}',
        name: 'AutoFixNotificationService',
      );
      return false;
    }

    final htmlMessage = buildAutoFixInProgressEmail(
      scraperName: scrappable.name,
      errorCount: autoFixSession.triggeredAtErrorCount,
      dashboardUrl: _getDashboardUrl(scrappable.id!),
    );

    return sendEmail(
      apiKey: session.passwords['resendApiKey']!,
      destinyEmail: email,
      subject: AutoFixEmailSubjects.inProgress(scrappable.name),
      htmlMessage: htmlMessage,
    );
  }

  /// Notifies the user that an auto-fix session completed successfully.
  ///
  /// This should be called when an [AutoFixSession.status] changes to success.
  static Future<bool> notifyAutoFixSuccess({
    required Session session,
    required Scrappable scrappable,
    required AutoFixSession autoFixSession,
  }) async {
    final email = await _getUserEmail(session, scrappable);
    if (email == null) {
      developer.log(
        'Cannot send auto-fix success notification: no email found for scrappable ${scrappable.id}',
        name: 'AutoFixNotificationService',
      );
      return false;
    }

    // Calculate total time
    final totalTime = _formatDuration(autoFixSession);

    // Count attempts from session
    final attemptCount = autoFixSession.attempts?.length ?? 1;

    final htmlMessage = buildAutoFixSuccessEmail(
      scraperName: scrappable.name,
      successSummary:
          autoFixSession.successSummary ?? 'Updated extraction rules',
      attemptCount: attemptCount,
      totalTime: totalTime,
      dashboardUrl: _getDashboardUrl(scrappable.id!),
      settingsUrl: _getSettingsUrl(),
    );

    return sendEmail(
      apiKey: session.passwords['resendApiKey']!,
      destinyEmail: email,
      subject: AutoFixEmailSubjects.success(scrappable.name),
      htmlMessage: htmlMessage,
    );
  }

  /// Notifies the user that an auto-fix session failed after exhausting all attempts.
  ///
  /// This should be called when an [AutoFixSession.status] changes to exhausted.
  static Future<bool> notifyAutoFixExhausted({
    required Session session,
    required Scrappable scrappable,
    required AutoFixSession autoFixSession,
  }) async {
    final email = await _getUserEmail(session, scrappable);
    if (email == null) {
      developer.log(
        'Cannot send auto-fix exhausted notification: no email found for scrappable ${scrappable.id}',
        name: 'AutoFixNotificationService',
      );
      return false;
    }

    // Count attempts from session
    final attemptCount = autoFixSession.attempts?.length ?? 5;

    final htmlMessage = buildAutoFixExhaustedEmail(
      scraperName: scrappable.name,
      attemptCount: attemptCount,
      failureReason: autoFixSession.failureReason ??
          'Unable to generate valid extraction rules',
      editorUrl: _getEditorUrl(scrappable.id!),
      supportUrl: _getSupportUrl(),
    );

    return sendEmail(
      apiKey: session.passwords['resendApiKey']!,
      destinyEmail: email,
      subject: AutoFixEmailSubjects.exhausted(scrappable.name),
      htmlMessage: htmlMessage,
    );
  }

  /// Notifies the user that their scraper is broken but auto-fix is disabled.
  ///
  /// This should be called when a scraper's consecutive errors reach the threshold
  /// but [AutoFixConfig.enabled] is false.
  static Future<bool> notifyScraperBroken({
    required Session session,
    required Scrappable scrappable,
    required int errorCount,
  }) async {
    final email = await _getUserEmail(session, scrappable);
    if (email == null) {
      developer.log(
        'Cannot send scraper broken notification: no email found for scrappable ${scrappable.id}',
        name: 'AutoFixNotificationService',
      );
      return false;
    }

    final htmlMessage = buildScraperBrokenNoAutoFixEmail(
      scraperName: scrappable.name,
      errorCount: errorCount,
      editorUrl: _getEditorUrl(scrappable.id!),
      enableAutoFixUrl: _getEnableAutoFixUrl(scrappable.id!),
      settingsUrl: _getSettingsUrl(),
    );

    return sendEmail(
      apiKey: session.passwords['resendApiKey']!,
      destinyEmail: email,
      subject: AutoFixEmailSubjects.brokenNoAutoFix(scrappable.name),
      htmlMessage: htmlMessage,
    );
  }

  /// Gets the user's email address from the scrappable's account.
  ///
  /// Flow: Scrappable -> AccountInfo -> UserInfo -> email
  static Future<String?> _getUserEmail(
    Session session,
    Scrappable scrappable,
  ) async {
    final accountId = scrappable.accountId;
    if (accountId == null) {
      developer.log(
        'Scrappable ${scrappable.id} has no accountId',
        name: 'AutoFixNotificationService',
      );
      return null;
    }

    // Fetch AccountInfo
    final accountInfo = await AccountInfo.db.findById(
      session,
      accountId,
    );

    if (accountInfo == null) {
      developer.log(
        'AccountInfo not found for id $accountId',
        name: 'AutoFixNotificationService',
      );
      return null;
    }

    // Fetch user profile using AuthServices
    final userProfile = await AuthServices.instance.userProfiles.findUserProfileByUserId(
      session,
      accountInfo.authUserId,
    );

    return userProfile.email;
  }

  /// Formats the duration of an auto-fix session.
  static String _formatDuration(AutoFixSession session) {
    final completedAt = session.completedAt;
    if (completedAt == null) {
      return 'N/A';
    }

    final duration = completedAt.difference(session.createdAt);

    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // URL generation helpers

  static String _getDashboardUrl(int scrappableId) =>
      '$_baseUrl/dashboard/scrapers/$scrappableId';

  static String _getEditorUrl(int scrappableId) =>
      '$_baseUrl/editor/$scrappableId';

  static String _getSettingsUrl() => '$_baseUrl/settings/notifications';

  static String _getEnableAutoFixUrl(int scrappableId) =>
      '$_baseUrl/dashboard/scrapers/$scrappableId/settings';

  static String _getSupportUrl() => '$_baseUrl/support';
}
