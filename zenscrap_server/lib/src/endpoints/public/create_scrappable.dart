import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class CreateScrappableEndpoint extends Endpoint {
  Future<Scrappable> call(
    Session session, {
    required String referenceLink,
  }) async {
    final GenerativeModel geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: session.passwords['geminiApiKey']!,
      systemInstruction: Content.system(
          'You are a helpful assistant that analyzes URLs and converts them into structured data for API request handling.'),
      generationConfig: GenerationConfig(responseSchema: schema),
    );

    final ChatSession chat = geminiModel.startChat();
    final GenerateContentResponse result = await chat.sendMessage(
      Content.text(getPromptToGenerateScrappableTargetRequest(referenceLink)),
    );
    final text = result.text;
    if (text == null) {
      throw ZenScrapException(
          title: 'Gemini AI could not generate the scrappable data.',
          description: 'No text was returned from the AI. Try again later.');
    }

    late final String name;
    late final String description;
    late final String url;
    late final Map<String, String> queryParams;
    late final List<String> pathParams;
    late final Map<String, String> referenceLinkPathParameters;

    var (String html, Uint8List pageFullscreenScreenshot) =
        await scrapingBee.fetchHtmlAndScreenshot(referenceLink);

    // Convert HTML to bytes for file-like upload
    final Uint8List htmlBytes = utf8.encode(html);
    final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
    final ByteData screenshotByteData =
        ByteData.view(pageFullscreenScreenshot.buffer);

    try {
      final Map<String, dynamic> convertedData =
          jsonDecode(text) as Map<String, dynamic>;
      name = convertedData['name'] as String;
      description = convertedData['description'] as String;
      url = convertedData['url'] as String;
      queryParams =
          Map<String, String>.from(convertedData['queryParams'] as Map? ?? {});
      pathParams =
          List<String>.from(convertedData['pathParams'] as List? ?? []);
      referenceLinkPathParameters = Map<String, String>.from(
          convertedData['referenceLinkPathParameters'] as Map? ?? {});
    } catch (error, stackTrace) {
      session.log('Error decoding JSON from Gemini AI response:\n$error',
          level: LogLevel.error, stackTrace: stackTrace);
      throw ZenScrapException(
          title: 'Gemini AI could not generate the scrappable data.',
          description:
              'The returned text was not a valid JSON. Try again later.');
    }

    return session.db.transaction((transaction) async {
      final ScrappableRequest targetRequest =
          await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: url,
          queryParams: queryParams,
          pathParams: pathParams,
        ),
        transaction: transaction,
      );
      final ReferenceTestData referenceTestData =
          await ReferenceTestData.db.insertRow(
        session,
        ReferenceTestData(
          referenceLinkUsed: referenceLink,
          referenceHtmlPage: htmlByteData,
          referenceSiteScreenshot: screenshotByteData,
          referenceQueryParametersJson: jsonEncode(referenceLinkPathParameters),
        ),
        transaction: transaction,
      );

      final Scrappable scrappable = await Scrappable.db.insertRow(
        session,
        Scrappable(
          name: name,
          description: description,
          createdAt: DateTime.now(),
          isActive: true,
          targetRequestId: targetRequest.id!,
          referenceTestDataId: referenceTestData.id!,
          referenceTestData: referenceTestData,
          targetRequest: targetRequest,
        ),
        transaction: transaction,
      );

      await Scrappable.db.attachRow.targetRequest(
          session, scrappable, targetRequest,
          transaction: transaction);
      await Scrappable.db.attachRow.referenceTestData(
          session, scrappable, referenceTestData,
          transaction: transaction);

      return scrappable;
    });
  }
}

String getPromptToGenerateScrappableTargetRequest(String url) =>
    '''I am running a dart api with a serverpod server.
I wan't to save urls of the user but I need to transform them in structured data so I can save it in the database work easily with it later.

The url inputed by the user, that should be considered a "reference link", was:
"$url"

The entity that I will save in the database is:
```yaml
# scrappable_target_request.spy.yaml
class: ScrappableTargetRequestStructure
table: scrappable_target_request
fields:
  url: String # Dynamic path fields are saved as {PATH_PARAM_NAME}. Example: www.mySocialMedia.com/posts/{postId}/comments/{commentsId}
  queryParams: Map<String, String?> # The query parameters that will be requested by the user in his payload, Example: [sort, filter]. The map value will be the default value in case it does not exist in users payload
  pathParams: List<String> # The name of the paths params that will be requested by the user in his payload, Example: [postId, commentsId]
```

So I need you to return for me a json like:
```json
{
  "url": "string",
  "queryParams": {},
  "pathParams": [],
}
```

So, for example, if the user inputs the following example url:
www.mySocialMedia.com/posts/123/comments/3854?sort=asc&filter=all


Then part of your output should something be:
```json
{
  "url": "www.mySocialMedia.com/posts/{postId}/comments/{commentsId}",
  "queryParams": {
    "sort": "asc",
    "filter": "all"
  },
  "pathParams": [
    "postId",
    "commentsId"
  ],
}
```

Ps: Note with this example that you will need to deduce that 123 and 3854 are the postId and commentsId respectively
This is a thing we will need you will need to do, deduce the path params by the context of the rest of the url... If it is wrong the user will be able to correct it in the app later.

With that example you can now understand what I want you to do with the url inputed by the user that I mentioned above.
Also, just so I can have track of what you did, please return in the json a field called "referenceLinkPathParameters" with a json representation of the path parameters you extracted from the reference link.
Garantee no "pathParams" are missing, the number of items in "pathParams" should be the same as the number of items in "referenceLinkPathParameters" and with the same key names, take care of that to not misstype anything.
In the example above with the social media, the referenceLinkPathParameters would be:
```json
{
  "postId": "123",
  "commentsId": "3854"
}
```
That way, I can automaticly test the scrapper with the extracted parameters.

But I also need some other fields.
That "scrappable" data will be saved in the database. It has some other fields, the model looks like:
```yaml
# scrappable.spy.yaml
class: Scrappable
table: scrappable
fields:
  name: String
  description: String
```

As you can see I will save the scrapping rules with a name and a description that will help the user to identify that scrapper.
The user will be able to edit that name/description whenever he wan'ts. But I wan't to generate the first name/description for him make things easy.

Create a JSON response with:
1. A concise, descriptive name for this scrapper (max 50 characters)
2. A detailed description explaining what data this scrapper extracts and its purpose

The name should be short but clear about what's being scraped (e.g., "Product Prices", "Article Headlines", "User Reviews").
The description should explain in 1-3 sentences what specific data is extracted and from which type of pages.

Don't forget to return only the raw json without anything more, not even "```" in the beginning or the end, only the pure raw json because I will directly call jsonDecode on it in my dart code.
Ultra think in the response so you generate a correct json and think in good path parameters names.
''';

final schema = Schema(
  SchemaType.object,
  description: '',
  nullable: false,
  properties: {
    'name': Schema(
      SchemaType.string,
      nullable: false,
      description:
          'A short name for the scrappable, like "MySocialMedia Posts Comments".',
    ),
    'description': Schema(
      SchemaType.string,
      nullable: false,
      description: 'A brief description of what this scrappable is for.',
    ),
    'url': Schema(
      SchemaType.string,
      nullable: false,
      description:
          'The URL with path parameters replaced by placeholders in {param} format.',
    ),
    'queryParams': Schema(
      SchemaType.object,
      nullable: false,
      description:
          'The query parameters that will be requested by the user in his payload.',
    ),
    'pathParams': Schema(
      SchemaType.array,
      nullable: false,
      description:
          'The path parameters that will be requested by the user in his payload.',
      items: Schema(
        SchemaType.string,
        nullable: false,
      ),
    ),
    'referenceLinkPathParameters': Schema(
      SchemaType.object,
      nullable: false,
      description:
          'A JSON representation of the path parameters extracted of the reference link.',
    ),
  },
);
