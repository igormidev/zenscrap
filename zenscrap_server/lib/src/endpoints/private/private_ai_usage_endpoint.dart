import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateAiUsageEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns paginated AI credit history for the authenticated user.
  Future<PaginatedAICreditHistoryResponse> getAiCreditHistory(
    Session session, {
    int page = 1,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final userId = authenticationInfo.userId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    const int pageSize = 6;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Get total count for pagination
    final totalCount = await AICreditHistoryItem.db.count(
      session,
      where: (p0) => p0.accountAIUsageId.equals(accountInfo.accountAIUsageId),
    );

    // Calculate pagination metadata
    final totalPages = totalCount == 0 ? 1 : (totalCount / pageSize).ceil();
    final hasNextPage = page < totalPages;
    final hasPreviousPage = page > 1;

    // Calculate offset
    final offset = (page - 1) * pageSize;

    final creditHistory = await AICreditHistoryItem.db.find(
      session,
      where: (p0) => p0.accountAIUsageId.equals(accountInfo.accountAIUsageId),
      limit: pageSize,
      offset: offset,
      orderBy: (p0) => p0.id,
      orderDescending: true,
      include: AICreditHistoryItem.include(
        monthlySubscriptionAICreditDeposit:
            MonthlySubscriptionAICreditDeposit.include(),
      ),
    );

    return PaginatedAICreditHistoryResponse(
      data: creditHistory,
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

  /// Returns the AI usage info for the authenticated user.
  Future<AccountAIUsage> getAiUsageInfo(
    Session session, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final userId = authenticationInfo.userId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
      include: AccountInfo.include(
        accountAIUsage: AccountAIUsage.include(),
      ),
    );

    if (accountInfo == null || accountInfo.accountAIUsage == null) {
      throw _accountNotFound(language);
    }

    return accountInfo.accountAIUsage!;
  }

  /// Returns paginated auto-fix sessions for scrappables owned by the authenticated user.
  ///
  /// This includes all auto-fix repair attempts across all of the user's scrappables,
  /// ordered by most recent first.
  Future<PaginatedAutoFixSessionResponse> getAutoFixSessions(
    Session session, {
    int page = 1,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final userId = authenticationInfo.userId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    const int pageSize = 10;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Get all scrappable IDs owned by this user
    final userScrappables = await Scrappable.db.find(
      session,
      where: (t) =>
          t.accountId.equals(accountInfo.id) & t.isDeleted.equals(false),
    );

    final scrappableIds = userScrappables.map((s) => s.id!).toSet();

    if (scrappableIds.isEmpty) {
      return PaginatedAutoFixSessionResponse(
        data: [],
        pagination: PaginationMetadata(
          currentPage: page,
          pageSize: pageSize,
          totalCount: 0,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      );
    }

    // Get total count for pagination
    final totalCount = await AutoFixSession.db.count(
      session,
      where: (t) => t.scrappableId.inSet(scrappableIds),
    );

    // Calculate pagination metadata
    final totalPages = totalCount == 0 ? 1 : (totalCount / pageSize).ceil();
    final hasNextPage = page < totalPages;
    final hasPreviousPage = page > 1;

    // Calculate offset
    final offset = (page - 1) * pageSize;

    // Fetch auto-fix sessions with related data
    final sessions = await AutoFixSession.db.find(
      session,
      where: (t) => t.scrappableId.inSet(scrappableIds),
      limit: pageSize,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      include: AutoFixSession.include(
        attempts: AutoFixAttempt.includeList(),
      ),
    );

    return PaginatedAutoFixSessionResponse(
      data: sessions,
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

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _accountNotFound(SupportedLanguage lang) =>
    createTranslatedException('account_not_found', lang);
