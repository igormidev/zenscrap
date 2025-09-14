import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:test/test.dart';

import '../example/complex_prompt.dart';

void main() async {
  test(
    'Should work with complex prompts',
    () async {
      // Get API key from environment or use a test key
      final apiKey = 'AIzaSyAk2TIoAFf99fVORelCV_KEcg3cJ_GI9AA';

      if (apiKey == 'YOUR_API_KEY') {
        print('Please set your GEMINI_API_KEY environment variable');
        print(
            'You can get your API key from: https://makersuite.google.com/app/apikey');
        return;
      }

      // Initialize the SDK with your API key
      final geminiSDK = GeminiSDK(
        apiKey,
      );

      // Create a new chat session
      final geminiChat = geminiSDK.createNewChat(
          options: GeminiChatOptions(
        systemPrompt: systemPrompt,
      ));

      print('Sending message to Gemini...\n');

      // Send a simple text message
      final result = await geminiChat.sendMessage([
        GeminiSdkContent.text(
          'Are you ready to help me with web scraping tasks? Please confirm.',
        ),
      ]);

      print('Gemini response:');
      print(result);

      // Continue the conversation
      print('\n---\nAsking follow-up question...\n');

      final followUp = await geminiChat.sendMessage([
        GeminiSdkContent.text(
            'Great! Give me one more confirmation; Do you have access to the ScrapingBee MCP server? And puppeteer MCP server? Please confirm.'),
      ]);

      print('Follow-up response:');
      print(followUp);

      final secondFollowUp = await geminiChat.sendMessage([
        GeminiSdkContent.text(
            'Got it. One more thing: Can you get the html content of a page after all JavaScript has executed with puppeteer MCP? Please confirm.\nAlso, what are the parameters you can use with the scrappingbee mcp server? List them all.'),
      ]);

      print('Second follow-up response:');
      print(secondFollowUp);
    },
  );
}
