import 'dart:io';

import 'package:codex_cli_sdk/codex_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    print('Example: export OPENAI_API_KEY="your-api-key-here"');
    exit(1);
  }

  final codexSDK = Codex(apiKey: apiKey);

  try {
    print('Checking Codex CLI installation...');
    final isInstalled = await codexSDK.isCodexCLIInstalled();

    if (!isInstalled) {
      print('Codex CLI is not installed.');
      print('Would you like to install it? (y/n)');

      final input = stdin.readLineSync();
      if (input?.toLowerCase() == 'y') {
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

    print('\nSDK Information:');
    final info = await codexSDK.getSDKInfo();
    info.forEach((key, value) => print('  $key: $value'));

    print('\nCreating chat session...');
    final chat = codexSDK.createNewChat(
      options: const CodexChatOptions(
        systemPrompt: 'You are a helpful AI assistant',
        mode: 'suggest',
      ),
    );

    try {
      print('\nSending message to Codex...');
      final response = await chat.sendMessage([
        PromptContent.text('Explain what Dart is in one sentence.'),
      ]);

      print('\nCodex response:');
      print(response);

      print('\n--- Schema Example ---');
      final schema = SchemaProperty.structuredObject(
        nullable: false,
        properties: {
          'language': SchemaProperty.text(nullable: false),
          'paradigm': SchemaProperty.text(nullable: false),
          'creator': SchemaProperty.text(nullable: true),
        },
      );

      final result = await chat.sendMessageWithSchema(
        messages: [
          PromptContent.text(
              'Give me information about the Dart programming language'),
        ],
        schema: schema as SchemaObject,
      );

      print('\nStructured response:');
      print('Message: ${result.llmMessage}');
      print('Data: ${result.structuredSchemaData}');
    } finally {
      await chat.dispose();
    }

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
