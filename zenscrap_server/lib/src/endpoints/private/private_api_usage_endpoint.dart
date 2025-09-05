import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateApiUsageEndpoint extends Endpoint {
  final Uuid _uuid = Uuid();

  @override
  bool get requireLogin => true;

  Future<List<CreditHistoryItem>> getCreditHistory(
    Session session, {
    required int offset,
    required int limit,
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

    final creditHistory = await CreditHistoryItem.db.find(
      session,
      where: (p0) => p0.accountApiUsageId.equals(accountInfo.accountApiUsageId),
      limit: limit,
      offset: offset,
      orderBy: (p0) => p0.id,
      orderDescending: true,
      include: CreditHistoryItem.include(
        monthlySubscriptionCreditDeposit:
            MonthlySubscriptionCreditDeposit.include(),
        creaditPackagePurchase: CreditPackagePurchase.include(),
      ),
    );

    return creditHistory;
  }

  Future<AccountApiKey> createApiKey(
    Session session, {
    required String name,
  }) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
    }

    final userId = authenticationInfo.userId;

    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
      include: AccountInfo.include(
        accountApiUsage: AccountApiUsage.include(),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    final nanoId = accountInfo.accountApiUsage!.nanoId;
    final apiKeyString = '$nanoId::${_uuid.v7()}';

    return await session.db.transaction((transaction) async {
      final apiKey = await AccountApiKey.db.insertRow(
        session,
        AccountApiKey(
          name: name,
          apiKey: apiKeyString,
          accountApiUsageId: accountInfo.accountApiUsageId,
          createdAt: DateTime.now(),
          isActive: true,
        ),
        transaction: transaction,
      );

      await AccountApiKey.db.attachRow.accountApiUsage(
        session,
        apiKey,
        accountInfo.accountApiUsage!,
        transaction: transaction,
      );

      return apiKey;
    });
  }

  Future<bool> deactivateApiKey(
    Session session, {
    required int apiKeyId,
  }) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
    }

    final userId = authenticationInfo.userId;

    // First check if user owns this API key and count active keys
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
      include: AccountInfo.include(
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    final activeKeys = accountInfo.accountApiUsage!.apiKeys ?? [];

    // Check if this is the last active key
    if (activeKeys.length <= 1) {
      throw ZenScrapException(
        title: 'Cannot Deactivate',
        description: 'You must have at least one active API key.',
      );
    }

    // Check if the key belongs to this user
    final keyToDeactivate = activeKeys.firstWhere(
      (k) => k.id == apiKeyId,
      orElse: () => throw ZenScrapException(
        title: 'API Key Not Found',
        description:
            'The specified API key was not found or does not belong to your account.',
      ),
    );

    // Deactivate the key
    keyToDeactivate.isActive = false;
    await AccountApiKey.db.updateRow(session, keyToDeactivate);

    return true;
  }

  Future<List<AccountApiKey>> getActiveApiKeys(
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
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    return accountInfo.accountApiUsage!.apiKeys ?? [];
  }

  Future<Map<int, int>> getApiKeyUsageStats(
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
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    final Map<int, int> usageStats = {};

    for (final apiKey in accountInfo.accountApiUsage!.apiKeys ?? []) {
      if (apiKey.id == null) continue;

      final count = await ScrappableAnalytics.db.count(
        session,
        where: (p0) =>
            p0.attachedApiKey.equals(apiKey.apiKey) &
            (p0.requestedAt >= thirtyDaysAgo),
      );

      usageStats[apiKey.id!] = count;
    }

    return usageStats;
  }

  Future<AccountApiUsage> getApiUsageInfo(
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
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    return accountInfo.accountApiUsage!;
  }

  Future<ApiKeyResponse> getApiKeysWithStats(
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
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Unable to find account information.',
      );
    }

    final apiKeys = accountInfo.accountApiUsage!.apiKeys ?? [];
    
    // Get usage stats for each API key
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    final Map<int, int> usageStats = {};

    for (final apiKey in apiKeys) {
      if (apiKey.id == null) continue;

      final count = await ScrappableAnalytics.db.count(
        session,
        where: (p0) =>
            p0.attachedApiKey.equals(apiKey.apiKey) &
            (p0.requestedAt >= thirtyDaysAgo),
      );

      usageStats[apiKey.id!] = count;
    }

    return ApiKeyResponse(
      apiKeys: apiKeys,
      usageStats: usageStats,
    );
  }
}
