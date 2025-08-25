// ignore_for_file: constant_identifier_names

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateScrappableAnalyticsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<PaginatedScrappableRequestsAnalytics>
      getScrappableAnalyticsOfTheLast12Hours(
    Session session, {
    int page = 1,
  }) async {
    const int pageSize = 4; // Fixed page size
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
    final targetDate = now.subtract(Duration(hours: 12));
    
    // Get total count for pagination
    final totalCount = await Scrappable.db.count(
      session,
      where: (t) =>
          t.accountId.equals(accountInfo.id) &
          t.scrappableAnalytics.any(
            (p0) => p0.requestedAt >= targetDate,
          ),
    );
    
    final offset = (page - 1) * pageSize;
    final List<Scrappable> scrappables = await Scrappable.db.find(
      session,
      where: (t) =>
          t.accountId.equals(accountInfo.id) &
          t.scrappableAnalytics.any(
            (p0) => p0.requestedAt >= targetDate,
          ),
      limit: pageSize,
      offset: offset,
      orderBy: (t) => t.id,
      orderDescending: false,
    );
    
    final List<ScrappableRequestsAnalyticsItem> items = [];
    final hoursScope = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    for (final Scrappable scrappable in scrappables) {
      final List<ScrappableRequestPerHour> data = [];
      int successTotalCount = 0;
      int clientErrorTotalCount = 0;
      int serverErrorTotalCount = 0;
      int insufficientCreditsTotalCount = 0;
      int maxConcurrencyExceededTotalCount = 0;

      DateTime end = now;
      for (final int hour in hoursScope) {
        final DateTime start = now.subtract(Duration(hours: hour));
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

        data.add(ScrappableRequestPerHour(
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
      items: items,
      hasNextPage: (offset + pageSize) < totalCount,
      totalCount: totalCount,
      currentPage: page,
      pageSize: pageSize,
    );
  }

  Future<PaginatedScrappableAnalytics> getScrappableAnalytics(
    Session session, {
    required UuidValue scrappableId,
    int page = 1,
    int daysBack = 7,
  }) async {
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
        description: 'The requested scrappable was not found or you do not have access to it.',
      );
    }

    final now = DateTime.now();
    final targetDate = now.subtract(Duration(days: daysBack));
    
    // Get total count for pagination
    final totalCount = await ScrappableAnalytics.db.count(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          (t.requestedAt >= targetDate),
    );

    final offset = (page - 1) * pageSize;
    
    // Fetch paginated analytics with includes for better performance
    final analytics = await ScrappableAnalytics.db.find(
      session,
      where: (t) =>
          t.scrappableId.equals(scrappableId) &
          (t.requestedAt >= targetDate),
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
