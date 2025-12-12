import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateUserScrappablesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UserPaginatedScrappableResponse> call(
    Session session, {
    int page = 1,
    String? searchQuery,
    List<ScraperCategory>? categories,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final userId = session.authenticated?.userId;
    if (userId == null) {
      throw _userNotAuthenticated(language);
    }

    // Get account info to verify user and get accountId
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );
    if (accountInfo == null) {
      throw _accountNotFoundForUser(language);
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

    // Get total count for pagination (filtered)
    final totalCount = await Scrappable.db.count(
      session,
      where: whereClause,
    );

    // Get total user scrappables count (unfiltered) for limit checking
    final totalUserScrappables = await Scrappable.db.count(
      session,
      where: baseWhere,
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
        totalUserScrappables: totalUserScrappables,
      ),
    );
  }

  Future<Scrappable> getScrappableById(
    Session session,
    int scrappableId, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final userId = session.authenticated?.userId;
    if (userId == null) {
      throw _userNotAuthenticated(language);
    }

    // First check if the user owns this scrappable
    final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw _accountNotFoundForUser(language);
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
      throw _scrappableNotFound(language);
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw _scrappableNotFound(language);
    }

    // Verify the user owns this scrappable
    if (scrappable.accountId != accountInfo.id) {
      throw _accessDeniedPermission(language);
    }

    return scrappable;
  }
}

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _userNotAuthenticated(SupportedLanguage lang) =>
    createTranslatedException('user_not_authenticated', lang);

ZenScrapException _accountNotFoundForUser(SupportedLanguage lang) =>
    createTranslatedException('account_not_found_for_user', lang);

ZenScrapException _scrappableNotFound(SupportedLanguage lang) =>
    createTranslatedException('scrappable_not_found', lang);

ZenScrapException _accessDeniedPermission(SupportedLanguage lang) =>
    createTranslatedException('access_denied_permission', lang);
