import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:test/test.dart';

void main() {
  test(
    'test if is working',
    () async {
      final claudeApiKey =
          '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';
      final sdk = Claude(apiKey: claudeApiKey);

      final chat = sdk.createNewChat(
        options: const ClaudeChatOptions(
          model: 'claude-haiku-4-5',
          permissionMode: 'bypassPermissions',
        ),
      );

      bool receivedAnyChunk = false;
      final stream = chat.streamResponse([
        PromptContent.text('Say "hello" in one word.'),
      ]);

      await for (final chunk in stream) {
        // ignore: avoid_print
        print('RECEIVED CHUNK: $chunk');
        receivedAnyChunk = true;
        break; // Exit after first chunk to make test fast
      }

      if (!receivedAnyChunk) {
        throw Exception(
            'STREAMING NOT WORKING: No chunks received within timeout!');
      }

      // ignore: avoid_print
      print('✅ Streaming is working! Received at least one chunk.');
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
