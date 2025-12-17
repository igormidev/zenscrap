import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateApiUsageEndpoint extends Endpoint {
  final Uuid _uuid = Uuid();

  @override
  bool get requireLogin => true;

  Future<PaginatedApiCreditHistoryResponse> getApiCreditHistory(
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

    const int pageSize = kCreditHistoryPageSize;

    // Ensure page is at least 1
    page = page < 1 ? 1 : page;

    // Get total count for pagination
    final totalCount = await ApiCreditHistoryItem.db.count(
      session,
      where: (p0) => p0.accountApiUsageId.equals(accountInfo.accountApiUsageId),
    );

    // Calculate pagination metadata
    final totalPages = totalCount == 0 ? 1 : (totalCount / pageSize).ceil();
    final hasNextPage = page < totalPages;
    final hasPreviousPage = page > 1;

    // Calculate offset
    final offset = (page - 1) * pageSize;

    final creditHistory = await ApiCreditHistoryItem.db.find(
      session,
      where: (p0) => p0.accountApiUsageId.equals(accountInfo.accountApiUsageId),
      limit: pageSize,
      offset: offset,
      orderBy: (p0) => p0.id,
      orderDescending: true,
      include: ApiCreditHistoryItem.include(
        monthlySubscriptionApiCreditDeposit:
            MonthlySubscriptionApiCreditDeposit.include(),
        apiCreditPackagePurchase: ApiCreditPackagePurchase.include(),
      ),
    );

    return PaginatedApiCreditHistoryResponse(
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

  Future<AccountApiKey> createApiKey(
    Session session, {
    required String name,
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
        accountApiUsage: AccountApiUsage.include(),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw _accountNotFound(language);
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
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
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
      throw _accountNotFound(language);
    }

    final activeKeys = accountInfo.accountApiUsage!.apiKeys ?? [];

    // Check if this is the last active key
    if (activeKeys.length <= 1) {
      throw _cannotDeactivateApiKey(language);
    }

    // Check if the key belongs to this user
    final keyToDeactivate = activeKeys.firstWhere(
      (k) => k.id == apiKeyId,
      orElse: () => throw _apiKeyNotFound(language),
    );

    // Deactivate the key
    keyToDeactivate.isActive = false;
    await AccountApiKey.db.updateRow(session, keyToDeactivate);

    return true;
  }

  Future<List<AccountApiKey>> getActiveApiKeys(
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
        accountApiUsage: AccountApiUsage.include(
          creditUsage: CreditUsage.include(),
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw _accountNotFound(language);
    }

    return accountInfo.accountApiUsage!.apiKeys ?? [];
  }

  Future<Map<int, int>> getApiKeyUsageStats(
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
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw _accountNotFound(language);
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
        accountApiUsage: AccountApiUsage.include(
          creditUsage: CreditUsage.include(),
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw _accountNotFound(language);
    }

    return accountInfo.accountApiUsage!;
  }

  Future<ApiKeyResponse> getApiKeysWithStats(
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
        accountApiUsage: AccountApiUsage.include(
          creditUsage: CreditUsage.include(),
          apiKeys: AccountApiKey.includeList(
            where: (k) => k.isActive.equals(true),
            orderBy: (k) => k.createdAt,
            orderDescending: true,
          ),
        ),
      ),
    );

    if (accountInfo == null || accountInfo.accountApiUsage == null) {
      throw _accountNotFound(language);
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

  Future<String> createCreditPurchaseCheckout(
    Session session, {
    required CreditPurchaseOption creditPackage,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final userId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (p0) => p0.userInfoId.equals(userId),
      include: AccountInfo.include(
        userInfo: auth.UserInfo.include(),
      ),
    );

    if (accountInfo == null || accountInfo.userInfo == null) {
      throw _accountNotFound(language);
    }

    // Validate that user has Ultra plan
    if (accountInfo.planTier != PlanTier.ultra) {
      throw _ultraPlanRequired(language);
    }

    // Get price ID and credit amount based on the package
    final packageName = creditPackage.name;
    final priceId = StripeConfig.getCreditPackagePriceId(packageName);
    final creditAmount = StripeConfig.getCreditAmount(packageName);

    // Create Stripe checkout session for one-time payment
    final checkoutSession = await StripeApi.createCreditPurchaseCheckoutSession(
      secretKey: StripeConfig.secretKey,
      priceId: priceId,
      customerEmail: accountInfo.userInfo!.email ?? '',
      successUrl: StripeConfig.successUrl,
      cancelUrl: StripeConfig.cancelUrl,
      accountInfoId: accountInfo.id!,
      creditPackage: packageName,
      creditAmount: creditAmount,
    );

    // Return the checkout URL
    final checkoutUrl = checkoutSession['url'] as String?;

    if (checkoutUrl == null) {
      throw _checkoutCreationFailed(language);
    }

    session.log('Created credit purchase checkout for user $userId, package: $packageName');

    return checkoutUrl;
  }
}

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _accountNotFound(SupportedLanguage lang) =>
    createTranslatedException('account_not_found', lang);

ZenScrapException _cannotDeactivateApiKey(SupportedLanguage lang) =>
    createTranslatedException('cannot_deactivate_api_key', lang);

ZenScrapException _apiKeyNotFound(SupportedLanguage lang) =>
    createTranslatedException('api_key_not_found', lang);

ZenScrapException _ultraPlanRequired(SupportedLanguage lang) =>
    createTranslatedException('ultra_plan_required', lang);

ZenScrapException _checkoutCreationFailed(SupportedLanguage lang) =>
    createTranslatedException('checkout_creation_failed', lang);
