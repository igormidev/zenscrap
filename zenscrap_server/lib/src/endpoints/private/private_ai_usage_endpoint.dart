import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateAiUsageEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns paginated AI credit history for the authenticated user.
  Future<PaginatedAICreditHistoryResponse> getAiCreditHistory(
    Session session, {
    int page = 1,
  }) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
    }

    final userId = authenticationInfo.userId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
    );

    if (accountInfo == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
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
    Session session,
  ) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
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
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    return accountInfo.accountAIUsage!;
  }
}
