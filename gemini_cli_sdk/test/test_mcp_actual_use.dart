import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('Test actual MCP tool usage', () async {
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

    print('Testing actual MCP tool usage...');

    final prompt = '''
Please use the test_extract_rules tool from the ScrapingBee MCP server to extract the title from example.com.

Use these parameters:
- url: "https://example.com"
- extract_rules: '{"title": "h1"}'
- render_js: false

Then tell me what the title is.
''';

    try {
      final result = await geminiChat.sendMessage([
        GeminiSdkContent.text(prompt),
      ]);

      print('Response received:');
      print('Length: ${result.length}');
      print('Content: "$result"');
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      await geminiChat.dispose();
    }
  }, timeout: const Timeout(Duration(seconds: 60)));
}