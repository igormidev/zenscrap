import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  
  if (apiKey == 'YOUR_API_KEY') {
    print('Please set your GEMINI_API_KEY environment variable');
    print('You can get your API key from: https://makersuite.google.com/app/apikey');
    return;
  }

  final geminiSDK = GeminiSDK(apiKey);
  
  print('🔌 MCP (Model Context Protocol) Management Example\n');
  print('=' * 50);
  
  // Check current MCP status
  print('\n📊 Current MCP Status:\n');
  final mcpInfo = await geminiSDK.isMcpInstalled();
  
  print('MCP Support: ${mcpInfo.hasMcpSupport ? '✅ Enabled' : '❌ Disabled'}');
  print('Config Path: ${mcpInfo.configPath ?? 'Not found'}');
  print('Configured Servers: ${mcpInfo.servers.length}');
  
  if (mcpInfo.servers.isNotEmpty) {
    print('\nExisting servers:');
    for (final server in mcpInfo.servers) {
      print('  • ${server.name}: ${server.status}');
    }
  }
  
  // List available popular servers
  print('\n📦 Available Popular MCP Servers:\n');
  final popularServers = PopularMcpServers.list();
  for (final serverName in popularServers) {
    final config = PopularMcpServers.getServer(serverName);
    print('  • $serverName: ${config?['description']}');
    if (config?['requiredEnv'] != null) {
      final envVars = (config!['requiredEnv'] as List).join(', ');
      print('    Required env: $envVars');
    }
  }
  
  // Interactive installation
  print('\n🎯 Would you like to install a popular MCP server? (y/n)');
  final response = stdin.readLineSync();
  
  if (response?.toLowerCase() == 'y') {
    print('\nWhich server would you like to install?');
    print('Options: ${popularServers.join(', ')}');
    print('Enter server name (or press Enter to skip): ');
    
    final serverChoice = stdin.readLineSync();
    
    if (serverChoice != null && serverChoice.isNotEmpty) {
      if (PopularMcpServers.isPopular(serverChoice)) {
        print('\n📦 Installing $serverChoice MCP server...\n');
        
        try {
          // Check if environment variables are needed
          final config = PopularMcpServers.getServer(serverChoice);
          Map<String, String>? environment;
          
          if (config?['requiredEnv'] != null) {
            environment = {};
            final requiredEnv = config!['requiredEnv'] as List;
            
            print('This server requires the following environment variables:');
            for (final envVar in requiredEnv) {
              print('Enter value for $envVar (or press Enter to skip): ');
              final value = stdin.readLineSync();
              if (value != null && value.isNotEmpty) {
                environment[envVar as String] = value;
              }
            }
          }
          
          await geminiSDK.installPopularMcpServer(
            serverChoice,
            environment: environment,
          );
          
          print('\n✅ Successfully installed $serverChoice MCP server!');
        } catch (e) {
          print('\n❌ Failed to install: $e');
        }
      } else {
        print('Invalid server name. Please choose from: ${popularServers.join(', ')}');
      }
    }
  }
  
  // List all configured servers
  print('\n📋 All Configured MCP Servers:\n');
  final servers = await geminiSDK.listMcpServers();
  
  if (servers.isEmpty) {
    print('No MCP servers configured.');
  } else {
    for (final server in servers) {
      print('Server: ${server.name}');
      print('  Command: ${server.command}');
      print('  Args: ${server.args.join(' ')}');
      if (server.env != null && server.env!.isNotEmpty) {
        print('  Environment variables: ${server.env!.keys.join(', ')}');
      }
      print('');
    }
  }
  
  // Example of adding a custom MCP server
  print('💡 Example: Adding a custom MCP server\n');
  print('You can add custom MCP servers programmatically:');
  print('''
// Add a custom MCP server
final customServer = McpServer(
  name: 'my-custom-server',
  command: 'node',
  args: ['path/to/server.js'],
  env: {'API_KEY': 'your-api-key'},
);

await geminiSDK.addMcpServer(
  'my-custom-server',
  customServer: customServer,
);
''');
  
  // Example of using MCP in chat
  if (mcpInfo.hasMcpSupport && mcpInfo.servers.isNotEmpty) {
    print('\n🧪 Testing MCP functionality...\n');
    
    final chat = geminiSDK.createNewChat();
    try {
      print('Sending a message that might use MCP tools...\n');
      
      final response = await chat.sendMessage([
        GeminiSdkContent.text(
          'Can you list what MCP tools are available to you? Just list their names if any are available.',
        ),
      ]);
      
      print('Response: $response');
    } catch (e) {
      print('Error: $e');
    } finally {
      await chat.dispose();
    }
  }
  
  await geminiSDK.dispose();
  print('\n✅ MCP management example complete!');
}