# Monthly Subscription Credits System

## Overview
Implemented an automated monthly credit addition system for active subscriptions using Serverpod's future call mechanism.

## Key Components

### 1. MonthlyCreditsData Entity (`monthly_credits_data.spy.yaml`)
- Stores the `accountInfoId` for tracking which account should receive credits
- Used as the parameter for the future call

### 2. MonthlySubscriptionCreditsFutureCall
- Executes every 30 days for active subscriptions
- Adds credits based on the user's plan tier
- Updates both database and in-memory cache (ApiHelperMixin)
- Automatically schedules the next monthly credit addition
- Validates subscription status before adding credits

### 3. Credit System Integration

#### When Credits Are Added:
1. **Initial Subscription Creation**: 
   - Credits added immediately when subscription is created
   - First monthly future call scheduled for 30 days later

2. **Monthly Recurring**:
   - Future call executes every 30 days
   - Adds credits to `AccountApiUsage.subscriptionCredits`
   - Updates `ApiHelperMixin.remainingSubscriptionCredits` cache

#### Credit Amounts by Plan:
- **Base/Basic**: 250,000 credits/month
- **Pro**: 1,000,000 credits/month
- **Unlimited/Ultra**: 4,000,000 credits/month

### 4. ApiHelperMixin Updates
The mixin now tracks two separate credit pools:
- `remainingSubscriptionCredits`: Credits from active subscriptions
- `remainingPurchasedCredits`: Credits purchased separately

Priority: Subscription credits are used first, then purchased credits.

### 5. Webhook Integration
Updated Stripe webhook handlers:
- `checkout.session.completed`: Adds initial credits and schedules monthly additions
- `customer.subscription.created`: Adds initial credits and schedules monthly additions
- `customer.subscription.deleted`: Sets plan to 'none', stopping future credit additions
- `invoice.payment_succeeded`: Now only logs for monitoring (credits handled by future call)

## How It Works

### Credit Addition Flow:
1. User subscribes → Webhook receives event
2. Initial credits added to account
3. Future call scheduled for +30 days
4. Every 30 days:
   - Future call checks if subscription is still active
   - Adds monthly credits if active
   - Updates cache for API performance
   - Schedules next future call for +30 days

### Credit Usage Flow:
1. API request arrives with nano ID
2. System checks cached credit balances
3. If no cache, loads from database
4. Deducts from subscription credits first
5. Falls back to purchased credits if needed
6. Updates cache for future requests

## Benefits
- **Automatic**: No manual intervention needed
- **Reliable**: Uses Serverpod's persistent future call system
- **Efficient**: Caches credit balances for fast API responses
- **Flexible**: Supports both subscription and purchased credits
- **Self-healing**: Automatically stops when subscription cancels

## Database Fields
- `AccountApiUsage.subscriptionCredits`: Current subscription credit balance
- `AccountApiUsage.purchasedCredits`: Current purchased credit balance
- `AccountApiUsage.nanoId`: Unique identifier for API access

## Future Call Registration
The monthly credit future call is registered in `server.dart`:
```dart
pod.registerFutureCall(
    MonthlySubscriptionCreditsFutureCall(), 
    'monthly_subscription_credits'
);
```

## Monitoring
Check server logs for:
- "Added X subscription credits to account Y"
- "Scheduled monthly credits for account Y"
- "Scheduled next monthly credits addition for account Y in 30 days"

## Testing
1. Create a subscription through Stripe checkout
2. Verify initial credits are added
3. Check that future call is scheduled (in database)
4. Wait or manually trigger future call
5. Verify credits are added monthly