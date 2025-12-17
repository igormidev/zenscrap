// ignore_for_file: constant_identifier_names
import 'package:serverpod_auth_idp_server/core.dart';

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateScrappableAnalyticsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<PaginatedScrappableRequestsAnalytics>
      getScrappableAnalyticsWithScope(
    Session session, {
    int page = 1,
    AnalyticsTimeScope scope = AnalyticsTimeScope.last12Hours,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    const int pageSize = kAnalyticsSummaryPageSize;
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) throw _authenticationFailed(language);
    final userId = authenticationInfo.authUserId;
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      include: AccountInfo.include(
        accountApiUsage: AccountApiUsage.include(),
      ),
    );
    if (accountInfo == null) {
      throw _accountNotFoundForUser(language);
    }

    // Get the user's nanoId from their AccountApiUsage
    final userNanoId = accountInfo.accountApiUsage?.nanoId;
    if (userNanoId == null) {
      throw _accountNotFoundForUser(language);
    }

    final now = DateTime.now();

    // Calculate time scopes based on selected scope
    final List<Duration> timeScopes;

    switch (scope) {
      case AnalyticsTimeScope.lastHour:
        // 12 intervals of 5 minutes each
        timeScopes = List.generate(12, (i) => Duration(minutes: 5 * (i + 1)));
        break;
      case AnalyticsTimeScope.last12Hours:
        // 12 intervals of 1 hour each
        timeScopes = List.generate(12, (i) => Duration(hours: i + 1));
        break;
      case AnalyticsTimeScope.last24Hours:
        // 24 intervals of 1 hour each
        timeScopes = List.generate(24, (i) => Duration(hours: i + 1));
        break;
      case AnalyticsTimeScope.last7Days:
        // 7 intervals of 1 day each
        timeScopes = List.generate(7, (i) => Duration(days: i + 1));
        break;
      case AnalyticsTimeScope.last30Days:
        // 30 intervals of 1 day each
        timeScopes = List.generate(30, (i) => Duration(days: i + 1));
        break;
    }

    // Find all unique scrappableIds that this user has interacted with
    // by querying analytics records with their nanoId
    final analyticsWithUserInteraction = await ScrappableAnalytics.db.find(
      session,
      where: (t) => t.attachedNanoId.equals(userNanoId),
      include: ScrappableAnalytics.include(
        scrappable: Scrappable.include(),
      ),
    );

    // Extract unique scrappables from the analytics records
    final Map<int, Scrappable> uniqueScrappablesMap = {};
    for (final analytics in analyticsWithUserInteraction) {
      final scrappable = analytics.scrappable;
      if (scrappable != null && scrappable.id != null && !scrappable.isDeleted) {
        uniqueScrappablesMap[scrappable.id!] = scrappable;
      }
    }

    // Get total count of unique scrappables user has interacted with
    final totalCount = uniqueScrappablesMap.length;

    final offset = (page - 1) * pageSize;

    // Get paginated list of scrappable IDs
    final allScrappableIds = uniqueScrappablesMap.keys.toList()..sort();
    final paginatedIds = allScrappableIds.skip(offset).take(pageSize).toList();

    // ==========================================================================
    // OPTIMIZED: Single aggregated query instead of N+1 queries
    // ==========================================================================
    // Previously: For each scrappable × each interval × each status = separate query
    // Now: Single query with GROUP BY, then map results to data structures
    // ==========================================================================

    if (paginatedIds.isEmpty) {
      return PaginatedScrappableRequestsAnalytics(
        scope: scope,
        items: [],
        hasNextPage: false,
        totalCount: totalCount,
        currentPage: page,
        pageSize: pageSize,
      );
    }

    // Calculate the time intervals for this scope
    final List<({DateTime start, DateTime end})> intervals = [];
    DateTime intervalEnd = now;
    for (final Duration duration in timeScopes) {
      final DateTime intervalStart = now.subtract(duration);
      intervals.add((start: intervalStart, end: intervalEnd));
      intervalEnd = intervalStart;
    }

    // Get the overall time range (from oldest interval start to now)
    final DateTime overallStart = now.subtract(timeScopes.last);
    final DateTime overallEnd = now;

    // Execute a single aggregated query for all scrappables and statuses
    // This replaces potentially thousands of individual count queries
    final aggregatedResult = await session.db.unsafeQuery(
      r'''
      SELECT
        "scrappableId",
        "requestStatus",
        "requestedAt"
      FROM "scrappable_analytics"
      WHERE "scrappableId" = ANY(@scrappableIds)
        AND "requestedAt" >= @startTime
        AND "requestedAt" <= @endTime
      ORDER BY "scrappableId", "requestedAt"
      ''',
      parameters: QueryParameters.named({
        'scrappableIds': paginatedIds,
        'startTime': overallStart,
        'endTime': overallEnd,
      }),
    );

    // Build a map: scrappableId -> intervalIndex -> status -> count
    // We need to bucket each record into the correct interval
    final Map<int, Map<int, Map<String, int>>> countsByScrapAndInterval = {};

    // Initialize the structure for all scrappables and intervals
    for (final scrappableId in paginatedIds) {
      countsByScrapAndInterval[scrappableId] = {};
      for (var i = 0; i < intervals.length; i++) {
        countsByScrapAndInterval[scrappableId]![i] = {
          'success': 0,
          'clientError': 0,
          'serverError': 0,
          'insufficientCredits': 0,
          'maxConcurrencyExceeded': 0,
          'failedAtScrappingBee': 0,
        };
      }
    }

    // Process each record and bucket it into the appropriate interval
    for (final row in aggregatedResult) {
      final scrappableId = row[0] as int;
      final status = row[1] as String;
      final requestedAt = row[2] as DateTime;

      // Find which interval this record belongs to
      // Intervals are processed from most recent (index 0) to oldest (last index)
      // Each interval: (start, end] where end is inclusive
      for (var i = 0; i < intervals.length; i++) {
        final interval = intervals[i];
        // Match the original BETWEEN behavior: inclusive on both ends
        if ((requestedAt.isAtSameMomentAs(interval.start) ||
                requestedAt.isAfter(interval.start)) &&
            (requestedAt.isAtSameMomentAs(interval.end) ||
                requestedAt.isBefore(interval.end))) {
          countsByScrapAndInterval[scrappableId]?[i]?[status] =
              (countsByScrapAndInterval[scrappableId]?[i]?[status] ?? 0) + 1;
          break; // Each record belongs to one interval only
        }
      }
    }

    // Build the response items from the aggregated data
    final List<ScrappableRequestsAnalyticsItem> items = [];

    for (final scrappableId in paginatedIds) {
      final scrappable = uniqueScrappablesMap[scrappableId]!;
      final intervalCounts = countsByScrapAndInterval[scrappableId]!;

      // Calculate totals and build per-interval data
      int successTotalCount = 0;
      int clientErrorTotalCount = 0;
      int serverErrorTotalCount = 0;
      int insufficientCreditsTotalCount = 0;
      int maxConcurrencyExceededTotalCount = 0;
      int failedAtScrappingBeeTotalCount = 0;

      final List<ScrappableRequestPerTimeScope> data = [];

      for (var i = 0; i < intervals.length; i++) {
        final interval = intervals[i];
        final counts = intervalCounts[i]!;

        final successCount = counts['success']!;
        final clientErrorCount = counts['clientError']!;
        final serverErrorCount = counts['serverError']!;
        final insufficientCreditsCount = counts['insufficientCredits']!;
        final maxConcurrencyExceededCount = counts['maxConcurrencyExceeded']!;
        final failedAtScrappingBeeCount = counts['failedAtScrappingBee']!;

        successTotalCount += successCount;
        clientErrorTotalCount += clientErrorCount;
        serverErrorTotalCount += serverErrorCount;
        insufficientCreditsTotalCount += insufficientCreditsCount;
        maxConcurrencyExceededTotalCount += maxConcurrencyExceededCount;
        failedAtScrappingBeeTotalCount += failedAtScrappingBeeCount;

        data.add(ScrappableRequestPerTimeScope(
          start: interval.start,
          end: interval.end,
          successCount: successCount,
          clientErrorCount: clientErrorCount,
          serverErrorCount: serverErrorCount,
          insufficientCreditsCount: insufficientCreditsCount,
          maxConcurrencyExceededCount: maxConcurrencyExceededCount,
          failedAtScrappingBeeCount: failedAtScrappingBeeCount,
        ));
      }

      items.add(ScrappableRequestsAnalyticsItem(
        scrappable: scrappable,
        successTotalCount: successTotalCount,
        clientErrorTotalCount: clientErrorTotalCount,
        serverErrorTotalCount: serverErrorTotalCount,
        insufficientCreditsTotalCount: insufficientCreditsTotalCount,
        maxConcurrencyExceededTotalCount: maxConcurrencyExceededTotalCount,
        failedAtScrappingBeeTotalCount: failedAtScrappingBeeTotalCount,
        data: data.reversed.toList(),
      ));
    }

    return PaginatedScrappableRequestsAnalytics(
      scope: scope,
      items: items,
      hasNextPage: (offset + pageSize) < totalCount,
      totalCount: totalCount,
      currentPage: page,
      pageSize: pageSize,
    );
  }

  Future<PaginatedScrappableAnalytics> getScrappableAnalytics(
    Session session, {
    required int scrappableId,
    int page = 1,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    const int daysBack = 7;
    const int pageSize = kAnalyticsDetailPageSize;
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) throw _authenticationFailed(language);
    final userId = authenticationInfo.authUserId;
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      include: AccountInfo.include(
        accountApiUsage: AccountApiUsage.include(),
      ),
    );
    if (accountInfo == null) {
      throw _accountNotFoundForUser(language);
    }

    // Get the user's nanoId from their AccountApiUsage
    final userNanoId = accountInfo.accountApiUsage?.nanoId;
    if (userNanoId == null) {
      throw _accountNotFoundForUser(language);
    }

    // Verify scrappable exists
    final scrappable = await Scrappable.db.findById(session, scrappableId);
    if (scrappable == null) {
      throw _scrappableNotFoundOrNoAccess(language);
    }

    // Verify user has interacted with this scrappable (has analytics records with their nanoId)
    final hasInteraction = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.attachedNanoId.equals(userNanoId),
      limit: 1,
    );
    if (hasInteraction == 0) {
      throw _scrappableNotFoundOrNoAccess(language);
    }

    final now = DateTime.now();
    final targetDate = now.subtract(Duration(days: daysBack));

    // Get total count for pagination - only count analytics from this user
    final totalCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.attachedNanoId.equals(userNanoId) &
          (t.requestedAt >= targetDate),
    );

    final offset = (page - 1) * pageSize;

    // Fetch paginated analytics with includes for better performance
    // Only fetch analytics from this user
    final analytics = await ScrappableAnalytics.db.find(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.attachedNanoId.equals(userNanoId) &
          (t.requestedAt >= targetDate),
      limit: pageSize,
      offset: offset,
      orderBy: (t) => t.requestedAt,
      orderDescending: true,
      include: ScrappableAnalytics.include(
        scrappable: Scrappable.include(),
        details: AnalyticsRequestDetails.include(),
        apiKey: AccountApiKey.include(),
      ),
    );

    return PaginatedScrappableAnalytics(
      scrappable: scrappable,
      items: analytics,
      hasNextPage: (offset + pageSize) < totalCount,
      totalCount: totalCount,
      currentPage: page,
      pageSize: pageSize,
    );
  }

  /// Get usage metrics for a scrappable in the last 30 days
  /// This includes ALL requests from ANY user who called this scrappable
  Future<ScrappableUsageMetrics> getScrappableUsageMetrics(
    Session session, {
    required int scrappableId,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Verify scrappable exists
    final scrappable = await Scrappable.db.findById(session, scrappableId);
    if (scrappable == null) {
      throw _scrappableNotFound(language);
    }

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Count success requests (from ANY user)
    final successCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.requestedAt.between(thirtyDaysAgo, now) &
          t.requestStatus.equals(RequestStatus.success),
    );

    // Count server error (5xx) requests (from ANY user)
    final serverErrorCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.requestedAt.between(thirtyDaysAgo, now) &
          t.requestStatus.equals(RequestStatus.serverError),
    );

    // Count ScrapingBee error requests (from ANY user)
    final scrappingBeeErrorCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          t.requestedAt.between(thirtyDaysAgo, now) &
          t.requestStatus.equals(RequestStatus.failedAtScrappingBee),
    );

    // Total error count includes both server errors and ScrapingBee errors
    final errorCount = serverErrorCount + scrappingBeeErrorCount;
    final totalCount = successCount + errorCount;

    return ScrappableUsageMetrics(
      successCount: successCount,
      errorCount: errorCount,
      totalCount: totalCount,
    );
  }
}

const int MAX_DAYS_ALLOWED = 30;

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _accountNotFoundForUser(SupportedLanguage lang) =>
    createTranslatedException('account_not_found_for_user', lang);

ZenScrapException _scrappableNotFoundOrNoAccess(SupportedLanguage lang) =>
    createTranslatedException('scrappable_not_found_or_no_access', lang);

ZenScrapException _scrappableNotFound(SupportedLanguage lang) =>
    createTranslatedException('scrappable_not_found', lang);
