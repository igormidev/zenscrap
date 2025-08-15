// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/extension/uint8list.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatController {
  static late final GenerativeModel _geminiModel;
  static void initialize({required String geminiApiKey}) {
    _geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseSchema: generateExtractRulesSchema,
      ),
    );
  }

  ChatController._();

  late final ChatSession chatSession;
  static ChatController create(ReferenceTestData referenceTestData) {
    final instance = ChatController._();
    instance.chatSession = _geminiModel.startChat(
      history: [
        getSystemPrompt(referenceTestData: referenceTestData),
      ],
    );
    return instance;
  }

  Future<void> sendMessage({
    required Session session,
    required String userPromt,
    required ReferenceTestData referenceTestData,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    const int MAX_ATTEMPTS = 3;
    int attempt = 0;
    RetryContent? retryContent;

    while (attempt >= MAX_ATTEMPTS) {
      attempt++;
      final GenerateContentResponse response = await chatSession.sendMessage(
        retryContent ??
            composeUserPromptIfNeeded(
                referenceTestData: referenceTestData, userPrompt: userPromt),
      );
      retryContent = await getChatResponses(
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
      TextPart(
          '''I need you to ultra think in the response of the task prompt I will send bellow, so you don't generate a response that is not compliant with ScrapingBee extract rules feature so it will not return a error the tests I will do later with the link "${referenceTestData.referenceLinkUsed}"...
Please deeply understand what I need so you can correctly build new extraction rules.

My modification/task prompt is:'''),
      TextPart(userPrompt),
    ]);
  }

  final Uint8List jsonBytes = utf8.encode(
    jsonEncode(referenceTestData.referenceQueryParametersJson),
  );

  return Content.multi([
    TextPart(
        'Hello, I wan\'t to iterate on the last extract rules I built. I will attach it bellow:'),
    DataPart('application/json', jsonBytes),
    TextPart('''It worked well, but I want to change it a little bit...
I wan't you to modify it and create a new rules json, that are compliant with ScrapingBee extract rules feature, that resolves what I will ask in my message that will describe the modifications I wan't.

I need you to ultra think in the response so you don't generate a response that is not compliant with ScrapingBee extract rules feature so it will not return a error the tests I will do later with the link "${referenceTestData.referenceLinkUsed}"...

Please deeply understand what I need so you can correctly build new extraction rules.

My modification/task prompt is:'''),
    TextPart(userPrompt),
  ]);
}

Content getSystemPrompt({
  required ReferenceTestData referenceTestData,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  final Uint8List imagePng =
      referenceTestData.referenceSiteScreenshot.asUint8List;
  final Uint8List htmlBytes = referenceTestData.referenceHtmlPage.asUint8List;

  return Content('system', [
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
  'title': 'h1',
  'price': '.price',
  'description': 'p.description'
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

Example response format:
{
  "product_name": "h1.product-title",
  "price": "span.price-now",
  "description": "div.product-description",
  "availability": "span.stock-status"
}

But before the interaction with the user, I'll attach the hmtl of the site and the screenshot as well'''),
    TextPart(
        'The html that you should use as base to create the extract rules json:'),
    DataPart('text/html', htmlBytes),
    TextPart(
        'Now, I will attach a print of the site so you can have a better understanding of how it looks:'),
    DataPart('image/png', imagePng),
    TextPart(neverGeneratedATestResultBefore
        ? 'Now, the user will start sending prompts to you for the creation of the first extraction rules and probably he will send more prompts for you to iterate on top of those rules to add more data, fix something, etc... Ultra think in each of your responses.'
        : 'Now, the user will start sending prompts to you to modify a current extraction rule that he created in a previous AI talking session, you will need to iterate on top of those rules... Ultra think in each of your responses.'),
  ]);
}

typedef RetryContent = Content;
Future<RetryContent?> getChatResponses({
  required Session session,
  required ReferenceTestData testData,
  required int attemptNumber,
  required GenerateContentResponse generatedContent,
  required StreamController<ChatResponse> chatSeasonController,
}) async {
  final String attempt = attemptNumber > 1 ? '# Attempt $attemptNumber\n' : '';

  final String? responseText = generatedContent.text;
  if (responseText == null || responseText.isEmpty) {
    chatSeasonController.add(ErrorTextResponse(
      role: PromptRole.system,
      errorMessage:
          'The AI returned an empty response. We will ask it to try again...',
    ));

    return Content.text(
        '${attempt}You returned a empty response. Please think harder and try again. Do not return a empty response.');
  }

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
        '${attempt}Failed to parse AI response as JSON. I called json.decode() in my dart code and received the following error:\n$error.\nUltra think in the reason for the error and try again, ensure you just return a json without anything more.');
  }

  // ignore: avoid_print
  print(
    'parsedResponse:\n\n${JsonEncoder.withIndent('  ').convert(parsedResponse)}\n--------------------------------------------------',
  );

  final String? message = parsedResponse['message'] as String?;
  final String? errorMessage = parsedResponse['errorMessage'] as String?;
  final Map<String, dynamic>? newExtractRules =
      parsedResponse['newExtractRules'] as Map<String, dynamic>?;

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
        '${attempt}I encountered an error while trying to map your request. You should return a json with "newExtractRules", a "message" or a "errorMessage"');
  } else {
    chatSeasonController.add(newState);
  }

  if (newState is! MessageTextAndNewExtractRulesResponse) {
    return null;
  }

  final extractedRules = newState.newExtractRules;
  chatSeasonController.add(MessageTextResponse(
    role: PromptRole.system,
    messageText:
        'Great, I will now test the extract rules you created to se if it works in the reference link we are using for testing.\n'
        'Please wait a moment...',
  ));

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
      final newTestData = testData.copyWith(
        scrappableTestResult: ScrappableTestResult(
          extractJsonResult: jsonEncode(result),
          testExtractRule: extractedRules,
        ),
      );
      await ReferenceTestData.db.updateRow(
        session,
        newTestData,
      );
      chatSeasonController.add(NewExtractRuleResponse(
        role: PromptRole.system,
        messageText: 'New rules where tested and did not present any errors',
        referenceTestData: newTestData,
      ));

      return null;
    },
    error: (String errorMessage) {
      chatSeasonController.add(
        ErrorTextResponse(role: PromptRole.system, errorMessage: ''),
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

final Schema generateExtractRulesSchema = Schema(
  SchemaType.object,
  nullable: false,
  properties: {
    'message': Schema(
      SchemaType.string,
      nullable: true,
      description:
          '''Message from the AI assistant for better context for what was done.
This could be a quick short resume of what was done to generate the extraction rules or even a question for clarification (in case of questions, send the "newExtractRulesnewExtractRules" as null).

Better understanding of a question:
You can ask, for example, a question like: "I found two information about <something>, one in the the user header and the other in the footer, which one do you want to extract?".
In that case you are making a question, the "newExtractRulesnewExtractRules" field of the schema will be null (the "errorMessage" as well).
After the question, the user will give his response and you can then continue to process a extract rule.

This should be null if there is a errorMessage''',
    ),
    'errorMessage': Schema(
      SchemaType.string,
      nullable: true,
      description:
          '''Error message if there was an error during the generation process to get extract rules.
In the error message please explain what happened any why you where not able to complete the task.

Example things that could cause error:
- Example 1: The html is of a 404 page, you can respond with a message indicating that the page was not found.
- Example 2: The user provided invalid input, you can respond with a message asking them to correct it.
- Example 3: It is a bug that you as an AI can not solve, you can respond with a message why you cant fix it. Examples of this case:
  - Example 3.1:
      The bug is on the scrapping bee endpoint since its error log is indicating that the route is not available or something like that.
      But note, if the error is with invalid rules you should respond with a new extract rules that should solve the problem and not a error message.
      
In any case that the errorMessage exists, the "newExtractRulesnewExtractRules" and "message" fields should be null.

This field should be null if there is no error.''',
    ),
    'newExtractRules': Schema(
      SchemaType.object,
      description:
          '''New extraction rules that are compliant with ScrapingBee extract rules feature.
If you have any doubts about how to generate the rules, you can web research the ScrapingBee documentation at "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage".''',
    ),
  },
);
