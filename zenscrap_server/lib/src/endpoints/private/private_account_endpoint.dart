import 'package:nanoid2/nanoid2.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateAccountEndpoint extends Endpoint {
  final Uuid _uuid = Uuid();
  @override
  bool get requireLogin => true;

  Future<AccountInfo> getAccountInfo(
    Session session, {
    required int? initialScrappableId,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final userId = authenticationInfo.authUserId;

    AccountInfo? accountInfo;
    try {
      accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.authUserId.equals(userId),
        include: include,
      );
    } catch (e) {
      throw _databaseError(language);
    }

    final isNewAccount = accountInfo == null;

    if (!isNewAccount && initialScrappableId != null) {
      return await session.db.transaction((transaction) async {
        await _attachScrappable(
            session, transaction, accountInfo!, initialScrappableId, language);
        return accountInfo;
      });
    }

    if (!isNewAccount) {
      return accountInfo;
    }

    final String nanoId = nanoid(length: 8);
    final acountApiKey = '$nanoId::${_uuid.v7()}';
    try {
      return await session.db.transaction((transaction) async {
        // Create CreditUsage first with 100 initial credits for free tier
        final creditUsage = await CreditUsage.db.insertRow(
          session,
          CreditUsage(
            purchasedCredits: 0,
            subscriptionCredits: 100, // Free tier gets 100 credits initially
          ),
          transaction: transaction,
        );

        // Create AccountApiUsage with creditUsageId
        final accountApiUsage = await AccountApiUsage.db.insertRow(
          session,
          AccountApiUsage(
            creditUsageId: creditUsage.id!,
            nanoId: nanoId,
          ),
          transaction: transaction,
        );

        // Create AccountAIUsage with default credits
        final accountAIUsage = await AccountAIUsage.db.insertRow(
          session,
          AccountAIUsage(
            userOpenAiApiKey: null,
            totalDollarsSpentFromTotalInUSD: kDefaultMonthlyAICreditsInDollars,
          ),
          transaction: transaction,
        );

        // Create monthly subscription API credit deposit record for initial credits
        final insertedApiDeposit =
            await MonthlySubscriptionApiCreditDeposit.db.insertRow(
          session,
          MonthlySubscriptionApiCreditDeposit(
            creditsAmount: 100, // Initial free tier credits
            planTier: PlanTier.none, // Free tier
          ),
          transaction: transaction,
        );

        // Create API credit history item for initial credits
        await ApiCreditHistoryItem.db.insertRow(
          session,
          ApiCreditHistoryItem(
            date: DateTime.now(),
            transactionType: ApiCreditTransactionType.initialAccountCredit,
            monthlySubscriptionApiCreditDepositId: insertedApiDeposit.id,
            monthlySubscriptionApiCreditDeposit: insertedApiDeposit,
            apiCreditPackagePurchaseId: null,
            apiCreditPackagePurchase: null,
            accountApiUsageId: accountApiUsage.id!,
          ),
          transaction: transaction,
        );

        // Create monthly subscription AI credit deposit record for initial credits
        final insertedAiDeposit =
            await MonthlySubscriptionAICreditDeposit.db.insertRow(
          session,
          MonthlySubscriptionAICreditDeposit(
            creditsAmountInDollars: kDefaultMonthlyAICreditsInDollars,
            planTier: PlanTier.none, // Free tier
          ),
          transaction: transaction,
        );

        // Create AI credit history item for initial credits
        await AICreditHistoryItem.db.insertRow(
          session,
          AICreditHistoryItem(
            date: DateTime.now(),
            transactionType: AICreditTransactionType.initialAccountCredit,
            monthlySubscriptionAICreditDepositId: insertedAiDeposit.id,
            monthlySubscriptionAICreditDeposit: insertedAiDeposit,
            accountAIUsageId: accountAIUsage.id!,
          ),
          transaction: transaction,
        );
        final apiKey = await AccountApiKey.db.insertRow(
          session,
          AccountApiKey(
            name: 'Default API Key',
            apiKey: acountApiKey,
            accountApiUsageId: accountApiUsage.id!,
            accountApiUsage: accountApiUsage,
            createdAt: DateTime.now(),
          ),
          transaction: transaction,
        );

        await AccountApiKey.db.attachRow.accountApiUsage(
          session,
          apiKey,
          accountApiUsage,
          transaction: transaction,
        );
        AccountInfo accountInfo = AccountInfo(
          authUserId: userId,
          accountApiUsageId: accountApiUsage.id!,
          accountApiUsage: accountApiUsage,
          planTier: PlanTier.none,
          accountAIUsageId: accountAIUsage.id!,
          accountAIUsage: accountAIUsage,
        );

        accountInfo = await AccountInfo.db
            .insertRow(session, accountInfo, transaction: transaction);

        await AccountInfo.db.attachRow.accountApiUsage(
            session, accountInfo, accountApiUsage,
            transaction: transaction);

        final accountAdded = await AccountInfo.db.findFirstRow(
          session,
          where: (p0) => p0.authUserId.equals(userId),
          include: include,
          transaction: transaction,
        );
        if (accountAdded == null) {
          throw _accountCreationFailed(language);
        }

        if (initialScrappableId != null) {
          await _attachScrappable(
              session, transaction, accountInfo, initialScrappableId, language);
        }

        return accountAdded;
      }).then((accountInfo) async {
        // Schedule monthly credit addition for free tier users
        // This runs outside the transaction after account creation succeeds
        await session.serverpod.futureCallWithDelay(
          'monthly_subscription_credits',
          MonthlyCreditsData(
            accountInfoId: accountInfo.id!,
          ),
          const Duration(days: 30), // First monthly credit in 30 days
        );

        session.log(
            'Scheduled monthly credits for new free tier account ${accountInfo.id}');

        return accountInfo;
      });
    } catch (error, stackTrace) {
      session.log(
        'Error creating new account for userId $userId',
        exception: error,
        level: LogLevel.error,
        stackTrace: stackTrace,
      );
      throw _accountCreationInternalError(language);
    }
  }

  Future<void> _attachScrappable(
    Session session,
    Transaction transaction,
    AccountInfo accountInfo,
    int targetAttachScrappableId,
    SupportedLanguage language,
  ) async {
    Scrappable? existingScrappable = await Scrappable.db.findById(
      session,
      targetAttachScrappableId,
      transaction: transaction,
    );
    final existsScrappableWithTargetId = existingScrappable != null;
    final scrappableAccountId = existingScrappable?.accountId;
    final isAlreadyAttachedToThisAccount =
        scrappableAccountId == accountInfo.id;
    final isAccountAlreadyAttachedToOtherUser =
        scrappableAccountId != null && scrappableAccountId != accountInfo.id;

    if (!existsScrappableWithTargetId) {
      throw _scrappableNotFoundAttach(language);
    }

    if (isAccountAlreadyAttachedToOtherUser == true) {
      // Already attached to another account
      throw _scrappableAlreadyAttached(language);
    }

    // If already attached to this account, no need to check limits or re-attach
    if (isAlreadyAttachedToThisAccount) {
      return;
    }

    // Validate endpoint limit before attaching
    final currentScrappablesCount = await Scrappable.db.count(
      session,
      where: (t) =>
          t.accountId.equals(accountInfo.id) & t.isDeleted.equals(false),
      transaction: transaction,
    );

    final maxAllowed = accountInfo.planTier.maxScrappables;

    if (currentScrappablesCount >= maxAllowed) {
      throw _endpointLimitReached(language, maxAllowed, accountInfo.planTier.name);
    }

    existingScrappable = existingScrappable.copyWith(accountId: accountInfo.id);

    await Scrappable.db
        .updateRow(session, existingScrappable, transaction: transaction);
    await AccountInfo.db.attachRow.scrappables(
        session, accountInfo, existingScrappable,
        transaction: transaction);
  }

  final include = AccountInfo.include(
    authUser: AuthUser.include(),
    accountApiUsage: AccountApiUsage.include(
      apiKeys: AccountApiKey.includeList(
        limit: 10,
        orderBy: (p0) => p0.createdAt,
      ),
    ),
  );
}

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _databaseError(SupportedLanguage lang) =>
    createTranslatedException('database_error', lang);

ZenScrapException _accountCreationFailed(SupportedLanguage lang) =>
    createTranslatedException('account_creation_failed', lang);

ZenScrapException _accountCreationInternalError(SupportedLanguage lang) =>
    createTranslatedException('account_creation_internal_error', lang);

ZenScrapException _scrappableNotFoundAttach(SupportedLanguage lang) =>
    createTranslatedException('scrappable_not_found_attach', lang);

ZenScrapException _scrappableAlreadyAttached(SupportedLanguage lang) =>
    createTranslatedException('scrappable_already_attached', lang);

ZenScrapException _endpointLimitReached(
        SupportedLanguage lang, int maxAllowed, String planName) =>
    createTranslatedException(
      'endpoint_limit_reached',
      lang,
      params: {'maxAllowed': maxAllowed.toString(), 'planName': planName},
    );
