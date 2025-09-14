import 'dart:io';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    exit(1);
  }

  final codexSDK = Codex(apiKey);

  try {
    print('=== MCP Server Management Example ===\n');

    // Check current MCP installation status
    print('Checking MCP installation...');
    final mcpInfo = await codexSDK.isMcpInstalled();
    print('MCP Support Enabled: ${mcpInfo.hasMcpSupport}');
    print('Config Path: ${mcpInfo.configPath ?? 'Not configured'}');
    print('Current Servers: ${mcpInfo.servers.length}');

    if (mcpInfo.servers.isNotEmpty) {
      print('\nConfigured MCP Servers:');
      for (final server in mcpInfo.servers) {
        print('  - ${server.name}');
        print('    Command: ${server.command}');
        print('    Args: ${server.args.join(' ')}');
        if (server.env != null && server.env!.isNotEmpty) {
          print('    Environment variables: ${server.env!.keys.join(', ')}');
        }
      }
    }

    // List all available popular servers
    print('\n--- Available Popular MCP Servers ---');
    final popularServers = [
      'filesystem',
      'github',
      'postgres',
      'git',
      'puppeteer',
      'sequential-thinking',
      'slack',
      'google-drive',
    ];

    for (final server in popularServers) {
      print('  - $server');
    }

    // Example: Install filesystem MCP server
    print('\n--- Installing Filesystem MCP Server ---');
    print('Would you like to install the filesystem MCP server? (y/n)');
    final input = stdin.readLineSync();

    if (input?.toLowerCase() == 'y') {
      try {
        await codexSDK.installPopularMcpServer('filesystem');
        print('✓ Filesystem MCP server installed successfully!');
      } catch (e) {
        print('Failed to install filesystem server: $e');
      }
    }

    // Example: Add a custom MCP server
    print('\n--- Adding Custom MCP Server ---');
    print('Adding a custom example MCP server...');

    final customServer = McpServer(
      name: 'my-custom-tool',
      command: 'node',
      args: ['/path/to/my/server.js'],
      env: {
        'API_KEY': 'example-key',
        'DEBUG': 'true',
      },
    );

    try {
      await codexSDK.addMcpServer(
        'my-custom-tool',
        customServer: customServer,
      );
      print('✓ Custom MCP server added successfully!');
    } catch (e) {
      print('Failed to add custom server: $e');
    }

    // Example: Add an npm package as MCP server
    print('\n--- Adding NPM Package as MCP Server ---');
    print('Adding an example npm MCP server...');

    try {
      await codexSDK.addMcpServer(
        'example-npm-server',
        packageName: '@example/mcp-server',
        options: McpAddOptions(
          scope: McpScope.user,
          useNpx: true,
          environment: {
            'CONFIG_PATH': '/path/to/config.json',
          },
        ),
      );
      print('✓ NPM MCP server added successfully!');
    } catch (e) {
      print('Note: Example npm package may not exist: $e');
    }

    // List all servers after modifications
    print('\n--- Updated MCP Server List ---');
    final updatedServers = await codexSDK.listMcpServers();

    if (updatedServers.isEmpty) {
      print('No MCP servers configured');
    } else {
      print('Configured servers:');
      for (final server in updatedServers) {
        print('  - ${server.name}');
      }
    }

    // Get details about a specific server
    if (updatedServers.isNotEmpty) {
      final firstServer = updatedServers.first;
      print('\n--- Server Details: ${firstServer.name} ---');
      final details = await codexSDK.getMcpServerDetails(firstServer.name);
      if (details != null) {
        print('Name: ${details.name}');
        print('Command: ${details.command}');
        print('Arguments: ${details.args.join(' ')}');
        print('Type: ${details.type}');
        if (details.env != null && details.env!.isNotEmpty) {
          print('Environment:');
          details.env!.forEach((key, value) {
            print('  $key: $value');
          });
        }
      }
    }

    // Example: Remove a server
    print('\n--- Removing Example Server ---');
    print('Would you like to remove the example custom server? (y/n)');
    final removeInput = stdin.readLineSync();

    if (removeInput?.toLowerCase() == 'y') {
      try {
        await codexSDK.removeMcpServer('my-custom-tool');
        print('✓ Server removed successfully!');
      } catch (e) {
        print('Failed to remove server: $e');
      }
    }

    // Using MCP servers in a chat session
    print('\n--- Using MCP in Chat Session ---');
    final chat = codexSDK.createNewChat(
      options: CodexChatOptions(
        enableMcp: true,
      ),
    );

    try {
      print('\nIf filesystem MCP is installed, you can now use file operations.');
      print('Example message: "List all files in the current directory"');

      // Only run if we have MCP servers configured
      if (mcpInfo.servers.isNotEmpty || updatedServers.isNotEmpty) {
        final response = await chat.sendMessage([
          CodexSdkContent.text(
            'What MCP tools are available to you right now?',
          ),
        ]);
        print('\nCodex response about available MCP tools:');
        print(response);
      }
    } finally {
      await chat.dispose();
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    await codexSDK.dispose();
  }
}