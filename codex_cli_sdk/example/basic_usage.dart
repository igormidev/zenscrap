import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  // Get API key from environment variable or use a test key
  final apiKey = const String.fromEnvironment('OPENAI_API_KEY',
      defaultValue: 'YOUR_API_KEY_HERE');

  // Initialize the SDK
  final codexSDK = Codex(apiKey);

  // Create a new chat session
  final codexChat = codexSDK.createNewChat();

  try {
    print('Sending message to Codex...\n');

    // Send a simple text message
    final result = await codexChat.sendMessage([
      CodexSdkContent.text('What is the capital of France?'),
    ]);

    print('Codex response:');
    print(result);

    // Send a follow-up question
    print('\nSending follow-up question...\n');
    final followUp = await codexChat.sendMessage([
      CodexSdkContent.text('What are some famous landmarks there?'),
    ]);

    print('Follow-up response:');
    print(followUp);

    // Get session ID
    print('\nSession ID: ${codexChat.sessionId}');
  } catch (e) {
    print('Error: $e');
  } finally {
    // Always dispose of the chat session
    await codexChat.dispose();
  }
}