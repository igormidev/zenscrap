import 'dart:io';

import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:test/test.dart';

/// Test to verify MCP servers are accessible when using API key with enableMcp: true
///
/// This test:
/// 1. Adds a simple MCP server (git)
/// 2. Creates a chat session with enableMcp: true
/// 3. Asks Claude to confirm MCP access
/// 4. Verifies Claude can see and access the MCP server
void main() {
  group('MCP Access Verification', () {
    late Claude claude;
    late String testApiKey;

    setUp(() async {
      // Get API key from environment
      testApiKey =
          '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';

      if (testApiKey.isEmpty) {
        print(
            '⚠️  Skipping test: ANTHROPIC_API_KEY environment variable not set');
        print('   To run this test, set: export ANTHROPIC_API_KEY="your-key"');
        return;
      }

      // Initialize Claude SDK
      claude = Claude(apiKey: testApiKey);

      // Ensure CLI is installed
      final isInstalled = await claude.isClaudeCLIInstalled();
      if (!isInstalled) {
        print('⚠️  Skipping test: Claude CLI not installed');
        print('   To install, run: npm install -g @anthropic-ai/claude-code');
        return;
      }
    });

    tearDown(() async {
      // Clean up - remove test MCP server if it exists
      try {
        await claude.removeMcpServer('test-git-mcp');
      } catch (_) {
        // Ignore errors if server doesn't exist
      }

      await claude.dispose();
    });

    test('should access MCP servers with enableMcp: true', () async {
      if (testApiKey.isEmpty) return; // Skip if no API key

      print(
          '\n🧪 TEST: Verifying MCP server access with API key isolation...\n');

      // Step 1: Add a simple MCP server (git)
      print('📝 Step 1: Adding git MCP server...');
      await claude.addMcpServer(
        'test-git-mcp',
        customServer: McpServer(
          name: 'test-git-mcp',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-git'],
        ),
      );
      print('✅ Git MCP server added\n');

      // Step 2: Verify MCP was added
      print('📝 Step 2: Verifying MCP server is in config...');
      final servers = await claude.listMcpServers();
      final hasTestMcp = servers.any((s) => s.name == 'test-git-mcp');
      expect(hasTestMcp, isTrue, reason: 'Test MCP server should be in config');
      print('✅ MCP server found in config: ${servers.length} total servers\n');
      for (final server in servers) {
        print(
            '   - ${server.name}: ${server.command} ${server.args.join(' ')}');
      }
      print('');

      // Step 3: Create chat with enableMcp: true
      print('📝 Step 3: Creating chat session with enableMcp: true...');
      final chat = claude.createNewChat(
        options: const ClaudeChatOptions(
          enableMcp: true, // This should allow MCP access!
          permissionMode: 'bypassPermissions',
        ),
      );
      print('✅ Chat session created\n');

      // Step 4: Ask Claude to confirm MCP access
      print('📝 Step 4: Asking Claude to confirm MCP server access...');
      print(
          '   Prompt: "List all available MCP tools you have access to. If you can see any MCP tools, respond with CONFIRMED ACCESS followed by the list of tools."');
      print('');

      final response = await chat.sendMessage([
        PromptContent.text(
          'List all available MCP tools you have access to. '
          'If you can see any MCP tools, respond with "CONFIRMED ACCESS" followed by the list of tools. '
          'If you cannot access any MCP tools, respond with "NO ACCESS".',
        ),
      ]);

      print('📨 Claude Response:');
      print('─' * 80);
      print(response);
      print('─' * 80);
      print('');

      // Step 5: Verify response
      final hasAccess = response.contains('CONFIRMED ACCESS') &&
          response.toLowerCase().contains('git');

      if (hasAccess) {
        print('✅ SUCCESS: Claude can access MCP servers!');
        print('   MCP servers are working with API key + enableMcp: true\n');
      } else {
        print('❌ FAILURE: Claude cannot access MCP servers');
        print(
            '   The MCP isolation issue still exists\n\nResponse:\n$response\n');
      }

      expect(
        hasAccess,
        isTrue,
        reason:
            'Claude should be able to access MCP servers when enableMcp: true',
      );

      await chat.dispose();
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('should show environment variables passed to subprocess', () async {
      if (testApiKey.isEmpty) return; // Skip if no API key

      print('\n🔍 DIAGNOSTIC: Checking environment configuration...\n');

      final chat = claude.createNewChat(
        options: const ClaudeChatOptions(
          enableMcp: true,
          permissionMode: 'bypassPermissions',
        ),
      );

      // This test just prints diagnostic info
      print('Chat created with:');
      print('  - enableMcp: true');
      print('  - apiKey: ${testApiKey.substring(0, 10)}...');
      print('  - permissionMode: bypassPermissions');
      print('');

      print('Environment variables that should be passed:');
      print('  - HOME: ${Platform.environment['HOME']}');
      print(
          '  - CLAUDE_HOME: ${Platform.environment['CLAUDE_HOME'] ?? 'not set (will use default)'}');
      print('  - ANTHROPIC_API_KEY: ***');
      print(
          '  - PATH: ${Platform.environment['PATH']?.split(':').take(3).join(':')}...');
      print('');

      final configPath = '${Platform.environment['HOME']}/.claude/.claude.json';
      final configFile = File(configPath);
      print('Config file location: $configPath');
      print('Config file exists: ${configFile.existsSync()}');

      if (configFile.existsSync()) {
        final content = await configFile.readAsString();
        print('Config file size: ${content.length} bytes');
        print('Contains "test-git-mcp": ${content.contains('test-git-mcp')}');
      }
      print('');

      await chat.dispose();
    });
  });
}
