import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('Test MCP with schema response', () async {
    final apiKey = 'AIzaSyAk2TIoAFf99fVORelCV_KEcg3cJ_GI9AA';
    final geminiSDK = GeminiSDK(apiKey);

    // Create a new chat session
    final geminiChat = geminiSDK.createNewChat(
      options: GeminiChatOptions(
        model: 'gemini-2.5-flash',
        allowedMcpServerNames: ['scraping-bee-mcp'],
        allowedTools: ['*'],
      ),
    );

    print('Testing MCP with schema...');

    // Define a simple schema
    final schema = SchemaObject(
      properties: {
        'responseType': SchemaProperty.string(
          description: 'Type of response: message or data',
          nullable: false,
          enumValues: ['message', 'data'],
        ),
        'message': SchemaProperty.string(
          description: 'The message content',
          nullable: true,
        ),
        'extractedData': SchemaProperty.object(
          description: 'Extracted data from the page',
          nullable: true,
          properties: {
            'title': SchemaProperty.string(nullable: true),
          },
        ),
      },
    );

    final prompt = '''
Please test the ScrapingBee MCP server with these parameters:
- url: "https://example.com"
- extract_rules: '{"title": "h1"}'

Return the result in the schema format with responseType "data" and the extracted title.
''';

    try {
      final result = await geminiChat.sendMessageWithSchema(
        messages: [
          GeminiSdkContent.text(prompt),
        ],
        schema: schema,
      );

      print('Response received:');
      print('Data: ${result.data}');
      print('Message: ${result.modelMessage}');
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      await geminiChat.dispose();
    }
  }, timeout: const Timeout(Duration(seconds: 60)));
}