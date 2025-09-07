import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  group('MCP Models', () {
    test('should create McpServer correctly', () {
      final server = McpServer(
        name: 'test-server',
        command: 'node',
        args: ['server.js'],
        env: {'API_KEY': 'test'},
      );

      expect(server.name, equals('test-server'));
      expect(server.command, equals('node'));
      expect(server.args, equals(['server.js']));
      expect(server.env, equals({'API_KEY': 'test'}));
      expect(server.type, equals('stdio'));
    });

    test('should serialize McpServer to JSON', () {
      final server = McpServer(
        name: 'test-server',
        command: 'npx',
        args: ['-y', 'package'],
        env: {'TOKEN': 'abc'},
      );

      final json = server.toJson();
      expect(json['command'], equals('npx'));
      expect(json['args'], equals(['-y', 'package']));
      expect(json['env'], equals({'TOKEN': 'abc'}));
      expect(json['type'], equals('stdio'));
    });

    test('should create McpServer from JSON', () {
      final json = {
        'command': 'python',
        'args': ['script.py'],
        'env': {'PATH': '/usr/bin'},
        'type': 'stdio',
      };

      final server = McpServer.fromJson('python-server', json);
      expect(server.name, equals('python-server'));
      expect(server.command, equals('python'));
      expect(server.args, equals(['script.py']));
      expect(server.env, equals({'PATH': '/usr/bin'}));
    });

    test('should handle McpConfig correctly', () {
      final config = McpConfig();
      expect(config.servers, isEmpty);

      final server = McpServer(
        name: 'test',
        command: 'cmd',
        args: [],
      );

      final updatedConfig = config.addServer(server);
      expect(updatedConfig.servers.length, equals(1));
      expect(updatedConfig.getServer('test'), equals(server));

      final removedConfig = updatedConfig.removeServer('test');
      expect(removedConfig.servers, isEmpty);
    });

    test('should serialize McpConfig to JSON', () {
      final server1 = McpServer(
        name: 'server1',
        command: 'cmd1',
        args: ['arg1'],
      );

      final server2 = McpServer(
        name: 'server2',
        command: 'cmd2',
        args: ['arg2'],
      );

      final config = McpConfig()
          .addServer(server1)
          .addServer(server2);

      final json = config.toJson();
      expect(json['mcpServers'], isA<Map>());
      expect(json['mcpServers']['server1'], isA<Map>());
      expect(json['mcpServers']['server2'], isA<Map>());
    });

    test('should access popular MCP servers', () {
      final servers = PopularMcpServers.availableServers;
      expect(servers, contains('filesystem'));
      expect(servers, contains('github'));
      expect(servers, contains('postgres'));

      final fsServer = PopularMcpServers.getServer('filesystem');
      expect(fsServer, isNotNull);
      expect(fsServer!.name, equals('filesystem'));
      expect(fsServer.command, equals('npx'));
    });

    test('should create McpInstallationInfo', () {
      final servers = [
        McpServer(name: 'test1', command: 'cmd', args: []),
        McpServer(name: 'test2', command: 'cmd', args: []),
      ];

      final info = McpInstallationInfo(
        isClaudeInstalled: true,
        claudeVersion: '1.0.0',
        servers: servers,
        hasMcpSupport: true,
        configPath: '/home/.claude/.claude.json',
      );

      expect(info.isClaudeInstalled, isTrue);
      expect(info.claudeVersion, equals('1.0.0'));
      expect(info.servers.length, equals(2));
      expect(info.hasMcpSupport, isTrue);

      final map = info.toMap();
      expect(map['claude_installed'], isTrue);
      expect(map['claude_version'], equals('1.0.0'));
      expect(map['server_count'], equals(2));
    });

    test('should handle McpAddOptions', () {
      final options = McpAddOptions(
        scope: McpScope.user,
        useNpx: true,
        npxAutoYes: true,
        environment: {'KEY': 'value'},
        additionalArgs: ['--flag'],
        windowsCmdWrapper: false,
      );

      expect(options.scope, equals(McpScope.user));
      expect(options.useNpx, isTrue);
      expect(options.npxAutoYes, isTrue);
      expect(options.environment, equals({'KEY': 'value'}));
      expect(options.additionalArgs, equals(['--flag']));
      expect(options.windowsCmdWrapper, isFalse);
    });
  });
}