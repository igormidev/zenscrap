import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Get API key from environment or use your key
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'YOUR_API_KEY';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your ANTHROPIC_API_KEY environment variable');
    print('Or replace YOUR_API_KEY with your actual API key');
    exit(1);
  }

  // Initialize the SDK
  final claudeSDK = Claude(apiKey);

  // Create a new chat session
  final claudeChat = claudeSDK.createNewChat();

  try {
    print('Sending message to Claude...');
    print('---');

    // Send a simple text message
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text('What is the capital of France?'),
    ]);

    print('Claude says:');
    print(result);
    print('---');

    // Send another message in the same session
    print('\nAsking a follow-up question...');
    print('---');

    final followUp = await claudeChat.sendMessage([
      ClaudeSdkContent.text('What is the population of that city?'),
    ]);

    print('Claude says:');
    print(followUp);
  } catch (e) {
    print('Error: $e');
  } finally {
    // Always dispose of the chat session
    await claudeChat.dispose();
    await claudeSDK.dispose();
  }
}