import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateUserScrappablesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UserPaginatedScrappableResponse> call(
    Session session, {
    int page = 1,
    String? searchQuery,
    List<ScraperCategory>? categories,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw ZenScrapException(
        title: 'User Not Authenticated',
        description: 'You must be logged in to access your scrappables.',
      );
    }

    // Get account info to verify user and get accountId
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );
    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account found for the authenticated user.',
      );
    }

    const int pageSize = 12;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Build where clause - filter by account and exclude deleted
    Expression baseWhere(ScrappableTable t) =>
        t.accountId.equals(accountInfo.id) & t.isDeleted.equals(false);

    // Add search filter and category filter if provided
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

    // Fetch paginated data
    final scrappables = await Scrappable.db.find(
      session,
      where: whereClause,
      orderBy: (t) => t.id,
      orderDescending: true,
      limit: pageSize,
      offset: offset,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
    );

    return UserPaginatedScrappableResponse(
      data: scrappables,
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

  Future<Scrappable> getScrappableById(
      Session session, int scrappableId) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw ZenScrapException(
        title: 'User Not Authenticated',
        description: 'You must be logged in to access your scrappables.',
      );
    }

    // First check if the user owns this scrappable
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'No account found for the authenticated user.',
      );
    }

    // Find the scrappable with all necessary includes
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    if (scrappable == null) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The requested scrappable does not exist.',
      );
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The requested scrappable does not exist.',
      );
    }

    // Verify the user owns this scrappable
    if (scrappable.accountId != accountInfo.id) {
      throw ZenScrapException(
        title: 'Access Denied',
        description: 'You do not have permission to access this scrappable.',
      );
    }

    return scrappable;
  }
}
