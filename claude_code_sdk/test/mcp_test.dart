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
      final config = McpConfig()
          .addServer(McpServer(name: 's1', command: 'cmd1', args: []))
          .addServer(McpServer(name: 's2', command: 'cmd2', args: []));

      final json = config.toJson();
      expect(json['mcp_servers'], isA<Map>());
      expect((json['mcp_servers'] as Map).keys, containsAll(['s1', 's2']));
    });

    test('should create McpInstallationInfo', () {
      final info = McpInstallationInfo(
        hasMcpSupport: true,
        servers: const [],
        configPath: '/home/.claude/.claude.json',
        mcpVersion: '1.0.0',
      );

      expect(info.hasMcpSupport, isTrue);
      expect(info.configPath, equals('/home/.claude/.claude.json'));
      expect(info.mcpVersion, equals('1.0.0'));

      final notInstalled = McpInstallationInfo.notInstalled();
      expect(notInstalled.hasMcpSupport, isFalse);
      expect(notInstalled.servers, isEmpty);
    });

    test('should handle McpAddOptions', () {
      const options = McpAddOptions(
        scope: McpScope.user,
        useNpx: true,
        environment: {'KEY': 'value'},
        force: true,
      );

      expect(options.scope, equals(McpScope.user));
      expect(options.useNpx, isTrue);
      expect(options.environment, equals({'KEY': 'value'}));
      expect(options.force, isTrue);
    });
  });
}
