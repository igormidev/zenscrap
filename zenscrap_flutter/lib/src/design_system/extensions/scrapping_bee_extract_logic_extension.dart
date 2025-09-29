import 'package:zenscrap_client/zenscrap_client.dart';

extension ScrappingBeeExtractLogicCostExtension on ScrappingBeeExtractLogic {
  /// Calculates the total ScrapingBee API credit cost for this extraction configuration
  ///
  /// Pricing based on ScrapingBee official documentation:
  /// - custom_google=true: 20 credits (flat rate for Google domains)
  /// - stealth_proxy=true: 75 credits (overrides premium_proxy)
  /// - premium_proxy=true + render_js=true: 25 credits
  /// - premium_proxy=true + render_js=false: 10 credits
  /// - render_js=true (no proxy): 5 credits
  /// - Basic request (no JS, no proxy): 1 credit
  int get totalCreditCost {
    // Google domains have a flat rate
    if (customGoogle == true) {
      return 20;
    }

    // Stealth proxy is the most expensive and overrides other options
    if (stealthProxy == true) {
      return 75;
    }

    // Premium proxy pricing depends on JS rendering
    if (premiumProxy == true) {
      return renderJs ? 25 : 10;
    }

    // JS rendering without proxy
    if (renderJs == true) {
      return 5;
    }

    // Basic request
    return 1;
  }

  /// Returns the individual cost contribution of each field
  Map<String, int> get fieldCosts {
    final costs = <String, int>{};

    // Calculate base cost based on configuration
    if (customGoogle == true) {
      costs['customGoogle'] = 20;
      // When customGoogle is true, it's a flat rate, other fields don't add cost
      costs['renderJs'] = 0;
      costs['premiumProxy'] = 0;
      costs['stealthProxy'] = 0;
    } else if (stealthProxy == true) {
      costs['stealthProxy'] = 75;
      // Stealth proxy includes everything, other fields don't add extra cost
      costs['renderJs'] = 0;
      costs['premiumProxy'] = 0;
      costs['customGoogle'] = 0;
    } else if (premiumProxy == true) {
      if (renderJs == true) {
        // Premium proxy + JS = 25 total
        costs['premiumProxy'] = 20; // 25 - 5 (JS cost)
        costs['renderJs'] = 5;
      } else {
        // Premium proxy without JS = 10
        costs['premiumProxy'] = 10;
        costs['renderJs'] = 0;
      }
      costs['stealthProxy'] = 0;
      costs['customGoogle'] = 0;
    } else {
      // No proxy
      costs['renderJs'] = renderJs ? 5 : 1;
      costs['premiumProxy'] = 0;
      costs['stealthProxy'] = 0;
      costs['customGoogle'] = 0;
    }

    // Fields that don't affect cost
    costs['wait'] = 0;
    costs['waitFor'] = 0;
    costs['waitBrowser'] = 0;
    costs['countryCode'] = 0;

    return costs;
  }
}
