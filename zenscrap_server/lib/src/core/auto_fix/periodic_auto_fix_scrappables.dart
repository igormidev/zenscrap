import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/auto_fix/auto_fix_session_handler.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Configuration constants for auto-fix
class AutoFixConstants {
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
/// - Queries AutoFixConfig for scrappables that meet auto-fix criteria
/// - Processes up to N scrappables per run (configurable)
/// - Uses AI to analyze and fix broken extraction rules
/// - Validates fixes with ScrapingBee before applying
/// - Logs all sessions and attempts for auditing
///
/// Scalability considerations:
/// - Uses denormalized `currentConsecutiveErrors` counter for efficient queries
/// - Composite index on (enabled, inProgress, currentConsecutiveErrors)
/// - `inProgress` flag prevents concurrent fixes on same scrappable
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

      // Get server's default ScrapingBee API key
      final scrapingBeeApiKey = session.passwords['scrapingBeeApiKey'];

      if (scrapingBeeApiKey == null) {
        session.log(
          'Auto-fix skipped: Missing scrapingBeeApiKey in server passwords',
          level: LogLevel.warning,
        );
        await _scheduleNextRun(session);
        return;
      }

      // Find scrappables that need auto-fix via AutoFixConfig
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
      for (final entry in candidates) {
        await _processAutoFix(
          session: session,
          autoFixConfig: entry.autoFixConfig,
          scrappable: entry.scrappable,
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

  /// Finds scrappables that are candidates for auto-fix via their AutoFixConfig.
  ///
  /// Criteria:
  /// - enabled = true
  /// - inProgress = false
  /// - currentConsecutiveErrors >= consecutiveErrorThreshold
  /// - attemptCount < maxAutoFixAttempts (haven't exhausted retries)
  /// - lastAttemptAt is null OR older than exponential cooldown period
  /// - Has required relations (extractRules, targetRequest, referenceTestData)
  /// - Not deleted
  Future<List<_AutoFixCandidate>> _findAutoFixCandidates(
      Session session) async {
    final now = DateTime.now();

    // Query AutoFixConfig entries that are enabled, not in progress, with errors
    final configs = await AutoFixConfig.db.find(
      session,
      where: (t) =>
          t.enabled.equals(true) &
          t.inProgress.equals(false) &
          (t.attemptCount < AutoFixConstants.maxAutoFixAttempts) &
          (t.currentConsecutiveErrors > 0),
      limit: AutoFixConstants.maxScrappablesPerRun * 3, // Fetch extra for filtering
      orderBy: (t) => t.currentConsecutiveErrors,
      orderDescending: true, // Process most broken first
    );

    if (configs.isEmpty) return [];

    // Get scrappable IDs for batch fetch
    final scrappableIds = configs.map((c) => c.scrappableId).toList();

    // Batch fetch scrappables with required relations
    final scrappables = await Scrappable.db.find(
      session,
      where: (t) =>
          t.id.inSet(scrappableIds.toSet()) & t.isDeleted.equals(false),
      include: Scrappable.include(
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
    );

    // Create a map for quick lookup
    final scrappableMap = {for (var s in scrappables) s.id!: s};

    // Filter and pair configs with scrappables
    final candidates = <_AutoFixCandidate>[];
    for (final config in configs) {
      // Check threshold requirement
      if (config.currentConsecutiveErrors < config.consecutiveErrorThreshold) {
        continue;
      }

      // Check exponential cooldown
      if (config.lastAttemptAt != null) {
        final cooldown =
            AutoFixConstants.calculateCooldown(config.attemptCount);
        final cooldownCutoff = now.subtract(cooldown);
        if (config.lastAttemptAt!.isAfter(cooldownCutoff)) {
          continue; // Still in cooldown
        }
      }

      // Get corresponding scrappable
      final scrappable = scrappableMap[config.scrappableId];
      if (scrappable == null) continue;

      // Ensure required relations exist
      if (scrappable.scrappingBeeExtractRules == null ||
          scrappable.targetRequest == null ||
          scrappable.referenceTestData == null) {
        continue;
      }

      candidates.add(_AutoFixCandidate(
        autoFixConfig: config,
        scrappable: scrappable,
      ));

      // Stop once we have enough candidates
      if (candidates.length >= AutoFixConstants.maxScrappablesPerRun) {
        break;
      }
    }

    return candidates;
  }

  /// Resolves which AiModel to use based on config and user API key availability.
  ///
  /// Logic:
  /// - If preferredAiModel is set (not null), use that model
  /// - If preferredAiModel is null (auto mode):
  ///   - Use AiModel.powerful if user has their own API key
  ///   - Use AiModel.normal if using platform's API key
  AiModel _resolveAiModel({
    required AutoFixConfig config,
    required bool hasUserApiKey,
  }) {
    if (config.preferredAiModel != null) {
      return config.preferredAiModel!;
    }
    // Auto mode: powerful if user pays, normal if platform pays
    return hasUserApiKey ? AiModel.powerful : AiModel.normal;
  }

  /// Gets the user's OpenAI API key if available, otherwise falls back to server key.
  ///
  /// Returns a tuple of (apiKey, isUserKey).
  Future<(String?, bool)> _getOpenAiApiKey(
    Session session,
    Scrappable scrappable,
  ) async {
    // Server's default API key
    final serverApiKey = session.passwords['openAiApiKey'];

    // Try to get user's own API key via account
    if (scrappable.accountId != null) {
      final accountInfo = await AccountInfo.db.findById(
        session,
        scrappable.accountId!,
        include: AccountInfo.include(
          accountAIUsage: AccountAIUsage.include(),
        ),
      );

      final userApiKey = accountInfo?.accountAIUsage?.userOpenAiApiKey;
      if (userApiKey != null && userApiKey.isNotEmpty) {
        return (userApiKey, true);
      }
    }

    return (serverApiKey, false);
  }

  /// Processes auto-fix for a single scrappable
  Future<void> _processAutoFix({
    required Session session,
    required AutoFixConfig autoFixConfig,
    required Scrappable scrappable,
    required String scrapingBeeApiKey,
  }) async {
    session.log(
      'Processing auto-fix for scrappable ${scrappable.id} (${scrappable.name})',
      level: LogLevel.info,
    );

    // Mark config as in progress
    try {
      await AutoFixConfig.db.updateRow(
        session,
        autoFixConfig.copyWith(inProgress: true),
        columns: (t) => [t.inProgress],
      );
    } catch (e) {
      session.log(
        'Failed to mark scrappable ${scrappable.id} as in progress: $e',
        level: LogLevel.error,
      );
      return;
    }

    try {
      // Get OpenAI API key (user's or server's)
      final (openAiApiKey, isUserApiKey) = await _getOpenAiApiKey(
        session,
        scrappable,
      );

      if (openAiApiKey == null) {
        session.log(
          'Auto-fix skipped for ${scrappable.id}: No OpenAI API key available',
          level: LogLevel.warning,
        );
        await _resetInProgress(session, autoFixConfig);
        return;
      }

      // Resolve which AI model to use
      final aiModel = _resolveAiModel(
        config: autoFixConfig,
        hasUserApiKey: isUserApiKey,
      );

      // Fetch recent analytics for context
      final recentAnalytics = await ScrappableAnalytics.db.find(
        session,
        where: (t) => t.scrappableId.equals(scrappable.id),
        orderBy: (t) => t.requestedAt,
        orderDescending: true,
        limit: AutoFixConstants.recentAnalyticsCount,
        include: ScrappableAnalytics.include(
          details: AnalyticsRequestDetails.include(),
        ),
      );

      // Create AutoFixSession for logging
      final now = DateTime.now();
      final autoFixSession = await AutoFixSession.db.insertRow(
        session,
        AutoFixSession(
          createdAt: now,
          status: AutoFixSessionStatus.in_progress,
          triggeredAtErrorCount: autoFixConfig.currentConsecutiveErrors,
          configuredThreshold: autoFixConfig.consecutiveErrorThreshold,
          usedAiModel: aiModel,
          usedUserApiKey: isUserApiKey,
          scrappableId: scrappable.id!,
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
        aiModel: aiModel,
        autoFixSessionId: autoFixSession.id!,
      );

      // Attempt the fix
      final result = await handler.attemptFix();

      // Handle the result
      switch (result) {
        case AutoFixSuccess(:final fixedExtractLogic, :final resumeMessage):
          await _applyAutoFixSuccess(
            session: session,
            autoFixConfig: autoFixConfig,
            autoFixSession: autoFixSession,
            scrappable: scrappable,
            fixedExtractLogic: fixedExtractLogic,
            resumeMessage: resumeMessage,
          );
          session.log(
            'Auto-fix SUCCESS for scrappable ${scrappable.id}: $resumeMessage',
            level: LogLevel.info,
          );

        case AutoFixFailure(:final errorMessage):
          await _markAutoFixFailed(
            session: session,
            autoFixConfig: autoFixConfig,
            autoFixSession: autoFixSession,
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

      // Reset in-progress flag on exception
      await _resetInProgress(session, autoFixConfig);
    }
  }

  /// Applies a successful auto-fix
  Future<void> _applyAutoFixSuccess({
    required Session session,
    required AutoFixConfig autoFixConfig,
    required AutoFixSession autoFixSession,
    required Scrappable scrappable,
    required ScrappingBeeExtractLogic fixedExtractLogic,
    required String resumeMessage,
  }) async {
    final now = DateTime.now();

    await session.db.transaction((transaction) async {
      // Update the extraction rules
      final updatedExtractLogic = fixedExtractLogic.copyWith(
        scrappableId: scrappable.id,
      );
      await ScrappingBeeExtractLogic.db.updateRow(
        session,
        updatedExtractLogic,
        transaction: transaction,
      );

      // Update scrappable timestamp
      await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(extractRulesUpdatedAt: now),
        columns: (t) => [t.extractRulesUpdatedAt],
        transaction: transaction,
      );

      // Reset AutoFixConfig on success
      await AutoFixConfig.db.updateRow(
        session,
        autoFixConfig.copyWith(
          currentConsecutiveErrors: 0,
          attemptCount: 0, // Reset on success
          lastAttemptAt: now,
          inProgress: false,
        ),
        columns: (t) => [
          t.currentConsecutiveErrors,
          t.attemptCount,
          t.lastAttemptAt,
          t.inProgress,
        ],
        transaction: transaction,
      );

      // Update session status to success
      await AutoFixSession.db.updateRow(
        session,
        autoFixSession.copyWith(
          completedAt: now,
          status: AutoFixSessionStatus.success,
          successSummary: resumeMessage,
        ),
        columns: (t) => [t.completedAt, t.status, t.successSummary],
        transaction: transaction,
      );
    });
  }

  /// Marks an auto-fix attempt as failed
  Future<void> _markAutoFixFailed({
    required Session session,
    required AutoFixConfig autoFixConfig,
    required AutoFixSession autoFixSession,
    required String errorMessage,
  }) async {
    final now = DateTime.now();
    final newAttemptCount = autoFixConfig.attemptCount + 1;

    // Update AutoFixConfig
    await AutoFixConfig.db.updateRow(
      session,
      autoFixConfig.copyWith(
        lastAttemptAt: now,
        inProgress: false,
        attemptCount: newAttemptCount,
      ),
      columns: (t) => [t.lastAttemptAt, t.inProgress, t.attemptCount],
    );

    // Determine final session status
    final sessionStatus = newAttemptCount >= AutoFixConstants.maxAutoFixAttempts
        ? AutoFixSessionStatus.exhausted
        : AutoFixSessionStatus.failed;

    // Update session status
    await AutoFixSession.db.updateRow(
      session,
      autoFixSession.copyWith(
        completedAt: now,
        status: sessionStatus,
        failureReason: errorMessage,
      ),
      columns: (t) => [t.completedAt, t.status, t.failureReason],
    );

    // Log next retry info
    final nextCooldown = AutoFixConstants.calculateCooldown(newAttemptCount);
    session.log(
      'Auto-fix failed (attempt $newAttemptCount/${AutoFixConstants.maxAutoFixAttempts}). '
      'Next retry in ${nextCooldown.inHours}h',
      level: LogLevel.warning,
    );
  }

  /// Resets the inProgress flag when auto-fix couldn't proceed
  Future<void> _resetInProgress(
      Session session, AutoFixConfig autoFixConfig) async {
    try {
      await AutoFixConfig.db.updateRow(
        session,
        autoFixConfig.copyWith(inProgress: false),
        columns: (t) => [t.inProgress],
      );
    } catch (e) {
      session.log(
        'Failed to reset inProgress flag: $e',
        level: LogLevel.error,
      );
    }
  }

  /// Schedules the next periodic run
  Future<void> _scheduleNextRun(Session session) async {
    await session.serverpod.futureCallWithDelay(
      'periodicAutoFixBrokenScrappables',
      null,
      AutoFixConstants.checkInterval,
      identifier: 'periodicAutoFixBrokenScrappables',
    );
  }
}

/// Internal class to pair AutoFixConfig with its Scrappable
class _AutoFixCandidate {
  final AutoFixConfig autoFixConfig;
  final Scrappable scrappable;

  _AutoFixCandidate({
    required this.autoFixConfig,
    required this.scrappable,
  });
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
