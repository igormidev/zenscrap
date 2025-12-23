import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// FutureCall that runs every 24 hours to clean up expired IP validation cache entries.
///
/// Entries older than 72 hours are deleted to ensure fresh validation data
/// while minimizing API calls to ipapi.is.
class CleanupExpiredIpValidationCacheFutureCall extends FutureCall {
  static const String callName = 'cleanup_expired_ip_validation_cache';
  static const Duration _cleanupInterval = Duration(hours: 24);
  static const Duration _cacheExpiry = Duration(hours: 72);

  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      final expiryThreshold = DateTime.now().subtract(_cacheExpiry);

      final expiredRecords = await IpValidationCache.db.find(
        session,
        where: (t) => t.updatedAt < expiryThreshold,
      );

      if (expiredRecords.isNotEmpty) {
        await IpValidationCache.db.delete(session, expiredRecords);
        session.log(
          'Cleaned up ${expiredRecords.length} expired IP validation cache entries',
        );
      } else {
        session.log(
          'No expired IP validation cache entries to clean up',
          level: LogLevel.debug,
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'Error in CleanupExpiredIpValidationCacheFutureCall',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      await session.serverpod.futureCallWithDelay(
        callName,
        null,
        _cleanupInterval,
      );
      session.log(
        'Scheduled next IP validation cache cleanup in ${_cleanupInterval.inHours} hours',
        level: LogLevel.debug,
      );
    }
  }
}
