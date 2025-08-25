// ignore_for_file: constant_identifier_names

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateScrappableAnalyticsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<ScrappableRequestsAnalyticsItem>
      getScrappableAnalyticsOfTheLast12Hours(Session session) async* {
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
    final List<Scrappable> scrappables = await Scrappable.db.find(
      session,
      where: (t) =>
          t.accountId.equals(accountInfo.id) &
          t.scrappableAnalytics.any(
            // Scrappables that had been used in the last 30 days
            (p0) => p0.requestedAt >= targetDate,
          ),
      limit: 4,
    );
    if (scrappables.isEmpty) {
      // No scrappables found with analytics in the last 12 hours
      return;
    }

    final hoursScope = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    for (final Scrappable scrappable in scrappables) {
      final List<ScrappableRequestPerHour> data = [];
      int successTotalCount = 0;
      int clientErrorTotalCount = 0;
      int serverErrorTotalCount = 0;
      int insufficientCreditsTotalCount = 0;
      int maxConcurrencyExceededTotalCount = 0;

      // Not lets make the last 12 hours loop
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

      yield ScrappableRequestsAnalyticsItem(
        scrappable: scrappable,
        successTotalCount: successTotalCount,
        clientErrorTotalCount: clientErrorTotalCount,
        serverErrorTotalCount: serverErrorTotalCount,
        insufficientCreditsTotalCount: insufficientCreditsTotalCount,
        maxConcurrencyExceededTotalCount: maxConcurrencyExceededTotalCount,
        data: data.reversed.toList(),
      );
    }
  }
}

const int MAX_DAYS_ALLOWED = 30;
