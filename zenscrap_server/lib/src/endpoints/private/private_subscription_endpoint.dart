import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateSubscriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<String> createCheckoutSession(
    Session session, {
    required String planTier,
    required bool isYearly,
  }) async {
    // Get authenticated user
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw Exception('User not authenticated');
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
      include: AccountInfo.include(
        userInfo: UserInfo.include(),
      ),
    );

    if (accountInfo == null) {
      throw Exception('Account info not found');
    }

    if (accountInfo.userInfo?.email == null) {
      throw Exception('User email not found');
    }

    // Check if user already has an active subscription
    if (accountInfo.stripeSubscriptionId != null &&
        accountInfo.subscriptionStatus == 'active') {
      throw Exception('User already has an active subscription');
    }

    try {
      // Get the price ID for the selected plan
      final priceId = StripeConfig.getPriceId(planTier, isYearly);

      // Create Stripe checkout session
      final checkoutSession = await StripeApi.createCheckoutSession(
        secretKey: StripeConfig.secretKey,
        priceId: priceId,
        customerEmail: accountInfo.userInfo!.email!,
        successUrl:
            '${StripeConfig.successUrl}?session_id={CHECKOUT_SESSION_ID}',
        cancelUrl: StripeConfig.cancelUrl,
        accountInfoId: accountInfo.id!,
      );

      // Return the checkout URL
      return checkoutSession['url'] as String;
    } catch (e) {
      session.log('Failed to create checkout session: $e');
      throw Exception('Failed to create checkout session: $e');
    }
  }

  Future<Map<String, dynamic>> getSubscriptionStatus(Session session) async {
    // Get authenticated user
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw Exception('User not authenticated');
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw Exception('Account info not found');
    }

    return {
      'hasSubscription': accountInfo.stripeSubscriptionId != null,
      'subscriptionStatus': accountInfo.subscriptionStatus,
      'planTier': accountInfo.planTier.name,
      'subscriptionEndDate': accountInfo.subscriptionEndDate?.toIso8601String(),
    };
  }

  Future<bool> cancelSubscription(Session session) async {
    // Get authenticated user
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw Exception('User not authenticated');
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw Exception('Account info not found');
    }

    if (accountInfo.stripeSubscriptionId == null) {
      throw Exception('No active subscription found');
    }

    try {
      // Cancel subscription in Stripe
      await StripeApi.cancelSubscription(
        secretKey: StripeConfig.secretKey,
        subscriptionId: accountInfo.stripeSubscriptionId!,
      );

      // Update account info
      accountInfo.subscriptionStatus = 'canceled';
      await AccountInfo.db.updateRow(session, accountInfo);

      // Get API usage to reset cache when subscription is canceled
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      return true;
    } catch (e) {
      session.log('Failed to cancel subscription: $e');
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  Future<String> createCustomerPortalSession(Session session) async {
    // Get authenticated user
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw Exception('User not authenticated');
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw Exception('Account info not found');
    }

    if (accountInfo.stripeCustomerId == null) {
      throw Exception(
          'No Stripe customer found. Please subscribe to a plan first.');
    }

    try {
      // Create customer portal session in Stripe
      final portalSession = await StripeApi.createCustomerPortalSession(
        secretKey: StripeConfig.secretKey,
        customerId: accountInfo.stripeCustomerId!,
        returnUrl: StripeConfig.portalReturnUrl,
      );

      // Return the portal URL
      return portalSession['url'] as String;
    } catch (e) {
      session.log('Failed to create customer portal session: $e');
      throw Exception('Failed to create customer portal session: $e');
    }
  }
}
