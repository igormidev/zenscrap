class StripeConfig {
  static late String secretKey;
  static late String webhookSecret;
  static late String basicPriceIdMonthly;
  static late String basicPriceIdYearly;
  static late String proPriceIdMonthly;
  static late String proPriceIdYearly;
  static late String ultraPriceIdMonthly;
  static late String ultraPriceIdYearly;
  static late String successUrl;
  static late String cancelUrl;

  static void initialize(Map<String, dynamic> config) {
    secretKey = config['stripe_secret_key'] ?? '';
    webhookSecret = config['stripe_webhook_secret'] ?? '';
    
    // Price IDs for each plan tier
    basicPriceIdMonthly = config['stripe_basic_price_id_monthly'] ?? '';
    basicPriceIdYearly = config['stripe_basic_price_id_yearly'] ?? '';
    proPriceIdMonthly = config['stripe_pro_price_id_monthly'] ?? '';
    proPriceIdYearly = config['stripe_pro_price_id_yearly'] ?? '';
    ultraPriceIdMonthly = config['stripe_ultra_price_id_monthly'] ?? '';
    ultraPriceIdYearly = config['stripe_ultra_price_id_yearly'] ?? '';
    
    // URLs for redirect after payment
    successUrl = config['stripe_success_url'] ?? '';
    cancelUrl = config['stripe_cancel_url'] ?? '';
  }

  static String getPriceId(String tier, bool isYearly) {
    switch (tier.toLowerCase()) {
      case 'basic':
      case 'base':
        return isYearly ? basicPriceIdYearly : basicPriceIdMonthly;
      case 'pro':
        return isYearly ? proPriceIdYearly : proPriceIdMonthly;
      case 'ultra':
      case 'unlimited':
        return isYearly ? ultraPriceIdYearly : ultraPriceIdMonthly;
      default:
        throw Exception('Invalid tier: $tier');
    }
  }
}