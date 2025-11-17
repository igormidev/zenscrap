README.md
I will do a GIANT refactor in how the server works and process things... 

I want to remove 100 any use reference to programming_cli_core_sdk, claude_code_sdk, codex_cli_sdk, gemini_cli_sdk and web_scrapper_generator - the project will not use them anymore... by the way, at the end of this task the file @pubspec.yaml and the workspace approach used in each package will be removed... removing web_scrapper_generator package from the server will cause several issues in the server and we will fix them by macking a deep refactor in how we make the ai 

Before doing anything lets take a general overview of the main files you will be looking to...

ultrathink and deeply understand the structures of everything in the file @zenscrap_server/lib/src/endpoints/public/scrappable_chat_session.dart

Note that the flow will call @zenscrap_server/lib/src/endpoints/public/scrappable_chat_session.dart - to be more specific, the implementation of claude code in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_claude_code_sdk_impl.dart that you should see as example to make the refactor that I will ask you to. You should delete all the current implementation that currently exists, since they use 'web_scrapper_generator' package... So that includes @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_gemini_sdk_impl.dart , @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_codex_sdk_impl.dart and @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_claude_code_sdk_impl.dart - all of they should be deleted totally.

Then, you should create a new implementation...
This implementation will a openai implementation and it will be called ChatControllerOpenAiSdkImpl. This implementation will not use any package in this repository like the other ones that use the... instead, it will make a pure REST request to open ai and use chat gpt - model 5 - and stream its response... also, use the schema as well to ensure the response is the same... So ultrathink and use your web research tool to see the most updated version of the documentation of chat gpt 5 so you can make a request with a schema response and also stream the thinking of the ai. The schema should be based on webScrapperResponseSchema of @web_scrapper_generator/lib/src/web_scrapper_generator_interface.dart

# Prompt generation

To build the prompt, I want you to combine the prompts in the following documentation to one single file:
- @web_scrapper_generator/lib/src/prompts.dart
- @web_scrapper_generator/lib/src/documentation/cost_optimization.dart
- @web_scrapper_generator/lib/src/documentation/how_to_edit_scrappable_request.dart
- @web_scrapper_generator/lib/src/documentation/scrappable_request_structure_guide.dart 
- @web_scrapper_generator/lib/src/documentation/system_prompt.dart

Note: This is the part where you should most ultrathink about since they are giant texts that you will resume into one prompt. Also, maybe the content is bloated so you can optimize if needed in some points. Also, remove those references that explain it needs to reed the files since the context will go fully in one prompt. ultrathink to make the best prompt possible. 

# MCP explaination
Since we will not run the code locally (since we will remove programming_cli_core_sdk, claude_code_sdk, codex_cli_sdk, gemini_cli_sdk and web_scrapper_generator) we of course will not have anymore the configs made in @web_scrapper_generator/lib/src/playwright_setup.dart @web_scrapper_generator/lib/src/scraping_bee_mcp.dart @web_scrapper_generator/lib/src/mcp_adapters.dart

But instead we will pass in the open api the servers of both playwright mcp and scrapping bee mcp (yes, I created a server for both of them). This way, ai will continue to have access to both mcps! So you can continue to mention in the prompt that it should use both mcps

# Request example
We will do the request to open ai in PURE REST - without any package...
This is because I want to have the 4 behaviors that is only able to have in a pure rest request since it is a complex ask because it will need to have the following behaviors:
- Needs to stream the thinking to the user
- Needs to have defined schema
- Needs to send the mcp tool
- Use chat gpt 5.1

I will show you a curl request example that has all those 4 criterias that you can ultrathink and deep analyse to see how to use it as sample:
```curl
curl https://api.openai.com/v1/responses \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -N \
  -d '{
    "model": "gpt-5.1",
    "stream": true,

    "tools": [
      {
        "type": "mcp",
        "server_label": "playwright",
        "server_url": "https://mcp-server-7d19c6f0-aab8-410f-916d-e6e0445ef2c3.supermachine.app/",
        "require_approval": "never"
      },
      {
        "type": "mcp",
        "server_label": "scrappingBee",
        "server_url": "https://mcp-server-826137dd-10ff-43d7-aa91-6b02978511f8.supermachine.app/",
        "require_approval": "never"
      }
    ],

    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "ScrapePageResult",
        "strict": true,
        "schema": {
          "type": "object",
          "properties": {
            "url": { "type": "string" },
            "explanation": {
              "type": "string",
              "description": "Explain briefly what you scraped and any caveats."
            },
            "fields": {
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "name": { "type": \"string\" },
                  "css_selector": { "type": \"string\" },
                  "sample_value": {
                    "type": "string",
                    "description": "Example text extracted using this selector."
                  }
                },
                "required": ["name", "css_selector"],
                "additionalProperties": false
              }
            }
          },
          "required": ["url", "fields"],
          "additionalProperties": false
        }
      }
    },

    "input": [
      {
        "role": "system",
        "content": "You are an expert web scraper designer. \
You have access to a Playwright MCP server labelled `playwright`. \
Use it to open pages, inspect the DOM, and then propose robust CSS selectors. \
Always answer ONLY with JSON that matches the ScrapePageResult schema."
      },
      {
        "role": "user",
        "content": "Scrape https://example.com/products and identify the key product fields."
      }
    ]
  }'
```

Now I will pass a pseudo-code that you can use as a base to make your our conde with much more code quality and better segregation of functions (this is just a really simple sample just to give you a general idea of the flow):
```dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Adjust to your key and MCP URL.
const String openAIApiKey = 'sk-...';
const String mcpPlaywrightUrl =
    'https://mcp-server-7d19c6f0-aab8-410f-916d-e6e0445ef2c3.supermachine.app/';

Future<void> streamScrapeWithSchema() async {
  final uri = Uri.parse('https://api.openai.com/v1/responses');

  final request = http.Request('POST', uri)
    ..headers.addAll({
      'Authorization': 'Bearer $openAIApiKey',
      'Content-Type': 'application/json',
    })
    ..body = jsonEncode({
      'model': 'gpt-5.1',
      'stream': true,
      'tools': [
        {
          'type': 'mcp',
          'server_label': 'playwright',
          'server_url': mcpPlaywrightUrl,
          'require_approval': 'never',
        }
      ],
      'response_format': {
        'type': 'json_schema',
        'json_schema': {
          'name': 'ScrapePageResult',
          'strict': true,
          'schema': {
            'type': 'object',
            'properties': {
              'url': {'type': 'string'},
              'explanation': {'type': 'string'},
              'fields': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'name': {'type': 'string'},
                    'css_selector': {'type': 'string'},
                    'sample_value': {'type': 'string'},
                  },
                  'required': ['name', 'css_selector'],
                  'additionalProperties': false,
                }
              }
            },
            'required': ['url', 'fields'],
            'additionalProperties': false,
          }
        }
      },
      'input': [
        {
          'role': 'system',
          'content':
              'You are an expert scraper designer. Use the Playwright MCP '
                  'server (label `playwright`) to inspect the page before '
                  'choosing selectors. Always answer ONLY with JSON that '
                  'matches the ScrapePageResult schema.',
        },
        {
          'role': 'user',
          'content':
              'Scrape https://example.com/products and identify the main product fields.',
        }
      ],
    });

  final streamedResponse = await request.send();

  if (streamedResponse.statusCode != 200) {
    final body = await streamedResponse.stream.bytesToString();
    throw Exception('OpenAI error ${streamedResponse.statusCode}: $body');
  }

  // SSE: each line is "data: {json}" or other control lines.
  final lines = streamedResponse.stream
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  final jsonBuffer = StringBuffer();

  await for (final line in lines) {
    if (line.isEmpty) continue;
    if (!line.startsWith('data:')) {
      // typically "event:" or ":" comments, ignore.
      continue;
    }

    final data = line.substring(5).trim();
    if (data == '[DONE]') break;

    final Map<String, dynamic> event;
    try {
      event = jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      // Partial line / keep-alive, just skip.
      continue;
    }

    final type = event['type'] as String?;

    // For plain text this would be "response.output_text.delta".
    // For structured outputs, you may see something like
    // "response.output_json.delta" or similar.
    if (type == 'response.output_text.delta' ||
        type == 'response.output_json.delta') {
      final delta = event['delta'];
      if (delta is String) {
        // This is the raw JSON text being generated.
        jsonBuffer.write(delta);

        // Naive UX: try to parse what we have and show explanation so far.
        try {
          final parsed = jsonDecode(jsonBuffer.toString());
          final explanation = parsed['explanation'];
          if (explanation is String) {
            // Send this to your WebSocket / Flutter UI as "thinking".
            print('[thinking] $explanation');
          }
        } catch (_) {
          // Not yet valid JSON – keep buffering.
        }
      }
    } else if (type == 'response.completed') {
      // Final full response object is available in event["response"].
      final response = event['response'] as Map<String, dynamic>?;
      if (response != null) {
        // Depending on the API version, the parsed JSON may live in:
        // response["output"][0]["content"][0]["parsed"]
        // or a similar structure. Log once to inspect:
        print('Final response event: ${jsonEncode(response)}');
      }
    }
  }

  // After the stream ends, you can parse the final buffer.
  try {
    final resultJson = jsonDecode(jsonBuffer.toString());
    print('Final structured result: $resultJson');
    // Map this to a Dart class if you want.
  } catch (e) {
    print('Could not parse final JSON: $e');
  }
}
```

# Final consideration
- There should be no static analysis errors in @zenscrap_flutter/ and @zenscrap_server/ 
- Let REALLY CLEAR that if ai does not have access to any of both mcps it should return a error saying that it does not have that access...
- Currently the app uses the pub workspaces approach. Remember to fully remove that so serverpod will not import any package from this repository - there should be NO reference to in @zenscrap_server/pubspec.yaml and the 'resolution' should be removed as well from it - ZERO references to programming_cli_core_sdk, claude_code_sdk, codex_cli_sdk, gemini_cli_sdk and web_scrapper_generator in the server repository... remove any reference to it
- If the client (flutter) breakes do all necessary fixes
- Run "serverpod generate --experimental-features=all" when generating severpod things since our server uses some experimental features
- This is a ULTRA MEGA hard/complex refactor... DO NOT RUSH this task and do it in your time without rushing to garantee this MEGA refactor will be sucessfull. ultrathink