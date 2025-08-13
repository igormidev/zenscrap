import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rxdart/subjects.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef RedraftSrappableSessionId = String;
final Map<RedraftSrappableSessionId, ReplaySubject<ZenScrapRedraftState>>
    scrapRedraftSessions = {};

class ScrappableSessionEndpoint extends Endpoint {
  final Uuid uuid = Uuid();

  Stream<ZenScrapRedraftState> listenToScrappableRedraftSession(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
  }) {
    final subject = scrapRedraftSessions[sessionUuid];
    if (subject == null) {
      throw ZenScrapException(
        title: 'Session Not Found',
        description: 'No active session found for uuid $sessionUuid.',
      );
    }
    return subject.stream;
  }

  Future<void> sendRedraftPrompt(
    Session session, {
    required RedraftSrappableSessionId sessionUuid,
    required String prompt,
  }) async {
    scrapRedraftSessions[sessionUuid]?.add(
      MessageTextResponse(
        role: PromptRole.user,
        messageText: prompt,
      ),
    );
  }

  Future<void> createPrompt(
    Session session, {
    required Scrappable scrappable,
  }) async {
    final RedraftSrappableSessionId sessionUuid = uuid.v4();
    scrapRedraftSessions[sessionUuid] = ReplaySubject<ZenScrapRedraftState>();
  }

  Future<void> _processRedraftCurrentState({
    required RedraftSrappableSessionId sessionUuid,
    required Scrappable scrappable,
    required ReferenceTestData testData,
  }) async {
    final allEmittedEvents = scrapRedraftSessions[sessionUuid]?.values;
    if (allEmittedEvents == null) return;

    final initialContent = getCommandPrompt(
      testData: testData,
      requestStructure: scrappable.targetRequest!,
    );

    final List<Content> allPreviousContents =
        allEmittedEvents.map((event) => event.toContent).toList();
  }

  Future<void> makeAiCal({
    required Session session,
    required RedraftSrappableSessionId sessionId,
    required List<Content> contents,
  }) async {
    final String? geminiApiKey = session.passwords['geminiApiKey'];
    if (geminiApiKey == null) {
      throw ZenScrapException(
        title: 'Gemini API Key Not Found',
        description: 'Please configure the Gemini API key in the serverpod.',
      );
    }

    final geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseSchema: Schema(
          SchemaType.object,
          properties: {
            'message': Schema(
              SchemaType.string,
              nullable: true,
              description:
                  '''Message from the AI assistant for better context for what was done.
This could be a quick short resume of what was done to generate the extraction rules or even a question for clarification (in case of questions, send the newExtractedRules as null).

Better understanding of a question:
You can ask, for example, a question like: "I found two information about <something>, one in the the user header and the other in the footer, which one do you want to extract?".
In that case you are making a question, the "newExtractRules" field of the schema will be null (the "errorMessage" as well).
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

In any case that the errorMessage exists, the "newExtractRules" and "message" fields should be null.

This field should be null if there is no error.''',
            ),
            'newExtractRules': Schema(
              SchemaType.object,
              description:
                  '''New extraction rules that are compliant with ScrapingBee extract rules feature.
If you have any doubts about how to generate the rules, you can web research the ScrapingBee documentation at "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage".''',
            ),
          },
        ),
      ),
    );

    final chat = geminiModel.generateContentStream(contents);
    final StringBuffer responseBuffer = StringBuffer();
    await for (final GenerateContentResponse response in chat) {
      if (response.text != null) {
        responseBuffer.write(response.text);
      }
    }

    final String responseText = responseBuffer.toString();
    if (responseText.isEmpty) {
      scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage: 'Error. Gemini returned empty response.',
        ),
      );
    }
    // Parse the JSON response directly (schema ensures it's valid JSON)
    Map<String, dynamic> parsedResponse;
    try {
      parsedResponse = json.decode(responseText);
    } catch (e) {
      scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.system,
          errorMessage: 'Failed to parse AI response as JSON:\n$e',
        ),
      );
      return;
    }
    final String? message = parsedResponse['message'] as String?;
    final String? errorMessage = parsedResponse['errorMessage'] as String?;
    final Map<String, dynamic>? newExtractRules =
        parsedResponse['newExtractRules'] as Map<String, dynamic>?;

    ZenScrapRedraftState? newState;

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

    if (newState != null) {
      scrapRedraftSessions[sessionId]?.add(newState);
    } else {
      scrapRedraftSessions[sessionId]?.add(
        ErrorTextResponse(
          role: PromptRole.model,
          errorMessage: 'AI response did not contain valid data.',
        ),
      );
    }
  }
}

Content getCommandPrompt({
  required ScrappableTargetRequestStructure requestStructure,
  required ReferenceTestData testData,
}) {
  final Uint8List imagePng =
      Uint8List.sublistView(testData.referenceSiteScreenshot);
  final Uint8List htmlBytes = utf8.encode(testData.referenceHtmlPage);
  final Uint8List jsonBytes = utf8.encode(
    jsonEncode(testData.referenceQueryParametersJson),
  );
  return Content(PromptRole.system.roleText, [
    TextPart(
        '''I am a saas company that generates scrapping extract rules with ai.
My user wan't to extract data with of "${requestStructure.url}" with web scrapping.

I wan't to use "extract rules" feature of ScrapingBee.
The overall documentation of ScrapingBee is: "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage", you can web research and read it if needed to understand how it works if needed.

I asked AI, in a previous prompt session, to help me generating the rules to create those extract rules.
She successfully generated the extraction rules, I used as reference this test link: "${testData.referenceLink}" and that link returned me the following html that I attached to that AI to analyse'''),
    DataPart('text/html', htmlBytes),
    TextPart(
        'Also, I will attach a print of the site so you can have a better understanding of how it looks:'),
    DataPart('image/png', imagePng),
    TextPart(
        'And with that html and using the site as referencce, she successfully generated the following extraction rules:'),
    DataPart('application/json', jsonBytes),
    TextPart(
        '''It worked well, my user want's to change it a little bit, so you should to create new rules that are compliant with ScrapingBee extract rules feature (as I said above, web research the documentation if needed).
I need you to allways ultra think in the response so you don't generate a response that is not compliant with ScrapingBee extract rules feature and that will return me a error.

The next messages with be made by the role 'user' with a prompt asking for modifications, please deeply understand what the user needs and so you can correctly build new extraction rules.
'''),
  ]);
}

extension ZenScrapRedraftStateExtension on ZenScrapRedraftState {
  Content get toContent {
    final roleText = role.roleText;
    return switch (this) {
      ErrorTextResponse(:final errorMessage) => Content(roleText, [
          TextPart(errorMessage),
        ]),
      MessageTextResponse(:final messageText) => Content(roleText, [
          TextPart(messageText),
        ]),
      MessageTextAndNewExtractRulesResponse(
        :final messageText,
        :final newExtractRules
      ) =>
        Content(roleText, [
          TextPart(messageText),
          () {
            final jsonString = jsonEncode(newExtractRules);
            final uint8list = utf8.encode(jsonString);
            return DataPart('application/json', uint8list);
          }(),
        ]),
    };
  }
}

extension PromptRoleExtension on PromptRole {
  String get roleText {
    return switch (this) {
      PromptRole.system => 'assistant',
      PromptRole.user => 'user',
      PromptRole.model => 'model',
    };
  }
}
