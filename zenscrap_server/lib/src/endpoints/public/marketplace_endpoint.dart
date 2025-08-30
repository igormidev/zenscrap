import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef ScrappableId = String;
final Map<ScrappableId, DateTime> _usageCountDateCache = {};
final Map<ScrappableId, int> _usageCountCache = {};

class MarketplaceEndpoint extends Endpoint {
  Future<PaginatedScrappableResponse> getItems(
    Session session, {
    int page = 1,
    String? searchQuery,
  }) async {
    final now = DateTime.now();
    const int pageSize = 12;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Build where clause
    // Add search filter if query is provided
    // Also filter out deleted scrappables and hidden from marketplace
    final whereClause = searchQuery != null && searchQuery.isNotEmpty
        ? (ScrappableTable t) =>
            t.willHideFromMarketplace.equals(false) &
            t.isDeleted.equals(false) &
            t.willHideFromMarketplace.equals(false) &
            (t.name.ilike('%$searchQuery%') |
                t.description.ilike('%$searchQuery%'))
        : (ScrappableTable t) =>
            t.willHideFromMarketplace.equals(false) &
            t.isDeleted.equals(false) &
            t.willHideFromMarketplace.equals(false);

    // Get total count for pagination
    final totalCount = await Scrappable.db.count(
      session,
      where: whereClause,
    );

    // Calculate pagination metadata
    final totalPages = (totalCount / pageSize).ceil();
    final hasNextPage = page < totalPages;
    final hasPreviousPage = page > 1;

    // Calculate offset
    final offset = (page - 1) * pageSize;

    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Fetch paginated data
    final scrappables = await Scrappable.db.find(
      session,
      where: whereClause,
      orderBy: (t) => t.scrappableAnalytics.count(
        (a) =>
            (a.requestedAt >= sevenDaysAgo) &
            (a.requestStatus.equals(RequestStatus.success)),
      ),
      orderDescending: true,
      limit: pageSize,
      offset: offset,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
          scrappableTestResult: ScrappableTestResult.include(),
        ),
      ),
    );

    final List<MarketPlacePaginatedItem> items = [];

    for (final Scrappable scrappable in scrappables) {
      int? count;

      final DateTime? dataCache =
          _usageCountDateCache[scrappable.id.toString()];

      final bool isCacheOutdated = dataCache == null ||
          dataCache.isBefore(now.subtract(const Duration(hours: 2)));
      if (isCacheOutdated == false) {
        final int? usageCount = _usageCountCache[scrappable.id.toString()];
        count = usageCount;
      }

      if (count == null) {
        count = await ScrappableAnalytics.db.count(
          session,
          where: (ScrappableAnalyticsTable t) =>
              t.scrappableId.equals(scrappable.id) &
              (t.requestedAt >= sevenDaysAgo) &
              (t.requestStatus.equals(RequestStatus.success)),
        );
        _usageCountCache[scrappable.id.toString()] = count;
        _usageCountDateCache[scrappable.id.toString()] = now;
      }

      items.add(MarketPlacePaginatedItem(
        scrappable: scrappable,
        usageCount: count,
      ));
    }

    return PaginatedScrappableResponse(
      data: items,
      pagination: PaginationMetadata(
        currentPage: page,
        pageSize: pageSize,
        totalCount: totalCount,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
      ),
    );
  }
}
