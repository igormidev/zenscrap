import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RetryText = String;

/// Mixin that provides shared functionality for chat controller implementations
mixin ChatControllerHandlerMixin {
  /// Abstract getter for the controller - must be implemented by classes using this mixin
  WebScrapperGeneratorController get controller;

  /// Abstract getter for the provider name - must be implemented by classes using this mixin
  String get providerName;

  /// Common implementation of sendMessage with retry logic
  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
  }) async {
    StreamSubscription<String>? sub;
    try {
      const int maxAttempts = 3;
      int attempt = 0;
      RetryText? retryContent;

      while (attempt < maxAttempts) {
        attempt++;

        session.log('Starting attempt #$attempt');

        final (
          :Stream<String> llmMessage,
          :Future<WebScrapperChatAIResponse> structuredSchemaDataCompleter,
        ) = controller.streamMessage(userPrompt: userPrompt);

        // final WebScrapperChatAIResponse response = await controller.sendMessage(userPrompt: userPrompt);

        // Stream all llm messages to [thinkingStream]
        sub = llmMessage.listen(
          (chunk) => thinkingStream.add(chunk),
          onError: (error, stackTrace) {
            session.log(
                'Error occurred while streaming messages from $providerName',
                exception: error,
                stackTrace: stackTrace,
                level: LogLevel.error);
          },
        );

        final List<String> thinkingSentences = await llmMessage.toList();
        retryContent = await handleSendMessage(
          session: session,
          response: await structuredSchemaDataCompleter,
          referenceTestData: referenceTestData,
          scrapperRequest: scrapperRequest,
          currentScrappingBeeExtractLogic: scrappingBeeExtractLogic,
          chatSeason: chatSeason,
          attemptNumber: attempt,
          thinkingSentences: thinkingSentences,
        );

        if (retryContent == null) {
          await sub.cancel();
          sub = null;
          // No retry needed, exit the loop
          return;
        }
      }
    } catch (error, stackTrace) {
      session.log(
          'Error occurred while generating extract rules with $providerName',
          exception: error,
          stackTrace: stackTrace,
          level: LogLevel.error);
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            '[ FATAL ]\nAn internal error occurred while generating extract rules:\n$error',
      ));
    } finally {
      await sub?.cancel();
    }
  }

  /// Handles the send message response and validates extraction rules
  Future<RetryText?> handleSendMessage({
    required Session session,
    required WebScrapperChatAIResponse response,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required int attemptNumber,
    required ScrappingBeeExtractLogic? currentScrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required List<String> thinkingSentences,
  }) async {
    final resp = response.toChatResponse(
      referenceTestData: referenceTestData,
      scrapperRequest: scrapperRequest,
      scrappingBeeExtractLogic: currentScrappingBeeExtractLogic,
      thinkingSentences: thinkingSentences,
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
            messageText: 'New rules were tested and did not present any errors',
            scrapperRequest: scrapperRequest,
            referenceTestData: newReferenceTestData,
            scrappingBeeExtractLogic: scrappingBeeExtractLogic));
        return null;
      },
      error: (String errorMessage) {
        chatSeason.add(ErrorTextResponse(
          role: PromptRole.system,
          errorMessage:
              'The extraction rules failed in my quality-assurance test validation. I will ask the AI to fix the selectors and try again.',
        ));
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
    final String attempt =
        attemptNumber > 1 ? '# Attempt $attemptNumber\n' : '';

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
  (ChatResponse chatResponse, ScrappingBeeExtractLogic? newExtractLogic)
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
              scrapperRequest: scrapperRequest.copyWith(
                id: scrapperRequest.id,
                url: request?.url,
                pathParams: request?.pathParams,
                queryParams: request?.queryParam,
              ),
              thinkingSentences: thinkingSentences,
              role: PromptRole.model,
              referenceTestData: referenceTestData,
              messageText: resumeActionMessage,
              scrappingBeeExtractLogic: scrappingBeeNewExtractRules,
            ),
            scrappingBeeNewExtractRules
          );
        }(),
    };
  }
}
