import 'dart:async';
import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class StripeWebhookRoute extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    try {
      // Read the request body (Stripe sends JSON)
      final body = await request.readAsString();

      // Get the Stripe signature header
      final signature = request.headers['stripe-signature']?.firstOrNull;
      if (signature == null) {
        session.log('Missing Stripe signature header');
        return Response.badRequest();
      }

      // Verify webhook signature
      final isValid = StripeApi.verifyWebhookSignature(
        payload: body,
        signature: signature,
        secret: StripeConfig.webhookSecret,
      );

      if (!isValid) {
        session.log('Invalid Stripe signature');
        return Response.forbidden();
      }

      // Parse the event data
      final data = jsonDecode(body);
      final eventType = data['type'] as String?;
      final eventData = data['data'] as Map<String, dynamic>?;
      final eventObject = eventData?['object'] as Map<String, dynamic>?;

      if (eventType == null || eventObject == null) {
        session.log('Invalid event structure');
        return Response.badRequest();
      }

      session.log('Processing Stripe event: $eventType');

      // Handle different event types
      switch (eventType) {
        case 'checkout.session.completed':
          await _handleCheckoutSessionCompleted(session, eventObject);
          break;

        case 'customer.subscription.created':
          await _handleSubscriptionCreated(session, eventObject);
          break;

        case 'customer.subscription.updated':
          await _handleSubscriptionUpdated(session, eventObject);
          break;

        case 'customer.subscription.deleted':
          await _handleSubscriptionDeleted(session, eventObject);
          break;

        case 'invoice.payment_succeeded':
          await _handleInvoicePaymentSucceeded(session, eventObject);
          break;

        case 'invoice.payment_failed':
          await _handleInvoicePaymentFailed(session, eventObject);
          break;

        default:
          session.log('Unhandled event type: $eventType');
      }

      // Respond with 200 OK to acknowledge receipt
      return Response.ok();
    } catch (e) {
      session.log('Error processing webhook: $e');
      return Response.internalServerError();
    }
  }

  Future<void> _handleCheckoutSessionCompleted(
    Session session,
    Map<String, dynamic> checkoutSession,
  ) async {
    try {
      // Get account info ID from metadata
      final metadata = checkoutSession['metadata'] as Map<String, dynamic>?;
      final accountInfoIdStr = metadata?['account_info_id'] as String?;
      final purchaseType = metadata?['purchase_type'] as String?;

      if (accountInfoIdStr == null) {
        session.log('Missing account_info_id in checkout session metadata');
        return;
      }

      final accountInfoId = int.tryParse(accountInfoIdStr);
      if (accountInfoId == null) {
        session.log('Invalid account_info_id: $accountInfoIdStr');
        return;
      }

      // Handle credit package purchase
      if (purchaseType == 'credit_package') {
        await _handleCreditPackagePurchase(
            session, checkoutSession, accountInfoId);
        return;
      }

      // Handle subscription checkout (existing logic)
      final subscriptionId = checkoutSession['subscription'] as String?;
      final customerId = checkoutSession['customer'] as String?;

      if (subscriptionId == null || customerId == null) {
        session.log('Missing subscription or customer ID in checkout session');
        return;
      }

      // Use transaction for subscription setup
      await session.db.transaction((transaction) async {
        // Update account info with Stripe IDs
        final accountInfo = await AccountInfo.db.findById(
          session,
          accountInfoId,
          transaction: transaction,
        );
        if (accountInfo == null) {
          session.log('Account info not found: $accountInfoId');
          throw Exception('Account info not found: $accountInfoId');
        }

        accountInfo.stripeCustomerId = customerId;
        accountInfo.stripeSubscriptionId = subscriptionId;
        accountInfo.subscriptionStatus = 'active';

        await AccountInfo.db.updateRow(
          session,
          accountInfo,
          transaction: transaction,
        );

        // Get API usage to reset cache
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }

        // Schedule immediate credit addition using future call for consistency
        // This ensures all credit additions go through the same logic and create history entries
        await session.serverpod.futureCallWithDelay(
          'monthly_subscription_credits',
          MonthlyCreditsData(
            accountInfoId: accountInfo.id!,
          ),
          Duration.zero, // Execute immediately to give user credits right away
        );
      });

      session.log(
          'Checkout session completed for account $accountInfoId - scheduled monthly credits');
    } catch (e) {
      session.log('Error handling checkout session completed: $e');
    }
  }

  Future<void> _handleCreditPackagePurchase(
    Session session,
    Map<String, dynamic> checkoutSession,
    int accountInfoId,
  ) async {
    try {
      final metadata = checkoutSession['metadata'] as Map<String, dynamic>?;
      final creditAmountStr = metadata?['credit_amount'] as String?;
      final creditPackage = metadata?['credit_package'] as String?;
      final paymentIntentId = checkoutSession['payment_intent'] as String?;

      if (creditAmountStr == null || creditPackage == null) {
        session.log('Missing credit package details in metadata');
        return;
      }

      final creditAmount = int.tryParse(creditAmountStr);
      if (creditAmount == null) {
        session.log('Invalid credit amount: $creditAmountStr');
        return;
      }

      // Use transaction for all database operations
      await session.db.transaction((transaction) async {
        // Get account info
        final accountInfo = await AccountInfo.db.findById(
          session,
          accountInfoId,
          transaction: transaction,
        );
        if (accountInfo == null) {
          session.log('Account info not found: $accountInfoId');
          throw Exception('Account info not found: $accountInfoId');
        }

        // Get API usage with credit usage relation
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
          include: AccountApiUsage.include(
            creditUsage: CreditUsage.include(),
          ),
        );

        if (apiUsage == null || apiUsage.creditUsage == null) {
          session.log(
              'API usage or credit usage not found for account $accountInfoId');
          throw Exception(
              'API usage or credit usage not found for account $accountInfoId');
        }

        // Add one-time purchase credits
        apiUsage.creditUsage!.purchasedCredits += creditAmount;
        await CreditUsage.db.updateRow(
          session,
          apiUsage.creditUsage!,
          transaction: transaction,
        );

        // Create API credit package purchase record
        final apiCreditPurchase = ApiCreditPackagePurchase(
          value: creditAmount.toDouble(),
          stripePurchaseId: paymentIntentId,
        );
        await ApiCreditPackagePurchase.db.insertRow(
          session,
          apiCreditPurchase,
          transaction: transaction,
        );

        // Create API credit history item
        final apiCreditHistoryItem = ApiCreditHistoryItem(
          date: DateTime.now(),
          monthlySubscriptionApiCreditDepositId: null,
          monthlySubscriptionApiCreditDeposit: null,
          apiCreditPackagePurchaseId: apiCreditPurchase.id,
          apiCreditPackagePurchase: apiCreditPurchase,
          accountApiUsageId: apiUsage.id!,
        );
        await ApiCreditHistoryItem.db.insertRow(
          session,
          apiCreditHistoryItem,
          transaction: transaction,
        );

        // Reset cache after adding credits (do this after transaction commits)
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      });

      session
          .log('Credit package purchase completed for account $accountInfoId: '
              '$creditAmount credits added ($creditPackage package)');
    } catch (e) {
      session.log('Error handling credit package purchase: $e');
    }
  }

  Future<void> _handleSubscriptionCreated(
    Session session,
    Map<String, dynamic> subscription,
  ) async {
    try {
      // Get metadata from subscription
      final metadata = subscription['metadata'] as Map<String, dynamic>?;
      final accountInfoIdStr = metadata?['account_info_id'] as String?;

      if (accountInfoIdStr == null) {
        session.log('Missing account_info_id in subscription metadata');
        return;
      }

      final accountInfoId = int.tryParse(accountInfoIdStr);
      if (accountInfoId == null) {
        session.log('Invalid account_info_id: $accountInfoIdStr');
        return;
      }

      // Get subscription details
      final subscriptionId = subscription['id'] as String?;
      final customerId = subscription['customer'] as String?;
      final status = subscription['status'] as String?;
      final currentPeriodEnd = subscription['current_period_end'] as int?;

      // Get the price ID to determine the plan tier
      final items = subscription['items'] as Map<String, dynamic>?;
      final data = items?['data'] as List<dynamic>?;
      final firstItem = data?.firstOrNull as Map<String, dynamic>?;
      final price = firstItem?['price'] as Map<String, dynamic>?;
      final priceId = price?['id'] as String?;

      // Use transaction for subscription creation
      await session.db.transaction((transaction) async {
        // Update account info
        final accountInfo = await AccountInfo.db.findById(
          session,
          accountInfoId,
          transaction: transaction,
        );
        if (accountInfo == null) {
          session.log('Account info not found: $accountInfoId');
          throw Exception('Account info not found: $accountInfoId');
        }

        // Determine plan tier from price ID
        PlanTier newPlanTier = _getPlanTierFromPriceId(priceId);

        accountInfo.stripeCustomerId = customerId;
        accountInfo.stripeSubscriptionId = subscriptionId;
        accountInfo.subscriptionStatus = status;
        accountInfo.planTier = newPlanTier;

        if (currentPeriodEnd != null) {
          accountInfo.subscriptionEndDate =
              DateTime.fromMillisecondsSinceEpoch(currentPeriodEnd * 1000);
        }

        await AccountInfo.db.updateRow(
          session,
          accountInfo,
          transaction: transaction,
        );

        // Get API usage to reset cache
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }

        // Add API credits for the new subscription
        if (status == 'active' || status == 'trialing') {
          // Schedule immediate credit addition using future call for consistency
          // This ensures all credit additions go through the same logic and create history entries
          await session.serverpod.futureCallWithDelay(
            'monthly_subscription_credits',
            MonthlyCreditsData(
              accountInfoId: accountInfo.id!,
            ),
            Duration
                .zero, // Execute immediately to give user credits right away
          );

          session.log(
              'Scheduled immediate and monthly credits for account ${accountInfo.id}');
        }
      });

      session.log('Subscription created for account $accountInfoId');
    } catch (e) {
      session.log('Error handling subscription created: $e');
    }
  }

  Future<void> _handleSubscriptionUpdated(
    Session session,
    Map<String, dynamic> subscription,
  ) async {
    try {
      final subscriptionId = subscription['id'] as String?;
      final status = subscription['status'] as String?;
      final currentPeriodEnd = subscription['current_period_end'] as int?;

      if (subscriptionId == null) {
        session.log('Missing subscription ID');
        return;
      }

      // Use transaction for subscription update
      await session.db.transaction((transaction) async {
        // Find account by subscription ID
        final accountInfo = await AccountInfo.db.findFirstRow(
          session,
          where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
          transaction: transaction,
        );

        if (accountInfo == null) {
          session.log('Account not found for subscription: $subscriptionId');
          throw Exception(
              'Account not found for subscription: $subscriptionId');
        }

        // Get the price ID to determine the plan tier
        final items = subscription['items'] as Map<String, dynamic>?;
        final data = items?['data'] as List<dynamic>?;
        final firstItem = data?.firstOrNull as Map<String, dynamic>?;
        final price = firstItem?['price'] as Map<String, dynamic>?;
        final priceId = price?['id'] as String?;

        // Determine plan tier from price ID
        PlanTier newPlanTier = _getPlanTierFromPriceId(priceId);

        // Update account info
        accountInfo.subscriptionStatus = status;
        accountInfo.planTier = newPlanTier;

        if (currentPeriodEnd != null) {
          accountInfo.subscriptionEndDate =
              DateTime.fromMillisecondsSinceEpoch(currentPeriodEnd * 1000);
        }

        await AccountInfo.db.updateRow(
          session,
          accountInfo,
          transaction: transaction,
        );

        // Get API usage to reset cache when plan changes
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }
      });

      session.log('Subscription updated for subscription $subscriptionId');
    } catch (e) {
      session.log('Error handling subscription updated: $e');
    }
  }

  Future<void> _handleSubscriptionDeleted(
    Session session,
    Map<String, dynamic> subscription,
  ) async {
    try {
      final subscriptionId = subscription['id'] as String?;

      if (subscriptionId == null) {
        session.log('Missing subscription ID');
        return;
      }

      // Use transaction for subscription deletion
      await session.db.transaction((transaction) async {
        // Find account by subscription ID
        final accountInfo = await AccountInfo.db.findFirstRow(
          session,
          where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
          transaction: transaction,
        );

        if (accountInfo == null) {
          session.log('Account not found for subscription: $subscriptionId');
          throw Exception(
              'Account not found for subscription: $subscriptionId');
        }

        // Update account info
        accountInfo.subscriptionStatus = 'canceled';
        accountInfo.planTier = PlanTier.none;

        await AccountInfo.db.updateRow(
          session,
          accountInfo,
          transaction: transaction,
        );

        // Get API usage to reset cache when subscription is canceled
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }
      });

      session.log('Subscription deleted for subscription $subscriptionId');
    } catch (e) {
      session.log('Error handling subscription deleted: $e');
    }
  }

  Future<void> _handleInvoicePaymentSucceeded(
    Session session,
    Map<String, dynamic> invoice,
  ) async {
    try {
      final subscriptionId = invoice['subscription'] as String?;
      final billingReason = invoice['billing_reason'] as String?;

      if (subscriptionId == null) {
        return; // Not a subscription invoice
      }

      // Find account by subscription ID
      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
      );

      if (accountInfo == null) {
        session.log('Account not found for subscription: $subscriptionId');
        return;
      }

      // Log the invoice payment for monitoring
      // Credits are now added via the monthly future call system
      session.log(
          'Invoice payment succeeded for account ${accountInfo.id} (reason: $billingReason)');
    } catch (e) {
      session.log('Error handling invoice payment succeeded: $e');
    }
  }

  Future<void> _handleInvoicePaymentFailed(
    Session session,
    Map<String, dynamic> invoice,
  ) async {
    try {
      final subscriptionId = invoice['subscription'] as String?;

      if (subscriptionId == null) {
        return; // Not a subscription invoice
      }

      // Use transaction for payment failure handling
      await session.db.transaction((transaction) async {
        // Find account by subscription ID
        final accountInfo = await AccountInfo.db.findFirstRow(
          session,
          where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
          transaction: transaction,
        );

        if (accountInfo == null) {
          session.log('Account not found for subscription: $subscriptionId');
          throw Exception(
              'Account not found for subscription: $subscriptionId');
        }

        // Update subscription status
        accountInfo.subscriptionStatus = 'past_due';
        await AccountInfo.db.updateRow(
          session,
          accountInfo,
          transaction: transaction,
        );

        // Get API usage to reset cache when payment fails
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
          transaction: transaction,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }
      });

      session.log('Invoice payment failed for subscription $subscriptionId');
    } catch (e) {
      session.log('Error handling invoice payment failed: $e');
    }
  }

  PlanTier _getPlanTierFromPriceId(String? priceId) {
    if (priceId == null) {
      return PlanTier.none;
    }

    // Map price IDs to plan tiers
    if (priceId == StripeConfig.basicPriceIdMonthly ||
        priceId == StripeConfig.basicPriceIdYearly) {
      return PlanTier.basic;
    } else if (priceId == StripeConfig.proPriceIdMonthly ||
        priceId == StripeConfig.proPriceIdYearly) {
      return PlanTier.pro;
    } else if (priceId == StripeConfig.ultraPriceIdMonthly ||
        priceId == StripeConfig.ultraPriceIdYearly) {
      return PlanTier.ultra;
    }

    return PlanTier.none;
  }
}
