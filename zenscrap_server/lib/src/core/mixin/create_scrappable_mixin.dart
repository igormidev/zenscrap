import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

mixin CreateScrappableMixin {
  Future<Scrappable> createScrappable({
    required ScrappableTargetRequestStructure requestStrcture,
    required String referenceUrl,
    required String userPrompt,
  }) async {
    // Step 1: Generate name and description using OpenAI
    final nameAndDescriptionPrompt =
        getPromptToGenerateScrappableNameAndDescription(
      requestStrcture: requestStrcture,
      referenceUrl: referenceUrl,
      userPrompt: userPrompt,
    );

    final openAiResponse = await openAiClient.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: const ChatCompletionModel.model(ChatCompletionModels.gpt5),
        messages: [
          ChatCompletionMessage.system(
            content:
                'You are a helpful assistant that creates concise names and descriptions for web scraping configurations.',
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(
                nameAndDescriptionPrompt),
            // content: ChatCompletionUserMessageContent.parts([
            //   ChatCompletionMessageContentPart.image(imageUrl: ),
            // ]),
          ),
        ],
        responseFormat: ResponseFormat.jsonSchema(
          jsonSchema: JsonSchemaObject(
            name: 'ScrappableMetadata',
            description:
                'Name and description for a web scrapper configuration',
            strict: true,
            schema: {
              'type': 'object',
              'properties': {
                'name': {
                  'type': 'string',
                  'description':
                      'A short, descriptive name for the scrapper (max 50 characters)',
                },
                'description': {
                  'type': 'string',
                  'description':
                      'A detailed description of what data this scrapper extracts and its purpose',
                },
              },
              'required': ['name', 'description'],
              'additionalProperties': false,
            },
          ),
        ),
        temperature: 0.7,
      ),
    );

    final content = openAiResponse.choices.first.message.content;
    if (content == null) {
      throw Exception(
          'OpenAI returned empty response for name and description');
    }

    final Map<String, dynamic> metadata = json.decode(content.toString());
    final String name = metadata['name'] ?? 'Untitled Scrapper';
    final String description =
        metadata['description'] ?? 'No description provided';

    // Step 2: Generate scrapping rules using Gemini (existing method)
    final String scrappingRules = await generateScrappingExtractRules(
      requestStrcture: requestStrcture,
      referenceUrl: referenceUrl,
      userPrompt: userPrompt,
    );

    // Step 3: Create and return the Scrappable model (not saved to database)
    return Scrappable(
      name: name,
      description: description,
      scrappingRules: scrappingRules,
      isActive: true,
      targetRequestId: 0, // Will be set when actually saving to database
    );
  }

  Future<ScrappingRulesEncoded> generateScrappingExtractRules({
    required ScrappableTargetRequestStructure requestStrcture,
    required String referenceUrl,
    required String userPrompt,
  }) async {
    var (String html, Uint8List pageFullscreenScreenshot) =
        await scrapingBee.fetchHtmlAndScreenshot(referenceUrl);

    // Create the prompt with all context
    final String fullPrompt = getPromptToGenerateScrappableExtractRules(
      requestStrcture: requestStrcture,
      referenceUrl: referenceUrl,
      userPrompt: userPrompt,
    );

    // Convert HTML to bytes for file-like upload
    final Uint8List htmlBytes = utf8.encode(html);

    // Create multimodal content with text prompt, HTML file, and image
    final response = await geminiModel.generateContent([
      Content.multi([
        // Main prompt
        TextPart(fullPrompt),
        // HTML as a file data part
        DataPart('text/html', htmlBytes),
        // Screenshot as image data
        DataPart('image/png', pageFullscreenScreenshot),
      ])
    ]);

    final responseText = response.text;
    if (responseText == null || responseText.isEmpty) {
      throw Exception('Gemini returned empty response');
    }

    // Parse the JSON response
    try {
      // Clean the response in case it has markdown formatting
      String cleanJson = responseText;
      if (cleanJson.contains('```json')) {
        cleanJson = cleanJson.split('```json')[1].split('```')[0].trim();
      } else if (cleanJson.contains('```')) {
        cleanJson = cleanJson.split('```')[1].split('```')[0].trim();
      }

      final Map<String, dynamic> extractionRules = json.decode(cleanJson);
      return json.encode(extractionRules);
    } catch (e) {
      throw Exception(
          'Failed to parse Gemini response as JSON: $e\nResponse: $responseText');
    }
  }
}

typedef ScrappingRulesJson = Map<String, dynamic>;
typedef ScrappingRulesEncoded = String;

String getSystemContext({
  required ScrappableTargetRequestStructure requestStrcture,
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
```''';

String getPromptToGenerateScrappableExtractRules({
  required ScrappableTargetRequestStructure requestStrcture,
  required String referenceUrl,
  required String userPrompt,
}) =>
    '''${getSystemContext(requestStrcture: requestStrcture, userPrompt: userPrompt)}

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

The link of the reference page is: "$referenceUrl".

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
8. Return ONLY the raw JSON object without any markdown formatting or code blocks

Example response format:
{
  "product_name": "h1.product-title",
  "price": "span.price-now",
  "description": "div.product-description",
  "availability": "span.stock-status"
}

Return ONLY the JSON object without any additional text, markdown formatting, or code blocks.
Don't forget to return only the raw json without anything more, not even "```" in the beginning or the end, only the pure raw json because I will directly call jsonDecode on it in my dart code.
''';

String getPromptToGenerateScrappableNameAndDescription({
  required ScrappableTargetRequestStructure requestStrcture,
  required String referenceUrl,
  required String userPrompt,
}) =>
    '''${getSystemContext(requestStrcture: requestStrcture, userPrompt: userPrompt)}

That "scrappable" data will be saved in the database. It has some other fields, the model looks like:
```yaml
# scrappable.spy.yaml
class: Scrappable
table: scrappable
fields:
  name: String
  description: String
  scrappingRules: String
```

As you can see I will save the scrapping rules with a name and a description that will help the user to identify that scrapper.
The user will be able to edit that name/description whenever he wan'ts. But I wan't to generate the first name/description for him make things easy.

Create a JSON response with:
1. A concise, descriptive name for this scrapper (max 50 characters)
2. A detailed description explaining what data this scrapper extracts and its purpose

The name should be short but clear about what's being scraped (e.g., "Product Prices", "Article Headlines", "User Reviews").
The description should explain in 1-3 sentences what specific data is extracted and from which type of pages.

Ultra think in a good short name and a description that describes the purpose of the scrapper.
''';
