import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_api.dart';
import 'package:zenscrap_server/src/core/stripe/stripe_config.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateSubscriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Syncs subscription status from Stripe using the user's email.
  /// This is useful when webhook delivery failed or user wants to manually refresh.
  Future<AccountInfo> syncSubscriptionFromStripe(
    Session session, {
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    // Get authenticated user
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }
    final authenticatedUserId = authenticationInfo.authUserId;

    // Get user profile for email
    final userProfile = await session.authenticated?.userProfile(session);
    final customerEmail = userProfile?.email;

    if (customerEmail == null) {
      throw _userEmailNotFound(language);
    }

    // Get account info with includes
    var accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authenticatedUserId),
      include: _accountInfoInclude,
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    try {
      // Search for customer by email in Stripe
      final customers = await StripeApi.listCustomersByEmail(
        secretKey: StripeConfig.secretKey,
        email: customerEmail,
      );

      if (customers.isEmpty) {
        session.log('No Stripe customer found for email: $customerEmail');
        // No Stripe customer - ensure account reflects no subscription
        if (accountInfo.stripeCustomerId != null ||
            accountInfo.stripeSubscriptionId != null) {
          accountInfo.stripeCustomerId = null;
          accountInfo.stripeSubscriptionId = null;
          accountInfo.subscriptionStatus = null;
          accountInfo.planTier = PlanTier.none;
          accountInfo.subscriptionEndDate = null;
          await AccountInfo.db.updateRow(session, accountInfo);

          // Reset cache
          final apiUsage = await AccountApiUsage.db.findById(
            session,
            accountInfo.accountApiUsageId,
          );
          if (apiUsage != null) {
            ApiHelperMixin.resetNanoId(apiUsage.nanoId);
          }
        }
        return accountInfo;
      }

      final stripeCustomer = customers.first;
      final customerId = stripeCustomer['id'] as String;

      // Get subscriptions for this customer
      final subscriptions = await StripeApi.listSubscriptionsForCustomer(
        secretKey: StripeConfig.secretKey,
        customerId: customerId,
      );

      // Find the most relevant subscription (active > trialing > others)
      Map<String, dynamic>? activeSubscription;
      for (final sub in subscriptions) {
        final status = sub['status'] as String?;
        if (status == 'active' || status == 'trialing') {
          activeSubscription = sub;
          break;
        }
      }

      // If no active subscription, check for other states
      activeSubscription ??= subscriptions.isNotEmpty ? subscriptions.first : null;

      if (activeSubscription == null) {
        session.log('No subscriptions found for customer: $customerId');
        // Customer exists but no subscriptions
        accountInfo.stripeCustomerId = customerId;
        accountInfo.stripeSubscriptionId = null;
        accountInfo.subscriptionStatus = null;
        accountInfo.planTier = PlanTier.none;
        accountInfo.subscriptionEndDate = null;
        await AccountInfo.db.updateRow(session, accountInfo);

        // Reset cache
        final apiUsage = await AccountApiUsage.db.findById(
          session,
          accountInfo.accountApiUsageId,
        );
        if (apiUsage != null) {
          ApiHelperMixin.resetNanoId(apiUsage.nanoId);
        }
        return accountInfo;
      }

      // Extract subscription details
      final subscriptionId = activeSubscription['id'] as String;
      final status = activeSubscription['status'] as String?;
      final currentPeriodEnd = activeSubscription['current_period_end'] as int?;

      // Get the price ID to determine the plan tier
      final items = activeSubscription['items'] as Map<String, dynamic>?;
      final data = items?['data'] as List<dynamic>?;
      final firstItem = data?.firstOrNull as Map<String, dynamic>?;
      final price = firstItem?['price'] as Map<String, dynamic>?;
      final priceId = price?['id'] as String?;

      // Determine plan tier from price ID
      final newPlanTier = _getPlanTierFromPriceId(priceId);

      // Update account info
      accountInfo.stripeCustomerId = customerId;
      accountInfo.stripeSubscriptionId = subscriptionId;
      accountInfo.subscriptionStatus = status;
      accountInfo.planTier = newPlanTier;

      if (currentPeriodEnd != null) {
        accountInfo.subscriptionEndDate =
            DateTime.fromMillisecondsSinceEpoch(currentPeriodEnd * 1000);
      }

      await AccountInfo.db.updateRow(session, accountInfo);

      // Reset cache
      final apiUsage = await AccountApiUsage.db.findById(
        session,
        accountInfo.accountApiUsageId,
      );
      if (apiUsage != null) {
        ApiHelperMixin.resetNanoId(apiUsage.nanoId);
      }

      session.log(
          'Synced subscription from Stripe for account ${accountInfo.id}: '
          'plan=$newPlanTier, status=$status');

      // Re-fetch with includes to return complete data
      final updatedAccountInfo = await AccountInfo.db.findById(
        session,
        accountInfo.id!,
        include: _accountInfoInclude,
      );

      return updatedAccountInfo ?? accountInfo;
    } catch (e) {
      session.log('Failed to sync subscription from Stripe: $e');
      throw _syncSubscriptionFailed(language);
    }
  }

  PlanTier _getPlanTierFromPriceId(String? priceId) {
    if (priceId == null) {
      return PlanTier.none;
    }

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

  final _accountInfoInclude = AccountInfo.include(
    authUser: AuthUser.include(),
    accountApiUsage: AccountApiUsage.include(
      apiKeys: AccountApiKey.includeList(
        limit: 10,
        orderBy: (p0) => p0.createdAt,
      ),
    ),
  );

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
    final authenticatedUserId = authenticationInfo.authUserId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authenticatedUserId),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    // Get user profile for email
    final userProfile = await session.authenticated?.userProfile(session);
    final customerEmail = userProfile?.email;

    if (customerEmail == null) {
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
        customerEmail: customerEmail,
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
    final authenticatedUserId = authenticationInfo.authUserId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authenticatedUserId),
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
    final authenticatedUserId = authenticationInfo.authUserId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authenticatedUserId),
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
    final authenticatedUserId = authenticationInfo.authUserId;

    // Get account info
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authenticatedUserId),
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

ZenScrapException _syncSubscriptionFailed(SupportedLanguage lang) =>
    createTranslatedException('sync_subscription_failed', lang);
