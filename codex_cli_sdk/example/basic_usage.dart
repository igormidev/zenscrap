import 'package:codex_cli_sdk/codex_cli_sdk.dart';

Future<void> main() async {
  final apiKey = const String.fromEnvironment('OPENAI_API_KEY',
      defaultValue: 'YOUR_API_KEY_HERE');

  final codexSDK = Codex(apiKey: apiKey);
  final codexChat = codexSDK.createNewChat();

  try {
    print('Sending message to Codex...\n');

    final result = await codexChat.sendMessage([
      PromptContent.text('What is the capital of France?'),
    ]);

    print('Codex response:');
    print(result);

    print('\nSending follow-up question...\n');
    final followUp = await codexChat.sendMessage([
      PromptContent.text('What are some famous landmarks there?'),
    ]);

    print('Follow-up response:');
    print(followUp);

    print('\nSession ID: ${codexChat.sessionId}');
  } catch (e) {
    print('Error: $e');
  } finally {
    await codexChat.dispose();
    await codexSDK.dispose();
  }
}
