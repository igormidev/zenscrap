// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/extension/uint8list.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/core/scrapping_bee_extract_rule_context.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerGeminiApiImpl extends IChatController {
  static late final GenerativeModel _geminiModel_2_5_flash;
  static late final GenerativeModel _geminiModel_2_5_pro;
  static void initialize({required String geminiApiKey}) {
    final genConfig =
        GenerationConfig(responseSchema: generateExtractRulesSchema);
    _geminiModel_2_5_flash = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: geminiApiKey,
      generationConfig: genConfig,
    );
    _geminiModel_2_5_pro = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: geminiApiKey,
      generationConfig: genConfig,
    );
  }

  ChatControllerGeminiApiImpl._({
    required this.chatSession,
    required this.scrappableId,
  });

  final ChatSession chatSession;
  final int scrappableId;
  factory ChatControllerGeminiApiImpl.create({
    required int scrappableId,
    required ReferenceTestData referenceTestData,
    required AiModel aiModel,
  }) {
    final chat = (switch (aiModel) {
      AiModel.gemini_2_5_flash => _geminiModel_2_5_flash,
      AiModel.gemini_2_5_pro => _geminiModel_2_5_pro,
    })
        .startChat(
      history: [getSystemPrompt(referenceTestData: referenceTestData)],
      generationConfig: GenerationConfig(
        responseSchema: generateExtractRulesSchema,
      ),
    );
    final instance = ChatControllerGeminiApiImpl._(
      chatSession: chat,
      scrappableId: scrappableId,
    );
    return instance;
  }

  @override
  Future<void> sendMessage({
    required Session session,
    required String userPromt,
    required,
    required ReferenceTestData referenceTestData,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    try {
      const int MAX_ATTEMPTS = 3;
      int attempt = 0;
      RetryContent? retryContent;
      while (attempt < MAX_ATTEMPTS) {
        attempt++;
        final GenerateContentResponse response = await chatSession.sendMessage(
          retryContent ??
              composeUserPromptIfNeeded(
                  referenceTestData: referenceTestData, userPrompt: userPromt),
        );
        retryContent = await _getChatResponses(
          session: session,
          generatedContent: response,
          testData: referenceTestData,
          chatSeasonController: chatSeason,
          attemptNumber: attempt,
        );
        if (retryContent == null) {
          // No retry needed.
          return;
        }
      }

      chatSeason.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage:
              'Exceeded maximum attempts to generate extract rules. The AI is not collaborating at all...\nThe AI is generating extract rules that do not work or not even generating extract rules at all...',
        ),
      );
    } catch (error, stackTrace) {
      session.log('Error occurred while generating extract rules',
          exception: error, stackTrace: stackTrace, level: LogLevel.error);
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            '[ FATAL ]\nAn internal error occurred while generating extract rules:\n$error',
      ));
    }
  }

  Future<RetryContent?> _getChatResponses({
    required Session session,
    required ReferenceTestData testData,
    required int attemptNumber,
    required GenerateContentResponse generatedContent,
    required StreamController<ChatResponse> chatSeasonController,
  }) async {
    final String attempt =
        attemptNumber > 1 ? '# Attempt $attemptNumber\n' : '';

    String? responseText = generatedContent.text;

    if (responseText == null || responseText.isEmpty) {
      chatSeasonController.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'The AI returned an empty response. We will ask it to try again...',
      ));

      return Content.text(
          '${attempt}You returned a empty response. Please think harder and try again. Do not return a empty response.');
    }

    // Clean up the response in case the AI wrapped it in markdown code blocks
    responseText = responseText.trim();
    if (responseText.startsWith('```json')) {
      responseText = responseText.substring(7); // Remove ```json
    } else if (responseText.startsWith('```')) {
      responseText = responseText.substring(3); // Remove ```
    }
    if (responseText.endsWith('```')) {
      responseText = responseText.substring(
          0, responseText.length - 3); // Remove trailing ```
    }
    responseText = responseText.trim();

    Map<String, dynamic> parsedResponse;
    try {
      parsedResponse = json.decode(responseText);
    } catch (error) {
      chatSeasonController.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'The ai returned a response that could not be parsed to a valid JSON object. We will ask it to try again...',
      ));
      return Content.text(
          '${attempt}Failed to parse AI response as JSON. I called json.decode() in my dart code and received the following error:\n$error.\nUltra think in the reason for the error and try again. Return only raw JSON without anything more (not even markdown notations like "```" in the beginning or end).');
    }

    final String? message = parsedResponse['message'] as String?;
    final String? errorMessage = parsedResponse['errorMessage'] as String?;
    Map<String, dynamic>? newExtractRules =
        parsedResponse['newExtractRules'] as Map<String, dynamic>?;

    // Remove the __example__ key if present (it's just for schema validation)
    if (newExtractRules != null) {
      newExtractRules = Map<String, dynamic>.from(newExtractRules);
      newExtractRules.remove('__example__');
    }

    ChatResponse? newState;

    if (message != null && newExtractRules != null) {
      newState = MessageTextAndNewExtractRulesResponse(
        role: PromptRole.model,
        messageText: message,
        newExtractRules: jsonEncode(newExtractRules),
      );
    }
    if (message != null && newExtractRules == null) {
      newState = MessageTextResponse(
        role: PromptRole.model,
        messageText: message,
      );
    }
    if (errorMessage != null) {
      newState = ErrorTextResponse(
        role: PromptRole.model,
        errorMessage: errorMessage,
      );
    }

    if (newState == null) {
      chatSeasonController.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage:
              'The AI returned a response that does not match the expected schema, so we cannot process it. We will ask it to try again...',
        ),
      );

      return Content.text(
          '${attempt}Your response didn\'t match the required format. You must use ONE of these three patterns:\n'
          '1) {"message": "...", "newExtractRules": {...}} - for providing extraction rules\n'
          '2) {"message": "..."} - for questions or information\n'
          '3) {"errorMessage": "..."} - for errors\n'
          'Return only raw JSON without markdown notations.');
    } else {
      chatSeasonController.add(newState);
    }

    if (newState is! MessageTextAndNewExtractRulesResponse) {
      return null;
    }

    final extractedRules = newState.newExtractRules;

    Future.delayed(const Duration(milliseconds: 700), () {
      chatSeasonController.add(MessageTextResponse(
        role: PromptRole.system,
        messageText:
            'Great, I will now test the extract rules you created to se if it works in the reference link we are using for testing.\n'
            'Please wait a moment...',
      ));
    });

    // Needs to validate if the rules are working...
    final ExtractDataByRule extractResult = await scrapingBee.extractByRules(
      targetUrl: testData.referenceLinkUsed,
      extractRules: extractedRules,
    );

    return extractResult.when(
      withData: (result) async {
        chatSeasonController.add(MessageTextResponse(
          role: PromptRole.system,
          messageText:
              'New rules where tested and did not present any errors! I\'ll update the test endpoint...',
        ));
        await Future.delayed(const Duration(milliseconds: 400));
        ScrappableTestResult? testResult = testData.scrappableTestResult;
        if (testResult == null) {
          testResult = await ScrappableTestResult.db.insertRow(
            session,
            ScrappableTestResult(
              scrappableId: scrappableId,
              extractJsonResult: jsonEncode(result),
              testExtractRule: extractedRules,
              referenceTestDataId: testData.id!,
              referenceTestData: testData,
            ),
          );

          await ScrappableTestResult.db.attachRow
              .referenceTestData(session, testResult, testData);
        } else {
          testResult = testResult.copyWith(
            extractJsonResult: jsonEncode(result),
            testExtractRule: extractedRules,
          );
        }
        chatSeasonController.add(NewExtractRuleResponse(
          role: PromptRole.system,
          messageText: 'New rules where tested and did not present any errors',
          referenceTestData: testData.copyWith(
            scrappableTestResult: testResult,
          ),
        ));

        return null;
      },
      error: (String errorMessage) {
        chatSeasonController.add(
          ErrorTextResponse(
            role: PromptRole.system,
            errorMessage:
                'The extraction rules failed in my quality-assurance test validation. I will ask the AI to fix the selectors and try again.',
          ),
        );

        return Content.text(
            '''${attempt}When I tried calling the scrapping bee API with the new extract rule that you just generated, I got the following error from the scrapping bee endpoint:
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

**ULTRA THINK:** Analyze the HTML structure methodically, verify each selector component exists, and ensure the extraction rules will successfully capture the requested data.''');
      },
    );
  }
}

Content composeUserPromptIfNeeded({
  required ReferenceTestData referenceTestData,
  required String userPrompt,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  if (neverGeneratedATestResultBefore) {
    return Content.multi([
      TextPart('''I need you to create extraction rules based on my request.

**RESPONSE FORMAT - Use ONE of these three patterns:**
1) Success with rules: {"message": "Description of what was created", "newExtractRules": {...}}
2) Question/Information: {"message": "Your question or information"}
3) Error: {"errorMessage": "What went wrong"}

When providing extraction rules, ALWAYS include a message describing what you created.

My task prompt is:'''),
      TextPart(userPrompt),
    ]);
  }

  // Get the JSON string and try to format it nicely
  final String rawJson =
      referenceTestData.scrappableTestResult!.testExtractRule;
  String existingRulesJson;

  try {
    // Try to parse and pretty-print the JSON
    final Map<String, dynamic> jsonMap = json.decode(rawJson);
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    existingRulesJson = encoder.convert(jsonMap);
  } catch (_) {
    // If parsing fails, use the raw JSON string
    existingRulesJson = rawJson;
  }

  return Content.multi([
    TextPart(
        'I wan\'t to iterate on the last extract rules I built. Here are the current rules:'),
    TextPart('```json\n$existingRulesJson\n```'),
    TextPart('''It worked well, but I want to modify it.

**RESPONSE FORMAT - Use ONE of these three patterns:**
1) Updated rules: {"message": "Description of changes", "newExtractRules": {...}}
2) Question/Info: {"message": "Your question or information"}
3) Error: {"errorMessage": "What went wrong"}

When providing updated extraction rules, ALWAYS include a message describing your changes.

My modification request is:'''),
    TextPart(userPrompt),
  ]);
}

Content getSystemPrompt({
  required ReferenceTestData referenceTestData,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  final Uint8List imagePng =
      referenceTestData.byteData!.referenceSiteScreenshot.asUint8List;
  final Uint8List htmlBytes =
      referenceTestData.byteData!.referenceHtmlPage.asUint8List;

  return Content('user', [
    TextPart(
        '''I am a saas company that generates scrapping extract rules with ai.
The client of my saas is made in flutter with serverpod as my server. This saas will extract data that my clients need from the web.
My user wan't to extract data with of "${referenceTestData.referenceLinkUsed}" with web scrapping.

I wan't to use "extract rules" feature of ScrapingBee. With this I'll have a deterministic way of scrapping the site.
The overall documentation of ScrapingBee is: "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage", you can web research and read it if needed to understand how it works if needed.

I will expose an api where my users can send requests to get data from that site with the extracted rules you built.
My ideia is to make a request in my serverpod server similar to this one:
```dart
/// Example of a extract rule - that you will generate
final extractionRules = {
  "coach_name": "h1.data-header__headline-wrapper",
  "current_club_name": ".data-header__club a",
};
  
/// Example of a request
final uri = Uri.parse('https://app.scrapingbee.com/api/v1/').replace(
  queryParameters: {
    'api_key': apiKey,
    'url': targetUrl,
    'extract_rules': jsonEncode(extractionRules),
  },
);
```

But of course, instead of that mocked extraction rules of the example I will use rules that will in fact get the data the user asked for in the prompt.
I need you to create that extraction rules (extract_rules) for me.

I am providing you with:
1. The complete HTML content of the reference page (attached as an HTML file)
2. A screenshot of the page (attached as an image file)

Use both the HTML content and the screenshot to understand the page structure and create accurate extraction rules.

IMPORTANT REQUIREMENTS:
1. Analyze the HTML content thoroughly to understand the structure
2. Use the screenshot to understand the visual layout and identify important elements
3. Double check that you are not hallucinating and creating rules to paths that don't exist in the HTML
4. Ultra think in your response and think for a long time about the correct selectors
5. Your response should be a valid JSON object with extraction rules
6. Each key should be the name of the data to extract, and the value should be the CSS selector or XPath to extract that data
7. Test your selectors mentally against the provided HTML to ensure they match elements
8. Return only raw JSON, without markdown notations
9. Use ONE of three valid response patterns:
   - Success: {"message": "...", "newExtractRules": {...}}
   - Question/Info: {"message": "..."}
   - Error: {"errorMessage": "..."}

Example success response:
{
  "message": "Created extraction rules for product details",
  "newExtractRules": {
    "product_name": "h1.product-title",
    "price": "span.price-now"
  }
}

But before the interaction with the user, I'll attach the hmtl of the site and the screenshot as well'''),
    TextPart(
        'The html that you should use as base to create the extract rules json:'),
    DataPart('text/html', htmlBytes),
    TextPart(
        'Now, I will attach a print of the site so you can have a better understanding of how it looks:'),
    DataPart('image/png', imagePng),
    TextPart(
        'I will attach a md file of how to create the extract rules as well:'),
    DataPart('text/markdown', utf8.encode(scrappingBeeExtractRuleContext)),
    TextPart(neverGeneratedATestResultBefore
        ? '''The user will now send prompts for creating extraction rules.

**VALID RESPONSE PATTERNS:**
1) {"message": "Created...", "newExtractRules": {...}} - when providing rules
2) {"message": "Question..."} - when asking for clarification
3) {"errorMessage": "Error..."} - when something goes wrong

Ultra think before responding.'''
        : '''The user will now send prompts to modify extraction rules.

**VALID RESPONSE PATTERNS:**
1) {"message": "Updated...", "newExtractRules": {...}} - when modifying rules
2) {"message": "Question..."} - when needing clarification
3) {"errorMessage": "Error..."} - when something fails

Ultra think before responding.'''),
  ]);
}

typedef RetryContent = Content;
final Schema generateExtractRulesSchema = Schema(
  SchemaType.object,
  description:
      'Schema for Gemini AI responses. There are exactly THREE valid response patterns:\n'
      '1) SUCCESS: Both "message" AND "newExtractRules" (describing what was created/modified and the extraction rules)\n'
      '2) QUESTION/INFO: Only "message" (for clarification questions or information)\n'
      '3) ERROR: Only "errorMessage" (when something went wrong)\n\n'
      'NEVER mix these patterns. For example:\n'
      '- If providing newExtractRules, MUST include message\n'
      '- If providing errorMessage, MUST NOT include message or newExtractRules\n'
      '- If asking a question, only include message (no newExtractRules or errorMessage)',
  nullable: false,
  properties: {
    'message': Schema(
      SchemaType.string,
      nullable: true,
      description: '''Message from the AI assistant. Used in two scenarios:

1. WITH newExtractRules (REQUIRED): Describe what extraction rules were created/modified
   Example: "Created extraction rules for coach name, club, and image"

2. ALONE (for questions/info): Ask clarification or provide information
   Example: "I found two locations for this data, which one should I extract?"

MUST be null if errorMessage is present.
MUST be present if newExtractRules is present.''',
    ),
    'errorMessage': Schema(
      SchemaType.string,
      nullable: true,
      description: '''Error message when unable to complete the task.

Examples:
- 404 page detected
- Invalid user input
- Technical limitation

IMPORTANT: When errorMessage is present, both "message" and "newExtractRules" MUST be null.
This creates an exclusive error state.''',
    ),
    'newExtractRules': Schema(
      SchemaType.object,
      nullable: true,
      description: '''ScrapingBee-compliant extraction rules.

Keys: field names to extract (e.g., "title", "price")
Values: CSS selectors or XPath expressions

REQUIRES: When present, "message" MUST also be present to describe the rules.
MUST be null when errorMessage is present or when only providing information/questions.''',
      properties: {
        '__example__': Schema(
          SchemaType.string,
          nullable: true,
          description:
              'This is just an example property to satisfy the Gemini API schema requirement that objects must have at least one property. '
              'The actual properties will be dynamic based on what data the user wants to extract from the webpage.',
        ),
      },
    ),
  },
);
