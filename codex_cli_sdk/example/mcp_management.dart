import 'dart:io';

import 'package:codex_cli_sdk/codex_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    exit(1);
  }

  final codexSDK = Codex(apiKey: apiKey);

  try {
    print('=== MCP Server Management Example ===\n');

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

    print('\n--- Available Popular MCP Servers ---');
    const popularServers = [
      'filesystem',
      'github',
      'postgres',
      'git',
      'sequential-thinking',
      'slack',
      'google-drive',
    ];
    for (final server in popularServers) {
      print('  - $server');
    }

    print('\n--- Installing Filesystem MCP Server ---');
    stdout.write('Install the filesystem MCP server? (y/n) ');
    final input = stdin.readLineSync();

    if (input?.toLowerCase() == 'y') {
      try {
        await codexSDK.installPopularMcpServer('filesystem');
        print('✓ Filesystem MCP server installed successfully!');
      } catch (e) {
        print('Failed to install filesystem server: $e');
      }
    }

    print('\n--- Adding Custom MCP Server ---');
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

    print('\n--- Adding NPM Package as MCP Server ---');
    try {
      await codexSDK.addMcpServer(
        'example-npm-server',
        customServer: McpServer(
          name: 'example-npm-server',
          command: 'npx',
          args: ['-y', '@example/mcp-server'],
        ),
        options: const McpAddOptions(
          scope: McpScope.user,
          useNpx: true,
        ),
      );
      print('✓ NPM MCP server added successfully!');
    } catch (e) {
      print('Note: Example npm package may not exist: $e');
    }

    print('\n--- Updated MCP Server List ---');
    final updatedServers = await codexSDK.listMcpServers();
    if (updatedServers.isEmpty) {
      print('No MCP servers configured');
    } else {
      for (final server in updatedServers) {
        print('  - ${server.name}');
      }
    }

    if (updatedServers.isNotEmpty) {
      final firstServer = updatedServers.first;
      print('\n--- Server Details: ${firstServer.name} ---');
      final details = await codexSDK.getMcpServerDetails(firstServer.name);
      if (details != null) {
        print('Name: ${details.name}');
        print('Command: ${details.command}');
        print('Arguments: ${details.args.join(' ')}');
        if (details.env != null && details.env!.isNotEmpty) {
          print('Environment:');
          details.env!.forEach((key, value) {
            print('  $key: $value');
          });
        }
      }
    }

    print('\n--- Removing Example Server ---');
    stdout.write('Remove the example custom server? (y/n) ');
    final removeInput = stdin.readLineSync();

    if (removeInput?.toLowerCase() == 'y') {
      try {
        await codexSDK.removeMcpServer('my-custom-tool');
        print('✓ Server removed successfully!');
      } catch (e) {
        print('Failed to remove server: $e');
      }
    }

    print('\n--- Using MCP in Chat Session ---');
    final chat = codexSDK.createNewChat(
      options: const CodexChatOptions(enableMcp: true),
    );

    try {
      if (mcpInfo.servers.isNotEmpty || updatedServers.isNotEmpty) {
        final response = await chat.sendMessage([
          PromptContent.text('What MCP tools are available to you right now?'),
        ]);
        print('\nCodex response about available MCP tools:');
        print(response);
      } else {
        print('No MCP servers configured, skipping chat demonstration.');
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
