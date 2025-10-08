import 'dart:io';

import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Claude', () {
    test('creates chat instances', () {
      final sdk = Claude(apiKey: 'test-key');
      final chat = sdk.createNewChat();
      expect(chat, isA<ClaudeChat>());
      expect(chat.didSendFirstMessage, isFalse);
    });

    test('addApiKeyToEnvironment runs without throwing', () async {
      final sdk = Claude(apiKey: 'secret');
      if (Platform.isWindows) {
        // Avoid modifying the persistent env on Windows during tests.
        await expectLater(sdk.addApiKeyToEnvironment('secret'), completes);
      } else {
        await sdk.addApiKeyToEnvironment('secret');
      }
    });
  });

  group('ClaudeChatOptions', () {
    test('converts to CLI arguments', () {
      const options = ClaudeChatOptions(
        systemPrompt: 'Be helpful',
        maxTurns: 3,
        allowedTools: ['fs', 'git'],
        disallowedTools: ['exec'],
        permissionMode: 'read-only',
        model: 'claude-3.5-sonnet',
        additionalArgs: ['--dry-run'],
      );

      final args = options.toCliArgs();
      expect(args, containsAll(['--append-system-prompt', 'Be helpful']));
      expect(args, containsAll(['--max-turns', '3']));
      expect(args, containsAll(['--allowedTools', 'fs,git']));
      expect(args, containsAll(['--disallowedTools', 'exec']));
      expect(args, containsAll(['--permission-mode', 'read-only']));
      expect(args, containsAll(['--model', 'claude-3.5-sonnet']));
      expect(args, contains('--dry-run'));
    });

    test('copyWith updates fields', () {
      const original = ClaudeChatOptions(model: 'claude-3', cwd: '/tmp');
      final updated = original.copyWith(model: 'claude-3.5', cwd: '/work');

      expect(updated.model, equals('claude-3.5'));
      expect(updated.cwd, equals('/work'));
    });
  });
}
