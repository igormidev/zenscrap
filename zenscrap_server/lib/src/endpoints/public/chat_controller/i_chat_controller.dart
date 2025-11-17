import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';

abstract class IChatController {
  final int scrappableId;
  const IChatController({required this.scrappableId});

  Future<void> changeModel(AiModel aiModel);

  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
  });

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
