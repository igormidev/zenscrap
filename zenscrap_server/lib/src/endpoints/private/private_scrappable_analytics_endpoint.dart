// ignore_for_file: constant_identifier_names

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateScrappableAnalyticsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<PaginatedScrappableRequestsAnalytics>
      getScrappableAnalyticsWithScope(
    Session session, {
    int page = 1,
    AnalyticsTimeScope scope = AnalyticsTimeScope.last12Hours,
  }) async {
    const int pageSize = 20; // Fixed page size
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) throw defaultAuthenticationException;
    final userId = authenticationInfo.userId;
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );
    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account information found for the authenticated user.',
      );
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

    // Get total count of ALL scrappables for this account
    final totalCount = await Scrappable.db.count(
      session,
      where: (t) => t.accountId.equals(accountInfo.id),
    );

    final offset = (page - 1) * pageSize;
    // Get ALL scrappables, not just those with recent analytics
    final List<Scrappable> scrappables = await Scrappable.db.find(
      session,
      where: (t) => t.accountId.equals(accountInfo.id),
      limit: pageSize,
      offset: offset,
      orderBy: (t) => t.id,
      orderDescending: false,
    );

    final List<ScrappableRequestsAnalyticsItem> items = [];

    for (final Scrappable scrappable in scrappables) {
      final List<ScrappableRequestPerTimeScope> data = [];
      int successTotalCount = 0;
      int clientErrorTotalCount = 0;
      int serverErrorTotalCount = 0;
      int insufficientCreditsTotalCount = 0;
      int maxConcurrencyExceededTotalCount = 0;

      DateTime end = now;
      for (final Duration duration in timeScopes) {
        final DateTime start = now.subtract(duration);
        // Dwc stands for "Default where clause"
        dWC(ScrappableAnalyticsTable t, RequestStatus status) =>
            t.scrappableId.equals(scrappable.id) &
            (t.requestedAt.between(start, end)) &
            t.requestStatus.equals(status);

        final successCount = await ScrappableAnalytics.db
            .count(session, where: (p0) => dWC(p0, RequestStatus.success));
        final clientErrorCount = await ScrappableAnalytics.db
            .count(session, where: (p0) => dWC(p0, RequestStatus.clientError));
        final serverErrorCount = await ScrappableAnalytics.db
            .count(session, where: (p0) => dWC(p0, RequestStatus.serverError));
        final insufficientCreditsCount = await ScrappableAnalytics.db.count(
            session,
            where: (p0) => dWC(p0, RequestStatus.insufficientCredits));
        final maxConcurrencyExceededCount = await ScrappableAnalytics.db.count(
            session,
            where: (p0) => dWC(p0, RequestStatus.maxConcurrencyExceeded));

        successTotalCount += successCount;
        clientErrorTotalCount += clientErrorCount;
        serverErrorTotalCount += serverErrorCount;
        insufficientCreditsTotalCount += insufficientCreditsCount;
        maxConcurrencyExceededTotalCount += maxConcurrencyExceededCount;

        data.add(ScrappableRequestPerTimeScope(
          start: start,
          end: end,
          successCount: successCount,
          clientErrorCount: clientErrorCount,
          serverErrorCount: serverErrorCount,
          insufficientCreditsCount: insufficientCreditsCount,
          maxConcurrencyExceededCount: maxConcurrencyExceededCount,
        ));

        end = start;
      }

      items.add(ScrappableRequestsAnalyticsItem(
        scrappable: scrappable,
        successTotalCount: successTotalCount,
        clientErrorTotalCount: clientErrorTotalCount,
        serverErrorTotalCount: serverErrorTotalCount,
        insufficientCreditsTotalCount: insufficientCreditsTotalCount,
        maxConcurrencyExceededTotalCount: maxConcurrencyExceededTotalCount,
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
  }) async {
    const int daysBack = 7;
    const int pageSize = 30; // Fixed page size
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) throw defaultAuthenticationException;
    final userId = authenticationInfo.userId;
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );
    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account information found for the authenticated user.',
      );
    }

    // Verify scrappable ownership
    final scrappable = await Scrappable.db.findById(session, scrappableId);
    if (scrappable == null || scrappable.accountId != accountInfo.id) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description:
            'The requested scrappable was not found or you do not have access to it.',
      );
    }

    final now = DateTime.now();
    final targetDate = now.subtract(Duration(days: daysBack));

    // Get total count for pagination
    final totalCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) & (t.requestedAt >= targetDate),
    );

    final offset = (page - 1) * pageSize;

    // Fetch paginated analytics with includes for better performance
    final analytics = await ScrappableAnalytics.db.find(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) & (t.requestedAt >= targetDate),
      limit: pageSize,
      offset: offset,
      orderBy: (t) => t.requestedAt,
      orderDescending: true,
      include: ScrappableAnalytics.include(
        scrappable: Scrappable.include(),
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
}

const int MAX_DAYS_ALLOWED = 30;
