import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

mixin CreateScrappableTargetRequestMixin {
  Future<ScrappableTargetRequestStructure> createMixinProvider({
    required String targetUrl,
  }) async {}
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

Then your output should be (note that in this example you will need to deduce that 123 and 3854 are the postId and commentsId respectively):
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

Don't forget to return only the raw json without anything more, not even "```" in the beginning or the end, only the pure raw json because I will directly call jsonDecode on it in my dart code.
Ultra think in the response so you generate a correct json and think in good path parameters names.
''';
