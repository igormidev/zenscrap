import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:zenscrap_server/src/generated/future_calls.dart';

/// Periodic cleanup of expired email authentication data.
///
/// This FutureCall runs daily to clean up:
/// - Expired account registration requests (users who started but never completed registration)
/// - Expired password reset requests (requests that were never completed)
/// - Old failed login attempts (older than 30 days, used for rate limiting)
///
/// This helps prevent database bloat and performance issues by removing
/// stale authentication data that is no longer needed.
class EmailIdpCleanupFutureCall extends FutureCall {
  static const String callName = 'email_idp_cleanup';
  static const Duration _cleanupInterval = Duration(days: 1);
  static const Duration _failedLoginAttemptsMaxAge = Duration(days: 30);

  Future<void> run(Session session, [bool? _]) async {
    session.log('Starting Email IDP cleanup...');

    try {
      final admin = AuthServices.instance.emailIdp.admin;

      // Delete expired account registration requests
      await admin.deleteExpiredAccountRequests(session);
      session.log(
        'Deleted expired account registration requests',
        level: LogLevel.debug,
      );

      // Delete expired password reset requests
      await admin.deleteExpiredPasswordResetRequests(session);
      session.log(
        'Deleted expired password reset requests',
        level: LogLevel.debug,
      );

      // Delete old failed login attempts (older than 30 days)
      await admin.deleteFailedLoginAttempts(
        session,
        olderThan: _failedLoginAttemptsMaxAge,
      );
      session.log(
        'Deleted failed login attempts older than ${_failedLoginAttemptsMaxAge.inDays} days',
        level: LogLevel.debug,
      );

      session.log('Email IDP cleanup completed successfully.');
    } catch (e, stackTrace) {
      session.log(
        'Email IDP cleanup failed',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      // Always reschedule the next cleanup, even if there was an error
      await session.serverpod.futureCalls
          .callWithDelay(_cleanupInterval)
          .emailIdpCleanup
          .run();

      session.log(
        'Scheduled next Email IDP cleanup in ${_cleanupInterval.inDays} day(s)',
        level: LogLevel.debug,
      );
    }
  }
}
