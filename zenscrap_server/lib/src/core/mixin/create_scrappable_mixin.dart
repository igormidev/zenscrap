import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

mixin CreateScrappableMixin {
  Future<Scrappable> createScrappable({
    required Session session,
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

    return session.db.transaction(
      (transaction) async {
        final ScrappableTargetRequestStructure insertedStructure =
            await ScrappableTargetRequestStructure.db
                .insertRow(session, requestStrcture, transaction: transaction);

        // Step 2: Generate scrapping rules using Gemini (existing method)
        final String scrappingRules = await generateScrappingExtractRules(
          session: session,
          requestStrcture: requestStrcture,
          referenceUrl: referenceUrl,
          userPrompt: userPrompt,
        );

        // Step 3: Create and return the Scrappable model (not saved to database)
        final insertedScrappable = await Scrappable.db.insertRow(
            session,
            Scrappable(
              name: name,
              description: description,
              scrappingRules: scrappingRules,
              isActive: true,
              targetRequestId: insertedStructure.id!,
              targetRequest: insertedStructure,
              testData: ReferenceTestData(
                referenceHtmlPage: '',
                referenceLink: '',
                referenceQueryParametersJson: '',
                referenceSiteScreenshot: ByteData(0),
                extractedRulesUsed: '',
              ),
            ),
            transaction: transaction);

        await Scrappable.db.attachRow.targetRequest(
            session, insertedScrappable, insertedStructure,
            transaction: transaction);

        return insertedScrappable;
      },
    );
  }

  Future<ScrappingRulesEncoded> generateScrappingExtractRules({
    required Session session,
    required ScrappableTargetRequestStructure requestStrcture,
    required String referenceUrl,
    required String userPrompt,
  }) async {
    // Fetch page content
    var (String html, Uint8List pageFullscreenScreenshot) =
        await scrapingBee.fetchHtmlAndScreenshot(referenceUrl);

    // Convert HTML to bytes for file-like upload
    final Uint8List htmlBytes = utf8.encode(html);

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
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          properties: {
            'rules': Schema(
              SchemaType.object,
              description:
                  'CSS selectors or XPath expressions for data extraction. Each key is the data field name and value is the CSS selector.',
            ),
          },
          requiredProperties: ['rules'],
        ),
      ),
    );

    // Start a chat session with system context
    final chat = geminiModel.startChat(
      history: [
        Content.system(
            '''You are an expert at creating web scraping extraction rules that are compliant with "extract rules" feature of ScrapingBee
The overall documentation of ScrapingBee is: "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage", you can web research and read it if needed to understand how it works if needed.

You analyze HTML and screenshots to generate precise CSS selectors that will extract the requested data.
Always return valid JSON with a "rules" object containing field names as keys and CSS selectors as values.
Be extremely precise with your selectors to ensure they work correctly.
Think step-by-step through the HTML structure to find the exact elements needed.'''),
      ],
    );

    // Initial prompt content
    final String initialPrompt = getPromptToGenerateScrappableExtractRules(
      requestStrcture: requestStrcture,
      referenceUrl: referenceUrl,
      userPrompt: userPrompt,
    );

    // Try up to 3 times
    String? lastError;
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        // Prepare the message content based on attempt
        final Content messageContent;

        if (attempt == 1) {
          // First attempt: send initial prompt with HTML and screenshot
          messageContent = Content.multi([
            TextPart(initialPrompt),
            DataPart('text/html', htmlBytes),
            DataPart('image/png', pageFullscreenScreenshot),
          ]);
        } else {
          // For retries, send the retry prompt with error context
          messageContent = Content.text(
            _getRetryPrompt(
                attempt - 1, lastError ?? 'Previous attempt failed'),
          );
        }

        // Send message and collect stream response
        final responseStream = chat.sendMessageStream(messageContent);

        // Accumulate the streaming response
        final StringBuffer responseBuffer = StringBuffer();
        await for (final chunk in responseStream) {
          final text = chunk.text;
          if (text != null && text.isNotEmpty) {
            responseBuffer.write(text);
          }
        }

        final String responseText = responseBuffer.toString();
        if (responseText.isEmpty) {
          throw Exception('Gemini returned empty response');
        }

        // Parse the JSON response directly (schema ensures it's valid JSON)
        Map<String, dynamic> parsedResponse;
        try {
          parsedResponse = json.decode(responseText);
        } catch (e) {
          throw Exception('Failed to parse AI response as JSON: $e');
        }

        // Extract the rules from the response
        final Map<String, dynamic> extractionRules = parsedResponse['rules']!;
        // parsedResponse['rules'] ?? parsedResponse;
        final String encodedRules = json.encode(extractionRules);

        // Validate the rules using extractByRules
        final ExtractDataByRule validationResult =
            await scrapingBee.extractByRules(
          targetUrl: referenceUrl,
          extractRules: encodedRules,
        );

        // Check if validation was successful
        final bool isSuccess = validationResult.when(
          withData: (data) => data.isNotEmpty,
          error: (_) => false,
        );

        if (isSuccess) {
          return encodedRules;
        }

        // If validation failed, store error for next retry
        lastError = validationResult.when(
          withData: (_) => 'Validation succeeded but no data was extracted',
          error: (error) => error,
        );

        // If this was the last attempt, throw exception
        if (attempt == 3) {
          throw ZenScrapException(
            title: 'Failed to generate valid extraction rules',
            description:
                'After 3 attempts, the extraction rules could not be validated. Last error: $lastError',
          );
        }
      } catch (e) {
        // Store error for next retry
        lastError = e.toString();

        // If this was the last attempt, throw exception
        if (attempt == 3) {
          throw ZenScrapException(
            title: 'Failed to generate extraction rules',
            description:
                'After 3 attempts, extraction rules could not be generated. Error: $e',
          );
        }
      }
    }

    // This should never be reached, but just in case
    throw Exception('Unexpected error in generateScrappingExtractRules');
  }

  String _getRetryPrompt(int attemptNumber, String errorMessage) {
    return '''
## Attempt ${attemptNumber + 1}

The previous extraction rules failed validation with the following error:
```
$errorMessage
```

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

**ULTRA THINK:** Analyze the HTML structure methodically, verify each selector component exists, and ensure the extraction rules will successfully capture the requested data.''';
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
