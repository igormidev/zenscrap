import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';

/// Result of a sendMessage operation containing the cost of the API call
class SendMessageResult {
  /// Cost in USD of this API call
  final double costInUsd;

  /// Number of input tokens used
  final int inputTokens;

  /// Number of output tokens used
  final int outputTokens;

  /// Number of reasoning tokens used (for reasoning models)
  final int reasoningTokens;

  const SendMessageResult({
    required this.costInUsd,
    required this.inputTokens,
    required this.outputTokens,
    this.reasoningTokens = 0,
  });

  /// Zero cost result (used when API key is user's own)
  static const zero = SendMessageResult(
    costInUsd: 0.0,
    inputTokens: 0,
    outputTokens: 0,
  );
}

abstract class IChatController {
  final int scrappableId;
  const IChatController({required this.scrappableId});

  Future<void> changeModel(AiModel aiModel);

  /// Sends a message and returns the cost of the API call in USD.
  /// The cost is calculated based on the model used and tokens consumed.
  /// [language] is used for translating system messages in the chat.
  Future<SendMessageResult> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
    required SupportedLanguage language,
  });

  /// Disposes of session-specific resources (e.g., uploaded files).
  /// Should be called when the chat session ends.
  Future<void> dispose();

  static InitialPayloadData getInitialPayloadDate({
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? currentFetchSettings,
  }) {
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      pathParams: scrapperRequest.pathParams,
      queryParam: scrapperRequest.queryParams,
      queryParamsNotRelatedToUrl: scrapperRequest.queryParamsNotRelatedToUrl,
    );
    if (currentFetchSettings != null) {
      return InitialPayloadDataEditingExistingWebScrapper(
        currentFetchSettings: ScrappingBeeFetchSettings(
          url: referenceTestData.referenceLinkUsed,
          extract_rules: currentFetchSettings.extractRules,
          js_scenario: currentFetchSettings.jsScenario,
          render_js: currentFetchSettings.renderJs,
          premium_proxy: currentFetchSettings.premiumProxy,
          stealth_proxy: currentFetchSettings.stealthProxy,
          wait: currentFetchSettings.wait,
          wait_for: currentFetchSettings.waitFor,
          wait_browser: currentFetchSettings.waitBrowser,
          country_code: currentFetchSettings.countryCode,
          session_id: currentFetchSettings.sessionId,
          custom_google: currentFetchSettings.customGoogle,
        ),
        currentRequest: webScrapperRequest,
      );
    }

    return InitialPayloadDataCreatingFromZero(
      targetExampleUrl: referenceTestData.referenceLinkUsed,
      webScrapperRequest: webScrapperRequest,
    );
  }
}
