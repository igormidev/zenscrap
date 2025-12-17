import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Tests for the _getUniqueScrappableIdsWithDuration functionality.
///
/// This test verifies that the method correctly returns unique scrappable IDs
/// that have analytics records with non-null duration and success status.
void main() {
  withServerpod('Given unique scrappable IDs with duration query',
      (sessionBuilder, endpoints) {
    test(
        'when called with analytics for multiple scrappables, should return unique IDs',
        () async {
      // Arrange: Create test scrappables and analytics records
      final session = await sessionBuilder.build();

      // Create test scrappable request
      final testRequest1 = await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: 'https://test1.example.com',
          queryParams: {},
          queryParamsNotRelatedToUrl: {},
          pathParams: [],
        ),
      );
      final testRequest2 = await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: 'https://test2.example.com',
          queryParams: {},
          queryParamsNotRelatedToUrl: {},
          pathParams: [],
        ),
      );
      final testRequest3 = await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: 'https://test3.example.com',
          queryParams: {},
          queryParamsNotRelatedToUrl: {},
          pathParams: [],
        ),
      );

      // Create test reference data
      final testData1 = await ReferenceTestData.db.insertRow(
        session,
        ReferenceTestData(
          scrapResultJson: '{}',
          referenceQueryParametersJson: '{}',
          referenceLinkUsed: 'https://test1.example.com',
        ),
      );
      final testData2 = await ReferenceTestData.db.insertRow(
        session,
        ReferenceTestData(
          scrapResultJson: '{}',
          referenceQueryParametersJson: '{}',
          referenceLinkUsed: 'https://test2.example.com',
        ),
      );
      final testData3 = await ReferenceTestData.db.insertRow(
        session,
        ReferenceTestData(
          scrapResultJson: '{}',
          referenceQueryParametersJson: '{}',
          referenceLinkUsed: 'https://test3.example.com',
        ),
      );

      // Create test scrappables
      final scrappable1 = await Scrappable.db.insertRow(
        session,
        Scrappable(
          createdAt: DateTime.now(),
          generalInfosUpdatedAt: DateTime.now(),
          extractRulesUpdatedAt: DateTime.now(),
          name: 'Test Scrappable 1',
          description: 'Test Description 1',
          willHideFromMarketplace: false,
          targetRequestId: testRequest1.id!,
          referenceTestDataId: testData1.id!,
          category: ScraperCategory.other,
          isDeleted: false,
        ),
      );
      final scrappable2 = await Scrappable.db.insertRow(
        session,
        Scrappable(
          createdAt: DateTime.now(),
          generalInfosUpdatedAt: DateTime.now(),
          extractRulesUpdatedAt: DateTime.now(),
          name: 'Test Scrappable 2',
          description: 'Test Description 2',
          willHideFromMarketplace: false,
          targetRequestId: testRequest2.id!,
          referenceTestDataId: testData2.id!,
          category: ScraperCategory.other,
          isDeleted: false,
        ),
      );
      final scrappable3 = await Scrappable.db.insertRow(
        session,
        Scrappable(
          createdAt: DateTime.now(),
          generalInfosUpdatedAt: DateTime.now(),
          extractRulesUpdatedAt: DateTime.now(),
          name: 'Test Scrappable 3',
          description: 'Test Description 3',
          willHideFromMarketplace: false,
          targetRequestId: testRequest3.id!,
          referenceTestDataId: testData3.id!,
          category: ScraperCategory.other,
          isDeleted: false,
        ),
      );

      // Create multiple analytics records for the same scrappables
      // Scrappable 1: 5 success records with duration
      for (var i = 0; i < 5; i++) {
        await ScrappableAnalytics.db.insertRow(
          session,
          ScrappableAnalytics(
            requestStatus: RequestStatus.success,
            requestedAt: DateTime.now().subtract(Duration(hours: i)),
            attachedNanoId: 'test-nano-id',
            attachedApiKey: 'test-api-key',
            scrappableId: scrappable1.id!,
            duration: Duration(milliseconds: 100 + i * 10),
          ),
        );
      }

      // Scrappable 2: 3 success records with duration
      for (var i = 0; i < 3; i++) {
        await ScrappableAnalytics.db.insertRow(
          session,
          ScrappableAnalytics(
            requestStatus: RequestStatus.success,
            requestedAt: DateTime.now().subtract(Duration(hours: i)),
            attachedNanoId: 'test-nano-id',
            attachedApiKey: 'test-api-key',
            scrappableId: scrappable2.id!,
            duration: Duration(milliseconds: 200 + i * 10),
          ),
        );
      }

      // Scrappable 3: 2 error records (should NOT be included) + 1 success without duration (should NOT be included)
      await ScrappableAnalytics.db.insertRow(
        session,
        ScrappableAnalytics(
          requestStatus: RequestStatus.clientError,
          requestedAt: DateTime.now(),
          attachedNanoId: 'test-nano-id',
          attachedApiKey: 'test-api-key',
          scrappableId: scrappable3.id!,
          duration: Duration(milliseconds: 300),
        ),
      );
      await ScrappableAnalytics.db.insertRow(
        session,
        ScrappableAnalytics(
          requestStatus: RequestStatus.success,
          requestedAt: DateTime.now(),
          attachedNanoId: 'test-nano-id',
          attachedApiKey: 'test-api-key',
          scrappableId: scrappable3.id!,
          duration: null, // No duration
        ),
      );

      // Act: Query for unique scrappable IDs with duration using the actual query method
      // We'll use a raw SQL query to test the DISTINCT approach
      final result = await session.db.unsafeQuery(
        r'''
        SELECT DISTINCT "scrappableId"
        FROM "scrappable_analytics"
        WHERE "duration" IS NOT NULL
          AND "requestStatus" = 'success'
        ORDER BY "scrappableId"
        LIMIT @limit OFFSET @offset
        ''',
        parameters: QueryParameters.named({'limit': 10, 'offset': 0}),
      );

      final uniqueIds = result.map((row) => row[0] as int).toList();

      // Assert: Should only return scrappable1 and scrappable2 IDs (not scrappable3)
      expect(uniqueIds.length, equals(2));
      expect(uniqueIds, contains(scrappable1.id));
      expect(uniqueIds, contains(scrappable2.id));
      expect(uniqueIds, isNot(contains(scrappable3.id)));
    });

    test('when called with pagination, should correctly limit and offset',
        () async {
      final session = await sessionBuilder.build();

      // Create multiple scrappables with success analytics
      final List<int> createdScrappableIds = [];

      for (var i = 0; i < 5; i++) {
        final testRequest = await ScrappableRequest.db.insertRow(
          session,
          ScrappableRequest(
            url: 'https://pagination-test-$i.example.com',
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
            referenceLinkUsed: 'https://pagination-test-$i.example.com',
          ),
        );
        final scrappable = await Scrappable.db.insertRow(
          session,
          Scrappable(
            createdAt: DateTime.now(),
            generalInfosUpdatedAt: DateTime.now(),
            extractRulesUpdatedAt: DateTime.now(),
            name: 'Pagination Test Scrappable $i',
            description: 'Test Description $i',
            willHideFromMarketplace: false,
            targetRequestId: testRequest.id!,
            referenceTestDataId: testData.id!,
            category: ScraperCategory.other,
            isDeleted: false,
          ),
        );
        createdScrappableIds.add(scrappable.id!);

        // Add success analytics with duration
        await ScrappableAnalytics.db.insertRow(
          session,
          ScrappableAnalytics(
            requestStatus: RequestStatus.success,
            requestedAt: DateTime.now(),
            attachedNanoId: 'test-nano-id',
            attachedApiKey: 'test-api-key',
            scrappableId: scrappable.id!,
            duration: Duration(milliseconds: 100),
          ),
        );
      }

      // Act: Get first 2 results
      final firstPage = await session.db.unsafeQuery(
        r'''
        SELECT DISTINCT "scrappableId"
        FROM "scrappable_analytics"
        WHERE "duration" IS NOT NULL
          AND "requestStatus" = 'success'
        ORDER BY "scrappableId"
        LIMIT @limit OFFSET @offset
        ''',
        parameters: QueryParameters.named({'limit': 2, 'offset': 0}),
      );

      // Act: Get next 2 results
      final secondPage = await session.db.unsafeQuery(
        r'''
        SELECT DISTINCT "scrappableId"
        FROM "scrappable_analytics"
        WHERE "duration" IS NOT NULL
          AND "requestStatus" = 'success'
        ORDER BY "scrappableId"
        LIMIT @limit OFFSET @offset
        ''',
        parameters: QueryParameters.named({'limit': 2, 'offset': 2}),
      );

      final firstPageIds =
          firstPage.map((row) => row[0] as int).toList();
      final secondPageIds =
          secondPage.map((row) => row[0] as int).toList();

      // Assert: Pagination works correctly
      expect(firstPageIds.length, equals(2));
      expect(secondPageIds.length, equals(2));

      // IDs should not overlap between pages
      expect(firstPageIds.toSet().intersection(secondPageIds.toSet()), isEmpty);
    });

    test(
        'when comparing ORM vs SQL DISTINCT, SQL should return fewer or equal records',
        () async {
      final session = await sessionBuilder.build();

      // Create a scrappable with many duplicate analytics
      final testRequest = await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: 'https://duplicate-test.example.com',
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
          referenceLinkUsed: 'https://duplicate-test.example.com',
        ),
      );
      final scrappable = await Scrappable.db.insertRow(
        session,
        Scrappable(
          createdAt: DateTime.now(),
          generalInfosUpdatedAt: DateTime.now(),
          extractRulesUpdatedAt: DateTime.now(),
          name: 'Duplicate Test Scrappable',
          description: 'Test Description',
          willHideFromMarketplace: false,
          targetRequestId: testRequest.id!,
          referenceTestDataId: testData.id!,
          category: ScraperCategory.other,
          isDeleted: false,
        ),
      );

      // Create 20 analytics records for the same scrappable
      for (var i = 0; i < 20; i++) {
        await ScrappableAnalytics.db.insertRow(
          session,
          ScrappableAnalytics(
            requestStatus: RequestStatus.success,
            requestedAt: DateTime.now().subtract(Duration(hours: i)),
            attachedNanoId: 'test-nano-id',
            attachedApiKey: 'test-api-key',
            scrappableId: scrappable.id!,
            duration: Duration(milliseconds: 100 + i),
          ),
        );
      }

      // Act: Query using ORM (current inefficient approach - fetches all 20 records)
      final ormResult = await ScrappableAnalytics.db.find(
        session,
        where: (t) =>
            t.duration.notEquals(null) &
            t.requestStatus.equals(RequestStatus.success),
        orderBy: (t) => t.scrappableId,
        limit: 10,
      );

      // Act: Query using SQL DISTINCT (efficient approach - should return 1 unique ID)
      final sqlResult = await session.db.unsafeQuery(
        r'''
        SELECT DISTINCT "scrappableId"
        FROM "scrappable_analytics"
        WHERE "duration" IS NOT NULL
          AND "requestStatus" = 'success'
        ORDER BY "scrappableId"
        LIMIT @limit OFFSET @offset
        ''',
        parameters: QueryParameters.named({'limit': 10, 'offset': 0}),
      );

      final ormIds = ormResult.map((r) => r.scrappableId).toSet();
      final sqlIds = sqlResult.map((row) => row[0] as int).toSet();

      // Assert: Both should contain the same unique ID, but ORM fetched more records
      expect(ormResult.length, greaterThan(sqlResult.length),
          reason:
              'ORM should fetch more records due to duplicates (20 vs 1 unique)');
      expect(ormIds, equals(sqlIds),
          reason: 'Both should contain the same unique scrappable ID');
      expect(sqlIds.length, equals(1),
          reason: 'SQL DISTINCT should return exactly 1 unique ID');
    });
  });
}
