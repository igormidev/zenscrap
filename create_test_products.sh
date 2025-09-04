#!/bin/bash

# Stripe Test Mode Product Creation Script
# Make sure you have Stripe CLI installed: https://stripe.com/docs/stripe-cli
# Run: stripe login --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ first

echo "Creating test mode products and prices..."

# Create BASIC product
BASIC_PRODUCT=$(stripe products create \
  --name="BASIC Plan" \
  --description="For side-projects - 50,000 API calls, 10 concurrent requests, 3 active endpoints" \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "Created BASIC product: $BASIC_PRODUCT"

# Create BASIC prices
BASIC_MONTHLY=$(stripe prices create \
  --product=$BASIC_PRODUCT \
  --unit-amount=10000 \
  --currency=usd \
  --recurring[interval]=month \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

BASIC_YEARLY=$(stripe prices create \
  --product=$BASIC_PRODUCT \
  --unit-amount=105000 \
  --currency=usd \
  --recurring[interval]=year \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "BASIC Monthly: $BASIC_MONTHLY"
echo "BASIC Yearly: $BASIC_YEARLY"

# Create PRO product
PRO_PRODUCT=$(stripe products create \
  --name="PRO Plan" \
  --description="For startups - 200,000 API calls, 30 concurrent requests, 10 active endpoints, access to best AI model" \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "Created PRO product: $PRO_PRODUCT"

# Create PRO prices
PRO_MONTHLY=$(stripe prices create \
  --product=$PRO_PRODUCT \
  --unit-amount=19900 \
  --currency=usd \
  --recurring[interval]=month \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

PRO_YEARLY=$(stripe prices create \
  --product=$PRO_PRODUCT \
  --unit-amount=199900 \
  --currency=usd \
  --recurring[interval]=year \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "PRO Monthly: $PRO_MONTHLY"
echo "PRO Yearly: $PRO_YEARLY"

# Create ULTRA product
ULTRA_PRODUCT=$(stripe products create \
  --name="ULTRA Plan" \
  --description="Enterprise usage - 1,000,000 API calls, 100 concurrent requests, 100 active endpoints, best AI model, priority support, marketplace features" \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "Created ULTRA product: $ULTRA_PRODUCT"

# Create ULTRA prices
ULTRA_MONTHLY=$(stripe prices create \
  --product=$ULTRA_PRODUCT \
  --unit-amount=50000 \
  --currency=usd \
  --recurring[interval]=month \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

ULTRA_YEARLY=$(stripe prices create \
  --product=$ULTRA_PRODUCT \
  --unit-amount=550000 \
  --currency=usd \
  --recurring[interval]=year \
  --api-key sk_test_51RK4KXJRaWX4CIXemSfOIlUydnVoGXCkTmhN5Kx47FQNL9QpygmAhciuBdsXVIce0Z4XyJOnNUaiSUlfN8OvHZgL00xYLltPyQ | jq -r '.id')

echo "ULTRA Monthly: $ULTRA_MONTHLY"
echo "ULTRA Yearly: $ULTRA_YEARLY"

echo ""
echo "========================================="
echo "Test Mode Products Created Successfully!"
echo "========================================="
echo ""
echo "Add these to your passwords.yaml development section:"
echo ""
echo "  stripeBasicPriceIdMonthly: '$BASIC_MONTHLY'"
echo "  stripeBasicPriceIdYearly: '$BASIC_YEARLY'"
echo "  stripeProPriceIdMonthly: '$PRO_MONTHLY'"
echo "  stripeProPriceIdYearly: '$PRO_YEARLY'"
echo "  stripeUltraPriceIdMonthly: '$ULTRA_MONTHLY'"
echo "  stripeUltraPriceIdYearly: '$ULTRA_YEARLY'"