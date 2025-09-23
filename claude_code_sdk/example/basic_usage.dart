import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 'YOUR_API_KEY';

  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your ANTHROPIC_API_KEY environment variable.');
    exit(1);
  }

  final claudeSDK = Claude(apiKey: apiKey);
  final claudeChat = claudeSDK.createNewChat();

  try {
    print('Sending message to Claude...');
    print('---');

    final result = await claudeChat.sendMessage([
      PromptContent.text('What is the capital of France?'),
    ]);

    print('Claude says:');
    print(result);
    print('---');

    print('\nAsking a follow-up question...');
    print('---');

    final followUp = await claudeChat.sendMessage([
      PromptContent.text('What is the population of that city?'),
    ]);

    print('Claude says:');
    print(followUp);
  } catch (e) {
    print('Error: $e');
  } finally {
    await claudeChat.dispose();
    await claudeSDK.dispose();
  }
}
