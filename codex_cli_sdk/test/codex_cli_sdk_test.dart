import 'package:codex_cli_sdk/codex_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Codex', () {
    test('creates chat instances without API key', () {
      final sdk = Codex();
      final chat = sdk.createNewChat();
      expect(chat, isA<CodexChat>());
      expect(chat.didSendFirstMessage, isFalse);
      expect(chat.apiKey, isNull);
    });

    test('creates chat instances with API key', () {
      final sdk = Codex(apiKey: 'test-key');
      final chat = sdk.createNewChat();
      expect(chat, isA<CodexChat>());
      expect(chat.didSendFirstMessage, isFalse);
      expect(chat.apiKey, equals('test-key'));
    });

    test('chat can override SDK API key', () {
      final sdk = Codex(apiKey: 'sdk-key');
      final chat = sdk.createNewChat(apiKey: 'chat-key');
      expect(chat.apiKey, equals('chat-key'));
    });

    test('addApiKeyToEnvironment runs without throwing', () async {
      final sdk = Codex();
      await sdk.addApiKeyToEnvironment('secret');
    });
  });

  group('CodexChatOptions', () {
    test('provides sensible defaults', () {
      const options = CodexChatOptions();
      expect(options.systemPrompt, isNull);
      expect(options.model, isNull);
      expect(options.cwd, isNull);
      expect(options.toCliArgs(), isEmpty);
    });

    test('converts to CLI arguments', () {
      const options = CodexChatOptions(
        model: 'gpt-5',
        sandboxMode: 'danger-full-access',
        approvalPolicy: 'never',
        additionalArgs: ['--dry-run'],
      );

      final args = options.toCliArgs();
      expect(args, containsAll(<String>['--model', 'gpt-5']));
      expect(args, containsAll(<String>['--sandbox', 'danger-full-access']));
      expect(args, containsAll(<String>['-c', 'approval_policy="never"']));
      expect(args, contains('--dry-run'));
    });

    test('copyWith updates fields', () {
      const original = CodexChatOptions(model: 'gpt-4o', cwd: '/tmp');
      final updated = original.copyWith(model: 'gpt-5', cwd: '/work');

      expect(updated.model, equals('gpt-5'));
      expect(updated.cwd, equals('/work'));
    });
  });

  group('MCP models', () {
    test('serialises McpServer correctly', () {
      final server = McpServer(
        name: 'filesystem',
        command: 'npx',
        args: ['-y', '@modelcontextprotocol/server-filesystem'],
        env: {'KEY': 'value'},
      );

      final json = server.toJson();
      expect(json['command'], equals('npx'));
      expect(json['args'], contains('@modelcontextprotocol/server-filesystem'));
      expect(json['env']['KEY'], equals('value'));

      final cloned = server.copyWith(command: 'node');
      expect(cloned.command, equals('node'));
      expect(cloned.name, equals('filesystem'));
    });

    test('McpConfig add/remove server', () {
      final config = McpConfig().addServer(
        McpServer(name: 'fs', command: 'npx', args: ['fs']),
      );

      expect(config.servers.containsKey('fs'), isTrue);

      final removed = config.removeServer('fs');
      expect(removed.servers.containsKey('fs'), isFalse);
    });

    test('McpInstallationInfo factories', () {
      final installed = McpInstallationInfo(
        hasMcpSupport: true,
        servers: const [],
        configPath: '/path/to/config',
        mcpVersion: '1.0.0',
      );
      expect(installed.hasMcpSupport, isTrue);
      expect(installed.configPath, equals('/path/to/config'));

      final notInstalled = McpInstallationInfo.notInstalled();
      expect(notInstalled.hasMcpSupport, isFalse);
      expect(notInstalled.servers, isEmpty);
    });

    test('McpAddOptions defaults', () {
      const options = McpAddOptions();
      expect(options.scope, equals(McpScope.user));
      expect(options.useNpx, isFalse);
      expect(options.environment, isNull);
      expect(options.force, isFalse);
    });
  });
}
