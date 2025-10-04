// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:web_scrapper_generator/web_scrapper_generator.dart'
    show
        ScrapingBeeApiMixin,
        ExtractDataByRule,
        ExtractFullDataByRule,
        kZenscrapHtmlCaptureField;
import 'package:zenscrap_server/src/generated/protocol.dart';

// Re-export the result types from the mixin
export 'package:web_scrapper_generator/web_scrapper_generator.dart'
    show ExtractDataByRule, ExtractFullDataByRule;

/// Global instance of ScrapingBee for server usage
final scrapingBee = ScrapingBee();

class ScrapingBee with ScrapingBeeApiMixin {
  Future<ExtractFullDataByRule> fetchHtmlAndScreenshotWithLogic({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    final String extractRulesWithHtml =
        _withHtmlCapture(scrappingBeeExtractLogic.extractRules);

    // Use the mixin's method with individual parameters
    return await fetchHtmlAndScreenshot(
      targetUrl: targetUrl,
      extract_rules: extractRulesWithHtml,
      js_scenario: scrappingBeeExtractLogic.jsScenario,
      render_js: scrappingBeeExtractLogic.renderJs,
      wait: scrappingBeeExtractLogic.wait,
      wait_for: scrappingBeeExtractLogic.waitFor,
      wait_browser: scrappingBeeExtractLogic.waitBrowser,
      premium_proxy: scrappingBeeExtractLogic.premiumProxy,
      stealth_proxy: scrappingBeeExtractLogic.stealthProxy,
      country_code: scrappingBeeExtractLogic.countryCode,
      session_id: scrappingBeeExtractLogic.sessionId,
      custom_google: scrappingBeeExtractLogic.customGoogle,
    );
  }

  Future<ExtractDataByRule> extractByRulesWithLogic({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    // Use the mixin's method with individual parameters
    return await extractByRules(
      targetUrl: targetUrl,
      extract_rules: scrappingBeeExtractLogic.extractRules,
      js_scenario: scrappingBeeExtractLogic.jsScenario,
      render_js: scrappingBeeExtractLogic.renderJs,
      wait: scrappingBeeExtractLogic.wait,
      wait_for: scrappingBeeExtractLogic.waitFor,
      wait_browser: scrappingBeeExtractLogic.waitBrowser,
      premium_proxy: scrappingBeeExtractLogic.premiumProxy,
      stealth_proxy: scrappingBeeExtractLogic.stealthProxy,
      country_code: scrappingBeeExtractLogic.countryCode,
      session_id: scrappingBeeExtractLogic.sessionId,
      custom_google: scrappingBeeExtractLogic.customGoogle,
    );
  }

  String _withHtmlCapture(String extractRules) {
    try {
      final decoded = jsonDecode(extractRules);
      if (decoded is Map<String, dynamic>) {
        if (!decoded.containsKey(kZenscrapHtmlCaptureField)) {
          decoded[kZenscrapHtmlCaptureField] = {
            'selector': 'html',
            'output': 'html',
          };
          return jsonEncode(decoded);
        }
      }
    } catch (_) {
      // If the extract rules aren't a JSON map we can't augment them.
    }

    return extractRules;
  }
}
