import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/consts.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class MonthlySubscriptionCreditsFutureCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    if (object is! MonthlyCreditsData) {
      session
          .log('Invalid object type for MonthlySubscriptionCreditsFutureCall');
      return;
    }

    try {
      // Get account info
      final accountInfo = await AccountInfo.db.findById(
        session,
        object.accountInfoId,
      );

      if (accountInfo == null) {
        session.log('Account not found: ${object.accountInfoId}');
        return;
      }

      // Check if subscription is still active OR if user is on free tier
      final isFreeTier = accountInfo.planTier == PlanTier.none;
      final hasActiveSubscription = accountInfo.subscriptionStatus == 'active' ||
          accountInfo.subscriptionStatus == 'trialing';

      if (!isFreeTier && !hasActiveSubscription) {
        session.log(
            'Subscription not active for account ${object.accountInfoId} and not on free tier');
        return;
      }

      // Get the API usage
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );

      if (apiUsage == null) {
        session.log('API usage not found for account ${object.accountInfoId}');
        return;
      }

      // Add monthly credits based on plan tier
      final creditsToAdd = accountInfo.planTier.apiCreditsToBeAddedPerMonth;

      if (creditsToAdd > 0) {
        // Use transaction for all database operations
        await session.db.transaction((transaction) async {
          // Reload API usage with credit usage within transaction to ensure consistency
          final currentApiUsage = await AccountApiUsage.db.findById(
            session,
            apiUsage.id!,
            transaction: transaction,
            include: AccountApiUsage.include(
              creditUsage: CreditUsage.include(),
            ),
          );
          
          if (currentApiUsage == null || currentApiUsage.creditUsage == null) {
            throw Exception('API usage or credit usage not found during transaction');
          }

          // Add credits
          currentApiUsage.creditUsage!.subscriptionCredits += creditsToAdd;
          await CreditUsage.db.updateRow(
            session,
            currentApiUsage.creditUsage!,
            transaction: transaction,
          );

          // Create monthly subscription API credit deposit record
          final monthlyApiDeposit = MonthlySubscriptionApiCreditDeposit(
            creditsAmount: creditsToAdd,
            planTier: accountInfo.planTier,
          );
          await MonthlySubscriptionApiCreditDeposit.db.insertRow(
            session,
            monthlyApiDeposit,
            transaction: transaction,
          );

          // Create API credit history item
          final apiCreditHistoryItem = ApiCreditHistoryItem(
            date: DateTime.now(),
            monthlySubscriptionApiCreditDepositId: monthlyApiDeposit.id,
            monthlySubscriptionApiCreditDeposit: monthlyApiDeposit,
            apiCreditPackagePurchaseId: null,
            apiCreditPackagePurchase: null,
            accountApiUsageId: currentApiUsage.id!,
          );
          await ApiCreditHistoryItem.db.insertRow(
            session,
            apiCreditHistoryItem,
            transaction: transaction,
          );

          // Reset AI credits to default monthly amount
          // If the user has a negative balance (they overspent), subtract that from the new credits
          final aiUsage = await AccountAIUsage.db.findById(
            session,
            accountInfo.accountAIUsageId,
            transaction: transaction,
          );
          if (aiUsage != null) {
            final currentBalance = aiUsage.totalDollarsSpentFromTotalInUSD;
            double newCredits = kDefaultMonthlyAICreditsInDollars;

            // If balance is negative (user overspent), carry over the debt
            if (currentBalance < 0) {
              // newCredits = default - abs(negative) = default + negative
              newCredits = kDefaultMonthlyAICreditsInDollars + currentBalance;
              session.log(
                'User had negative balance of \$$currentBalance. '
                'Carrying over debt to new month.',
              );
            }

            aiUsage.totalDollarsSpentFromTotalInUSD = newCredits;
            await AccountAIUsage.db.updateRow(
              session,
              aiUsage,
              transaction: transaction,
            );

            // Create monthly subscription AI credit deposit record
            final monthlyAiDeposit = MonthlySubscriptionAICreditDeposit(
              creditsAmountInDollars: kDefaultMonthlyAICreditsInDollars,
              planTier: accountInfo.planTier,
            );
            await MonthlySubscriptionAICreditDeposit.db.insertRow(
              session,
              monthlyAiDeposit,
              transaction: transaction,
            );

            // Create AI credit history item
            final aiCreditHistoryItem = AICreditHistoryItem(
              date: DateTime.now(),
              monthlySubscriptionAICreditDepositId: monthlyAiDeposit.id,
              monthlySubscriptionAICreditDeposit: monthlyAiDeposit,
              accountAIUsageId: aiUsage.id!,
            );
            await AICreditHistoryItem.db.insertRow(
              session,
              aiCreditHistoryItem,
              transaction: transaction,
            );

            session.log(
                'Reset AI credits to \$${newCredits.toStringAsFixed(4)} for account ${accountInfo.id}');
          }

          // Update the cached values in ApiHelperMixin (after transaction)
          ApiHelperMixin.resetNanoId(currentApiUsage.nanoId);
        });

        session.log(
            'Added $creditsToAdd monthly subscription credits to account ${accountInfo.id} (nanoId: ${apiUsage.nanoId})');
      }
    } catch (e, stackTrace) {
      session.log(
        'Error in MonthlySubscriptionCreditsFutureCall for '
        'account ${object.accountInfoId}',
        level: LogLevel.fatal,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      // Schedule the next monthly credit addition (30 days from now)
      await session.serverpod.futureCallWithDelay(
        'monthly_subscription_credits',
        MonthlyCreditsData(
          accountInfoId: object.accountInfoId,
        ),
        const Duration(days: 30),
      );

      session.log(
          'Scheduled next monthly credits addition for account ${object.accountInfoId} in 30 days');
    }
  }
}
