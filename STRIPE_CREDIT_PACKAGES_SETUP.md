# Stripe Credit Packages Setup Guide

## Overview
This guide will help you set up one-time credit package purchases in Stripe for ZenScrap.

## Credit Packages Available
- **Small Package**: 100,000 credits for $59
- **Medium Package**: 1,000,000 credits for $199
- **Large Package**: 2,500,000 credits for $399

## Setup Instructions

### 1. Create Products in Stripe Dashboard

1. Go to [Stripe Dashboard](https://dashboard.stripe.com/products)
2. Click "Add Product" for each credit package:

#### Small Credit Package
- **Name**: ZenScrap Credits - Small Package
- **Description**: 100,000 API credits for ZenScrap
- **Price**: $59.00 (one-time)
- **Price ID**: Save this for `stripeCreditPackageSmallPriceId`

#### Medium Credit Package
- **Name**: ZenScrap Credits - Medium Package
- **Description**: 1,000,000 API credits for ZenScrap
- **Price**: $199.00 (one-time)
- **Price ID**: Save this for `stripeCreditPackageMediumPriceId`

#### Large Credit Package
- **Name**: ZenScrap Credits - Large Package
- **Description**: 2,500,000 API credits for ZenScrap
- **Price**: $399.00 (one-time)
- **Price ID**: Save this for `stripeCreditPackageLargePriceId`

### 2. Update Configuration

Add the price IDs to your `passwords.yaml` file:

```yaml
development:
  stripeCreditPackageSmallPriceId: 'price_YOUR_SMALL_PACKAGE_PRICE_ID'
  stripeCreditPackageMediumPriceId: 'price_YOUR_MEDIUM_PACKAGE_PRICE_ID'
  stripeCreditPackageLargePriceId: 'price_YOUR_LARGE_PACKAGE_PRICE_ID'

production:
  stripeCreditPackageSmallPriceId: 'price_YOUR_SMALL_PACKAGE_PRICE_ID'
  stripeCreditPackageMediumPriceId: 'price_YOUR_MEDIUM_PACKAGE_PRICE_ID'
  stripeCreditPackageLargePriceId: 'price_YOUR_LARGE_PACKAGE_PRICE_ID'
```

### 3. Webhook Configuration

Your webhook at `https://zenscrap.com/stripe/webhook` will automatically handle:
- `checkout.session.completed` events for credit purchases
- Adding purchased credits to user accounts
- Creating credit history entries

## API Usage

### Creating a Credit Purchase Checkout

Call the endpoint from your Flutter client:

```dart
final checkoutUrl = await client.privateApiUsage.createCreditPurchaseCheckout(
  creditPackage: CreditPurchaseOption.medium, // small, medium, or large
);

// Redirect user to checkoutUrl
```

### Checking Credit Balance

Users can view their credit balance in the API Usage section, which shows:
- Subscription credits
- Purchased credits
- Total available credits
- Credit history with dates and amounts

## How It Works

1. User selects a credit package in the app
2. App calls `createCreditPurchaseCheckout` endpoint
3. Server creates a Stripe checkout session with:
   - User's email
   - Selected package price
   - Metadata for tracking
4. User completes payment on Stripe
5. Stripe sends webhook to your server
6. Server processes the payment:
   - Adds credits to user's account
   - Creates credit history entry
   - Updates cache
7. User sees updated balance immediately

## Testing

### Test Mode
Use Stripe test cards for development:
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`

### Verify Implementation
1. Create a test purchase
2. Check webhook logs in Stripe Dashboard
3. Verify credits added to user account
4. Check credit history shows the purchase

## Monitoring

Monitor credit purchases through:
- Stripe Dashboard payments
- Server logs for webhook processing
- Credit history in database
- User's credit balance in app

## Support

For issues:
- Check Stripe webhook logs
- Verify price IDs are correct
- Ensure webhook secret is configured
- Check server logs for errors