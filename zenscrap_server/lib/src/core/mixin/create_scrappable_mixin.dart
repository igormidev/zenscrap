import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

mixin CreateScrappableMixin {}

String getPromptToGenerateScrappableTargetRequest({
  required ScrappableTargetRequestStructure requestStrcture,
  required String referenceUrl,
  required String html,
}) =>
    '''I wan't you to create extraction rules so I can extract from a html page the data that I need.

Context:
I am running a dart api with a serverpod server.
I am building a web scrapper for the site "${requestStrcture.url}" that will run in my server.

In that site there are some data's that I wan't to extract.
For that, I wan't to use the "ScrappingBee extract rules" feature to extract the data that I need in a deterministic way.

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

But of course, instead of that mocked extraction rules of the example I will use rules that will in fact get the data I needed.
I need you to create that extraction rules (extract_rules) for me.

The data I need to extract is:
''';
