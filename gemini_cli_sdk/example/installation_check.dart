import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Get API key from environment
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  
  if (apiKey == 'YOUR_API_KEY') {
    print('⚠️  Please set your GEMINI_API_KEY environment variable');
    print('   You can get your API key from: https://makersuite.google.com/app/apikey');
    print('');
  }

  final geminiSDK = GeminiSDK(apiKey);
  
  print('🔍 Checking Gemini SDK installation...\n');
  
  // Check if Gemini SDK is installed
  final isInstalled = await geminiSDK.isGeminiSDKInstalled();
  
  if (isInstalled) {
    print('✅ Gemini SDK is installed!\n');
  } else {
    print('❌ Gemini SDK is not installed.\n');
    print('Would you like to install it now? (y/n)');
    
    final response = stdin.readLineSync();
    if (response?.toLowerCase() == 'y') {
      print('\n📦 Installing Gemini SDK...\n');
      
      try {
        await geminiSDK.installGeminiSDK(global: true);
        print('\n✅ Installation complete!');
      } catch (e) {
        print('\n❌ Installation failed: $e');
        print('\nYou can manually install it with:');
        print('  npm install -g @google/gemini-cli');
        print('  or');
        print('  brew install gemini-cli');
        return;
      }
    } else {
      print('\nYou can install it later with:');
      print('  npm install -g @google/gemini-cli');
      print('  or');
      print('  brew install gemini-cli');
      return;
    }
  }
  
  // Get SDK information
  print('\n📊 SDK Information:\n');
  final info = await geminiSDK.getSDKInfo();
  
  print('Gemini CLI: ${info['geminiCLI'] ? '✅ Installed' : '❌ Not installed'}');
  if (info['version'] != null) {
    print('Version: ${info['version']}');
  }
  
  // Check MCP status
  if (info['mcp'] != null) {
    final mcp = info['mcp'] as Map<String, dynamic>;
    print('\nMCP (Model Context Protocol):');
    print('  Enabled: ${mcp['enabled'] ? '✅ Yes' : '❌ No'}');
    print('  Configured servers: ${mcp['servers']}');
    if (mcp['configPath'] != null) {
      print('  Config path: ${mcp['configPath']}');
    }
  }
  
  // Check MCP servers in detail
  print('\n🔌 Checking MCP servers...\n');
  final mcpInfo = await geminiSDK.isMcpInstalled();
  
  if (mcpInfo.hasMcpSupport) {
    print('MCP is enabled with ${mcpInfo.servers.length} server(s):');
    for (final server in mcpInfo.servers) {
      print('  • ${server.name}: ${server.status}');
    }
  } else {
    print('No MCP servers configured.');
    print('\nYou can install popular MCP servers using the SDK:');
    print('  - filesystem: File system access');
    print('  - github: GitHub integration');
    print('  - postgres: PostgreSQL database');
    print('  - git: Git operations');
    print('  - puppeteer: Web automation');
    print('\nExample:');
    print("  await geminiSDK.installPopularMcpServer('filesystem');");
  }
  
  if (apiKey != 'YOUR_API_KEY') {
    print('\n🧪 Testing basic functionality...\n');
    
    final chat = geminiSDK.createNewChat();
    try {
      final response = await chat.sendMessage([
        GeminiSdkContent.text('Say "Hello, SDK test successful!" if you can read this.'),
      ]);
      print('Test response: $response');
      print('\n✅ Everything is working correctly!');
    } catch (e) {
      print('❌ Test failed: $e');
    } finally {
      await chat.dispose();
    }
  }
  
  await geminiSDK.dispose();
}