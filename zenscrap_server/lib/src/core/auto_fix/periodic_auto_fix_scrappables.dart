import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/auto_fix/auto_fix_session_handler.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Configuration constants for auto-fix
class AutoFixConfig {
  /// How often the periodic check runs
  static const checkInterval = Duration(minutes: 5);

  /// Base cooldown period for exponential backoff (1 hour)
  /// Actual cooldown = baseCooldown * 2^attemptCount (capped at maxCooldown)
  static const baseCooldownPeriod = Duration(hours: 1);

  /// Maximum cooldown period (24 hours) - prevents infinite delay
  static const maxCooldownPeriod = Duration(hours: 24);

  /// Maximum number of auto-fix attempts before disabling auto-fix
  /// After this many failures, the scrappable needs manual intervention
  static const maxAutoFixAttempts = 5;

  /// Maximum number of scrappables to process per periodic run
  /// This prevents overloading the system with too many AI calls
  static const maxScrappablesPerRun = 3;

  /// Number of recent analytics to include in the AI context
  static const recentAnalyticsCount = 10;

  /// Calculates the cooldown period based on attempt count (exponential backoff)
  /// attemptCount 0 → 1h, 1 → 2h, 2 → 4h, 3 → 8h, 4 → 16h (capped at 24h)
  static Duration calculateCooldown(int attemptCount) {
    final multiplier = 1 << attemptCount; // 2^attemptCount
    final cooldown = baseCooldownPeriod * multiplier;
    return cooldown > maxCooldownPeriod ? maxCooldownPeriod : cooldown;
  }
}

/// Periodic FutureCall that checks for broken scrappables and attempts to fix them.
///
/// Architecture:
/// - Runs every 5 minutes
/// - Queries for scrappables that meet auto-fix criteria
/// - Processes up to N scrappables per run (configurable)
/// - Uses AI to analyze and fix broken extraction rules
/// - Validates fixes with ScrapingBee before applying
///
/// Scalability considerations:
/// - Uses denormalized `currentConsecutiveErrors` counter for efficient queries
/// - Composite index on (autoFixEnabled, autoFixInProgress, currentConsecutiveErrors)
/// - `autoFixInProgress` flag prevents concurrent fixes on same scrappable
/// - Cooldown period prevents spam-fixing
/// - Batch limit prevents overloading the system
class PeriodicAutoFixBrokenScrappables extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    try {
      session.log(
        'Starting periodic auto-fix check...',
        level: LogLevel.info,
      );

      // Get API keys from server passwords
      final openAiApiKey = session.passwords['openAiApiKey'];
      final scrapingBeeApiKey = session.passwords['scrapingBeeApiKey'];

      if (openAiApiKey == null || scrapingBeeApiKey == null) {
        session.log(
          'Auto-fix skipped: Missing API keys (openAiApiKey or scrapingBeeApiKey)',
          level: LogLevel.warning,
        );
        await _scheduleNextRun(session);
        return;
      }

      // Find scrappables that need auto-fix
      final candidates = await _findAutoFixCandidates(session);

      if (candidates.isEmpty) {
        session.log(
          'No scrappables need auto-fix at this time',
          level: LogLevel.debug,
        );
        await _scheduleNextRun(session);
        return;
      }

      session.log(
        'Found ${candidates.length} scrappable(s) needing auto-fix',
        level: LogLevel.info,
      );

      // Process each candidate
      for (final scrappable in candidates) {
        await _processAutoFix(
          session: session,
          scrappable: scrappable,
          openAiApiKey: openAiApiKey,
          scrapingBeeApiKey: scrapingBeeApiKey,
        );
      }
    } catch (e, stackTrace) {
      session.log(
        'Error in periodic auto-fix check',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }

    // Always schedule the next run
    await _scheduleNextRun(session);
  }

  /// Finds scrappables that are candidates for auto-fix.
  ///
  /// Criteria:
  /// - autoFixEnabled = true
  /// - autoFixInProgress = false
  /// - currentConsecutiveErrors >= consecutiveErrorThreshold
  /// - autoFixAttemptCount < maxAutoFixAttempts (haven't exhausted retries)
  /// - lastAutoFixAttemptAt is null OR older than exponential cooldown period
  /// - Has extract rules (can't fix what doesn't exist)
  /// - Not deleted
  Future<List<Scrappable>> _findAutoFixCandidates(Session session) async {
    return await Scrappable.db.find(
      session,
      where: (t) =>
          t.autoFixEnabled.equals(true) &
          t.autoFixInProgress.equals(false) &
          t.isDeleted.equals(false) &
          // Filter out scrappables that have exhausted auto-fix attempts
          (t.autoFixAttemptCount < AutoFixConfig.maxAutoFixAttempts) &
          // Check consecutive errors > 0 (threshold check done in post-processing)
          // We use a subquery pattern here - for each row, check if its
          // currentConsecutiveErrors >= its consecutiveErrorThreshold
          // Since we can't directly compare two columns in Serverpod ORM,
          // we'll handle this in post-processing
          (t.currentConsecutiveErrors > 0),
          // NOTE: Cooldown check is done in post-processing to support
          // exponential backoff (different cooldowns per scrappable)
      include: Scrappable.include(
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
      limit: AutoFixConfig.maxScrappablesPerRun * 3, // Fetch extra for filtering
      orderBy: (t) => t.currentConsecutiveErrors,
      orderDescending: true, // Process most broken first
    ).then((scrappables) {
      final now = DateTime.now();

      // Post-filter: check consecutiveErrorThreshold and exponential cooldown
      // (Serverpod ORM doesn't support column-to-column comparison directly)
      return scrappables
          .where((s) {
            // Must meet error threshold
            if (s.currentConsecutiveErrors < s.consecutiveErrorThreshold) {
              return false;
            }

            // Must have required relations
            if (s.scrappingBeeExtractRules == null ||
                s.targetRequest == null ||
                s.referenceTestData == null) {
              return false;
            }

            // Check exponential cooldown based on attempt count
            if (s.lastAutoFixAttemptAt != null) {
              final cooldown =
                  AutoFixConfig.calculateCooldown(s.autoFixAttemptCount);
              final cooldownCutoff = now.subtract(cooldown);
              if (s.lastAutoFixAttemptAt!.isAfter(cooldownCutoff)) {
                return false; // Still in cooldown
              }
            }

            return true;
          })
          .take(AutoFixConfig.maxScrappablesPerRun)
          .toList();
    });
  }

  /// Processes auto-fix for a single scrappable
  Future<void> _processAutoFix({
    required Session session,
    required Scrappable scrappable,
    required String openAiApiKey,
    required String scrapingBeeApiKey,
  }) async {
    session.log(
      'Processing auto-fix for scrappable ${scrappable.id} (${scrappable.name})',
      level: LogLevel.info,
    );

    // Mark as in progress to prevent concurrent attempts
    try {
      await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(autoFixInProgress: true),
        columns: (t) => [t.autoFixInProgress],
      );
    } catch (e) {
      session.log(
        'Failed to mark scrappable ${scrappable.id} as in progress: $e',
        level: LogLevel.error,
      );
      return;
    }

    try {
      // Fetch recent analytics for context
      final recentAnalytics = await ScrappableAnalytics.db.find(
        session,
        where: (t) => t.scrappableId.equals(scrappable.id),
        orderBy: (t) => t.requestedAt,
        orderDescending: true,
        limit: AutoFixConfig.recentAnalyticsCount,
        include: ScrappableAnalytics.include(
          details: AnalyticsRequestDetails.include(),
        ),
      );

      // Create the auto-fix handler
      final handler = AutoFixSessionHandler(
        session: session,
        openAiApiKey: openAiApiKey,
        scrapingBeeApiKey: scrapingBeeApiKey,
        scrappable: scrappable,
        scrappableRequest: scrappable.targetRequest!,
        extractLogic: scrappable.scrappingBeeExtractRules!,
        referenceTestData: scrappable.referenceTestData!,
        recentAnalytics: recentAnalytics,
      );

      // Attempt the fix
      final result = await handler.attemptFix();

      // Handle the result
      switch (result) {
        case AutoFixSuccess(:final fixedExtractLogic, :final resumeMessage):
          await applyAutoFix(
            session: session,
            scrappable: scrappable,
            fixedExtractLogic: fixedExtractLogic,
            resumeMessage: resumeMessage,
          );
          session.log(
            'Auto-fix SUCCESS for scrappable ${scrappable.id}: $resumeMessage',
            level: LogLevel.info,
          );

        case AutoFixFailure(:final errorMessage):
          await markAutoFixFailed(
            session: session,
            scrappable: scrappable,
            errorMessage: errorMessage,
          );
          session.log(
            'Auto-fix FAILED for scrappable ${scrappable.id}: $errorMessage',
            level: LogLevel.warning,
          );
      }
    } catch (e, stackTrace) {
      session.log(
        'Exception during auto-fix for scrappable ${scrappable.id}',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );

      // Ensure we reset the in-progress flag even on exception
      await markAutoFixFailed(
        session: session,
        scrappable: scrappable,
        errorMessage: 'Exception: $e',
      );
    }
  }

  /// Schedules the next periodic run
  Future<void> _scheduleNextRun(Session session) async {
    await session.serverpod.futureCallWithDelay(
      'periodicAutoFixBrokenScrappables',
      null,
      AutoFixConfig.checkInterval,
      identifier: 'periodicAutoFixBrokenScrappables',
    );
  }
}

/// Starts the periodic auto-fix check.
/// Should be called once at server startup.
Future<void> startPeriodicAutoFix(Serverpod serverpod) async {
  // Register the FutureCall
  serverpod.registerFutureCall(
    PeriodicAutoFixBrokenScrappables(),
    'periodicAutoFixBrokenScrappables',
  );

  // Schedule the first run after a short delay
  // This gives the server time to fully initialize
  await serverpod.futureCallWithDelay(
    'periodicAutoFixBrokenScrappables',
    null,
    const Duration(seconds: 30),
    identifier: 'periodicAutoFixBrokenScrappables',
  );
}
