import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RetryText = String;

/// Mixin that provides shared functionality for chat controller implementations
mixin ChatControllerHandlerMixin {
  int get scrappableId;

  /// Handles the send message response and validates extraction rules
  Future<RetryText?> handleSendMessage({
    required Session session,
    required WebScrapperChatAIResponse response,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required int attemptNumber,
    required ScrappingBeeExtractLogic? scrappingBeeLogic,
    required StreamController<ChatResponse> chatSeason,
    required List<String> thinkingSentences,
  }) async {
    final resp = response.toChatResponse(
      referenceTestData: referenceTestData,
      scrapperRequest: scrapperRequest,
      scrappingBeeExtractLogic: scrappingBeeLogic,
      thinkingSentences: thinkingSentences,
    );
    chatSeason.add(resp.$1);
    final ScrappingBeeExtractLogic? scrappingBeeExtractLogic = resp.$2;
    final ScrappableRequest? newRequest = resp.$3;

    // If a new request structure was provided, log it for debugging
    if (newRequest != null) {
      session.log(
        'AI modified the ScrappableRequest structure',
        level: LogLevel.info,
      );
      session.log(
        '  New queryParams: ${newRequest.queryParams}',
        level: LogLevel.debug,
      );
      session.log(
        '  New queryParamsNotRelatedToUrl: ${newRequest.queryParamsNotRelatedToUrl}',
        level: LogLevel.debug,
      );
    }

    if (scrappingBeeExtractLogic == null) {
      // No new extract logic to test, so no verification/retry needed.
      // However, if the request was modified, notify via the chat stream
      // so the cache can be updated (similar to how extract logic is handled).
      if (newRequest != null) {
        chatSeason.add(
          UpdatedScrappableRequestResponse(
            role: PromptRole.system,
            expectsFollowUp: false,
            messageText: 'Request structure updated successfully.',
            url: newRequest.url,
            pathParams: newRequest.pathParams,
            queryParams: newRequest.queryParams,
            scrappableRequest: newRequest,
          ),
        );
      }
      return null;
    }

    chatSeason.add(
      MessageTextResponse(
        role: PromptRole.system,
        expectsFollowUp: true, // Validation will follow
        messageText:
            'Great, I will now test the extract rules you created to see if it works in the reference link we are using for testing.\n'
            'Please wait a moment...',
      ),
    );

    // Prepare test payload for placeholder replacement
    final Map<String, dynamic> testPayload = {};

    // Add path parameters from reference test data
    final refQueryParamsJson = referenceTestData.referenceQueryParametersJson;
    if (refQueryParamsJson.isNotEmpty) {
      try {
        final pathParams =
            jsonDecode(refQueryParamsJson) as Map<String, dynamic>;
        testPayload.addAll(pathParams);
      } catch (e) {
        session.log(
          'Failed to parse referenceQueryParametersJson for testing: $e',
          level: LogLevel.warning,
        );
      }
    }

    // Add query parameters from scrapper request (use their default values or provide sensible defaults)
    for (final entry in scrapperRequest.queryParams.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value != null) {
        // Use the default value if available
        testPayload[key] = value;
      } else if (!testPayload.containsKey(key)) {
        // Provide sensible test defaults for common parameter names
        if (key.toLowerCase().contains('search') ||
            key.toLowerCase().contains('query')) {
          testPayload[key] = 'test query';
        } else if (key.toLowerCase().contains('page')) {
          testPayload[key] = '1';
        } else if (key.toLowerCase().contains('min') ||
            key.toLowerCase().contains('max')) {
          testPayload[key] = '0';
        } else {
          testPayload[key] = 'test value';
        }
      }
    }

    // Replace placeholders in extraction logic with test values
    final extractLogicWithTestValues = replaceExtractLogicPlaceholders(
      scrappingBeeExtractLogic,
      testPayload,
    );

    // Needs to validate if the rules are working...
    final ExtractFullDataByRule extractResult = await scrappingBee
        .fetchHtmlAndScreenshotWithLogic(
          targetUrl: referenceTestData.referenceLinkUsed,
          scrappingBeeExtractLogic: extractLogicWithTestValues,
        );

    return await extractResult.when(
      withData: (result, html, pageFullscreenScreenshot) async {
        chatSeason.add(
          MessageTextResponse(
            role: PromptRole.system,
            expectsFollowUp: true, // NewExtractRuleResponse will follow
            messageText:
                'New rules were tested and did not present any errors! I\'ll update the test endpoint...',
          ),
        );
        final Uint8List htmlBytes = utf8.encode(html);
        final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
        final ByteData screenshotByteData = ByteData.view(
          pageFullscreenScreenshot.buffer,
        );
        ByteTestData byteTestData =
            referenceTestData.byteData?.copyWith(
              referenceHtmlPage: htmlByteData,
              referenceSiteScreenshot: screenshotByteData,
            ) ??
            ByteTestData(
              referenceHtmlPage: htmlByteData,
              referenceSiteScreenshot: screenshotByteData,
            );
        ReferenceTestData newReferenceTestData = referenceTestData.copyWith(
          scrapResultJson: jsonEncode(result),
          byteData: byteTestData,
        );

        ScrappingBeeExtractLogic newScrappingBeeLogic =
            scrappingBeeExtractLogic;

        final isNew =
            referenceTestData.byteDataId == null ||
            referenceTestData.byteData == null ||
            newScrappingBeeLogic.id == null;

        if (isNew) {
          await session.db.transaction((transaction) async {
            byteTestData = await ByteTestData.db.insertRow(
              session,
              byteTestData,
              transaction: transaction,
            );
            newReferenceTestData = newReferenceTestData.copyWith(
              byteDataId: byteTestData.id,
              byteData: byteTestData,
            );
            await ReferenceTestData.db.attachRow.byteData(
              session,
              newReferenceTestData,
              byteTestData,
              transaction: transaction,
            );
            await ReferenceTestData.db.updateRow(
              session,
              newReferenceTestData,
              transaction: transaction,
            );
            final scrappable = await Scrappable.db.findById(
              session,
              scrappableId,
              transaction: transaction,
            );

            newScrappingBeeLogic = await ScrappingBeeExtractLogic.db.insertRow(
              session,
              newScrappingBeeLogic,
              transaction: transaction,
            );

            // CRITICAL: Update the in-memory object with the scrappableId that was set by attachRow
            // Without this, the cached object will have scrappableId = null, and commitCurrentEditState
            // will break the relationship when it calls updateRow!
            newScrappingBeeLogic = newScrappingBeeLogic.copyWith(
              scrappableId: scrappable!.id,
            );
            await Scrappable.db.attachRow.scrappingBeeExtractRules(
              session,
              scrappable,
              newScrappingBeeLogic,
              transaction: transaction,
            );
          });
        } else {
          await Future.delayed(const Duration(milliseconds: 800));
        }

        chatSeason.add(
          NewExtractRuleResponse(
            role: PromptRole.system,
            expectsFollowUp: false, // Final success, no follow-up
            messageText: 'New rules were tested and did not present any errors',
            scrapperRequest: newRequest ?? scrapperRequest,
            referenceTestData: newReferenceTestData,
            scrappingBeeExtractLogic: newScrappingBeeLogic,
          ),
        );
        return null;
      },
      error: (String errorMessage) {
        session.log(
          '#$attemptNumber retrying due to error: $errorMessage',
          level: LogLevel.warning,
        );
        chatSeason.add(
          ErrorTextResponse(
            role: PromptRole.system,
            expectsFollowUp: true, // Retry will follow
            errorMessage:
                'The extraction rules failed in my quality-assurance test validation. I will ask the AI to fix the selectors and try again.',
          ),
        );
        return buildRetryMessage(
          attemptNumber: attemptNumber,
          errorMessage: errorMessage,
        );
      },
    );
  }

  /// Builds the retry message with critical analysis requirements
  String buildRetryMessage({
    required int attemptNumber,
    required String errorMessage,
  }) {
    final String attempt = attemptNumber > 1
        ? '# Attempt $attemptNumber\n'
        : '';

    return '''${attempt}When I tried calling the scrapping bee API with the new extract rule that you just generated, I got the following error from the scrapping bee endpoint:
```log
\n$errorMessage
```

Please try again. Try to deeply understand how the scrapping bee rules creation works, see the documentation in https://www.scrapingbee.com/documentation/data-extraction/#basic-usage if needed.

${_getCriticalAnalysisText()}''';
  }

  /// Returns the critical analysis requirements text
  String _getCriticalAnalysisText() {
    return '''**CRITICAL ANALYSIS REQUIRED:**
1. The selectors you provided are likely incorrect or don't match actual elements in the HTML
2. Please carefully re-examine the HTML structure provided
3. Verify that each selector path actually exists in the HTML document
4. Consider using more specific or alternative selectors
5. Think step-by-step through the HTML hierarchy to ensure accuracy
6. Double-check for typos in class names, IDs, or element tags
7. Consider if the elements might be dynamically loaded (look for data attributes or JS-rendered content markers)

**Common issues to check:**
- Incorrect class names (check for exact matches including hyphens/underscores)
- Missing parent elements in selector chains
- Using IDs that don't exist
- Assuming structure that isn't present in the actual HTML

Please generate new extraction rules with extreme attention to detail. Take your time to think through each selector carefully. The HTML content and screenshot remain the same as provided initially.

**ULTRA THINK:** Analyze the HTML structure methodically, verify each selector component exists, and ensure the extraction rules will successfully capture the requested data.''';
  }
}

/// Extension to convert WebScrapperChatAIResponse to ChatResponse
extension WebScrapperChatAIResponseMapExt on WebScrapperChatAIResponse {
  (
    ChatResponse chatResponse,
    ScrappingBeeExtractLogic? newExtractLogic,
    ScrappableRequest? newRequest,
  )
  toChatResponse({
    required ScrappableRequest scrapperRequest,
    required ReferenceTestData referenceTestData,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required List<String> thinkingSentences,
  }) {
    return switch (this) {
      WebScrapperChatAIResponseJustMessage(:final String message) => (
        MessageTextResponse(
          role: PromptRole.model,
          expectsFollowUp: false, // Final AI message, no follow-up
          messageText: message,
        ),
        null,
        null,
      ),
      WebScrapperChatAIResponseErrorMessage(:final String errorDescription) => (
        ErrorTextResponse(
          role: PromptRole.model,
          expectsFollowUp: false, // AI error, no follow-up
          errorMessage: errorDescription,
        ),
        null,
        null,
      ),
      WebScrapperChatAIResponseOnlyExtractRulesModified(
        :final String resumeActionMessage,
        :final ScrappingBeeFetchSettings fetchSettings,
      ) =>
        () {
          // Create new extract rules from the AI's response
          final ScrappingBeeExtractLogic updatedExtractLogic =
              scrappingBeeExtractLogic?.copyWith(
                extractRules: fetchSettings.extract_rules,
                jsScenario: fetchSettings.js_scenario,
                renderJs: fetchSettings.render_js,
                wait: fetchSettings.wait,
                waitFor: fetchSettings.wait_for,
                waitBrowser: fetchSettings.wait_browser,
                premiumProxy: fetchSettings.premium_proxy,
                stealthProxy: fetchSettings.stealth_proxy,
                countryCode: fetchSettings.country_code,
                sessionId: fetchSettings.session_id,
                customGoogle: fetchSettings.custom_google,
              ) ??
              ScrappingBeeExtractLogic(
                extractRules: fetchSettings.extract_rules,
                jsScenario: fetchSettings.js_scenario,
                renderJs: fetchSettings.render_js,
                wait: fetchSettings.wait,
                waitFor: fetchSettings.wait_for,
                waitBrowser: fetchSettings.wait_browser,
                premiumProxy: fetchSettings.premium_proxy,
                stealthProxy: fetchSettings.stealth_proxy,
                countryCode: fetchSettings.country_code,
                sessionId: fetchSettings.session_id,
                customGoogle: fetchSettings.custom_google,
              );

          return (
            CandidateExtractLogicUpdate(
              thinkingSentences: thinkingSentences,
              role: PromptRole.model,
              expectsFollowUp: true, // Validation will follow
              referenceTestData: referenceTestData,
              messageText: resumeActionMessage,
              scrappingBeeExtractLogic: updatedExtractLogic,
            ),
            updatedExtractLogic,
            null, // No request modification
          );
        }(),
      WebScrapperChatAIResponseOnlyRequestModified(
        :final String resumeActionMessage,
        :final WebScrapperRequest scrappableRequest,
      ) =>
        (
          MessageTextResponse(
            role: PromptRole.model,
            expectsFollowUp: false, // Request modification only, no follow-up
            messageText:
                '$resumeActionMessage\n\n**Note:** The request structure has been modified. The updated queryParams and queryParamsNotRelatedToUrl will be applied.',
          ),
          null, // No extract logic modification
          ScrappableRequest(
            url: scrappableRequest.url,
            queryParams: scrappableRequest.queryParam,
            queryParamsNotRelatedToUrl:
                scrappableRequest.queryParamsNotRelatedToUrl,
            pathParams: scrappableRequest.pathParams,
          ),
        ),
      WebScrapperChatAIResponseBothModified(
        :final String resumeActionMessage,
        :final ScrappingBeeFetchSettings fetchSettings,
        :final WebScrapperRequest scrappableRequest,
      ) =>
        () {
          // Create new extract rules from the AI's response
          final ScrappingBeeExtractLogic updatedExtractLogic =
              scrappingBeeExtractLogic?.copyWith(
                extractRules: fetchSettings.extract_rules,
                jsScenario: fetchSettings.js_scenario,
                renderJs: fetchSettings.render_js,
                wait: fetchSettings.wait,
                waitFor: fetchSettings.wait_for,
                waitBrowser: fetchSettings.wait_browser,
                premiumProxy: fetchSettings.premium_proxy,
                stealthProxy: fetchSettings.stealth_proxy,
                countryCode: fetchSettings.country_code,
                sessionId: fetchSettings.session_id,
                customGoogle: fetchSettings.custom_google,
              ) ??
              ScrappingBeeExtractLogic(
                extractRules: fetchSettings.extract_rules,
                jsScenario: fetchSettings.js_scenario,
                renderJs: fetchSettings.render_js,
                wait: fetchSettings.wait,
                waitFor: fetchSettings.wait_for,
                waitBrowser: fetchSettings.wait_browser,
                premiumProxy: fetchSettings.premium_proxy,
                stealthProxy: fetchSettings.stealth_proxy,
                countryCode: fetchSettings.country_code,
                sessionId: fetchSettings.session_id,
                customGoogle: fetchSettings.custom_google,
              );

          return (
            CandidateExtractLogicUpdate(
              thinkingSentences: thinkingSentences,
              role: PromptRole.model,
              expectsFollowUp: true, // Validation will follow
              referenceTestData: referenceTestData,
              messageText: resumeActionMessage,
              scrappingBeeExtractLogic: updatedExtractLogic,
            ),
            updatedExtractLogic,
            ScrappableRequest(
              url: scrappableRequest.url,
              queryParams: scrappableRequest.queryParam,
              queryParamsNotRelatedToUrl:
                  scrappableRequest.queryParamsNotRelatedToUrl,
              pathParams: scrappableRequest.pathParams,
            ),
          );
        }(),
    };
  }
}
