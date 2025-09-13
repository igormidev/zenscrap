import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Get API key from environment or use a test key
  final apiKey = 'AIzaSyAk2TIoAFf99fVORelCV_KEcg3cJ_GI9AA';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your GEMINI_API_KEY environment variable');
    print(
        'You can get your API key from: https://makersuite.google.com/app/apikey');
    return;
  }

  // Initialize the SDK with your API key
  final geminiSDK = GeminiSDK(apiKey);

  // Create a new chat session
  final geminiChat = geminiSDK.createNewChat();

  try {
    print('Sending message to Gemini...\n');

    // Send a simple text message
    final result = await geminiChat.sendMessage([
      GeminiSdkContent.text(
          'What are the main differences between Dart and JavaScript? Please provide a brief comparison.'),
    ]);

    print('Gemini response:');
    print(result);

    // Continue the conversation
    print('\n---\nAsking follow-up question...\n');

    final followUp = await geminiChat.sendMessage([
      GeminiSdkContent.text(
          'Which one would you recommend for building mobile apps and why?'),
    ]);

    print('Gemini response:');
    print(followUp);
  } catch (e) {
    print('Error: $e');
  } finally {
    // Always dispose of the chat when done
    await geminiChat.dispose();
    print('\nChat session disposed.');
  }
}
