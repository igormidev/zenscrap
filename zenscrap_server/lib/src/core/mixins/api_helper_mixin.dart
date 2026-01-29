import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:result_dart/result_dart.dart';
import 'package:serverpod/serverpod.dart' hide Result;
import 'package:zenscrap_core/zenscrap_core.dart';
import 'package:zenscrap_server/src/core/extension/duration_list_extension.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/core/extension/scrapping_bee_extract_logic_extension.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/endpoints/public/scrappable_chat_session.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';
import 'package:zenscrap_server/src/notifications/auto_fix_notification_service.dart';

typedef ApiKey = String;
typedef NanoId = String;
typedef ScrappableId = int;

/// Configuration constants for API helper operations.
///
/// This class centralizes all tunable parameters for caching, analytics,
/// batch processing, and cleanup operations. Having these as named constants
/// makes the code self-documenting and simplifies tuning.
class ApiHelperConfig {
  ApiHelperConfig._();

  // ============================================================================
  // CACHE TTL (Time-To-Live) SETTINGS
  // ============================================================================

  /// Maximum age for nanoId-related cache entries.
  ///
  /// This covers plan tier, credit usage, API keys, subscription credits,
  /// purchased credits, and allowed scrappable IDs. After this duration,
  /// entries are considered stale and will be refreshed from the database.
  static const Duration nanoIdCacheMaxAge = Duration(minutes: 30);

  /// Maximum age for scrappable cache entries.
  ///
  /// Scrappables (extraction configurations) change less frequently than
  /// account data, so they have a longer TTL. This reduces database load
  /// for frequently accessed scrappables.
  static const Duration scrappableCacheMaxAge = Duration(hours: 1);

  // ============================================================================
  // CACHE SIZE LIMITS
  // ============================================================================

  /// Maximum number of entries in scrappables cache before forced eviction.
  ///
  /// This prevents unbounded memory growth even if cleanup doesn't run.
  /// When this limit is reached, the oldest entry is evicted to make room.
  static const int maxScrappableCacheSize = 500;

  /// Maximum number of nanoIds to track before forced eviction.
  ///
  /// Each nanoId can have multiple associated cache entries (plan tier,
  /// credits, API keys, etc.). This limit ensures memory doesn't grow
  /// unbounded with many unique users.
  static const int maxNanoIdCacheSize = 1000;

  // ============================================================================
  // PERIODIC TASK INTERVALS
  // ============================================================================

  /// Interval for batching pending analytics writes to database.
  ///
  /// Analytics are collected in-memory and written to the database in batches
  /// to reduce write frequency. Lower values = more frequent writes but less
  /// data loss on crash. Higher values = fewer writes but more potential data loss.
  static const Duration analyticsBatchInterval = Duration(minutes: 3);

  /// Interval for cleaning up expired in-memory cache entries.
  ///
  /// This periodic task removes expired entries from all caches to free memory.
  /// Should run frequently enough to prevent stale data but not so often as to
  /// cause unnecessary overhead.
  static const Duration cacheCleanupInterval = Duration(minutes: 15);

  /// Interval for cleaning up old analytics records from the database.
  ///
  /// This periodic task deletes analytics details older than [analyticsRetentionPeriod]
  /// and recalculates average durations. Runs less frequently since it involves
  /// database operations.
  static const Duration analyticsCleanupInterval = Duration(hours: 1);

  // ============================================================================
  // DATA RETENTION SETTINGS
  // ============================================================================

  /// How long to retain detailed analytics records before deletion.
  ///
  /// Analytics request details (payloads, responses, errors) older than this
  /// are permanently deleted. Aggregated data like average durations are
  /// calculated before deletion and preserved.
  static const Duration analyticsRetentionPeriod = Duration(days: 7);

  /// Age threshold for identifying orphaned average duration records.
  ///
  /// ScrappableAverageDuration records are considered orphaned if they're
  /// not referenced by any active scrappable AND are older than this threshold.
  /// The threshold prevents deletion of recently created records that might
  /// not yet be linked due to race conditions.
  static const Duration orphanedRecordThreshold = Duration(days: 1);

  // ============================================================================
  // BATCH PROCESSING SETTINGS
  // ============================================================================

  /// Number of scrappables to process per batch during cleanup operations.
  ///
  /// Processing in chunks prevents memory issues when dealing with large
  /// datasets. Smaller values use less memory but require more iterations.
  /// Larger values are more efficient but use more memory per iteration.
  static const int cleanupBatchSize = 30;

  /// Number of recent success records to use for average duration calculation.
  ///
  /// Average request duration is calculated from the N most recent successful
  /// requests. Larger values give more stable averages but include older data.
  /// Smaller values are more responsive to recent performance changes.
  static const int averageDurationSampleSize = 50;
}

/// Wrapper class for cache entries with timestamp tracking for TTL-based eviction.
class _CacheEntry<T> {
  final T value;
  final DateTime createdAt;

  _CacheEntry(this.value) : createdAt = DateTime.now();

  /// Checks if this cache entry has expired based on the given max age.
  bool isExpired(Duration maxAge) {
    return DateTime.now().difference(createdAt) > maxAge;
  }
}

/// Replaces placeholder patterns {paramName} in a string with actual values from the payload
String replacePlaceholders(String? input, Map<String, dynamic> payload) {
  if (input == null || input.isEmpty || payload.isEmpty) return input ?? '';

  String result = input;

  // Create a regex pattern that matches only the keys present in the payload
  // This is more efficient than matching all {.*} patterns
  final keys = payload.keys.where((k) => k.isNotEmpty).toList();
  if (keys.isEmpty) return result;

  // Build pattern like {(?:key1|key2|key3)}
  final pattern = '{(?:${keys.map(RegExp.escape).join('|')})}';
  final placeholderPattern = RegExp(pattern);

  // Replace all matches
  result = result.replaceAllMapped(placeholderPattern, (match) {
    final fullMatch = match.group(0)!; // e.g., "{searchQuery}"
    final paramName = fullMatch.substring(
      1,
      fullMatch.length - 1,
    ); // Remove { and }
    final value = payload[paramName];
    return value?.toString() ?? '';
  });

  return result;
}

/// Creates a copy of ScrappingBeeExtractLogic with all placeholders replaced
/// and optionally overrides the countryCode if provided in the payload.
///
/// The `countryCode` can be overridden by including it in the payload.
/// If the payload contains a `countryCode` key, it will be used instead of
/// the one stored in the extractLogic.
ScrappingBeeExtractLogic replaceExtractLogicPlaceholders(
  ScrappingBeeExtractLogic extractLogic,
  Map<String, dynamic> payload,
) {
  // Check if countryCode override is in the payload
  final String? countryCodeOverride = payload['countryCode'] as String?;

  return extractLogic.copyWith(
    extractRules: replacePlaceholders(extractLogic.extractRules, payload),
    jsScenario: replacePlaceholders(extractLogic.jsScenario, payload),
    // Only override countryCode if explicitly provided in payload
    countryCode: countryCodeOverride ?? extractLogic.countryCode,
  );
}

mixin ApiHelperMixin {
  // Concurrency tracking - self-cleans when count reaches 0 (see decreaseConcurrency)
  static final Map<NanoId, int> _currentConcurrencyRequests = {};

  // NanoId-keyed caches with TTL tracking
  static final Map<NanoId, _CacheEntry<PlanTier>> _currentAccountPlanTierCache =
      {};
  static final Map<NanoId, _CacheEntry<CreditUsage>> _currentCreditUsage = {};
  static final Map<NanoId, _CacheEntry<int>> _remainingSubscriptionCredits = {};
  static final Map<NanoId, _CacheEntry<int>> _remainingPurchasedCredits = {};
  static final Map<NanoId, _CacheEntry<List<ApiKey>>> _apiKeysAttachedToNanoId =
      {};
  static final Map<NanoId, _CacheEntry<List<ScrappableId>>>
  _allowedScrappableIdsToUse = {};

  // Scrappable cache with TTL tracking
  static final Map<ScrappableId, _CacheEntry<Scrappable>> _scrappables = {};

  // Pending analytics - cleared by PeriodicSetRequestsAnalytics FutureCall
  static final Map<
    ScrappableId,
    Map<NanoId, Map<ApiKey, List<AnalyticsPayload>>>
  >
  _pendingAnalytics = {};

  /// Cleans up expired cache entries. Called periodically by PeriodicCacheCleanup.
  static void cleanupExpiredCacheEntries() {
    final nanoIdMaxAge = ApiHelperConfig.nanoIdCacheMaxAge;
    final scrappableMaxAge = ApiHelperConfig.scrappableCacheMaxAge;

    // Cleanup nanoId-keyed caches
    _currentAccountPlanTierCache.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );
    _currentCreditUsage.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );
    _remainingSubscriptionCredits.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );
    _remainingPurchasedCredits.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );
    _apiKeysAttachedToNanoId.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );
    _allowedScrappableIdsToUse.removeWhere(
      (_, entry) => entry.isExpired(nanoIdMaxAge),
    );

    // Cleanup scrappable cache
    _scrappables.removeWhere((_, entry) => entry.isExpired(scrappableMaxAge));

    // Cleanup stale concurrency entries (should not normally have entries
    // stuck, but this is a safety net)
    _currentConcurrencyRequests.removeWhere((_, count) => count <= 0);
  }

  /// Enforces maximum cache sizes by evicting oldest entries.
  /// Called when adding new entries to prevent unbounded growth.
  static void _enforceNanoIdCacheSize(NanoId newNanoId) {
    if (_currentAccountPlanTierCache.length >=
        ApiHelperConfig.maxNanoIdCacheSize) {
      // Find and remove the oldest entry (excluding the new one being added)
      _evictOldestEntry(_currentAccountPlanTierCache, exclude: newNanoId);
    }
  }

  /// Enforces maximum scrappable cache size.
  static void _enforceScrappableCacheSize(ScrappableId newId) {
    if (_scrappables.length >= ApiHelperConfig.maxScrappableCacheSize) {
      _evictOldestEntry(_scrappables, exclude: newId);
    }
  }

  /// Evicts the oldest entry from a cache map.
  static void _evictOldestEntry<K, V>(
    Map<K, _CacheEntry<V>> cache, {
    K? exclude,
  }) {
    if (cache.isEmpty) return;

    K? oldestKey;
    DateTime? oldestTime;

    for (final entry in cache.entries) {
      if (entry.key == exclude) continue;
      if (oldestTime == null || entry.value.createdAt.isBefore(oldestTime)) {
        oldestKey = entry.key;
        oldestTime = entry.value.createdAt;
      }
    }

    if (oldestKey != null) {
      cache.remove(oldestKey);
    }
  }

  static void resetNanoId(NanoId nanoId) {
    _allowedScrappableIdsToUse.remove(nanoId);
    _currentConcurrencyRequests.remove(nanoId);
    _currentAccountPlanTierCache.remove(nanoId);
    _currentCreditUsage.remove(nanoId);
    _remainingSubscriptionCredits.remove(nanoId);
    _remainingPurchasedCredits.remove(nanoId);
    _apiKeysAttachedToNanoId.remove(nanoId);
  }

  Future<({NanoId? nanoId, Scrappable scrappable, PlanTier? planTier})>
  setAllDependencies(
    Session session,
    ScrappableId scrappableId,
    ApiKey? apiKey,
  ) async {
    // Get cached scrappable value (if not expired)
    final scrappableCacheEntry = _scrappables[scrappableId];
    final Scrappable? cacheScrappable =
        scrappableCacheEntry?.isExpired(
              ApiHelperConfig.scrappableCacheMaxAge,
            ) ==
            false
        ? scrappableCacheEntry?.value
        : null;

    String? nanoId;
    if (apiKey != null) {
      final splitted = apiKey.split('::');
      if (splitted.length != 2) throw _invalidApiKeyFormat();
      nanoId = splitted[0];
    }

    // Get cached plan tier (if not expired)
    final planTierCacheEntry = nanoId == null
        ? null
        : _currentAccountPlanTierCache[nanoId];
    PlanTier? cachePlanTier =
        planTierCacheEntry?.isExpired(ApiHelperConfig.nanoIdCacheMaxAge) ==
            false
        ? planTierCacheEntry?.value
        : null;

    if (apiKey == null && cacheScrappable != null) {
      return (
        nanoId: null,
        scrappable: cacheScrappable,
        planTier: cachePlanTier,
      );
    }
    if (apiKey != null && nanoId != null) {
      // Check if all cached values are valid (not expired)
      final creditUsageEntry = _currentCreditUsage[nanoId];
      final apiKeysEntry = _apiKeysAttachedToNanoId[nanoId];
      final allowedScrappablesEntry = _allowedScrappableIdsToUse[nanoId];

      final creditUsageValid =
          creditUsageEntry?.isExpired(ApiHelperConfig.nanoIdCacheMaxAge) ==
          false;
      final apiKeysValid =
          apiKeysEntry?.isExpired(ApiHelperConfig.nanoIdCacheMaxAge) == false;
      final allowedScrappablesValid =
          allowedScrappablesEntry?.isExpired(
            ApiHelperConfig.nanoIdCacheMaxAge,
          ) ==
          false;

      if (cachePlanTier != null &&
          creditUsageValid &&
          apiKeysValid &&
          apiKeysEntry!.value.contains(apiKey) &&
          allowedScrappablesValid &&
          allowedScrappablesEntry!.value.contains(scrappableId) &&
          cacheScrappable != null &&
          _pendingAnalytics[scrappableId]?[nanoId]?[apiKey] != null) {
        return (
          nanoId: nanoId,
          scrappable: cacheScrappable,
          planTier: cachePlanTier,
        );
      }

      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) =>
            p0.accountApiUsage.nanoId.equals(nanoId) &
            p0.accountApiUsage.apiKeys.any(
              (key) => key.apiKey.equals(apiKey) & key.isActive.equals(true),
            ),
        include: AccountInfo.include(
          accountApiUsage: AccountApiUsage.include(
            creditUsage: CreditUsage.include(),
          ),
        ),
      );
      final PlanTier? newPlanTier = accountInfo?.planTier;
      final CreditUsage? creditUsage =
          accountInfo?.accountApiUsage?.creditUsage;
      if (newPlanTier == null) throw _invalidApiKey();
      if (creditUsage == null) throw _invalidApiKey();

      // Enforce cache size limits before adding new entries
      _enforceNanoIdCacheSize(nanoId);

      _currentAccountPlanTierCache[nanoId] = _CacheEntry(newPlanTier);
      _currentCreditUsage[nanoId] = _CacheEntry(creditUsage);
      cachePlanTier = newPlanTier;
    }

    final Scrappable? scrappable = await Scrappable.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(scrappableId) &
          (t.apiUsageOwnerNanoId.equals(null) |
              // If not private, allow all
              t.willHideFromMarketplace.equals(false) |
              // If private, allow only if the nanoId matches
              (t.willHideFromMarketplace.equals(true) &
                  t.apiUsageOwnerNanoId.notEquals(null) &
                  t.apiUsageOwnerNanoId.equals(nanoId))),
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
      ),
    );
    final ScrappableRequest? targetRequest = scrappable?.targetRequest;
    final ScrappingBeeExtractLogic? extractRules =
        scrappable?.scrappingBeeExtractRules;
    if (scrappable == null || targetRequest == null || extractRules == null) {
      throw _noScrappableFound(scrappableId.toString());
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw _noScrappableFound(scrappableId.toString());
    }

    // Enforce cache size limit before adding new entry
    _enforceScrappableCacheSize(scrappableId);
    _scrappables[scrappableId] = _CacheEntry(scrappable);

    if (nanoId != null && apiKey != null) {
      _pendingAnalytics[scrappableId]?[nanoId]?[apiKey] ??= [];

      // Update allowed scrappable IDs cache
      final existingAllowedEntry = _allowedScrappableIdsToUse[nanoId];
      if (existingAllowedEntry == null ||
          existingAllowedEntry.isExpired(ApiHelperConfig.nanoIdCacheMaxAge)) {
        _allowedScrappableIdsToUse[nanoId] = _CacheEntry([scrappableId]);
      } else if (!existingAllowedEntry.value.contains(scrappableId)) {
        existingAllowedEntry.value.add(scrappableId);
      }

      if (!_pendingAnalytics.containsKey(scrappableId)) {
        _pendingAnalytics[scrappableId] = {};
      }
      if (!_pendingAnalytics[scrappableId]!.containsKey(nanoId)) {
        _pendingAnalytics[scrappableId]![nanoId] = {};
      }
      if (!_pendingAnalytics[scrappableId]![nanoId]!.containsKey(apiKey)) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey] = [];
      }

      // Update API keys cache
      final existingApiKeysEntry = _apiKeysAttachedToNanoId[nanoId];
      if (existingApiKeysEntry == null ||
          existingApiKeysEntry.isExpired(ApiHelperConfig.nanoIdCacheMaxAge)) {
        _apiKeysAttachedToNanoId[nanoId] = _CacheEntry([apiKey]);
      } else if (!existingApiKeysEntry.value.contains(apiKey)) {
        existingApiKeysEntry.value.add(apiKey);
      }
    }

    return (nanoId: nanoId, scrappable: scrappable, planTier: cachePlanTier);
  }

  void increaseConcurrency(NanoId? nanoId, PlanTier? planTier) {
    if (nanoId == null) return;
    final maxConcurrentRequests =
        planTier?.numberOfConcurrentRequestsAllowedByPlan;
    if (maxConcurrentRequests == null) throw _invalidApiKey();

    final canIncrease =
        (_currentConcurrencyRequests[nanoId] ?? 0) + 1 <= maxConcurrentRequests;
    if (!canIncrease) throw _maxConcurrencyReached(maxConcurrentRequests);

    _currentConcurrencyRequests[nanoId] =
        (_currentConcurrencyRequests[nanoId] ?? 0) + 1;
  }

  void decreaseConcurrency(NanoId? nanoId) {
    if (nanoId == null) return;
    _currentConcurrencyRequests[nanoId] =
        (_currentConcurrencyRequests[nanoId] ?? 1) - 1;
    if (_currentConcurrencyRequests[nanoId] == 0) {
      _currentConcurrencyRequests.remove(nanoId);
    }
  }

  void throwErrorIfIsATestRequestAndTestTimeExpired(
    ApiKey? apiKey,
    Scrappable scrappable,
  ) {
    final isTest = apiKey == null;

    if (isTest) {
      final testExpiry = scrappable.testEndpointAvailableUntil;
      if (testExpiry == null || testExpiry.isBefore(DateTime.now())) {
        throw _testPeriodExpired();
      }
    }
  }

  String composeUrl(
    Map<String, dynamic> payload,
    ScrappableRequest scrappableRequest,
  ) {
    String targetUrl = scrappableRequest.url;

    // First, add the path parameters
    for (final String pathParam in scrappableRequest.pathParams) {
      final String? payloadParam = payload[pathParam];
      if (payloadParam == null) {
        throw createTranslatedException(
          'missing_path_parameter',
          SupportedLanguage.en,
          params: {'pathParam': pathParam},
        );
      }
      targetUrl = targetUrl.replaceAll('{$pathParam}', payloadParam);
    }

    // Now, let's add query parameters
    final Map<String, String> queryParams = {};
    for (final MapEntry<String, String?> entry
        in scrappableRequest.queryParams.entries) {
      final String queryParamName = entry.key;
      final String? defaultQueryParam = entry.value;
      final String? payloadQueryParam = payload[queryParamName];
      final String? queryParam = payloadQueryParam ?? defaultQueryParam;
      if (queryParam != null) {
        queryParams[queryParamName] = queryParam;
      }
    }
    if (queryParams.isNotEmpty) {
      targetUrl += '?${Uri(queryParameters: queryParams).query}';
    }

    return targetUrl;
  }

  /// Priority is; first deduce on subscription, then on purchased credits
  Future<void> discountApiTokens(
    Session session, {
    required NanoId? nanoId,
    required int creditCost,
  }) async {
    if (nanoId == null) return;

    // Get cached values, checking for expiration
    final subscriptionEntry = _remainingSubscriptionCredits[nanoId];
    final purchasedEntry = _remainingPurchasedCredits[nanoId];

    final subscriptionCredits =
        subscriptionEntry?.isExpired(ApiHelperConfig.nanoIdCacheMaxAge) == false
        ? subscriptionEntry?.value
        : null;
    final purchasedCredits =
        purchasedEntry?.isExpired(ApiHelperConfig.nanoIdCacheMaxAge) == false
        ? purchasedEntry?.value
        : null;

    if (subscriptionCredits == null || purchasedCredits == null) {
      // Let's get the most updated value from data base
      final accountApiUsage = await AccountApiUsage.db.findFirstRow(
        session,
        where: (p0) => p0.nanoId.equals(nanoId),
        include: AccountApiUsage.include(creditUsage: CreditUsage.include()),
      );
      if (accountApiUsage == null || accountApiUsage.creditUsage == null) {
        throw _noApiFound();
      }

      _currentCreditUsage[nanoId] = _CacheEntry(accountApiUsage.creditUsage!);
      _remainingPurchasedCredits[nanoId] = _CacheEntry(
        accountApiUsage.creditUsage!.purchasedCredits,
      );
      _remainingSubscriptionCredits[nanoId] = _CacheEntry(
        accountApiUsage.creditUsage!.subscriptionCredits,
      );
      return discountApiTokens(session, nanoId: nanoId, creditCost: creditCost);
    }

    // Check if we have enough credits in total
    final totalCredits = subscriptionCredits + purchasedCredits;
    if (totalCredits < creditCost) {
      throw _insufficientCredits();
    }

    // First, try to deduct from subscription credits
    if (subscriptionCredits >= creditCost) {
      final currentEntry = _remainingSubscriptionCredits[nanoId];
      final currentValue = currentEntry?.value ?? subscriptionCredits;
      _remainingSubscriptionCredits[nanoId] = _CacheEntry(
        currentValue - creditCost,
      );
      return;
    }

    // If subscription credits are not enough, use them all and deduct the rest from purchased credits
    if (subscriptionCredits > 0) {
      final remainingCost = creditCost - subscriptionCredits;
      _remainingSubscriptionCredits[nanoId] = _CacheEntry(0);
      final currentPurchasedEntry = _remainingPurchasedCredits[nanoId];
      final currentPurchasedValue =
          currentPurchasedEntry?.value ?? purchasedCredits;
      _remainingPurchasedCredits[nanoId] = _CacheEntry(
        currentPurchasedValue - remainingCost,
      );
      return;
    }

    // No subscription credits, deduct all from purchased credits
    if (purchasedCredits >= creditCost) {
      final currentEntry = _remainingPurchasedCredits[nanoId];
      final currentValue = currentEntry?.value ?? purchasedCredits;
      _remainingPurchasedCredits[nanoId] = _CacheEntry(
        currentValue - creditCost,
      );
      return;
    }

    throw _insufficientCredits();
  }

  Future<ScrappingBeeExtractLogic> _getExtractRules(
    Session session,
    Scrappable scrappable,
    String? accountApiKeyString,
  ) async {
    final isTest = accountApiKeyString == null;
    if (isTest) {
      final testSessionExtractRule = getTestExtractRules(scrappable.id!);
      if (testSessionExtractRule == null) {
        throw _noActiveTestSessionFinded();
      }

      return testSessionExtractRule;
    }

    final ScrappingBeeExtractLogic? extractRules =
        scrappable.scrappingBeeExtractRules;

    if (extractRules == null) throw _missingExtractRules();

    return extractRules;
  }

  bool checkIdApiKeyExists(NanoId? nanoId, ApiKey? apiKey) {
    final entry = _apiKeysAttachedToNanoId[nanoId];
    if (entry == null || entry.isExpired(ApiHelperConfig.nanoIdCacheMaxAge)) {
      return false;
    }
    return entry.value.contains(apiKey);
  }

  Future<void> guaranteeApiKeyExists(
    Session session,
    NanoId? nanoId,
    ApiKey? apiKey,
  ) async {
    final isTest = nanoId == null || apiKey == null;
    if (isTest) return;

    final accountApiUsage = await AccountApiUsage.db.findFirstRow(
      session,
      where: (p0) =>
          p0.nanoId.equals(nanoId) &
          p0.apiKeys.any(
            (key) => key.apiKey.equals(apiKey) & key.isActive.equals(true),
          ),
    );

    if (accountApiUsage == null) {
      throw _apiKeyNotFound(apiKey);
    } else {
      final existingEntry = _apiKeysAttachedToNanoId[nanoId];
      if (existingEntry == null ||
          existingEntry.isExpired(ApiHelperConfig.nanoIdCacheMaxAge)) {
        _apiKeysAttachedToNanoId[nanoId] = _CacheEntry([apiKey]);
      } else if (!existingEntry.value.contains(apiKey)) {
        existingEntry.value.add(apiKey);
      }
    }
  }

  Future<T> wrapAnalytics<T>(
    Session session,
    ScrappableId scrappableId,
    ApiKey? apiKey,
    Map<String, dynamic> payload,
    Future<T> Function(
      NanoId? nanoId,
      Scrappable scrappable,
      Stopwatch stopwatch,
    )
    call,
  ) async {
    // Start stopwatch at the EARLIEST point to capture full request duration
    final stopwatch = Stopwatch()..start();
    final now = DateTime.now();
    final String stringifiedPayload = jsonEncode(payload);
    Scrappable scrappable;
    NanoId? nanoId;
    try {
      final result = await setAllDependencies(session, scrappableId, apiKey);
      nanoId = result.nanoId;
      scrappable = result.scrappable;
      increaseConcurrency(nanoId, result.planTier);
      final doesApiKeyExists = checkIdApiKeyExists(nanoId, apiKey);
      // Will throw if not exists and cache result if exist so new calls to db are not needed each time
      if (!doesApiKeyExists) {
        await guaranteeApiKeyExists(session, nanoId, apiKey);
      }

      return await call(nanoId, scrappable, stopwatch);
    } on ApiError catch (error, stackTrace) {
      stopwatch.stop();
      final requestDuration = stopwatch.elapsed;
      session.log(
        '[${error.status.name.toUpperCase()}] ${error.exception.title}',
        exception: error.exception,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: error.status,
            stringifiedPayload: stringifiedPayload,
            title: error.exception.title,
            description: error.exception.description,
            errorObjectAsString: error.exception.toString(),
            errorStackTraceAsString: stackTrace.toString(),
            duration: requestDuration,
          ),
        );
      }
      rethrow;
    } on ZenScrapException catch (error, stackTrace) {
      stopwatch.stop();
      final requestDuration = stopwatch.elapsed;
      // Convert ZenScrapException to ApiError to preserve error details
      final apiError = ApiError(RequestStatus.clientError, error);
      session.log(
        '[${apiError.status.name.toUpperCase()}] ${error.title}',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: apiError.status,
            stringifiedPayload: stringifiedPayload,
            title: error.title,
            description: error.description,
            errorObjectAsString: error.toString(),
            errorStackTraceAsString: stackTrace.toString(),
            duration: requestDuration,
          ),
        );
      }
      throw apiError;
    } catch (error, stackTrace) {
      stopwatch.stop();
      final requestDuration = stopwatch.elapsed;
      session.log(
        'An unknown error occurred in api',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: RequestStatus.serverError,
            stringifiedPayload: stringifiedPayload,
            title: getErrorTitle('unexpected_error', SupportedLanguage.en),
            description: getErrorDescription(
              'unexpected_error',
              SupportedLanguage.en,
            ),
            errorObjectAsString: error.toString(),
            errorStackTraceAsString: stackTrace.toString(),
            duration: requestDuration,
          ),
        );
      }
      // Handle any other exceptions
      throw createTranslatedException('unexpected_error', SupportedLanguage.en);
    } finally {
      decreaseConcurrency(nanoId);
    }
  }

  /// Gets the current credit information for a nanoId
  /// Returns null if nanoId is null (test requests)
  Map<String, dynamic>? _getCreditInfo(NanoId? nanoId, int creditCost) {
    if (nanoId == null) return null;

    final subscriptionCredits =
        _remainingSubscriptionCredits[nanoId]?.value ?? 0;
    final purchasedCredits = _remainingPurchasedCredits[nanoId]?.value ?? 0;
    final totalCredits = subscriptionCredits + purchasedCredits;

    return {
      'spent': creditCost,
      'remaining': {
        'subscription': subscriptionCredits,
        'purchased': purchasedCredits,
        'total': totalCredits,
      },
    };
  }

  AsyncResultDart<Map<String, dynamic>, ApiError> callFunc(
    Session session, {
    required int scrappableId,
    String? apiKey,
    required Map<String, dynamic> payload,
  }) async {
    final String stringifiedPayload = jsonEncode(payload);

    // Validate country code if provided in payload
    final String? countryCodeOverride = payload['countryCode'] as String?;
    if (countryCodeOverride != null &&
        countryCodeOverride.isNotEmpty &&
        !isValidScrapingBeeCountryCode(countryCodeOverride)) {
      return ApiError(
        RequestStatus.clientError,
        createTranslatedException(
          'invalid_country_code',
          SupportedLanguage.en,
          params: {'countryCode': countryCodeOverride},
        ),
      ).toFailure();
    }

    try {
      return await wrapAnalytics(session, scrappableId, apiKey, payload, (
        nanoId,
        scrappable,
        stopwatch,
      ) async {
        // final (Scrappable scrappable, ScrappableRequest targetRequest) =
        //     await getScrappableById(session, scrappableId, nanoId);
        // setScrappableCallback(scrappable);
        throwErrorIfIsATestRequestAndTestTimeExpired(apiKey, scrappable);

        final isTestRequest = apiKey == null;

        final ScrappingBeeExtractLogic extractRules = await _getExtractRules(
          session,
          scrappable,
          apiKey,
        );

        // Calculate the actual credit cost for this extraction using the totalCreditCost getter
        final creditCost = extractRules.totalCreditCost;

        // Discount the actual cost from the account
        await discountApiTokens(
          session,
          nanoId: nanoId,
          creditCost: creditCost,
        );

        // Get the scrappable request - use cached version for test requests
        final ScrappableRequest scrappableRequest = isTestRequest
            ? (getScrappableRequest(scrappable.id!) ??
                  scrappable.targetRequest!)
            : scrappable.targetRequest!;

        final String targetUrl = composeUrl(payload, scrappableRequest);

        // For test requests, use fetchHtmlAndScreenshotWithLogic (heavier, includes screenshot)
        // For production requests, use extractByRulesWithLogic (lighter, no screenshot)
        if (isTestRequest) {
          // Get the current reference test data from cache
          final ReferenceTestData? currentTestData = getReferenceTestData(
            scrappable.id!,
          );

          if (currentTestData == null) {
            // Stop stopwatch before returning error
            stopwatch.stop();
            return ApiError(
              RequestStatus.serverError,
              createTranslatedException(
                'test_data_not_found',
                SupportedLanguage.en,
              ),
            ).toFailure();
          }

          // Replace placeholders in extract logic before calling ScrapingBee
          final extractLogicWithReplacedPlaceholders =
              replaceExtractLogicPlaceholders(extractRules, payload);

          // ScrapingBee API call - stopwatch already running from wrapAnalytics
          final ExtractFullDataByRule extractResponse = await scrappingBee
              .fetchHtmlAndScreenshotWithLogic(
                targetUrl: targetUrl,
                scrappingBeeExtractLogic: extractLogicWithReplacedPlaceholders,
              );
          // Stop stopwatch after ScrapingBee call completes (success or error)
          stopwatch.stop();
          final requestDuration = stopwatch.elapsed;

          return extractResponse.when(
            withData: (scrapedData, html, pageFullscreenScreenshot) async {
              final responseJson = jsonEncode(scrapedData);
              // Track success analytics
              if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(
                    apiKey,
                  ) ==
                  true) {
                _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                  AnalyticsPayload(
                    time: DateTime.now(),
                    status: RequestStatus.success,
                    stringifiedPayload: stringifiedPayload,
                    stringifiedResponse: responseJson,
                    duration: requestDuration,
                  ),
                );
              }

              // Create ByteTestData with the new HTML and screenshot
              final Uint8List htmlBytes = utf8.encode(html);
              final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
              final ByteData screenshotByteData = ByteData.view(
                pageFullscreenScreenshot.buffer,
              );

              ByteTestData byteTestData =
                  currentTestData.byteData?.copyWith(
                    referenceHtmlPage: htmlByteData,
                    referenceSiteScreenshot: screenshotByteData,
                  ) ??
                  ByteTestData(
                    referenceHtmlPage: htmlByteData,
                    referenceSiteScreenshot: screenshotByteData,
                  );

              // Create new ReferenceTestData with updated data
              ReferenceTestData newReferenceTestData = currentTestData.copyWith(
                scrapResultJson: jsonEncode(scrapedData),
                byteData: byteTestData,
                referenceLinkUsed: targetUrl,
              );

              // Update the cache with new reference test data
              updateTestReferenceData(scrappable.id!, newReferenceTestData);

              // Send success notification to chat session with updated test data
              sendSystemMessageToScrappableSession(
                scrappableId: scrappable.id!,
                response: TestEndpointCalledSuccessResponse(
                  role: PromptRole.system,
                  expectsFollowUp:
                      false, // Test result notification, no follow-up
                  inputPayload: stringifiedPayload,
                  responseData: jsonEncode(scrapedData),
                  timestamp: DateTime.now(),
                  referenceTestData: newReferenceTestData,
                ),
              );

              // Create response with scraped data and credit information
              final response = <String, dynamic>{
                'credits': _getCreditInfo(nanoId, creditCost),
                'data': scrapedData,
              };
              return response.toSuccess();
            },
            error: (errorMessage) {
              // Track ScrapingBee errors separately
              if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(
                    apiKey,
                  ) ==
                  true) {
                _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                  AnalyticsPayload(
                    time: DateTime.now(),
                    status: RequestStatus.failedAtScrappingBee,
                    stringifiedPayload: stringifiedPayload,
                    title: 'Scraping Error',
                    description: errorMessage,
                    duration: requestDuration,
                  ),
                );
              }

              // Send error notification to chat session
              sendSystemMessageToScrappableSession(
                scrappableId: scrappable.id!,
                response: TestEndpointCalledErrorResponse(
                  role: PromptRole.system,
                  expectsFollowUp:
                      false, // Test error notification, no follow-up
                  errorTitle: 'Scraping Error',
                  errorDescription: errorMessage,
                  inputPayload: stringifiedPayload,
                  timestamp: DateTime.now(),
                ),
              );

              return ApiError(
                RequestStatus.failedAtScrappingBee,
                ZenScrapException(
                  title: 'Scraping Error',
                  description: errorMessage,
                ),
              ).toFailure();
            },
          );
        } else {
          // Production request - use lighter extraction without screenshot
          // Replace placeholders in extract logic before calling ScrapingBee
          final extractLogicWithReplacedPlaceholders =
              replaceExtractLogicPlaceholders(extractRules, payload);

          // ScrapingBee API call - stopwatch already running from wrapAnalytics
          final ExtractDataByRule extractResponse = await scrappingBee
              .extractByRulesWithLogic(
                targetUrl: targetUrl,
                scrappingBeeExtractLogic: extractLogicWithReplacedPlaceholders,
              );
          // Stop stopwatch after ScrapingBee call completes (success or error)
          stopwatch.stop();
          final requestDuration = stopwatch.elapsed;

          return extractResponse.when(
            withData: (scrapedData) {
              final responseJson = jsonEncode(scrapedData);
              // Track success analytics
              if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(
                    apiKey,
                  ) ==
                  true) {
                _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                  AnalyticsPayload(
                    time: DateTime.now(),
                    status: RequestStatus.success,
                    stringifiedPayload: stringifiedPayload,
                    stringifiedResponse: responseJson,
                    duration: requestDuration,
                  ),
                );
              }

              // Create response with scraped data and credit information
              final response = <String, dynamic>{
                'credits': _getCreditInfo(nanoId, creditCost),
                'data': scrapedData,
              };
              return response.toSuccess();
            },
            error: (errorMessage) {
              // Track ScrapingBee errors separately
              if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(
                    apiKey,
                  ) ==
                  true) {
                _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                  AnalyticsPayload(
                    time: DateTime.now(),
                    status: RequestStatus.failedAtScrappingBee,
                    stringifiedPayload: stringifiedPayload,
                    title: 'Scraping Error',
                    description: errorMessage,
                    duration: requestDuration,
                  ),
                );
              }

              return ApiError(
                RequestStatus.failedAtScrappingBee,
                ZenScrapException(
                  title: 'Scraping Error',
                  description: errorMessage,
                ),
              ).toFailure();
            },
          );
        }
      });
    } on ZenScrapException catch (error) {
      return ApiError(RequestStatus.serverError, error).toFailure();
    } on ApiError catch (error) {
      return error.toFailure();
    } catch (error, stackTrace) {
      session.log(
        'Unexpected error in ScrappableApiRoute',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      return ApiError(
        RequestStatus.serverError,
        createTranslatedException('unexpected_error', SupportedLanguage.en),
      ).toFailure();
    }
  }
}

ApiError _noCreditUsageModelFound(
  ApiKey apiKey, [
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException(
    'no_credit_usage_model',
    lang,
    params: {'apiKey': apiKey},
  ),
);

ApiError _apiKeyNotFound(
  ApiKey apiKey, [
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException(
    'api_key_not_found_active',
    lang,
    params: {'apiKey': apiKey},
  ),
);
ApiError _noActiveTestSessionFinded([
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException('no_active_test_session', lang),
);

ApiError _testPeriodExpired([SupportedLanguage lang = SupportedLanguage.en]) =>
    ApiError(
      RequestStatus.clientError,
      createTranslatedException('test_period_expired', lang),
    );

ApiError _noApiFound([SupportedLanguage lang = SupportedLanguage.en]) =>
    ApiError(
      RequestStatus.clientError,
      createTranslatedException('api_key_database_not_found', lang),
    );
// final _scrappableDataDissasociated = ApiError(
//   RequestStatus.serverError,
//   ZenScrapException(
//     title: 'Scrappable Data Dissasociated',
//     description:
//         'The scrappable data is dissasociated the current stack. This is a rare error that can happen after a server migration - your next scrapping request should work fine. If the error persists, contact support.',
//   ),
// );

ApiError _insufficientCredits([
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.insufficientCredits,
  createTranslatedException('insufficient_credits', lang),
);

ApiError _missingExtractRules([
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException('missing_extract_rules', lang),
);

ApiError _invalidApiKey([SupportedLanguage lang = SupportedLanguage.en]) =>
    ApiError(
      RequestStatus.clientError,
      createTranslatedException('invalid_api_key_account', lang),
    );

ApiError _maxConcurrencyReached(
  int maxQuantityOfParallelRequests, [
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.maxConcurrencyExceeded,
  createTranslatedException(
    'concurrency_limit_exceeded',
    lang,
    params: {'maxConcurrentRequests': maxQuantityOfParallelRequests.toString()},
  ),
);

ApiError _noScrappableFound(
  String scrappableId, [
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException(
    'api_scrappable_not_found',
    lang,
    params: {'scrappableId': scrappableId},
  ),
);

ApiError _invalidApiKeyFormat([
  SupportedLanguage lang = SupportedLanguage.en,
]) => ApiError(
  RequestStatus.clientError,
  createTranslatedException('invalid_api_key_format', lang),
);

class ApiError {
  final RequestStatus status;
  final ZenScrapException exception;

  ApiError(this.status, this.exception);
}

class AnalyticsPayload {
  final RequestStatus status;
  final DateTime time;
  final String? title;
  final String? description;
  final String? errorObjectAsString;
  final String? errorStackTraceAsString;
  final String stringifiedPayload;

  /// The JSON-encoded response data (only present on successful requests)
  final String? stringifiedResponse;

  /// The duration of the request execution (only present when timing was captured)
  final Duration? duration;

  const AnalyticsPayload({
    required this.time,
    required this.status,
    required this.stringifiedPayload,
    this.title,
    this.description,
    this.errorObjectAsString,
    this.errorStackTraceAsString,
    this.stringifiedResponse,
    this.duration,
  });
}

class PeriodicSetRequestsAnalytics extends FutureCall {
  static const String callName = 'periodicSetRequestsAnalytics';

  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    Map<ScrappableId, Map<NanoId, Map<ApiKey, List<AnalyticsPayload>>>>
    pendingAnalytics = {...ApiHelperMixin._pendingAnalytics};
    ApiHelperMixin._pendingAnalytics.clear();

    for (final entry in pendingAnalytics.entries) {
      final scrappableId = entry.key;
      // Extract actual Scrappable value from cache entry
      final scrappable = ApiHelperMixin._scrappables[scrappableId]?.value;
      for (final requestEntry in entry.value.entries) {
        final nanoId = requestEntry.key;
        final apiKeys = requestEntry.value;
        for (final apiKeyEntry in apiKeys.entries) {
          final apiKey = apiKeyEntry.key;
          final analyticsPayload = apiKeyEntry.value;

          await _setScrappableAnalytics(
            session,
            scrappable: scrappable,
            apiKey: apiKey,
            nanoId: nanoId,
            items: analyticsPayload,
          );
        }
      }
    }

    // Schedule the next execution
    await session.serverpod.futureCallWithDelay(
      callName,
      null,
      ApiHelperConfig.analyticsBatchInterval,
      identifier: callName,
    );
  }
}

/// Periodic cleanup for in-memory caches to prevent memory leaks.
/// This FutureCall runs at [ApiHelperConfig.cacheCleanupInterval] and evicts expired cache entries.
class PeriodicCacheCleanup extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      // Log cache sizes before cleanup for monitoring
      final beforeSizes = _getCacheSizes();

      // Perform cleanup
      ApiHelperMixin.cleanupExpiredCacheEntries();

      // Log cache sizes after cleanup
      final afterSizes = _getCacheSizes();

      session.log(
        'Cache cleanup completed. '
        'PlanTier: ${beforeSizes['planTier']} -> ${afterSizes['planTier']}, '
        'CreditUsage: ${beforeSizes['creditUsage']} -> ${afterSizes['creditUsage']}, '
        'Scrappables: ${beforeSizes['scrappables']} -> ${afterSizes['scrappables']}, '
        'ApiKeys: ${beforeSizes['apiKeys']} -> ${afterSizes['apiKeys']}',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error during periodic cache cleanup',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }

    // Schedule the next execution
    await session.serverpod.futureCallWithDelay(
      'periodicCacheCleanup',
      null,
      ApiHelperConfig.cacheCleanupInterval,
      identifier: 'periodicCacheCleanup',
    );
  }

  Map<String, int> _getCacheSizes() {
    return {
      'planTier': ApiHelperMixin._currentAccountPlanTierCache.length,
      'creditUsage': ApiHelperMixin._currentCreditUsage.length,
      'scrappables': ApiHelperMixin._scrappables.length,
      'apiKeys': ApiHelperMixin._apiKeysAttachedToNanoId.length,
      'subscriptionCredits':
          ApiHelperMixin._remainingSubscriptionCredits.length,
      'purchasedCredits': ApiHelperMixin._remainingPurchasedCredits.length,
      'allowedScrappables': ApiHelperMixin._allowedScrappableIdsToUse.length,
      'concurrency': ApiHelperMixin._currentConcurrencyRequests.length,
    };
  }
}

class PeriodicCleanupOldAnalyticsDetails extends FutureCall {
  static const String callName = 'periodicCleanupOldAnalyticsDetails';

  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    try {
      final now = DateTime.now();
      final retentionCutoff = now.subtract(
        ApiHelperConfig.analyticsRetentionPeriod,
      );

      // STEP 1: Calculate and update average durations BEFORE deleting old analytics
      await _updateAverageDurationsForAllScrappables(session);

      // STEP 2: Delete all AnalyticsRequestDetails older than retention period
      final deletedCount = await AnalyticsRequestDetails.db.deleteWhere(
        session,
        where: (t) => t.timeStamp < retentionCutoff,
      );

      session.log(
        'Cleaned up $deletedCount old analytics details (older than ${ApiHelperConfig.analyticsRetentionPeriod.inDays} days)',
        level: LogLevel.info,
      );

      // STEP 3: Clean up orphaned ScrappableAverageDuration records
      await _cleanupOrphanedAverageDurations(session);
    } catch (e, stackTrace) {
      session.log(
        'Error during periodic cleanup of analytics details',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }

    // Schedule the next execution
    await session.serverpod.futureCallWithDelay(
      callName,
      null,
      ApiHelperConfig.analyticsCleanupInterval,
      identifier: callName,
    );
  }

  /// Updates average duration for all scrappables that have analytics with duration data.
  ///
  /// This method processes scrappables in chunks of [ApiHelperConfig.cleanupBatchSize]
  /// to avoid memory issues when dealing with large datasets.
  Future<void> _updateAverageDurationsForAllScrappables(Session session) async {
    try {
      const int chunkSize = ApiHelperConfig.cleanupBatchSize;
      int offset = 0;
      bool hasMore = true;
      int updatedCount = 0;

      while (hasMore) {
        // Get a chunk of scrappable IDs that have analytics with duration
        final scrappableIds = await _getUniqueScrappableIdsWithDuration(
          session,
          limit: chunkSize,
          offset: offset,
        );

        if (scrappableIds.isEmpty) {
          hasMore = false;
          break;
        }

        // Process this chunk
        for (final scrappableId in scrappableIds) {
          final wasUpdated = await _updateAverageDurationForScrappable(
            session,
            scrappableId,
          );
          if (wasUpdated) {
            updatedCount++;
          }
        }

        offset += chunkSize;

        // Safety check to avoid infinite loops
        if (scrappableIds.length < chunkSize) {
          hasMore = false;
        }
      }

      session.log(
        'Updated average durations for $updatedCount scrappables',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error updating average durations',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }
  }

  /// Gets unique scrappable IDs that have analytics with duration data.
  ///
  /// Uses a raw SQL query with DISTINCT for efficient unique ID retrieval.
  /// Pagination is handled with [limit] and [offset] parameters.
  /// Returns a list of unique scrappable IDs ordered by scrappableId.
  Future<List<int>> _getUniqueScrappableIdsWithDuration(
    Session session, {
    required int limit,
    required int offset,
  }) async {
    // Use raw SQL with DISTINCT for efficient unique ID retrieval
    // This is much more efficient than fetching all records and deduplicating in Dart
    final result = await session.db.unsafeQuery(
      r'''
      SELECT DISTINCT "scrappableId"
      FROM "scrappable_analytics"
      WHERE "duration" IS NOT NULL
        AND "requestStatus" = 'success'
      ORDER BY "scrappableId"
      LIMIT @limit OFFSET @offset
      ''',
      parameters: QueryParameters.named({'limit': limit, 'offset': offset}),
    );

    // Map the result rows to a list of integers
    return result.map((row) => row[0] as int).toList();
  }

  /// Gets the timestamp of the most recent SUCCESS analytics record with duration
  /// for a given scrappable. Returns null if no records exist.
  ///
  /// This is used to determine if there's new data since the last average
  /// duration calculation, avoiding unnecessary recalculations.
  Future<DateTime?> _getLatestAnalyticsTimestamp(
    Session session,
    int scrappableId,
  ) async {
    final result = await ScrappableAnalytics.db.findFirstRow(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.duration.notEquals(null) &
          t.requestStatus.equals(RequestStatus.success),
      orderBy: (t) => t.requestedAt,
      orderDescending: true,
    );
    return result?.requestedAt;
  }

  /// Updates the average duration for a single scrappable.
  ///
  /// Fetches the last [ApiHelperConfig.averageDurationSampleSize] SUCCESS analytics
  /// records with duration data, calculates the average, and updates or creates
  /// the ScrappableAverageDuration record.
  ///
  /// This method only performs the calculation if there is new analytics data
  /// since the last update. This makes the `updatedAt` field meaningful - it
  /// accurately reflects when the average was last recalculated based on new data,
  /// not just when the periodic job ran.
  ///
  /// Returns true if the average duration was updated, false otherwise.
  Future<bool> _updateAverageDurationForScrappable(
    Session session,
    int scrappableId,
  ) async {
    // STEP 1: Get the timestamp of the most recent analytics record
    final latestAnalyticsTimestamp = await _getLatestAnalyticsTimestamp(
      session,
      scrappableId,
    );

    // If no analytics exist, nothing to calculate
    if (latestAnalyticsTimestamp == null) {
      return false;
    }

    // STEP 2: Get the scrappable with its existing average duration info
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        averageDurationInfo: ScrappableAverageDuration.include(),
      ),
    );

    if (scrappable == null) {
      return false;
    }

    final existing = scrappable.averageDurationInfo;

    // STEP 3: Check if we need to update
    // Update required if:
    // - No existing record (first time calculation)
    // - Latest analytics timestamp is after the last update (new data exists)
    if (existing != null &&
        !latestAnalyticsTimestamp.isAfter(existing.updatedAt)) {
      // No new data since last calculation - SKIP
      session.log(
        'Skipping average duration update for scrappable $scrappableId - no new data since ${existing.updatedAt}',
        level: LogLevel.debug,
      );
      return false;
    }

    // STEP 4: New data exists - proceed with calculation
    // Fetch last N SUCCESS analytics with duration for this scrappable
    final analytics = await ScrappableAnalytics.db.find(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.duration.notEquals(null) &
          t.requestStatus.equals(RequestStatus.success),
      limit: ApiHelperConfig.averageDurationSampleSize,
      orderBy: (t) => t.requestedAt,
      orderDescending: true, // Most recent first
    );

    if (analytics.isEmpty) {
      return false;
    }

    // Extract durations
    final durations = analytics
        .where((a) => a.duration != null)
        .map((a) => a.duration!)
        .toList();

    if (durations.isEmpty) {
      return false;
    }

    // Calculate average
    final avgDuration = durations.average;

    // STEP 5: Update or create the average duration info
    if (existing == null) {
      // Create new ScrappableAverageDuration
      final avgInfo = ScrappableAverageDuration(
        updatedAt: DateTime.now(),
        averageDuration: avgDuration,
      );
      final inserted = await ScrappableAverageDuration.db.insertRow(
        session,
        avgInfo,
      );

      // Update scrappable to link to the new average duration info
      await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(averageDurationInfoId: inserted.id),
      );
    } else {
      // Update existing ScrappableAverageDuration
      await ScrappableAverageDuration.db.updateRow(
        session,
        existing.copyWith(
          updatedAt: DateTime.now(),
          averageDuration: avgDuration,
        ),
      );
    }

    return true;
  }

  /// Cleans up orphaned ScrappableAverageDuration records.
  ///
  /// An orphaned record is one that is not referenced by any active (non-deleted)
  /// scrappable. This can happen when:
  /// - A scrappable is soft-deleted (isDeleted = true)
  /// - A scrappable is hard-deleted
  /// - The averageDurationInfoId is set to null
  ///
  /// This method finds all ScrappableAverageDuration IDs that are:
  /// 1. Not referenced by any scrappable with isDeleted = false
  /// 2. Older than 1 day (to avoid race conditions with recent creations)
  Future<void> _cleanupOrphanedAverageDurations(Session session) async {
    try {
      // Get all averageDurationInfoIds that are currently in use by active scrappables
      final activeScrappables = await Scrappable.db.find(
        session,
        where: (t) =>
            t.isDeleted.equals(false) & t.averageDurationInfoId.notEquals(null),
      );

      final activeAverageDurationIds = activeScrappables
          .map((s) => s.averageDurationInfoId)
          .whereType<int>()
          .toSet();

      // Find all ScrappableAverageDuration records that are older than the threshold
      // to avoid race conditions with newly created records
      final orphanThreshold = DateTime.now().subtract(
        ApiHelperConfig.orphanedRecordThreshold,
      );

      final allAverageDurations = await ScrappableAverageDuration.db.find(
        session,
        where: (t) => t.updatedAt < orphanThreshold,
      );

      // Filter to find orphaned records (not in the active set)
      final orphanedRecords = allAverageDurations
          .where((record) => !activeAverageDurationIds.contains(record.id))
          .toList();

      if (orphanedRecords.isEmpty) {
        session.log(
          'No orphaned ScrappableAverageDuration records to clean up',
          level: LogLevel.debug,
        );
        return;
      }

      // Delete orphaned records
      await ScrappableAverageDuration.db.delete(session, orphanedRecords);

      session.log(
        'Cleaned up ${orphanedRecords.length} orphaned ScrappableAverageDuration records',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error cleaning up orphaned ScrappableAverageDuration records',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }
  }
}

Future<void> _setScrappableAnalytics(
  Session session, {
  Scrappable? scrappable,
  ApiKey? apiKey,
  NanoId? nanoId,
  required List<AnalyticsPayload> items,
}) async {
  if (scrappable != null && apiKey != null && nanoId != null) {
    // Extract actual CreditUsage value from cache entry
    final CreditUsage? credit =
        ApiHelperMixin._currentCreditUsage[nanoId]?.value;
    if (credit == null) {
      session.log(
        'Credit usage not found for nanoId $nanoId when trying to log scrappable analytics',
        level: LogLevel.error,
      );
      throw _noCreditUsageModelFound(apiKey);
    }

    // Fetch the AccountApiKey entity to link it to the analytics record
    final accountApiKey = await AccountApiKey.db.findFirstRow(
      session,
      where: (t) => t.apiKey.equals(apiKey) & t.isActive.equals(true),
    );

    await session.db.transaction((transaction) async {
      // Extract actual values from cache entries
      final newCredit = credit.copyWith(
        subscriptionCredits:
            ApiHelperMixin._remainingSubscriptionCredits[nanoId]?.value,
        purchasedCredits:
            ApiHelperMixin._remainingPurchasedCredits[nanoId]?.value,
      );
      await CreditUsage.db.updateRow(
        session,
        newCredit,
        transaction: transaction,
      );

      // First, create all AnalyticsRequestDetails
      final detailsList = await AnalyticsRequestDetails.db.insert(
        session,
        items.map((e) {
          return AnalyticsRequestDetails(
            timeStamp: e.time,
            title: e.title,
            description: e.description,
            errorObjectAsString: e.errorObjectAsString,
            errorStackTraceAsString: e.errorStackTraceAsString,
            stringifiedPayload: e.stringifiedPayload,
            stringifiedResponse: e.stringifiedResponse,
          );
        }).toList(),
        transaction: transaction,
      );

      // Then create ScrappableAnalytics with detailsId and apiKeyId set
      final analytics = await ScrappableAnalytics.db.insert(
        session,
        List.generate(items.length, (i) {
          return ScrappableAnalytics(
            requestStatus: items[i].status,
            scrappableId: scrappable.id!,
            scrappable: scrappable,
            requestedAt: items[i].time,
            attachedApiKey: apiKey,
            attachedNanoId: nanoId,
            detailsId: detailsList[i].id,
            apiKeyId: accountApiKey?.id,
            duration: items[i].duration,
          );
        }),
        transaction: transaction,
      );

      await Scrappable.db.attach.scrappableAnalytics(
        session,
        scrappable,
        analytics,
        transaction: transaction,
      );

      // Update consecutive error counter for auto-fix feature
      // The counter is now stored in AutoFixConfig (separate model for smaller update footprint)
      final autoFixConfig = await AutoFixConfig.db.findFirstRow(
        session,
        where: (t) => t.scrappableId.equals(scrappable.id),
        transaction: transaction,
      );

      if (autoFixConfig != null) {
        // Sort items by timestamp to process in chronological order
        final sortedItems = List<AnalyticsPayload>.from(items)
          ..sort((a, b) => a.time.compareTo(b.time));

        // Calculate new consecutive error count
        // Start with current count from the auto-fix config
        int newConsecutiveErrors = autoFixConfig.currentConsecutiveErrors;

        for (final item in sortedItems) {
          if (item.status == RequestStatus.success) {
            // Success resets the counter
            newConsecutiveErrors = 0;
          } else {
            // Any error increments the counter
            newConsecutiveErrors++;
          }
        }

        // Only update if the counter changed
        if (newConsecutiveErrors != autoFixConfig.currentConsecutiveErrors) {
          await AutoFixConfig.db.updateRow(
            session,
            autoFixConfig.copyWith(
              currentConsecutiveErrors: newConsecutiveErrors,
            ),
            columns: (t) => [t.currentConsecutiveErrors],
            transaction: transaction,
          );

          // Check if we just reached the threshold and auto-fix is disabled
          // Only notify when we cross the threshold (previous count was below, new count is at/above)
          final justReachedThreshold =
              autoFixConfig.currentConsecutiveErrors <
                  autoFixConfig.consecutiveErrorThreshold &&
              newConsecutiveErrors >= autoFixConfig.consecutiveErrorThreshold;

          if (justReachedThreshold && !autoFixConfig.enabled) {
            // Send notification outside transaction to avoid blocking
            // Use unawaited to not block the transaction
            unawaited(
              AutoFixNotificationService.notifyScraperBroken(
                session: session,
                scrappable: scrappable,
                errorCount: newConsecutiveErrors,
              ),
            );
          }
        }
      }
    });
  }
}
