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
  static ChatController create() {
    final instance = ChatController._();
    instance.chatSession = _geminiModel.startChat();
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
            composeUserPrompt(
              referenceTestData: referenceTestData,
              userPrompt: userPromt,
            ),
      );
      retryContent = await getChatResponses(
        session: session,
        generatedContent: response,
        testData: referenceTestData,
        chatSeasonController: chatSeason,
        attemptNumber: attempt,
      );
      final bool hasARetryPrompt = retryContent != null;
      if (hasARetryPrompt) continue;

      return;
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

Content composeUserPrompt({
  required ReferenceTestData referenceTestData,
  required String userPrompt,
}) {
  final bool neverGeneratedATestResultBefore =
      referenceTestData.scrappableTestResult == null;

  final Uint8List imagePng =
      referenceTestData.referenceSiteScreenshot.asUint8List;
  final Uint8List htmlBytes = referenceTestData.referenceHtmlPage.asUint8List;
  final Uint8List jsonBytes = utf8.encode(
    jsonEncode(referenceTestData.referenceQueryParametersJson),
  );

  return Content.multi([
    TextPart(
        '''I am a saas company that generates scrapping extract rules with ai.
My user wan't to extract data with of "${referenceTestData.referenceLinkUsed}" with web scrapping.

I wan't to use "extract rules" feature of ScrapingBee.
The overall documentation of ScrapingBee is: "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage", you can web research and read it if needed to understand how it works if needed.

Also using scrapping bee, I extracted the html that will be attached in the next message'''),
    DataPart('text/html', htmlBytes),
    TextPart(
        'Also, I will attach a print of the site so you can have a better understanding of how it looks:'),
    DataPart('image/png', imagePng),
    if (neverGeneratedATestResultBefore)
      ...[
    ] else ...[
      TextPart(
          'And with that html and using the site as referencce, she successfully generated the following extraction rules:'),
    ],
    DataPart('application/json', jsonBytes),
    TextPart(
        '''It worked well, my user want's to change it a little bit, so you should to create new rules that are compliant with ScrapingBee extract rules feature (as I said above, web research the documentation if needed).
I need you to allways ultra think in the response so you don't generate a response that is not compliant with ScrapingBee extract rules feature and that will return me a error.

The next messages with be made by the role 'user' with a prompt asking for modifications, please deeply understand what the user needs and so you can correctly build new extraction rules.
'''),
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
        'I encountered an error while trying to map your request. You should return a json with "newExtractRules", a "message" or a "errorMessage"');
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
          '''When I tried calling the scrapping bee API with the new extract rule that you just generated, I got the following error from the scrapping bee endpoint:
```log
\n$errorMessage
```

Please try again. Try to deeply understand how the scrapping bee rules creation works, see the documentation in https://www.scrapingbee.com/documentation/data-extraction/#basic-usage if needed.
Then, analyse the log and ultra think in a new extract rule file''');
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
