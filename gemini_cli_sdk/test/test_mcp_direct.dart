import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('Test MCP server direct call', () async {
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

    print('Testing direct MCP call...');

    // Try a simple prompt that should trigger MCP usage
    final prompt = '''
Please use the test_extract_rules tool from the ScrapingBee MCP server with these parameters:
- url: "https://example.com"
- extract_rules: '{"title": "h1"}'

Just call the tool and tell me if it works.
''';

    try {
      final result = await geminiChat.sendMessage([
        GeminiSdkContent.text(prompt),
      ]);

      print('Response received:');
      print(result);
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      await geminiChat.dispose();
    }
  }, timeout: const Timeout(Duration(seconds: 30)));
}