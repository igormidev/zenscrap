import 'dart:typed_data';
import 'package:openai_dart/openai_dart.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

(String, int) getNameAndAge() => ('Alice', 30);
mixin CreateScrappableMixin {
  Future<void> createInitialScrappableMixin({
    required ScrappableTargetRequestStructure requestStrcture,
    required String referenceUrl,
    required String userPrompt,
  }) async {
    var (String html, Uint8List pageFullscreenScreenshot) =
        await scrapingBee.fetchHtmlAndScreenshot(referenceUrl);

    final response = await openAiClient.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.model(ChatCompletionModels.gpt5),
        messages: [
          ChatCompletionMessage.system(
            content:
                'You are a helpful assistant that creates extraction rules that are compliant with the expected "ScrappingBee extract rules feature" pattern for web scraping.',
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
              getPromptToGenerateScrappableTargetRequest(
                requestStrcture: requestStrcture,
                referenceUrl: referenceUrl,
                userPrompt: userPrompt,
              ),
            ),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}

String getPromptToGenerateScrappableTargetRequest({
  required ScrappableTargetRequestStructure requestStrcture,
  required String referenceUrl,
  required String userPrompt,
}) =>
    '''I wan't you to create extraction rules so I can extract from a html page the data that I need.

Context:
I have a saas made in flutter with serverpod as my server. This saas will extract data that my clients need from the web.

My client/user wan't a web scrapper for the site "${requestStrcture.url}". He wan't to extract data from that site.
The scrapper api will run in my server, and I will give him a endpoint to access it.
The user sent me a prompt of what data he wants to extract from the site. The prompt of the user was:
```prompt
$userPrompt
```

I don't wan't to use websearch of AI each time to extract the data, I wan't to use a webscrapper instead.
For that, I wan't to use the "ScrappingBee extract rules" feature to extract the data that I need in a more deterministic way.

My ideia is to make a request in my serverpod server similar to this one:
```dart
/// Example of a rule
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

I will attach bellow the HTML of a reference page that the user gived me and asked to use it as a reference to create the extraction rules.
The link of the reference page is: "$referenceUrl".
The html resulted of this link attached bellow, use it to build the rules that will return exactly the data the user asked for.

I need to you double check that you are not hallucinating and creating rules to path that don't exist. By the way, ultra think in your response and think for a long time.
''';
