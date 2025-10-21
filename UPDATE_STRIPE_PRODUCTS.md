# Update Stripe Product Descriptions

## Why This Script Exists

The Stripe MCP (Model Context Protocol) server doesn't expose an `update_product` function, only `create_product` and `list_products`. Therefore, we need to use the Stripe API directly to update product descriptions.

## Prerequisites

1. Your `passwords.yaml` file must be configured with Stripe credentials
2. Run this from the project root directory

## Usage

### Update Test Mode Products (Development)

```bash
dart run update_stripe_products.dart development
```

### Update Production Products

```bash
dart run update_stripe_products.dart production
```

## What It Does

The script updates the following Stripe products with the new credit amounts:

### BASIC Plan
- **Old**: 50,000 API calls
- **New**: 250,000 API credits

### PRO Plan
- **Old**: 200,000 API calls
- **New**: 1,000,000 API credits

### ULTRA Plan
- **Old**: 1,000,000 API calls
- **New**: 4,000,000 API credits

## Product IDs

### Test Mode (Development)
- BASIC: `prod_SzRrOGVyjakoTS`
- PRO: `prod_SzRrdnJSVLcKkY`
- ULTRA: `prod_SzRrOifCioXQVI`

### Production Mode
You'll need to update the script with your production product IDs if they differ.

## Manual Alternative

If you prefer, you can also update these manually in the [Stripe Dashboard](https://dashboard.stripe.com/products):

1. Go to Products
2. Click on each product
3. Update the description field
4. Click Save

## Implementation Details

The script uses the `StripeApi.updateProduct()` method which makes a direct HTTP POST request to:
```
https://api.stripe.com/v1/products/{product_id}
```

This is the same approach used throughout the codebase for other Stripe operations (checkout sessions, subscriptions, etc.).
