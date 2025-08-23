# Stripe Subscription System Setup Guide

## Overview
This implementation provides a complete Stripe subscription system for your ZenScrap app with the following features:
- Pre-filled email checkout sessions
- Webhook handling for subscription events
- Automatic plan tier updates
- API credit management based on subscription
- Subscription cancellation support

## Setup Instructions

### 1. Stripe Dashboard Configuration

#### Create Products and Prices
1. Go to [Stripe Dashboard](https://dashboard.stripe.com/products)
2. Create three products:
   - **Basic Plan** - For side-projects
   - **Pro Plan** - For startups
   - **Ultra Plan** - For enterprise usage

3. For each product, create two prices:
   - Monthly price
   - Yearly price (with discount)

4. Note down all the Price IDs (they look like `price_1234567890abcdef`)

#### Configure Webhook Endpoint
1. Go to [Webhooks](https://dashboard.stripe.com/webhooks)
2. Add endpoint with URL: `https://yourdomain.com/stripe/webhook`
3. Select the following events to listen for:
   - `checkout.session.completed`
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
4. Copy the Webhook signing secret (starts with `whsec_`)

### 2. Server Configuration

#### Update passwords.yaml
1. Copy `zenscrap_server/config/passwords_stripe_template.yaml` to `zenscrap_server/config/passwords.yaml`
2. Fill in your Stripe credentials:
```yaml
development:
  stripeSecretKey: 'sk_test_YOUR_KEY'
  stripeWebhookSecret: 'whsec_YOUR_SECRET'
  stripeBasicPriceIdMonthly: 'price_BASIC_MONTHLY'
  stripeBasicPriceIdYearly: 'price_BASIC_YEARLY'
  stripeProPriceIdMonthly: 'price_PRO_MONTHLY'
  stripeProPriceIdYearly: 'price_PRO_YEARLY'
  stripeUltraPriceIdMonthly: 'price_ULTRA_MONTHLY'
  stripeUltraPriceIdYearly: 'price_ULTRA_YEARLY'
  stripeSuccessUrl: 'http://localhost:3000/success'
  stripeCancelUrl: 'http://localhost:3000/cancel'
```

### 3. Database Migration
Run the database migration to add new Stripe fields:
```bash
cd zenscrap_server
serverpod create-migration --experimental-features=all
serverpod migrate --experimental-features=all
```

### 4. Testing

#### Test Checkout Flow
1. Use Stripe test mode credentials
2. Test card number: `4242 4242 4242 4242`
3. Any future expiry date and any CVC

#### Test Webhook Locally
Use Stripe CLI to forward webhooks to your local server:
```bash
stripe listen --forward-to localhost:8080/stripe/webhook
```

## Implementation Details

### Server Components

#### 1. AccountInfo Model Updates
Added fields to track Stripe subscription:
- `stripeCustomerId`: Stripe customer ID
- `stripeSubscriptionId`: Active subscription ID
- `subscriptionStatus`: Current status (active, past_due, canceled)
- `subscriptionEndDate`: When the current period ends

#### 2. PrivateSubscriptionEndpoint
Provides three main methods:
- `createCheckoutSession`: Creates Stripe checkout with pre-filled email
- `getSubscriptionStatus`: Returns current subscription status
- `cancelSubscription`: Cancels active subscription

#### 3. StripeWebhookRoute
Handles all Stripe webhook events:
- Verifies webhook signatures for security
- Updates user plan tiers automatically
- Manages API credits based on subscription events
- Handles payment failures and subscription cancellations

#### 4. Stripe API Helper
Direct API integration without external packages:
- Creates checkout sessions
- Verifies webhook signatures using HMAC-SHA256
- Manages subscriptions

### Flutter Components

#### Updated Pricing Page
- Calls subscription endpoint instead of test methods
- Opens Stripe checkout in external browser
- Shows appropriate error messages
- Redirects to auth if not signed in

## Security Considerations

1. **Webhook Signature Verification**: All webhooks are verified using HMAC-SHA256 to ensure they're from Stripe
2. **Pre-filled Email**: Email is taken from authenticated user session, preventing manipulation
3. **Account Identification**: Uses AccountInfo ID in metadata to securely link subscriptions to users
4. **Authentication Required**: All subscription endpoints require user authentication

## API Credits Management

Credits are automatically managed based on subscription events:
- **On subscription creation**: Initial credits added
- **On monthly renewal**: Monthly credits added (via invoice.payment_succeeded)
- **On cancellation**: Plan tier set to 'none', stopping credit additions

Plan tier credits per month:
- Basic: 50,000 credits
- Pro: 200,000 credits
- Ultra: 1,000,000 credits

## Troubleshooting

### Common Issues

1. **Webhook not receiving events**
   - Check webhook URL is accessible
   - Verify webhook secret is correct
   - Check server logs for signature verification errors

2. **Checkout session not creating**
   - Verify Stripe API key is correct
   - Check price IDs exist in your Stripe account
   - Ensure user is authenticated

3. **Plan tier not updating**
   - Check webhook events are being received
   - Verify AccountInfo ID is correctly passed in metadata
   - Check database connection and transactions

## Next Steps

1. Create success and cancel pages in your Flutter app
2. Add subscription status display in user dashboard
3. Implement credit balance display
4. Add subscription management portal link
5. Set up email notifications for subscription events

## Support

For any issues with the implementation:
1. Check server logs for detailed error messages
2. Use Stripe Dashboard to view event logs
3. Test with Stripe CLI for local development
4. Ensure all dependencies are up to date