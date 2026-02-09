import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/generated/future_calls.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// FutureCall that runs hourly to clean up expired anonymous IP spending records.
///
/// This helps prevent abuse by anonymous users who create multiple sessions
/// to bypass per-session spending limits. After [kAnonymousIpSpendingResetDuration]
/// (7 days), the IP spending record is deleted, allowing the user to use the
/// platform again with a fresh limit.
class CleanupExpiredIpSpendingFutureCall extends FutureCall {
  static const String callName = 'cleanup_expired_ip_spending';
  static const Duration _cleanupInterval = Duration(hours: 1);

  Future<void> run(Session session, [bool? _]) async {
    try {
      // Find all IP spending records that are older than the reset duration
      final expiryThreshold = DateTime.now().subtract(
        kAnonymousIpSpendingResetDuration,
      );

      final expiredRecords = await AnonymousIpSpending.db.find(
        session,
        where: (t) => t.createdAt < expiryThreshold,
      );

      if (expiredRecords.isNotEmpty) {
        // Delete all expired records
        await AnonymousIpSpending.db.delete(session, expiredRecords);

        session.log(
          'Cleaned up ${expiredRecords.length} expired IP spending records '
          '(older than ${kAnonymousIpSpendingResetDuration.inDays} days)',
        );

        // Log each deleted IP for debugging
        for (final record in expiredRecords) {
          session.log(
            'Deleted IP spending record: ${record.ipAddress} '
            '(\$${record.totalSpentUsd.toStringAsFixed(4)} spent, '
            'created ${record.createdAt.toIso8601String()})',
            level: LogLevel.debug,
          );
        }
      } else {
        session.log(
          'No expired IP spending records to clean up',
          level: LogLevel.debug,
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'Error in CleanupExpiredIpSpendingFutureCall',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      // Always reschedule the next cleanup, even if there was an error
      await session.serverpod.futureCalls
          .callWithDelay(_cleanupInterval)
          .cleanupExpiredIpSpending
          .run();

      session.log(
        'Scheduled next IP spending cleanup in ${_cleanupInterval.inMinutes} minutes',
        level: LogLevel.debug,
      );
    }
  }
}
