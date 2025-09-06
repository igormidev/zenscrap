class StripeConfig {
  static late String secretKey;
  static late String webhookSecret;
  static late String basicPriceIdMonthly;
  static late String basicPriceIdYearly;
  static late String proPriceIdMonthly;
  static late String proPriceIdYearly;
  static late String ultraPriceIdMonthly;
  static late String ultraPriceIdYearly;
  
  // One-time credit package price IDs
  static late String creditPackageSmallPriceId;  // 100K credits for $59
  static late String creditPackageMediumPriceId; // 1M credits for $199
  static late String creditPackageLargePriceId;  // 2.5M credits for $399
  
  static late String successUrl;
  static late String cancelUrl;
  static late String portalReturnUrl;

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
    
    // One-time credit package price IDs
    creditPackageSmallPriceId = config['stripe_credit_package_small_price_id'] ?? '';
    creditPackageMediumPriceId = config['stripe_credit_package_medium_price_id'] ?? '';
    creditPackageLargePriceId = config['stripe_credit_package_large_price_id'] ?? '';
    
    // URLs for redirect after payment
    successUrl = config['stripe_success_url'] ?? '';
    cancelUrl = config['stripe_cancel_url'] ?? '';
    portalReturnUrl = config['stripe_portal_return_url'] ?? '';
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
  
  static String getCreditPackagePriceId(String packageName) {
    switch (packageName.toLowerCase()) {
      case 'small':
        return creditPackageSmallPriceId;
      case 'medium':
        return creditPackageMediumPriceId;
      case 'large':
        return creditPackageLargePriceId;
      default:
        throw Exception('Invalid credit package: $packageName');
    }
  }
  
  static int getCreditAmount(String packageName) {
    switch (packageName.toLowerCase()) {
      case 'small':
        return 100000;  // 100K credits
      case 'medium':
        return 1000000; // 1M credits
      case 'large':
        return 2500000; // 2.5M credits
      default:
        throw Exception('Invalid credit package: $packageName');
    }
  }
}