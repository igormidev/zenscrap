# Cache Reset Implementation

## Overview
Implemented `ApiHelperMixin.resetNanoId()` calls throughout the codebase to ensure the API cache is properly cleared whenever plan tiers or credit amounts change.

## What resetNanoId Does
The `resetNanoId` function clears all cached data for a specific nano ID:
- Current concurrency requests count
- Plan tier cache
- Remaining subscription credits cache
- Remaining purchased credits cache

This ensures the next API call will fetch fresh data from the database.

## Where resetNanoId is Called

### 1. Stripe Webhook Handlers (`stripe_webhook.dart`)
- **checkout.session.completed**: When initial subscription is created
- **customer.subscription.created**: When subscription is created via API
- **customer.subscription.updated**: When subscription plan changes
- **customer.subscription.deleted**: When subscription is canceled
- **invoice.payment_failed**: When payment fails (status becomes past_due)
- **_addSubscriptionCredits**: After credits are added to the account

### 2. Subscription Management Endpoint (`private_subscription_endpoint.dart`)
- **cancelSubscription**: When user manually cancels their subscription

### 3. Plan Tier Updates (`public_tier_endpoint.dart`)
- **updatePlayerTier**: When admin manually updates a user's plan tier

### 4. Monthly Credits Future Call (`monthly_subscription_credits_future_call.dart`)
- After adding monthly subscription credits (already implemented)

## Why This Is Important
The API helper maintains an in-memory cache to avoid database queries on every API request. This improves performance but requires cache invalidation when:
- Plan tier changes (affects concurrency limits)
- Credit balances change (affects API usage tracking)
- Subscription status changes (affects access permissions)

Without proper cache invalidation, users might:
- See old credit balances after purchasing/receiving credits
- Hit incorrect concurrency limits after plan changes
- Continue/lose access incorrectly after subscription changes

## Testing Checklist
1. ✅ Subscription creation → Cache reset
2. ✅ Subscription upgrade/downgrade → Cache reset
3. ✅ Subscription cancellation → Cache reset
4. ✅ Payment failure → Cache reset
5. ✅ Monthly credit addition → Cache reset
6. ✅ Manual tier update → Cache reset
7. ✅ Credit addition via webhook → Cache reset

## Implementation Pattern
```dart
// Get API usage to reset cache
final apiUsage = await AccountApiUsage.db.findById(
  session,
  accountInfo.accountApiUsageId,
);
if (apiUsage != null) {
  ApiHelperMixin.resetNanoId(apiUsage.nanoId);
}
```

This pattern is used consistently throughout the codebase to ensure cache is cleared whenever plan or credit changes occur.