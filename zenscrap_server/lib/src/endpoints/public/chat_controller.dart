// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:zenscrap_server/server.dart';
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

  Future<List<ChatResponse>> sendMessage({
    required String userPromt,
    required Scrappable scrappable,
  }) async {
    final referenceTestData = scrappable.referenceTestData;
    if (referenceTestData == null) {
      throw ZenScrapException(
        title: 'Reference Test Data Not Found',
        description:
            'No reference test data found for scrappable ${scrappable.id}.',
      );
    }

    final List<ChatResponse> chatResponse = [];

    const int MAX_ATTEMPTS = 3;

    for (int attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
      final GenerateContentResponse response = await chatSession.sendMessage(
        Content.text(userPromt),
      );
      chatResponse.addAll(await getChatResponses(
        generatedContent: response,
        testData: referenceTestData,
      ));

      final ChatResponse lastChat = chatResponse.last;
      final PromptRole role = lastChat.role;
      bool shouldContinue = false;
      if (role == PromptRole.system) {
        if (lastChat is! NewExtractRuleResponse) {
          shouldContinue = true;
        }
      }
      if (shouldContinue) {
        continue;
      }

      return chatResponse;
    }

    chatResponse.add(
      ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'Exceeded maximum attempts to generate extract rules. The AI is not collaborating at all...\nThe AI is generating extract rules that do not work or not even generating extract rules at all...',
      ),
    );
    return chatResponse;
  }
}

Future<List<ChatResponse>> getChatResponses({
  required ReferenceTestData testData,
  required GenerateContentResponse generatedContent,
}) async {
  final List<ChatResponse> response = [];

  Map<String, dynamic> parsedResponse;
  try {
    final String? responseText = generatedContent.text;
    if (responseText == null || responseText.isEmpty) {
      return [
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage:
              'You returned empty response. Please think harder and try again. Do not return a empty response.',
        ),
      ];
    }
    parsedResponse = json.decode(responseText);
  } catch (error) {
    return [
      ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'Failed to parse AI response as JSON:\n$error.\nUltra think in the reason for the error and try again.',
      ),
    ];
  }

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
    return [
      ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            'I encountered an error while processing your request. You should return a json with "newExtractRules", a "message" or a "errorMessage"',
      ),
    ];
  }

  response.add(newState);

  if (newState is! MessageTextAndNewExtractRulesResponse) {
    return response;
  }

  final extractedRules = newState.newExtractRules;
  response.add(MessageTextResponse(
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

  extractResult.when(
    withData: (result) {
      response.add(NewExtractRuleResponse(
        role: PromptRole.system,
        messageText: 'New rules where tested and did not present any errors',
        referenceTestData: testData.copyWith(
          scrappableTestResult: ScrappableTestResult(
            extractJsonResult: jsonEncode(result),
            testExtractRule: extractedRules,
          ),
        ),
      ));
    },
    error: (String errorMessage) {
      response.add(
        ErrorTextResponse(
            role: PromptRole.system,
            errorMessage:
                '''When I tried calling the scrapping bee API with the new extract rule that you just generated, I got the following error from the scrapping bee endpoint:
```log
\n$errorMessage
```

Please try again. Try to deeply understand how the scrapping bee rules creation works, see the documentation in https://www.scrapingbee.com/documentation/data-extraction/#basic-usage if needed.
Then, analyse the log and ultra think in a new extract rule file'''),
      );
    },
  );

  return response;
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
