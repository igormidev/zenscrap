import 'dart:io';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  // Get API key from environment variable
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    print('Example: export OPENAI_API_KEY="your-api-key-here"');
    exit(1);
  }

  // Initialize the SDK
  final codexSDK = Codex(apiKey);

  try {
    // Check if Codex CLI is installed
    print('Checking Codex CLI installation...');
    final isInstalled = await codexSDK.isCodexCLIInstalled();

    if (!isInstalled) {
      print('Codex CLI is not installed.');
      print('Would you like to install it? (y/n)');

      final input = stdin.readLineSync();
      if (input?.toLowerCase() == 'y') {
        print('Installing Codex CLI...');
        await codexSDK.installCodexCLI();
        print('Installation complete!');
      } else {
        print('Please install Codex CLI manually:');
        print('npm install -g @openai/codex');
        exit(1);
      }
    } else {
      print('✓ Codex CLI is installed');
    }

    // Get SDK information
    print('\nSDK Information:');
    final info = await codexSDK.getSDKInfo();
    info.forEach((key, value) {
      print('  $key: $value');
    });

    // Create a chat session with options
    print('\nCreating chat session...');
    final chat = codexSDK.createNewChat(
      options: CodexChatOptions(
        systemPrompt: 'You are a helpful AI assistant',
        mode: 'suggest', // Use suggest mode for this example
        outputJson: false,
      ),
    );

    try {
      // Send a message
      print('\nSending message to Codex...');
      final response = await chat.sendMessage([
        CodexSdkContent.text('Hello! Can you explain what Dart is in one sentence?'),
      ]);

      print('\nCodex response:');
      print(response);

      // Example with schema
      print('\n--- Schema Example ---');
      final schema = SchemaObject(
        properties: {
          'language': SchemaProperty.string(
            description: 'The programming language name',
            nullable: false,
          ),
          'paradigm': SchemaProperty.string(
            description: 'The programming paradigm',
            nullable: false,
          ),
          'creator': SchemaProperty.string(
            description: 'Who created it',
            nullable: true,
          ),
        },
        description: 'Information about a programming language',
      );

      final schemaResult = await chat.sendMessageWithSchema(
        messages: [
          CodexSdkContent.text('Give me information about the Dart programming language'),
        ],
        schema: schema,
      );

      print('\nStructured response:');
      print('Message: ${schemaResult.llmMessage}');
      print('Data: ${schemaResult.structuredSchemaData}');
    } finally {
      await chat.dispose();
    }

    // Check MCP installation
    print('\n--- MCP Status ---');
    final mcpInfo = await codexSDK.isMcpInstalled();
    print('MCP Support: ${mcpInfo.hasMcpSupport}');
    print('Configured Servers: ${mcpInfo.servers.length}');

    for (final server in mcpInfo.servers) {
      print('  - ${server.name}');
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  } finally {
    await codexSDK.dispose();
  }
}