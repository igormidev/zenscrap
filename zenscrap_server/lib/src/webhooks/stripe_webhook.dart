import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/api_helper/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class StripeWebhookRoute extends Route {
  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    try {
      // Read the request body (Stripe sends JSON)
      final body = await utf8.decoder.bind(request).join();

      // Get the Stripe signature header
      final signature = request.headers.value('stripe-signature');
      if (signature == null) {
        session.log('Missing Stripe signature header');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        return true;
      }

      // Verify webhook signature
      final isValid = StripeApi.verifyWebhookSignature(
        payload: body,
        signature: signature,
        secret: StripeConfig.webhookSecret,
      );

      if (!isValid) {
        session.log('Invalid Stripe signature');
        request.response.statusCode = HttpStatus.forbidden;
        await request.response.close();
        return true;
      }

      // Parse the event data
      final data = jsonDecode(body);
      final eventType = data['type'] as String?;
      final eventData = data['data'] as Map<String, dynamic>?;
      final eventObject = eventData?['object'] as Map<String, dynamic>?;

      if (eventType == null || eventObject == null) {
        session.log('Invalid event structure');
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        return true;
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
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return true;
    } catch (e) {
      session.log('Error processing webhook: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      await request.response.close();
      return true;
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

      if (accountInfoIdStr == null) {
        session.log('Missing account_info_id in checkout session metadata');
        return;
      }

      final accountInfoId = int.tryParse(accountInfoIdStr);
      if (accountInfoId == null) {
        session.log('Invalid account_info_id: $accountInfoIdStr');
        return;
      }

      // Get the subscription ID from the checkout session
      final subscriptionId = checkoutSession['subscription'] as String?;
      final customerId = checkoutSession['customer'] as String?;

      if (subscriptionId == null || customerId == null) {
        session.log('Missing subscription or customer ID in checkout session');
        return;
      }

      // Update account info with Stripe IDs
      final accountInfo = await AccountInfo.db.findById(session, accountInfoId);
      if (accountInfo == null) {
        session.log('Account info not found: $accountInfoId');
        return;
      }

      accountInfo.stripeCustomerId = customerId;
      accountInfo.stripeSubscriptionId = subscriptionId;
      accountInfo.subscriptionStatus = 'active';

      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      // Add initial credits and schedule monthly credit addition
      await _addSubscriptionCredits(session, accountInfo, accountInfo.planTier);

      // Schedule monthly credit addition (first one in 30 days)
      await session.serverpod.futureCallWithDelay(
        'monthly_subscription_credits',
        MonthlyCreditsData(
          accountInfoId: accountInfo.id!,
        ),
        const Duration(days: 30),
      );

      session.log(
          'Checkout session completed for account $accountInfoId - scheduled monthly credits');
    } catch (e) {
      session.log('Error handling checkout session completed: $e');
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

      // Update account info
      final accountInfo = await AccountInfo.db.findById(session, accountInfoId);
      if (accountInfo == null) {
        session.log('Account info not found: $accountInfoId');
        return;
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

      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      // Add API credits for the new subscription
      if (status == 'active' || status == 'trialing') {
        await _addSubscriptionCredits(session, accountInfo, newPlanTier);

        // Schedule monthly credit addition (first one in 30 days)
        await session.serverpod.futureCallWithDelay(
          'monthly_subscription_credits',
          MonthlyCreditsData(
            accountInfoId: accountInfo.id!,
          ),
          const Duration(days: 30),
        );

        session.log('Scheduled monthly credits for account ${accountInfo.id}');
      }

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

      // Find account by subscription ID
      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
      );

      if (accountInfo == null) {
        session.log('Account not found for subscription: $subscriptionId');
        return;
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

      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache when plan changes
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      session.log('Subscription updated for account ${accountInfo.id}');
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

      // Find account by subscription ID
      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
      );

      if (accountInfo == null) {
        session.log('Account not found for subscription: $subscriptionId');
        return;
      }

      // Update account info
      accountInfo.subscriptionStatus = 'canceled';
      accountInfo.planTier = PlanTier.none;

      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache when subscription is canceled
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      session.log('Subscription deleted for account ${accountInfo.id}');
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

      // Find account by subscription ID
      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (t) => t.stripeSubscriptionId.equals(subscriptionId),
      );

      if (accountInfo == null) {
        session.log('Account not found for subscription: $subscriptionId');
        return;
      }

      // Update subscription status
      accountInfo.subscriptionStatus = 'past_due';
      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache when payment fails
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      session.log('Invoice payment failed for account ${accountInfo.id}');
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
      return PlanTier.base;
    } else if (priceId == StripeConfig.proPriceIdMonthly ||
        priceId == StripeConfig.proPriceIdYearly) {
      return PlanTier.pro;
    } else if (priceId == StripeConfig.ultraPriceIdMonthly ||
        priceId == StripeConfig.ultraPriceIdYearly) {
      return PlanTier.unlimited;
    }

    return PlanTier.none;
  }

  Future<void> _addSubscriptionCredits(
    Session session,
    AccountInfo accountInfo,
    PlanTier planTier,
  ) async {
    // Get the amount of credits to add based on plan tier
    final creditsToAdd = planTier.apiCreditsToBeAddedPerMonth;

    if (creditsToAdd <= 0) {
      return;
    }

    // Update account API usage with new credits
    final apiUsage = await AccountApiUsage.db.findById(
      session,
      accountInfo.accountApiUsageId,
    );

    if (apiUsage != null) {
      apiUsage.subscriptionCredits += creditsToAdd;
      await AccountApiUsage.db.updateRow(session, apiUsage);

      // Reset cache after adding credits
      ApiHelperMixin.resetNanoId(apiUsage.nanoId);

      session.log(
          'Added $creditsToAdd subscription credits to account ${accountInfo.id}');
    }
  }
}
