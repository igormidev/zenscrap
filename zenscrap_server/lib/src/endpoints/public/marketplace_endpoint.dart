import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef ScrappableId = int;
final Map<int, DateTime> _usageCountDateCache = {};
final Map<int, int> _usageCountCache = {};

class MarketplaceEndpoint extends Endpoint {
  Future<PaginatedScrappableResponse> getItems(
    Session session, {
    int page = 1,
    String? searchQuery,
    List<ScraperCategory>? categories,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final now = DateTime.now();
    const int pageSize = 12;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Build where clause
    // Start with base filters (non-deleted, non-hidden, has account)
    Expression baseWhere(ScrappableTable t) =>
        t.willHideFromMarketplace.equals(false) &
        t.isDeleted.equals(false) &
        t.accountId.notEquals(null);

    // Add search filter if query is provided
    Expression whereClause(ScrappableTable t) {
      Expression where = baseWhere(t);

      // Add search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        where = where &
            (t.name.ilike('%$searchQuery%') |
                t.description.ilike('%$searchQuery%'));
      }

      // Add category filter
      if (categories != null && categories.isNotEmpty) {
        // Build OR expression for categories
        Expression? categoryExpression;
        for (final category in categories) {
          final categoryMatch = t.category.equals(category);
          categoryExpression = categoryExpression == null
              ? categoryMatch
              : categoryExpression | categoryMatch;
        }
        if (categoryExpression != null) {
          where = where & categoryExpression;
        }
      }

      return where;
    }

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
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
    );

    final List<MarketPlacePaginatedItem> items = [];

    for (final Scrappable scrappable in scrappables) {
      int? count;

      final DateTime? dataCache = _usageCountDateCache[scrappable.id!];

      final bool isCacheOutdated = dataCache == null ||
          dataCache.isBefore(now.subtract(const Duration(hours: 2)));
      if (isCacheOutdated == false) {
        final int? usageCount = _usageCountCache[scrappable.id!];
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
        _usageCountCache[scrappable.id!] = count;
        _usageCountDateCache[scrappable.id!] = now;
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
