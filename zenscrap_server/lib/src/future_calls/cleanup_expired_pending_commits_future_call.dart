import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/generated/future_calls.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// FutureCall that runs hourly to clean up expired pending session commit records.
///
/// When a chat session expires (after 1 hour), the cached data is saved to the
/// database so users can still deploy their changes. This cleanup ensures that
/// stale pending commits (older than 24 hours) are deleted to prevent database bloat.
class CleanupExpiredPendingCommitsFutureCall extends FutureCall {
  static const String callName = 'cleanup_expired_pending_commits';

  Future<void> run(Session session, [bool? placeholder]) async {
    try {
      // Find all pending commit records older than the max age
      final expiryThreshold = DateTime.now().subtract(
        kPendingSessionCommitMaxAge,
      );

      final expiredRecords = await PendingSessionCommit.db.find(
        session,
        where: (t) => t.createdAt < expiryThreshold,
      );

      if (expiredRecords.isNotEmpty) {
        // Delete all expired records
        await PendingSessionCommit.db.delete(session, expiredRecords);

        session.log(
          'Cleaned up ${expiredRecords.length} expired pending session commit records '
          '(older than ${kPendingSessionCommitMaxAge.inHours} hours)',
        );

        // Log each deleted session for debugging
        for (final record in expiredRecords) {
          session.log(
            'Deleted pending commit: session=${record.sessionId}, '
            'scrappableId=${record.scrappableId}, '
            'created=${record.createdAt.toIso8601String()}',
            level: LogLevel.debug,
          );
        }
      } else {
        session.log(
          'No expired pending session commit records to clean up',
          level: LogLevel.debug,
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'Error in CleanupExpiredPendingCommitsFutureCall',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      // Always reschedule the next cleanup, even if there was an error
      await session.serverpod.futureCalls
          .callWithDelay(kPendingSessionCommitCleanupInterval)
          .cleanupExpiredPendingCommits
          .run();

      session.log(
        'Scheduled next pending commits cleanup in ${kPendingSessionCommitCleanupInterval.inMinutes} minutes',
        level: LogLevel.debug,
      );
    }
  }
}
