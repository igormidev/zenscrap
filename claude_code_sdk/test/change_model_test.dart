import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  group('ClaudeChat changeModel', () {
    test('should update model and reset session', () {
      // Create a chat with initial model
      final chat = ClaudeChat(
        apiKey: 'test-key',
        options: ClaudeChatOptions(
          model: 'claude-3-5-sonnet-20241022',
        ),
      );

      // Verify initial model
      expect(chat.options.model, equals('claude-3-5-sonnet-20241022'));

      // Change the model
      chat.changeModel('claude-3-7-sonnet-20250219');

      // Verify model was updated
      expect(chat.options.model, equals('claude-3-7-sonnet-20250219'));

      // Session should be reset (null)
      expect(chat.sessionId, isNull);
    });

    test('should throw when chat is disposed', () {
      final chat = ClaudeChat(
        apiKey: 'test-key',
        options: ClaudeChatOptions(
          model: 'claude-3-5-sonnet-20241022',
        ),
      );

      // Dispose the chat
      chat.dispose();

      // Attempting to change model should throw
      expect(
        () => chat.changeModel('claude-3-7-sonnet-20250219'),
        throwsA(isA<ClaudeSDKException>()),
      );
    });

    test('should preserve other options when changing model', () {
      // Create a chat with various options
      final chat = ClaudeChat(
        apiKey: 'test-key',
        options: ClaudeChatOptions(
          model: 'claude-3-5-sonnet-20241022',
          systemPrompt: 'You are a helpful assistant',
          timeoutMs: 120000,
          cwd: '/test/directory',
          maxTurns: 10,
        ),
      );

      // Change the model
      chat.changeModel('claude-3-7-sonnet-20250219');

      // Verify model was updated
      expect(chat.options.model, equals('claude-3-7-sonnet-20250219'));

      // Verify other options are preserved
      expect(chat.options.systemPrompt, equals('You are a helpful assistant'));
      expect(chat.options.timeoutMs, equals(120000));
      expect(chat.options.cwd, equals('/test/directory'));
      expect(chat.options.maxTurns, equals(10));
    });
  });
}