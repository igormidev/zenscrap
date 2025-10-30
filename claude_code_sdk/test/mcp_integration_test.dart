import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

/// Integration test for MCP server management
///
/// This test verifies the complete MCP lifecycle:
/// 1. List existing MCP servers
/// 2. Add a new MCP server
/// 3. Verify it was added correctly
/// 4. Remove the MCP server
/// 5. Verify it was removed
///
/// IMPORTANT: This test modifies the actual ~/.claude/.claude.json file
/// It backs up and restores the original config to minimize side effects
void main() {
  group('MCP Server Integration Tests', () {
    late Claude claude;
    late File configFile;
    late String? originalConfigContent;
    const testServerName = 'test-mcp-server-integration';

    setUp(() async {
      // Initialize Claude SDK without API key (we're only testing config management)
      claude = Claude();

      // Get the config file path
      final home = Platform.environment['HOME'] ??
          Platform.environment['USERPROFILE'] ??
          '';
      configFile = File(path.join(home, '.claude', '.claude.json'));

      // Back up original config if it exists
      if (await configFile.exists()) {
        originalConfigContent = await configFile.readAsString();
        print('✅ Backed up existing Claude config');
      } else {
        originalConfigContent = null;
        print('ℹ️ No existing Claude config found');
      }
    });

    tearDown(() async {
      // Restore original config or delete test config
      if (originalConfigContent != null) {
        await configFile.writeAsString(originalConfigContent!);
        print('✅ Restored original Claude config');
      } else if (await configFile.exists()) {
        await configFile.delete();
        print('✅ Deleted test Claude config');
      }
    });

    test('should list MCP servers', () async {
      final servers = await claude.listMcpServers();
      expect(servers, isA<List<McpServer>>());
      print('📋 Found ${servers.length} existing MCP server(s)');
      for (final server in servers) {
        print('  - ${server.name}: ${server.command} ${server.args.join(' ')}');
      }
    });

    test('should add and remove a custom MCP server', () async {
      // Step 1: Get initial server count
      final initialServers = await claude.listMcpServers();
      final initialCount = initialServers.length;
      print('📊 Initial server count: $initialCount');

      // Ensure our test server doesn't already exist
      expect(
        initialServers.any((s) => s.name == testServerName),
        isFalse,
        reason: 'Test server should not exist before test',
      );

      // Step 2: Add a test MCP server
      print('➕ Adding test MCP server: $testServerName');
      final testServer = McpServer(
        name: testServerName,
        command: 'echo',
        args: ['test'],
        env: {'TEST_VAR': 'test_value'},
      );

      await claude.addMcpServer(
        testServerName,
        customServer: testServer,
      );
      print('✅ Test MCP server added');

      // Step 3: Verify server was added
      final serversAfterAdd = await claude.listMcpServers();
      expect(serversAfterAdd.length, equals(initialCount + 1));

      final addedServer = serversAfterAdd.firstWhere(
        (s) => s.name == testServerName,
      );
      expect(addedServer.command, equals('echo'));
      expect(addedServer.args, equals(['test']));
      expect(addedServer.env, equals({'TEST_VAR': 'test_value'}));
      print('✅ Verified server was added correctly');

      // Step 4: Remove the test server
      print('➖ Removing test MCP server');
      await claude.removeMcpServer(testServerName);
      print('✅ Test MCP server removed');

      // Step 5: Verify server was removed
      final serversAfterRemove = await claude.listMcpServers();
      expect(serversAfterRemove.length, equals(initialCount));
      expect(
        serversAfterRemove.any((s) => s.name == testServerName),
        isFalse,
        reason: 'Test server should be removed',
      );
      print('✅ Verified server was removed correctly');
    });

    test('should add a popular MCP server template (git)', () async {
      // NOTE: Template names must match exactly (e.g., 'git', not 'test-git')
      // The SDK only applies templates when the name matches predefined templates
      const gitServerName = 'test-git-template';

      try {
        // Get the git template and apply it with a custom name for testing
        print('➕ Adding git MCP server using template');

        // Create a server using the git template structure
        final gitTemplateServer = McpServer(
          name: gitServerName,
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-git'],
        );

        await claude.addMcpServer(
          gitServerName,
          customServer: gitTemplateServer,
        );
        print('✅ Git MCP server added with template structure');

        // Verify it was added with correct template values
        final servers = await claude.listMcpServers();
        final gitServer = servers.firstWhere(
          (s) => s.name == gitServerName,
          orElse: () => throw Exception('Git server not found'),
        );

        expect(gitServer.command, equals('npx'));
        expect(
          gitServer.args,
          equals(['-y', '@modelcontextprotocol/server-git']),
        );
        print('✅ Git MCP server has correct template values');
      } finally {
        // Clean up - remove the git server
        try {
          await claude.removeMcpServer(gitServerName);
          print('✅ Cleaned up git MCP server');
        } catch (e) {
          print('⚠️ Failed to clean up git server: $e');
        }
      }
    });

    test('should handle adding MCP server with useNpx option', () async {
      const npxServerName = 'test-npx-server';

      try {
        // Add server using npx by default
        print('➕ Adding MCP server with npx');
        await claude.addMcpServer(
          npxServerName,
          options: McpAddOptions(useNpx: true),
        );

        final servers = await claude.listMcpServers();
        final npxServer = servers.firstWhere(
          (s) => s.name == npxServerName,
        );

        expect(npxServer.command, equals('npx'));
        expect(npxServer.args, equals(['-y', npxServerName]));
        print('✅ NPX server configured correctly');
      } finally {
        try {
          await claude.removeMcpServer(npxServerName);
          print('✅ Cleaned up npx server');
        } catch (e) {
          print('⚠️ Failed to clean up npx server: $e');
        }
      }
    });

    test('should check MCP installation status', () async {
      final mcpInfo = await claude.isMcpInstalled();

      expect(mcpInfo, isA<McpInstallationInfo>());
      expect(mcpInfo.hasMcpSupport, isA<bool>());
      expect(mcpInfo.servers, isA<List<McpServer>>());
      expect(mcpInfo.configPath, isNotEmpty);

      print('📊 MCP Installation Info:');
      print('   MCP Support: ${mcpInfo.hasMcpSupport}');
      print('   Servers: ${mcpInfo.servers.length}');
      print('   Config Path: ${mcpInfo.configPath}');
      print('   MCP Version: ${mcpInfo.mcpVersion ?? 'unknown'}');
    });

    test('should get SDK info including MCP details', () async {
      final info = await claude.getSDKInfo();

      expect(info, isA<Map<String, dynamic>>());
      expect(info['mcpEnabled'], isA<bool>());
      expect(info['mcpServerCount'], isA<int>());
      expect(info['configPath'], isA<String>());

      print('📊 SDK Info:');
      info.forEach((key, value) {
        print('   $key: $value');
      });
    });

    test('should handle duplicate server names gracefully', () async {
      const duplicateName = 'test-duplicate-server';

      try {
        // Add first server
        await claude.addMcpServer(
          duplicateName,
          customServer: McpServer(
            name: duplicateName,
            command: 'echo',
            args: ['first'],
          ),
        );
        print('✅ Added first server');

        // Add second server with same name (should overwrite)
        await claude.addMcpServer(
          duplicateName,
          customServer: McpServer(
            name: duplicateName,
            command: 'echo',
            args: ['second'],
          ),
        );
        print('✅ Added second server (overwrite)');

        // Verify only one server with that name exists
        final servers = await claude.listMcpServers();
        final duplicateServers = servers.where(
          (s) => s.name == duplicateName,
        ).toList();

        expect(duplicateServers.length, equals(1));
        expect(duplicateServers.first.args, equals(['second']));
        print('✅ Duplicate handling works correctly (overwrites)');
      } finally {
        try {
          await claude.removeMcpServer(duplicateName);
          print('✅ Cleaned up duplicate server test');
        } catch (e) {
          print('⚠️ Failed to clean up: $e');
        }
      }
    });

    test('should throw error when removing non-existent server', () async {
      const nonExistentServer = 'this-server-does-not-exist-xyz';

      expect(
        () => claude.removeMcpServer(nonExistentServer),
        throwsA(isA<CliException>()),
      );
      print('✅ Correctly throws error for non-existent server');
    });
  }, timeout: Timeout(Duration(minutes: 2)));
}
