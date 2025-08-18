import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  print('Claude Code SDK Installation Checker');
  print('=====================================\n');

  // Initialize SDK with a dummy key for checking installation
  final claudeSDK = Claude('checking-installation');

  try {
    // Check if Claude Code SDK is installed
    print('Checking Claude Code CLI installation...');
    final isInstalled = await claudeSDK.isClaudeCodeSDKInstalled();

    if (isInstalled) {
      print('✅ Claude Code CLI is installed!');
    } else {
      print('❌ Claude Code CLI is not installed.');
      print('\nWould you like to install it now? (y/n)');
      
      final input = stdin.readLineSync()?.toLowerCase();
      
      if (input == 'y' || input == 'yes') {
        print('\nInstalling Claude Code SDK...');
        print('This may take a few minutes...\n');
        
        try {
          await claudeSDK.installClaudeCodeSDK(global: true);
          print('\n✅ Installation complete!');
        } catch (e) {
          print('\n❌ Installation failed: $e');
          print('\nYou can manually install it with:');
          print('npm install -g @anthropic-ai/claude-code');
        }
      } else {
        print('\nYou can install it manually with:');
        print('npm install -g @anthropic-ai/claude-code');
      }
    }

    // Get detailed SDK information
    print('\n---\n');
    print('Getting SDK information...');
    final info = await claudeSDK.getSDKInfo();
    
    print('\nSDK Status:');
    print('-----------');
    
    // Claude CLI
    if (info['claude_cli_installed'] == true) {
      print('✅ Claude CLI: Installed');
      if (info['claude_cli_version'] != null) {
        print('   Version: ${info['claude_cli_version']}');
      }
    } else {
      print('❌ Claude CLI: Not installed');
    }
    
    // npm
    if (info['npm_installed'] == true) {
      print('✅ npm: Installed');
      if (info['npm_version'] != null) {
        print('   Version: ${info['npm_version']}');
      }
    } else {
      print('❌ npm: Not installed');
      print('   Required for Claude Code CLI');
      print('   Install from: https://nodejs.org/');
    }
    
    // Python SDK
    if (info['python_sdk_installed'] == true) {
      print('✅ Python SDK: Installed');
      if (info['python_sdk_version'] != null) {
        print('   Version: ${info['python_sdk_version']}');
      }
    } else {
      print('⚠️  Python SDK: Not installed (optional)');
      print('   Install with: pip install claude-code-sdk');
    }
    
    // pip
    if (info['pip_installed'] == true) {
      print('✅ pip: Installed');
    } else {
      print('⚠️  pip: Not installed (optional)');
      print('   Required for Python SDK features');
    }
    
    print('\n---\n');
    
    // Check API key
    final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      print('✅ ANTHROPIC_API_KEY environment variable is set');
    } else {
      print('⚠️  ANTHROPIC_API_KEY environment variable is not set');
      print('   Get your API key from: https://console.anthropic.com/');
      print('   Set it with: export ANTHROPIC_API_KEY="your-key-here"');
    }
    
    print('\n---\n');
    print('System Information:');
    print('Platform: ${Platform.operatingSystem}');
    print('Dart Version: ${Platform.version}');
    print('Script: ${Platform.script.path}');
    
    // Test basic functionality if everything is installed
    if (isInstalled && apiKey != null && apiKey.isNotEmpty) {
      print('\n---\n');
      print('Testing basic functionality...');
      
      final testSDK = Claude(apiKey);
      final testChat = testSDK.createNewChat(
        options: ClaudeChatOptions(
          maxTurns: 1,
          timeoutMs: 10000,
        ),
      );
      
      try {
        final result = await testChat.sendMessage([
          ClaudeSdkContent.text('Say "Hello, World!" and nothing else.'),
        ]);
        print('✅ Basic test successful!');
        print('   Response: ${result.trim()}');
      } catch (e) {
        print('❌ Basic test failed: $e');
      } finally {
        await testChat.dispose();
        await testSDK.dispose();
      }
    }
    
  } catch (e) {
    print('Error during installation check: $e');
  } finally {
    await claudeSDK.dispose();
  }
  
  print('\nInstallation check complete!');
}