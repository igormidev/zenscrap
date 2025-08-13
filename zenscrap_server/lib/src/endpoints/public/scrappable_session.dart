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
    );

    final aiResponse = await geminiModel.generateContent(contents);
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
