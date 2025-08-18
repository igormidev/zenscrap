// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/extension/uint8list.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatController {
  static late final String _scrapingBeeApiKey;
  static late final Claude _claudeModel;
  static Future<void> initialize(
      {required String claudeApiKey, required String scrapingBeeApiKey}) async {
    ChatController._scrapingBeeApiKey = scrapingBeeApiKey;
    final claude = Claude(claudeApiKey);
    final isClaudeCodeSDKInstalled = await claude.isClaudeCodeSDKInstalled();
    if (isClaudeCodeSDKInstalled) {
      await claude.installClaudeCodeSDK();
    }
    _claudeModel = Claude(claudeApiKey);
  }

  ChatController._({
    required this.chatSession,
    required this.scrappableId,
  });

  final ClaudeChat chatSession;
  final UuidValue scrappableId;

  static ChatController create({
    required UuidValue scrappableId,
    required ReferenceTestData referenceTestData,
  }) {
    final chat = _claudeModel.createNewChat(
      options: ClaudeChatOptions(
        systemPrompt: systemPrompt,
        timeoutMs: 90000,
      ),
    );
    final instance = ChatController._(
      chatSession: chat,
      scrappableId: scrappableId,
    );
    return instance;
  }

  bool _isFirstTime = true;

  Future<void> sendMessage({
    required Session session,
    required String userPromt,
    required,
    required ReferenceTestData referenceTestData,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    const int MAX_ATTEMPTS = 3;
    int attempt = 0;
    RetryContent? retryContent;
    while (attempt < MAX_ATTEMPTS) {
      attempt++;
      List<ClaudeSdkContent>? initialItems;
      if (_isFirstTime && attempt == 1) {
        initialItems = getSystemPrompt(referenceTestData: referenceTestData);
        _isFirstTime = false;
      }
      final String response = await chatSession.sendMessage(
        <ClaudeSdkContent>[
          ...?initialItems,
          if (retryContent != null) retryContent,
          if (retryContent == null)
            ...composeUserPromptIfNeeded(
                referenceTestData: referenceTestData, userPrompt: userPromt)
        ],
      );
      retryContent = await _getChatResponses(
        session: session,
        responseText: response,
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

  Future<RetryContent?> _getChatResponses({
    required Session session,
    required ReferenceTestData testData,
    required int attemptNumber,
    required String responseText,
    required StreamController<ChatResponse> chatSeasonController,
  }) async {
    final String attempt =
        attemptNumber > 1 ? '# Attempt $attemptNumber\n' : '';
    // print(
    //     'Raw AI response:\n$responseText\n--------------------------------------------------');
    session.log(
        'Raw AI response:\n$responseText\n--------------------------------------------------');
    if (responseText.isEmpty) {
      chatSeasonController.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'The AI returned an empty response. We will ask it to try again...',
      ));

      return ClaudeSdkContent.text(
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
      return ClaudeSdkContent.text(
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

      return ClaudeSdkContent.text(
          '${attempt}I encountered an error while trying to map your request. You should return a JSON with "newExtractRules", a "message" or a "errorMessage". Return only raw JSON without anything more (not even markdown notations like "```").');
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
        ScrappableTestResult? testResult = testData.scrappableTestResult;
        if (testResult != null) {
          testResult = await ScrappableTestResult.db.updateRow(
            session,
            testResult.copyWith(
              extractJsonResult: jsonEncode(result),
              testExtractRule: extractedRules,
            ),
          );
        } else {
          testResult = ScrappableTestResult(
            scrappableId: scrappableId,
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

        return ClaudeSdkContent.text(
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

List<ClaudeSdkContent> composeUserPromptIfNeeded({
  required ReferenceTestData referenceTestData,
  required String userPrompt,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  if (neverGeneratedATestResultBefore) {
    return [
      ClaudeSdkContent.text(
          '''I need you to ultra think in the response of the task prompt I will send bellow, so you don't generate a response that is not compliant with ScrapingBee extract rules feature.

CRITICAL: You MUST test your extraction rules immediately after generating them:
1. Generate extraction rules based on my requirements
2. Make an HTTP request to ScrapingBee API with a 4-second wait parameter
3. If the test succeeds (status 200 with extracted data), return the working rules
4. If the test fails, analyze the error message, fix the selectors, and try again
5. Keep iterating until you have PROVEN the rules work with "${referenceTestData.referenceLinkUsed}"

Use the error logs to debug and fix any issues. Common errors to watch for:
- Incorrect CSS selectors or class names
- Elements that don't exist in the HTML
- Typos in selector syntax
- Dynamic content that needs different selectors

Please deeply understand what I need so you can correctly build AND VALIDATE new extraction rules.

My modification/task prompt is:'''),
      ClaudeSdkContent.text(userPrompt),
    ];
  }

  final Uint8List jsonBytes = utf8.encode(
    jsonEncode(referenceTestData.referenceQueryParametersJson),
  );

  return [
    ClaudeSdkContent.text(
        'Hello, I wan\'t to iterate on the last extract rules I built. I will attach it bellow:'),
    ClaudeSdkContent.bytes(data: jsonBytes, fileExtension: 'json'),
    ClaudeSdkContent.text(
        '''It worked well, but I want to change it a little bit...
I wan't you to modify it and create a new rules json, that are compliant with ScrapingBee extract rules feature, that resolves what I will ask in my message that will describe the modifications I wan't.

CRITICAL TESTING REQUIREMENT:
You MUST test your modified extraction rules immediately:
1. Modify the rules based on my requirements
2. Make an HTTP request to ScrapingBee API with the new rules (include 4-second wait)
3. If successful (status 200 with data), return the validated rules
4. If failed, analyze the error, fix the selectors, and retry
5. Iterate until the modified rules are PROVEN to work with "${referenceTestData.referenceLinkUsed}"

Remember to:
- Test EVERY modification before returning it
- Use error messages to debug selector issues
- Verify that modified selectors actually exist in the HTML
- Ensure backwards compatibility (don't break working selectors)

I need you to ultra think in the response and guarantee the modified rules work correctly.

Please deeply understand what I need so you can correctly build AND TEST new extraction rules.

My modification/task prompt is:'''),
    ClaudeSdkContent.text(userPrompt),
  ];
}

List<ClaudeSdkContent> getSystemPrompt({
  required ReferenceTestData referenceTestData,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  final Uint8List imagePng =
      referenceTestData.referenceSiteScreenshot.asUint8List;
  final Uint8List htmlBytes = referenceTestData.referenceHtmlPage.asUint8List;

  return [
    ClaudeSdkContent.text(
        '''I am a saas company that generates scrapping extract rules with ai.
The client of my saas is made in flutter with serverpod as my server. This saas will extract data that my clients need from the web.
My user wan't to extract data with of "${referenceTestData.referenceLinkUsed}" with web scrapping.

I wan't to use "extract rules" feature of ScrapingBee. With this I'll have a deterministic way of scrapping the site.
The overall documentation of ScrapingBee is: "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage", you can web research and read it if needed to understand how it works if needed.

⚠️ CRITICAL: You have Claude Code SDK installed and MUST use it to test extraction rules in real-time.

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
I need you to create that extraction rules (extract_rules) for me AND TEST THEM to ensure they work.

📝 EXAMPLE OF HOW YOU SHOULD TEST THE RULES:
When you generate extraction rules, you MUST test them immediately using Claude Code like this:

```bash
# Example test request you should make
curl -G "https://app.scrapingbee.com/api/v1/" \
  --data-urlencode "api_key=${ChatController._scrapingBeeApiKey}" \
  --data-urlencode "url=${referenceTestData.referenceLinkUsed}" \
  --data-urlencode 'extract_rules={"title":"h1","price":".price"}' \
  --data-urlencode "render_js=true" \
  --data-urlencode "json_response=true" \
  --data-urlencode "wait=4000"
```

Or using a programming language:
```python
import requests
import json
import time

# Wait 4 seconds before making the request (important for rate limiting)
time.sleep(4)

params = {
    'api_key': '${ChatController._scrapingBeeApiKey}',
    'url': '${referenceTestData.referenceLinkUsed}',
    'extract_rules': json.dumps(your_generated_rules),
    'render_js': 'true',
    'json_response': 'true',
    'wait': '4000'
}

response = requests.get('https://app.scrapingbee.com/api/v1/', params=params)
if response.status_code == 200:
    data = response.json()
    extracted = data.get('extract_rules', {})
    print("Success! Extracted data:", extracted)
else:
    print("Error:", response.text)
    # Analyze error and fix selectors
```

⚠️ REMEMBER: Always include a 4-second wait/delay in your requests for the page to fully load!

I am providing you with:
1. The complete HTML content of the reference page (attached as an HTML file)
2. A screenshot of the page (attached as an image file)

Use both the HTML content and the screenshot to understand the page structure and create accurate extraction rules.

IMPORTANT REQUIREMENTS:
1. Analyze the HTML content thoroughly to understand the structure
2. Use the screenshot to understand the visual layout and identify important elements
3. Double check that you are not hallucinating and creating rules to paths that don't exist in the HTML
4. Ultra think in your response and think for a long time about the correct selectors
5. 🔴 MANDATORY: TEST YOUR RULES WITH ACTUAL API CALLS BEFORE RETURNING THEM
   - Make a real HTTP request to ScrapingBee API with your generated rules
   - Wait 4 seconds in your request for the page to fully render
   - If the test fails, analyze the error and try again with corrected selectors
   - NEVER return untested rules - this is a hard requirement
6. Your response should be a valid JSON object with extraction rules
7. Each key should be the name of the data to extract, and the value should be the CSS selector or XPath to extract that data
8. Verify success: The API should return status 200 with extracted data in 'extract_rules' field
9. If you get errors, use them to debug:
   - Check exact class names and IDs from the HTML
   - Verify element hierarchy is correct
   - Try alternative selectors if needed
10. Return only raw JSON, without anything more (not even markdown notations like "```" in the beginning or end... just the raw JSON)

Example response format:
{
  "product_name": "h1.product-title",
  "price": "span.price-now",
  "description": "div.product-description",
  "availability": "span.stock-status"
}

But before the interaction with the user, I'll attach the hmtl of the site and the screenshot as well'''),
    ClaudeSdkContent.text(
        'The html that you should use as base to create the extract rules json:'),
    ClaudeSdkContent.bytes(data: htmlBytes, fileExtension: 'html'),
    ClaudeSdkContent.text(
        'Now, I will attach a print of the site so you can have a better understanding of how it looks:'),
    ClaudeSdkContent.bytes(data: imagePng, fileExtension: 'png'),
    ClaudeSdkContent.text('''🔴 CRITICAL TESTING INSTRUCTIONS - READ CAREFULLY:

You have the capability and REQUIREMENT to test the extraction rules you generate. Here's how you MUST test them:

1. **ScrapingBee API Key**: ${ChatController._scrapingBeeApiKey}

2. **Test URL**: ${referenceTestData.referenceLinkUsed}

3. **HOW TO TEST YOUR RULES**:
   After generating extraction rules, you MUST make an HTTP GET request to test them:

   ```dart
   // Example of the exact request you should make:
   final testUrl = 'https://app.scrapingbee.com/api/v1/';
   final queryParameters = {
     'api_key': '${ChatController._scrapingBeeApiKey}',
     'url': '${referenceTestData.referenceLinkUsed}',
     'extract_rules': jsonEncode(yourGeneratedRules), // Your rules as JSON string
     'render_js': 'true',
     'json_response': 'true',
     'wait': '4000', // IMPORTANT: 4 second delay for page to fully load
   };
   
   // Make the GET request with these parameters
   // The response will contain 'extract_rules' field with the extracted data
   ```

4. **TESTING WORKFLOW**:
   a) Generate your extraction rules based on the HTML and requirements
   b) IMMEDIATELY test them with a real HTTP request (4 second wait is crucial)
   c) If successful (status 200 and data in 'extract_rules' field), present the working rules
   d) If failed, analyze the error message and try again with corrected selectors
   e) Keep iterating until you have PROVEN the rules work

5. **ERROR HANDLING**:
   - If you get a 400/422 error: Your selectors are likely wrong
   - Check the error message in the response for specific issues
   - Common problems: wrong class names, non-existent IDs, incorrect element paths
   - USE THE ERROR FEEDBACK to correct your rules and try again

6. **ULTRA THINK REQUIREMENTS**:
   - Think deeply about each selector before testing
   - When a test fails, carefully analyze WHY it failed
   - Use the actual HTML structure (not assumptions) to build selectors
   - Test edge cases and ensure robustness
   - NEVER give up after one failure - iterate until success

⚠️ MANDATORY: You MUST test every extraction rule you generate. Do not return rules without confirming they work via actual API calls. The user's system depends on these rules working correctly.

🎯 Your success criteria: Only return extraction rules that you have personally tested and confirmed working with the ScrapingBee API.

${neverGeneratedATestResultBefore
        ? 'Now, the user will start sending prompts for the creation of the first extraction rules. You MUST test each rule before presenting it.'
        : 'Now, the user will start sending prompts to modify existing extraction rules. You MUST test all modifications before presenting them.'}'''),
  ];
}

typedef RetryContent = ClaudeSdkContent;
final SchemaObject generateExtractRulesSchema = SchemaObject(
  description:
      'Schema for Gemini AI to generate ScrapingBee extraction rules from HTML content and user requirements. '
      'This schema enforces structured responses for web scraping rule generation, allowing the AI to: '
      '1) Create CSS selectors or XPath expressions that accurately target HTML elements, '
      '2) Provide contextual messages about the rules or ask clarification questions, '
      '3) Report errors when extraction is not possible (e.g., 404 pages, invalid HTML). '
      'The AI analyzes both HTML content and screenshots to identify the correct selectors, '
      'ensuring the extraction rules are valid for ScrapingBee\'s extract_rules API parameter. '
      'The schema supports iterative refinement where users can modify existing rules based on feedback.',
  properties: {
    'message': SchemaProperty.string(
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
    'errorMessage': SchemaProperty.string(
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
    'newExtractRules': SchemaProperty.object(
      nullable: true,
      description:
          '''New extraction rules that are compliant with ScrapingBee extract rules feature.
This is a dynamic map where keys are the data field names to extract (e.g., "title", "price", "description") 
and values are CSS selectors or XPath expressions that target those elements in the HTML.
Example: {"product_name": "h1.title", "price": "span.price-value", "availability": "div.stock-status"}.
If you have any doubts about how to generate the rules, you can web research the ScrapingBee documentation at "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage".
This field should be null when asking clarification questions (only 'message' should be set).''',
      properties: {
        '__example__': SchemaProperty.string(
          nullable: true,
          description:
              'This is just an example property to satisfy the Gemini API schema requirement that objects must have at least one property. '
              'The actual properties will be dynamic based on what data the user wants to extract from the webpage.',
        ),
      },
    ),
  },
);

final String systemPrompt =
    '''You are a web scraping assistant with the ability to test extraction rules in real-time. Your primary task is to generate and validate ScrapingBee extract rules based on the provided HTML content and user requirements.

CRITICAL TESTING REQUIREMENT:
After generating extraction rules, you MUST test them immediately using the ScrapingBee API to ensure they work correctly. This is mandatory - do not skip this step.

Your workflow:
1. Analyze the HTML structure and user requirements
2. Generate accurate extraction rules for ScrapingBee's extract_rules feature
3. TEST the rules immediately using the API (this is non-negotiable)
4. If the test fails, analyze the error and retry with corrected rules
5. Continue iterating until the rules work successfully

You have access to make real HTTP requests to validate your work. Use this capability to guarantee success.''';
