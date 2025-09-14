import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('Test MCP without schema', () async {
    final apiKey = 'AIzaSyAk2TIoAFf99fVORelCV_KEcg3cJ_GI9AA';
    final geminiSDK = GeminiSDK(apiKey);

    // Use the massive system prompt from web scrapper
    final systemPrompt = '''You are a world-class expert in web scraping.

## Your Available Tools

You have access to ScrapingBee MCP (test_extract_rules tool).

When asked to extract data, use the test_extract_rules tool and return the results.''';

    // Create a new chat session
    final geminiChat = geminiSDK.createNewChat(
      options: GeminiChatOptions(
        model: 'gemini-2.5-flash',
        systemPrompt: systemPrompt,
        allowedMcpServerNames: ['scraping-bee-mcp'],
        allowedTools: ['*'],
        approvalMode: 'yolo',
      ),
    );

    print('Testing MCP without schema...');

    final prompt = '''
Extract the player name from this URL: https://www.transfermarkt.com/neymar/profil/spieler/68290

Use the test_extract_rules tool with:
- url: "https://www.transfermarkt.com/neymar/profil/spieler/68290"
- extract_rules: '{"playerName": "h1.data-header__headline-wrapper"}'
- render_js: true
- premium_proxy: true

Return the extracted player name.
''';

    try {
      final result = await geminiChat.sendMessage([
        GeminiSdkContent.text(prompt),
      ]);

      print('Response received:');
      print('Length: ${result.length}');
      if (result.isNotEmpty) {
        print('First 500 chars: ${result.substring(0, 500.clamp(0, result.length))}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      await geminiChat.dispose();
    }
  }, timeout: const Timeout(Duration(minutes: 2)));
}