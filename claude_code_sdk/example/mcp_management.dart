import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

/// Example demonstrating MCP (Model Context Protocol) management
/// 
/// This example shows how to:
/// - Check MCP installation status
/// - List configured MCP servers
/// - Add new MCP servers
/// - Install popular MCP servers
/// - Remove MCP servers
/// - Get details about specific servers
void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('Please set ANTHROPIC_API_KEY environment variable');
    exit(1);
  }

  final claude = Claude(apiKey);

  try {
    // Check if MCP is installed and get information
    print('Checking MCP installation status...\n');
    final mcpInfo = await claude.isMcpInstalled();
    
    print('MCP Installation Info:');
    print('  Claude installed: ${mcpInfo.isClaudeInstalled}');
    print('  Claude version: ${mcpInfo.claudeVersion ?? "N/A"}');
    print('  MCP support: ${mcpInfo.hasMcpSupport}');
    print('  Config path: ${mcpInfo.configPath ?? "N/A"}');
    print('  Configured servers: ${mcpInfo.servers.length}');
    
    if (mcpInfo.servers.isNotEmpty) {
      print('\n  Server list:');
      for (final server in mcpInfo.servers) {
        print('    - ${server.name} (${server.status?.name ?? "unknown"})');
      }
    }

    // Check if Claude is installed
    if (!mcpInfo.isClaudeInstalled) {
      print('\n⚠️  Claude Code CLI is not installed.');
      print('Would you like to install it? (y/n)');
      
      final input = stdin.readLineSync();
      if (input?.toLowerCase() == 'y') {
        print('\nInstalling Claude Code SDK...');
        await claude.installClaudeCodeSDK();
      } else {
        print('Exiting. Please install Claude Code CLI to use MCP features.');
        exit(0);
      }
    }

    // List available popular MCP servers
    print('\n' + '=' * 50);
    print('Available Popular MCP Servers:');
    print('=' * 50);
    
    final popularServers = claude.getPopularMcpServers();
    for (var i = 0; i < popularServers.length; i++) {
      print('  ${i + 1}. ${popularServers[i]}');
    }

    // Example: Install filesystem MCP server
    print('\n' + '=' * 50);
    print('Example: Installing Filesystem MCP Server');
    print('=' * 50);
    
    print('\nWould you like to install the filesystem MCP server? (y/n)');
    print('This will give Claude access to specified directories.');
    
    final installFs = stdin.readLineSync();
    if (installFs?.toLowerCase() == 'y') {
      print('\nInstalling filesystem MCP server...');
      await claude.installPopularMcpServer('filesystem');
      print('✅ Filesystem MCP server installed!');
      
      // List servers again to show the new one
      final updatedServers = await claude.listMcpServers();
      print('\nUpdated server list:');
      for (final server in updatedServers) {
        print('  - ${server.name}: ${server.command} ${server.args.join(" ")}');
      }
    }

    // Example: Add a custom MCP server
    print('\n' + '=' * 50);
    print('Example: Adding a Custom MCP Server');
    print('=' * 50);
    
    print('\nWould you like to see how to add a custom MCP server? (y/n)');
    final addCustom = stdin.readLineSync();
    
    if (addCustom?.toLowerCase() == 'y') {
      // Create a custom server configuration
      final customServer = McpServer(
        name: 'my-custom-server',
        command: 'node',
        args: ['path/to/server.js'],
        env: {
          'API_KEY': 'your-api-key-here',
          'DEBUG': 'true',
        },
      );
      
      print('\nAdding custom MCP server configuration:');
      print('  Name: ${customServer.name}');
      print('  Command: ${customServer.command}');
      print('  Args: ${customServer.args}');
      print('  Environment: ${customServer.env}');
      
      await claude.addMcpServer(
        'my-custom-server',
        customServer: customServer,
      );
      
      print('✅ Custom server added!');
    }

    // Example: Get details about a specific server
    print('\n' + '=' * 50);
    print('Example: Getting Server Details');
    print('=' * 50);
    
    final servers = await claude.listMcpServers();
    if (servers.isNotEmpty) {
      final firstServer = servers.first;
      print('\nGetting details for server: ${firstServer.name}');
      
      final details = await claude.getMcpServerDetails(firstServer.name);
      if (details != null) {
        print('  Command: ${details.command}');
        print('  Args: ${details.args.join(" ")}');
        if (details.env != null && details.env!.isNotEmpty) {
          print('  Environment variables:');
          details.env!.forEach((key, value) {
            print('    $key: ${value.isEmpty ? "(not set)" : value}');
          });
        }
      }
    }

    // Example: Remove a server
    print('\n' + '=' * 50);
    print('Example: Removing an MCP Server');
    print('=' * 50);
    
    if (servers.any((s) => s.name == 'my-custom-server')) {
      print('\nWould you like to remove the custom server we added? (y/n)');
      final removeCustom = stdin.readLineSync();
      
      if (removeCustom?.toLowerCase() == 'y') {
        print('Removing my-custom-server...');
        await claude.removeMcpServer('my-custom-server');
        print('✅ Server removed!');
      }
    }

    // Show final SDK info including MCP status
    print('\n' + '=' * 50);
    print('Final SDK Information');
    print('=' * 50);
    
    final sdkInfo = await claude.getSDKInfo();
    print('\nComplete SDK Info:');
    sdkInfo.forEach((key, value) {
      if (value is List) {
        print('  $key: ${value.join(", ")}');
      } else {
        print('  $key: $value');
      }
    });

    // Using MCP-enabled chat
    print('\n' + '=' * 50);
    print('Using MCP in Chat Sessions');
    print('=' * 50);
    
    print('\nMCP servers are automatically available in chat sessions.');
    print('Example: If you have the filesystem MCP server installed,');
    print('Claude can read and write files in the configured directories.');
    
    print('\nWould you like to start a chat session with MCP support? (y/n)');
    final startChat = stdin.readLineSync();
    
    if (startChat?.toLowerCase() == 'y') {
      final chat = claude.createNewChat();
      
      print('\nStarting chat with MCP support...');
      print('Available MCP servers will be accessible to Claude.');
      print('Try asking Claude to list files if you have filesystem MCP installed!\n');
      
      final response = await chat.sendMessage([
        TextContent('Hello! Can you tell me what MCP servers are available to you?'),
      ]);
      
      print('Claude: $response\n');
      
      await chat.dispose();
    }

  } catch (e) {
    print('Error: $e');
  } finally {
    await claude.dispose();
  }

  print('\n✅ MCP management example completed!');
}