import 'dart:convert';

import 'package:openai_dart/openai_dart.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

mixin CreateScrappableTargetRequestMixin {
  Future<ScrappableTargetRequestStructure> createMixinProvider({
    required String targetUrl,
  }) async {
    try {
      final prompt = getPromptToGenerateScrappableTargetRequest(targetUrl);

      final response = await openAiClient.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: const ChatCompletionModel.model(ChatCompletionModels.gpt5),
          messages: [
            ChatCompletionMessage.system(
              content:
                  'You are a helpful assistant that analyzes URLs and converts them into structured data for API request handling.',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(prompt),
            ),
          ],
          responseFormat: ResponseFormat.jsonSchema(
            jsonSchema: JsonSchemaObject(
              name: 'ScrappableTargetRequest',
              description:
                  'Structured representation of a URL with path and query parameters',
              strict: true,
              schema: {
                'type': 'object',
                'properties': {
                  'url': {
                    'type': 'string',
                    'description':
                        'URL with path parameters replaced by placeholders in {param} format',
                  },
                  'queryParams': {
                    'type': 'object',
                    'description':
                        'Map of query parameter names to their default values',
                    'additionalProperties': {
                      'type': ['string', 'null'],
                    },
                  },
                  'pathParams': {
                    'type': 'array',
                    'description':
                        'List of path parameter names found in the URL',
                    'items': {
                      'type': 'string',
                    },
                  },
                },
                'required': ['url', 'queryParams', 'pathParams'],
                'additionalProperties': false,
              },
            ),
          ),
        ),
      );

      final content = response.choices.first.message.content;
      if (content == null) {
        throw Exception('OpenAI returned empty response');
      }

      final String jsonString = content.toString();

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, String?> queryParams = {};
      if (jsonData['queryParams'] != null) {
        final dynamic queryParamsData = jsonData['queryParams'];
        if (queryParamsData is Map) {
          queryParamsData.forEach((key, value) {
            queryParams[key.toString()] = value?.toString();
          });
        }
      }

      final List<String> pathParams = [];
      if (jsonData['pathParams'] != null) {
        final dynamic pathParamsData = jsonData['pathParams'];
        if (pathParamsData is List) {
          pathParams.addAll(pathParamsData.map((e) => e.toString()));
        }
      }

      return ScrappableTargetRequestStructure(
        url: jsonData['url']?.toString() ?? targetUrl,
        queryParams: queryParams,
        pathParams: pathParams,
      );
    } catch (e) {
      throw Exception('Failed to generate structured URL data: $e');
    }
  }
}

String getPromptToGenerateScrappableTargetRequest(String url) =>
    '''I am running a dart api with a serverpod server.
I wan't to save urls of the user but I need to transform them in structured data so I can save it in the database work easily with it later.

The url inputed by the user was:
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

Then your output should be:
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


With that example you can now understand what I want you to do with the url inputed by the user that I mentioned above.

Ps: Note that in this example you will need to deduce that 123 and 3854 are the postId and commentsId respectively
This is a thing we will need you will need to do, deduce the path params by the context of the rest of the url... If it is wrong the user will be able to correct it in the app later.

Don't forget to return only the raw json without anything more, not even "```" in the beginning or the end, only the pure raw json because I will directly call jsonDecode on it in my dart code.
Ultra think in the response so you generate a correct json and think in good path parameters names.
''';
