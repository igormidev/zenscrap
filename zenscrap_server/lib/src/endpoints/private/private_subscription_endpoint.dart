import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateSubscriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<String> createCheckoutSession(
    Session session, {
    required String planTier,
    required bool isYearly,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Get authenticated user
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
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
      throw _accountNotFound(language);
    }

    if (accountInfo.userInfo?.email == null) {
      throw _userEmailNotFound(language);
    }

    // Check if user already has an active subscription
    if (accountInfo.stripeSubscriptionId != null &&
        accountInfo.subscriptionStatus == 'active') {
      throw _alreadySubscribed(language);
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
      throw _subscriptionCheckoutFailed(language);
    }
  }

  Future<Map<String, dynamic>> getSubscriptionStatus(
    Session session, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Get authenticated user
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    return {
      'hasSubscription': accountInfo.stripeSubscriptionId != null,
      'subscriptionStatus': accountInfo.subscriptionStatus,
      'planTier': accountInfo.planTier.name,
      'subscriptionEndDate': accountInfo.subscriptionEndDate?.toIso8601String(),
    };
  }

  Future<bool> cancelSubscription(
    Session session, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Get authenticated user
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    if (accountInfo.stripeSubscriptionId == null) {
      throw _noActiveSubscription(language);
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
      throw _subscriptionCancelFailed(language);
    }
  }

  Future<String> createCustomerPortalSession(
    Session session, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Get authenticated user
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }
    final authenticatedUserId = authenticationInfo.userId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    if (accountInfo.stripeCustomerId == null) {
      throw _noStripeCustomer(language);
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
      throw _customerPortalFailed(language);
    }
  }
}

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _accountNotFound(SupportedLanguage lang) =>
    createTranslatedException('account_not_found', lang);

ZenScrapException _userEmailNotFound(SupportedLanguage lang) =>
    createTranslatedException('user_email_not_found', lang);

ZenScrapException _alreadySubscribed(SupportedLanguage lang) =>
    createTranslatedException('already_subscribed', lang);

ZenScrapException _subscriptionCheckoutFailed(SupportedLanguage lang) =>
    createTranslatedException('subscription_checkout_failed', lang);

ZenScrapException _noActiveSubscription(SupportedLanguage lang) =>
    createTranslatedException('no_active_subscription', lang);

ZenScrapException _subscriptionCancelFailed(SupportedLanguage lang) =>
    createTranslatedException('subscription_cancel_failed', lang);

ZenScrapException _noStripeCustomer(SupportedLanguage lang) =>
    createTranslatedException('no_stripe_customer', lang);

ZenScrapException _customerPortalFailed(SupportedLanguage lang) =>
    createTranslatedException('customer_portal_failed', lang);
