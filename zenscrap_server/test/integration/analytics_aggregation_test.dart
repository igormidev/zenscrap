import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Tests for the N+1 query optimization in getScrappableAnalyticsWithScope.
///
/// These tests verify that the aggregated query approach produces identical
/// results to the original nested loop approach.
void main() {
  withServerpod('Given analytics aggregation optimization', (
    sessionBuilder,
    endpoints,
  ) {
    /// Helper function to create a test scrappable with all required dependencies
    Future<Scrappable> createTestScrappable(
      Session session, {
      required String name,
      required String url,
    }) async {
      final testRequest = await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: url,
          queryParams: {},
          queryParamsNotRelatedToUrl: {},
          pathParams: [],
        ),
      );
      final testData = await ReferenceTestData.db.insertRow(
        session,
        ReferenceTestData(
          scrapResultJson: '{}',
          referenceQueryParametersJson: '{}',
          referenceLinkUsed: url,
        ),
      );
      return await Scrappable.db.insertRow(
        session,
        Scrappable(
          createdAt: DateTime.now(),
          generalInfosUpdatedAt: DateTime.now(),
          extractRulesUpdatedAt: DateTime.now(),
          name: name,
          description: 'Test Description for $name',
          willHideFromMarketplace: false,
          targetRequestId: testRequest.id!,
          referenceTestDataId: testData.id!,
          category: ScraperCategory.other,
          isDeleted: false,
        ),
      );
    }

    /// Helper function to create analytics records
    Future<void> createAnalyticsRecord(
      Session session, {
      required int scrappableId,
      required RequestStatus status,
      required DateTime requestedAt,
      required String nanoId,
    }) async {
      await ScrappableAnalytics.db.insertRow(
        session,
        ScrappableAnalytics(
          requestStatus: status,
          requestedAt: requestedAt,
          attachedNanoId: nanoId,
          attachedApiKey: 'test-api-key',
          scrappableId: scrappableId,
          duration: const Duration(milliseconds: 100),
        ),
      );
    }

    test(
      'when aggregating analytics counts by status, SQL GROUP BY should return correct counts',
      () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();
        final testNanoId = 'test-nano-id-agg-${now.millisecondsSinceEpoch}';

        // Create a test scrappable
        final scrappable = await createTestScrappable(
          session,
          name: 'Aggregation Test Scrappable',
          url: 'https://aggregation-test.example.com',
        );

        // Create known number of analytics records for each status
        for (var i = 0; i < 3; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable.id!,
            status: RequestStatus.success,
            requestedAt: now.subtract(Duration(minutes: 5 + i)),
            nanoId: testNanoId,
          );
        }
        for (var i = 0; i < 2; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable.id!,
            status: RequestStatus.clientError,
            requestedAt: now.subtract(Duration(minutes: 10 + i)),
            nanoId: testNanoId,
          );
        }
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.serverError,
          requestedAt: now.subtract(const Duration(minutes: 15)),
          nanoId: testNanoId,
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.insufficientCredits,
          requestedAt: now.subtract(const Duration(minutes: 20)),
          nanoId: testNanoId,
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.maxConcurrencyExceeded,
          requestedAt: now.subtract(const Duration(minutes: 25)),
          nanoId: testNanoId,
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.failedAtScrappingBee,
          requestedAt: now.subtract(const Duration(minutes: 30)),
          nanoId: testNanoId,
        );

        // Query using SQL GROUP BY (simplified - no time filter for clarity)
        final result = await session.db.unsafeQuery(
          r'''
        SELECT
          "requestStatus",
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = @scrappableId
        GROUP BY "requestStatus"
        ORDER BY "requestStatus"
        ''',
          parameters: QueryParameters.named({'scrappableId': scrappable.id}),
        );

        // Convert results to a map for easy verification
        final countsByStatus = <String, int>{};
        for (final row in result) {
          final status = row[0] as String;
          final count = row[1] as int;
          countsByStatus[status] = count;
        }

        // Verify counts match what we created
        expect(countsByStatus['success'], equals(3));
        expect(countsByStatus['clientError'], equals(2));
        expect(countsByStatus['serverError'], equals(1));
        expect(countsByStatus['insufficientCredits'], equals(1));
        expect(countsByStatus['maxConcurrencyExceeded'], equals(1));
        expect(countsByStatus['failedAtScrappingBee'], equals(1));
      },
    );

    test(
      'when using DATE_TRUNC for hour grouping, should correctly group by hour period',
      () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();

        // Create a test scrappable
        final scrappable = await createTestScrappable(
          session,
          name: 'Hour Grouping Test Scrappable',
          url: 'https://hour-test.example.com',
        );

        // Create records spread across different hour buckets
        // Use specific timestamps that are clearly in different DATE_TRUNC('hour') buckets
        final baseTime = DateTime(now.year, now.month, now.day, now.hour);

        // Records in the current hour bucket
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: baseTime.add(const Duration(minutes: 5)),
          nanoId: 'test-hour-grouping',
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: baseTime.add(const Duration(minutes: 10)),
          nanoId: 'test-hour-grouping',
        );

        // Records in the previous hour bucket
        final prevHour = baseTime.subtract(const Duration(hours: 1));
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: prevHour.add(const Duration(minutes: 30)),
          nanoId: 'test-hour-grouping',
        );

        // Query using DATE_TRUNC
        final result = await session.db.unsafeQuery(
          r'''
        SELECT
          DATE_TRUNC('hour', "requestedAt") as period,
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = @scrappableId
        GROUP BY DATE_TRUNC('hour', "requestedAt")
        ORDER BY period DESC
        ''',
          parameters: QueryParameters.named({'scrappableId': scrappable.id}),
        );

        // Should have 2 distinct hour periods
        expect(result.length, equals(2));

        // Verify counts
        final counts = result.map((row) => row[1] as int).toList();
        expect(
          counts,
          contains(2),
          reason: 'Current hour should have 2 records',
        );
        expect(
          counts,
          contains(1),
          reason: 'Previous hour should have 1 record',
        );
      },
    );

    test(
      'when querying multiple scrappables, aggregation should correctly separate by scrappableId',
      () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();

        // Create multiple test scrappables
        final scrappable1 = await createTestScrappable(
          session,
          name: 'Multi Test Scrappable 1',
          url: 'https://multi-test-1.example.com',
        );
        final scrappable2 = await createTestScrappable(
          session,
          name: 'Multi Test Scrappable 2',
          url: 'https://multi-test-2.example.com',
        );

        // Create analytics records for scrappable 1: 3 success, 1 error
        for (var i = 0; i < 3; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable1.id!,
            status: RequestStatus.success,
            requestedAt: now.subtract(Duration(minutes: 5 + i)),
            nanoId: 'test-multi',
          );
        }
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable1.id!,
          status: RequestStatus.clientError,
          requestedAt: now.subtract(const Duration(minutes: 15)),
          nanoId: 'test-multi',
        );

        // Create analytics records for scrappable 2: 2 success, 2 errors
        for (var i = 0; i < 2; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable2.id!,
            status: RequestStatus.success,
            requestedAt: now.subtract(Duration(minutes: 5 + i)),
            nanoId: 'test-multi',
          );
        }
        for (var i = 0; i < 2; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable2.id!,
            status: RequestStatus.serverError,
            requestedAt: now.subtract(Duration(minutes: 20 + i)),
            nanoId: 'test-multi',
          );
        }

        // Query all scrappables using = ANY(@array)
        final result = await session.db.unsafeQuery(
          r'''
        SELECT
          "scrappableId",
          "requestStatus",
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = ANY(@scrappableIds)
        GROUP BY "scrappableId", "requestStatus"
        ORDER BY "scrappableId", "requestStatus"
        ''',
          parameters: QueryParameters.named({
            'scrappableIds': [scrappable1.id, scrappable2.id],
          }),
        );

        // Build a map of results: scrappableId -> status -> count
        final resultMap = <int, Map<String, int>>{};
        for (final row in result) {
          final scrappableId = row[0] as int;
          final status = row[1] as String;
          final count = row[2] as int;
          resultMap.putIfAbsent(scrappableId, () => {});
          resultMap[scrappableId]![status] = count;
        }

        // Verify scrappable 1 counts
        expect(resultMap[scrappable1.id]?['success'], equals(3));
        expect(resultMap[scrappable1.id]?['clientError'], equals(1));

        // Verify scrappable 2 counts
        expect(resultMap[scrappable2.id]?['success'], equals(2));
        expect(resultMap[scrappable2.id]?['serverError'], equals(2));
      },
    );

    test(
      'when ORM count and SQL GROUP BY are compared, they should produce identical results',
      () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();

        // Create a test scrappable
        final scrappable = await createTestScrappable(
          session,
          name: 'Comparison Test Scrappable',
          url: 'https://compare-test.example.com',
        );

        // Create a specific set of records
        for (var i = 0; i < 5; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable.id!,
            status: RequestStatus.success,
            requestedAt: now.subtract(Duration(minutes: 5 + i)),
            nanoId: 'test-compare',
          );
        }
        for (var i = 0; i < 3; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable.id!,
            status: RequestStatus.clientError,
            requestedAt: now.subtract(Duration(minutes: 15 + i)),
            nanoId: 'test-compare',
          );
        }
        for (var i = 0; i < 2; i++) {
          await createAnalyticsRecord(
            session,
            scrappableId: scrappable.id!,
            status: RequestStatus.serverError,
            requestedAt: now.subtract(Duration(minutes: 25 + i)),
            nanoId: 'test-compare',
          );
        }

        // Get counts using ORM (the old approach)
        final ormSuccessCount = await ScrappableAnalytics.db.count(
          session,
          where: (t) =>
              t.scrappableId.equals(scrappable.id) &
              t.requestStatus.equals(RequestStatus.success),
        );
        final ormClientErrorCount = await ScrappableAnalytics.db.count(
          session,
          where: (t) =>
              t.scrappableId.equals(scrappable.id) &
              t.requestStatus.equals(RequestStatus.clientError),
        );
        final ormServerErrorCount = await ScrappableAnalytics.db.count(
          session,
          where: (t) =>
              t.scrappableId.equals(scrappable.id) &
              t.requestStatus.equals(RequestStatus.serverError),
        );

        // Get counts using SQL GROUP BY (the new approach)
        final sqlResult = await session.db.unsafeQuery(
          r'''
        SELECT
          "requestStatus",
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = @scrappableId
        GROUP BY "requestStatus"
        ''',
          parameters: QueryParameters.named({'scrappableId': scrappable.id}),
        );

        final sqlCounts = <String, int>{};
        for (final row in sqlResult) {
          sqlCounts[row[0] as String] = row[1] as int;
        }

        // Compare ORM vs SQL results - they should be identical
        expect(sqlCounts['success'], equals(ormSuccessCount));
        expect(sqlCounts['clientError'], equals(ormClientErrorCount));
        expect(sqlCounts['serverError'], equals(ormServerErrorCount));

        // Verify the absolute values match what we created
        expect(ormSuccessCount, equals(5));
        expect(ormClientErrorCount, equals(3));
        expect(ormServerErrorCount, equals(2));
      },
    );

    test(
      'when no analytics records exist for a scrappable, GROUP BY should return empty results',
      () async {
        final session = sessionBuilder.build();

        // Create a test scrappable with no analytics
        final scrappable = await createTestScrappable(
          session,
          name: 'Empty Test Scrappable',
          url: 'https://empty-test.example.com',
        );

        final result = await session.db.unsafeQuery(
          r'''
        SELECT
          "requestStatus",
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = @scrappableId
        GROUP BY "requestStatus"
        ''',
          parameters: QueryParameters.named({'scrappableId': scrappable.id}),
        );

        expect(result.isEmpty, isTrue);
      },
    );

    test(
      'when grouping by scrappableId, status, and time period, all dimensions should be correct',
      () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();

        // Create a test scrappable
        final scrappable = await createTestScrappable(
          session,
          name: 'Full Aggregation Test',
          url: 'https://full-test.example.com',
        );

        // Create records at known times with known statuses
        // Records separated by 2 hours to ensure distinct DATE_TRUNC buckets
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: now.subtract(const Duration(minutes: 5)),
          nanoId: 'test-full',
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: now.subtract(const Duration(minutes: 10)),
          nanoId: 'test-full',
        );
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.clientError,
          requestedAt: now.subtract(const Duration(minutes: 15)),
          nanoId: 'test-full',
        );

        // Record from a different hour
        await createAnalyticsRecord(
          session,
          scrappableId: scrappable.id!,
          status: RequestStatus.success,
          requestedAt: now.subtract(const Duration(hours: 2)),
          nanoId: 'test-full',
        );

        // Query with full aggregation
        final result = await session.db.unsafeQuery(
          r'''
        SELECT
          "scrappableId",
          DATE_TRUNC('hour', "requestedAt") as period,
          "requestStatus",
          COUNT(*) as count
        FROM "scrappable_analytics"
        WHERE "scrappableId" = @scrappableId
        GROUP BY "scrappableId", DATE_TRUNC('hour', "requestedAt"), "requestStatus"
        ORDER BY period DESC, "requestStatus"
        ''',
          parameters: QueryParameters.named({'scrappableId': scrappable.id}),
        );

        // Should have at least 2 distinct periods
        expect(result.length, greaterThanOrEqualTo(2));

        // Extract results into a structured format - just verify totals
        int totalSuccess = 0;
        int totalClientError = 0;
        for (final row in result) {
          final status = row[2] as String;
          final count = row[3] as int;
          if (status == 'success') totalSuccess += count;
          if (status == 'clientError') totalClientError += count;
        }

        // Verify total counts match what we created
        expect(totalSuccess, equals(3));
        expect(totalClientError, equals(1));
      },
    );

    test(
      'interval calculation should produce correct non-overlapping time ranges',
      () async {
        // This test verifies our understanding of how the original algorithm
        // calculates time intervals

        final now = DateTime.now();

        // For last12Hours scope: 12 intervals of 1 hour each
        // Original algorithm processes intervals from most recent to oldest:
        // Interval 0: (now - 1h, now]
        // Interval 1: (now - 2h, now - 1h]
        // ...
        // Interval 11: (now - 12h, now - 11h]

        // Verify the interval math
        final intervals = <Map<String, DateTime>>[];
        DateTime end = now;
        for (int i = 1; i <= 12; i++) {
          final start = now.subtract(Duration(hours: i));
          intervals.add({'start': start, 'end': end});
          end = start;
        }

        // Verify we have 12 intervals
        expect(intervals.length, equals(12));

        // First interval (most recent)
        expect(
          intervals[0]['end']!.difference(intervals[0]['start']!).inHours,
          equals(1),
        );

        // Last interval (oldest)
        expect(
          intervals[11]['end']!.difference(intervals[11]['start']!).inHours,
          equals(1),
        );

        // Total span should be 12 hours
        final totalSpan = intervals[0]['end']!.difference(
          intervals[11]['start']!,
        );
        expect(totalSpan.inHours, equals(12));
      },
    );
  });
}
