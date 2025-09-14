import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('Test MCP with large prompt and schema', () async {
    final apiKey = 'AIzaSyAk2TIoAFf99fVORelCV_KEcg3cJ_GI9AA';
    final geminiSDK = GeminiSDK(apiKey);

    // Create a large system prompt
    final largeSystemPrompt = List.generate(100, (i) =>
      'This is line $i of a large system prompt to test if large prompts cause issues with MCP servers.'
    ).join('\n');

    // Create a new chat session with large system prompt
    final geminiChat = geminiSDK.createNewChat(
      options: GeminiChatOptions(
        model: 'gemini-2.5-flash',
        systemPrompt: largeSystemPrompt,
        allowedMcpServerNames: ['scraping-bee-mcp'],
        allowedTools: ['*'],
      ),
    );

    print('Testing MCP with large system prompt and schema...');
    print('System prompt length: ${largeSystemPrompt.length} characters');

    // Define a simple schema
    final schema = SchemaObject(
      properties: {
        'message': SchemaProperty.string(
          description: 'A simple message',
          nullable: false,
        ),
      },
    );

    final prompt = 'Return a JSON with message "Hello World" - do not use any MCP tools.';

    try {
      final result = await geminiChat.sendMessageWithSchema(
        messages: [
          GeminiSdkContent.text(prompt),
        ],
        schema: schema,
      );

      print('Response received:');
      print('Data: ${result.data}');
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      await geminiChat.dispose();
    }
  }, timeout: const Timeout(Duration(seconds: 30)));
}