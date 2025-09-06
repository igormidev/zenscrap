import 'package:serverpod/serverpod.dart';
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

      // Check if subscription is still active
      if (accountInfo.subscriptionStatus != 'active' &&
          accountInfo.subscriptionStatus != 'trialing') {
        session
            .log('Subscription not active for account ${object.accountInfoId}');
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

          // Create monthly subscription credit deposit record
          final monthlyDeposit = MonthlySubscriptionCreditDeposit(
            creditsAmount: creditsToAdd,
            planTier: accountInfo.planTier,
          );
          await MonthlySubscriptionCreditDeposit.db.insertRow(
            session,
            monthlyDeposit,
            transaction: transaction,
          );

          // Create credit history item
          final creditHistoryItem = CreditHistoryItem(
            date: DateTime.now(),
            monthlySubscriptionCreditDeposit: monthlyDeposit,
            creaditPackagePurchase: null,
            accountApiUsageId: currentApiUsage.id!,
          );
          await CreditHistoryItem.db.insertRow(
            session,
            creditHistoryItem,
            transaction: transaction,
          );

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
