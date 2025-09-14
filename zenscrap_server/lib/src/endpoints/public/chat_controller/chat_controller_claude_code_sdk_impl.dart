import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RetryText = String;

class ChatControllerClaudeCodeSdkImpl extends IChatController {
  final WebScrapperClaudeImpl controller;
  const ChatControllerClaudeCodeSdkImpl._({required this.controller});

  factory ChatControllerClaudeCodeSdkImpl.startChat({
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    ClaudeModel model = ClaudeModel.claude35Sonnet,
  }) {
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      pathParams: scrapperRequest.pathParams,
      queryParam: scrapperRequest.queryParams,
    );
    final controller = WebScrapperClaudeImpl.startChat(
      initialPayload: InitialPayloadDataCreatingFromZero(
        targetExampleUrl: referenceTestData.referenceLinkUsed,
        webScrapperRequest: webScrapperRequest,
      ),
      model: model,
    );

    return ChatControllerClaudeCodeSdkImpl._(controller: controller);
  }

  @override
  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    try {
      const int maxAttempts = 3;
      int attempt = 0;
      RetryText? retryContent;

      while (attempt < maxAttempts) {
        attempt++;

        session.log('( Claude: starting attempt #$attempt');

        final WebScrapperChatAIResponse response =
            await controller.sendMessage(userPrompt: userPrompt);
        session.log('( Claude: ending attempt #$attempt');

        retryContent = await _handleSendMessage(
          session: session,
          response: response,
          referenceTestData: referenceTestData,
          scrapperRequest: scrapperRequest,
          currentScrappingBeeExtractLogic: scrappingBeeExtractLogic,
          chatSeason: chatSeason,
          attemptNumber: attempt,
        );

        if (retryContent == null) {
          // No retry needed, exit the loop
          return;
        }
      }
    } catch (error, stackTrace) {
      session.log('Error occurred while generating extract rules with Claude',
          exception: error, stackTrace: stackTrace, level: LogLevel.error);
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            '[ FATAL ]\nAn internal error occurred while generating extract rules:\n$error',
      ));
    }
  }

  Future<RetryText?> _handleSendMessage({
    required Session session,
    required WebScrapperChatAIResponse response,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required int attemptNumber,
    required ScrappingBeeExtractLogic? currentScrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    final resp = response.toChatResponse(
      referenceTestData: referenceTestData,
      scrapperRequest: scrapperRequest,
      scrappingBeeExtractLogic: currentScrappingBeeExtractLogic,
    );
    chatSeason.add(resp.$1);
    final scrappingBeeExtractLogic = resp.$2;
    if (scrappingBeeExtractLogic == null) {
      // No new extract logic to test, so no verification/retry needed
      return null;
    }

    chatSeason.add(MessageTextResponse(
      role: PromptRole.system,
      messageText:
          'Great, I will now test the extract rules you created to see if it works in the reference link we are using for testing.\n'
          'Please wait a moment...',
    ));

    // Needs to validate if the rules are working...
    final ExtractFullDataByRule extractResult =
        await scrappingBee.fetchHtmlAndScreenshot(
      targetUrl: referenceTestData.referenceLinkUsed,
      scrappingBeeExtractLogic: scrappingBeeExtractLogic,
    );

    return await extractResult.when(
      withData: (result, html, pageFullscreenScreenshot) async {
        chatSeason.add(MessageTextResponse(
          role: PromptRole.system,
          messageText:
              'New rules were tested and did not present any errors! I\'ll update the test endpoint...',
        ));
        final Uint8List htmlBytes = utf8.encode(html);
        final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
        final ByteData screenshotByteData =
            ByteData.view(pageFullscreenScreenshot.buffer);
        ByteTestData byteTestData = referenceTestData.byteData?.copyWith(
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

        final isNew = referenceTestData.byteDataId == null ||
            referenceTestData.byteData == null ||
            scrappingBeeExtractLogic.id == null;

        if (isNew) {
          await session.db.transaction((transaction) async {
            byteTestData = await ByteTestData.db
                .insertRow(session, byteTestData, transaction: transaction);
            newReferenceTestData = newReferenceTestData.copyWith(
              byteDataId: byteTestData.id,
              byteData: byteTestData,
            );
            await ReferenceTestData.db.attachRow.byteData(
                session, newReferenceTestData, byteTestData,
                transaction: transaction);
            await ReferenceTestData.db.updateRow(session, newReferenceTestData,
                transaction: transaction);
            await ScrappingBeeExtractLogic.db.insertRow(
                session, scrappingBeeExtractLogic,
                transaction: transaction);
          });
        }

        await Future.delayed(const Duration(milliseconds: 800));
        chatSeason.add(NewExtractRuleResponse(
            role: PromptRole.system,
            messageText:
                'New rules were tested and did not present any errors',
            scrapperRequest: scrapperRequest,
            referenceTestData: newReferenceTestData,
            scrappingBeeExtractLogic: scrappingBeeExtractLogic));
        return null;
      },
      error: (String errorMessage) {
        final String attempt =
            attemptNumber > 1 ? '# Attempt $attemptNumber\n' : '';
        chatSeason.add(ErrorTextResponse(
          role: PromptRole.system,
          errorMessage:
              'The extraction rules failed in my quality-assurance test validation. I will ask Claude to fix the selectors and try again.',
        ));
        return '''${attempt}When I tried calling the scrapping bee API with the new extract rule that you just generated, I got the following error from the scrapping bee endpoint:
```log
\n$errorMessage
```

Please try again. Try to deeply understand how the scrapping bee rules creation works, see the documentation in https://www.scrapingbee.com/documentation/data-extraction/#basic-usage if needed.

**CRITICAL ANALYSIS REQUIRED:**
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
      },
    );
  }

  @override
  Future<void> changeModel(AiModel aiModel) async {
    // Claude doesn't support changing models mid-conversation in the same way as Gemini
    // For now, we'll map the Gemini models to appropriate Claude models
    final claudeModel = switch (aiModel) {
      AiModel.gemini_2_5_flash => ClaudeModel.claude35Haiku, // Fast model
      AiModel.gemini_2_5_pro => ClaudeModel.claude35Sonnet,  // Balanced model
    };

    await controller.changeModel(claudeModel);

    // Note: This would require creating a new chat session with Claude
    // The controller.changeModel method should handle this appropriately
  }
}

// Extension to convert WebScrapperChatAIResponse to ChatResponse
extension WebScrapperChatAIResponseMapExt on WebScrapperChatAIResponse {
  (ChatResponse chatResponse, ScrappingBeeExtractLogic? newExtractLogic)
      toChatResponse({
    required ScrappableRequest scrapperRequest,
    required ReferenceTestData referenceTestData,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
  }) {
    return switch (this) {
      WebScrapperChatAIResponseJustMessage(:final String message) => (
          MessageTextResponse(
            role: PromptRole.model,
            messageText: message,
          ),
          null
        ),
      WebScrapperChatAIResponseErrorMessage(:final String errorDescription) => (
          ErrorTextResponse(
            role: PromptRole.model,
            errorMessage: errorDescription,
          ),
          null
        ),
      WebScrapperChatAIResponseWithDataResponse(
        :final String resumeActionMessage,
        :final WebScrapperRequest? request,
        :final ScrappingBeeFetchSettings fetchSettings,
      ) =>
        () {
          final scrappingBeeNewExtractRules =
              scrappingBeeExtractLogic?.copyWith(
                    extractRules: fetchSettings.extract_rules,
                    jsScenario: fetchSettings.js_scenario,
                    renderJs: fetchSettings.render_js,
                    wait: fetchSettings.wait,
                    waitFor: fetchSettings.wait_for,
                    waitBrowser: fetchSettings.wait_browser,
                    premiumProxy: fetchSettings.premium_proxy,
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
                    countryCode: fetchSettings.country_code,
                    sessionId: fetchSettings.session_id,
                    customGoogle: fetchSettings.custom_google,
                  );
          return (
            CandidateExtractLogicUpdate(
              role: PromptRole.model,
              referenceTestData: referenceTestData,
              scrapperRequest: scrapperRequest.copyWith(
                id: scrapperRequest.id,
                url: request?.url,
                pathParams: request?.pathParams,
                queryParams: request?.queryParam,
              ),
              messageText: resumeActionMessage,
              scrappingBeeExtractLogic: scrappingBeeNewExtractRules,
            ),
            scrappingBeeNewExtractRules
          );
        }(),
    };
  }
}