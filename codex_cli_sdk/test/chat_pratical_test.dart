import 'package:test/test.dart';

import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() {
  test('Internet verification', () async {
    final codexApiKey =
        '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';
    final sdk = Codex(codexApiKey);
    final newChat = sdk.createNewChat(
      options: CodexChatOptions(
        model: 'gpt-5',
        sandbox: 'danger-full-access', // Enable full network access
      ),
    );

    final response = await newChat.sendMessage([
      CodexSdkContent.text(
          'Hello, codex! Please confirm me if you have access to internet. Try to make a ping to any site'),
    ]);
    print(response);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
