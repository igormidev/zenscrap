import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

/// Main example demonstrating the Claude Code SDK usage
void main() async {
  // Get API key from environment variable
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
  
  if (apiKey == null || apiKey.isEmpty) {
    print('Please set ANTHROPIC_API_KEY environment variable');
    print('export ANTHROPIC_API_KEY="your-api-key-here"');
    exit(1);
  }

  // Initialize the SDK
  final claudeSDK = Claude(apiKey);

  // Check if Claude Code CLI is installed
  final isInstalled = await claudeSDK.isClaudeCodeSDKInstalled();
  if (!isInstalled) {
    print('Claude Code CLI is not installed.');
    print('Installing...');
    await claudeSDK.installClaudeCodeSDK();
  }

  // Create a chat session
  final chat = claudeSDK.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a helpful assistant',
      maxTurns: 3,
    ),
  );

  try {
    // Send a simple message
    print('Sending message to Claude...');
    final response = await chat.sendMessage([
      ClaudeSdkContent.text('Hello Claude! Please introduce yourself briefly.'),
    ]);
    
    print('Response: $response');

    // Example with schema
    final schema = SchemaObject(
      properties: {
        'greeting': SchemaProperty.string(
          description: 'A greeting message',
        ),
        'name': SchemaProperty.string(
          description: 'Your name',
        ),
        'capabilities': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'List of your main capabilities',
        ),
      },
      required: ['greeting', 'name'],
    );

    print('\nSending message with schema...');
    final schemaResult = await chat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text('Please introduce yourself'),
      ],
      schema: schema,
    );

    print('Structured response:');
    print('  Greeting: ${schemaResult.structuredSchemaData['greeting']}');
    print('  Name: ${schemaResult.structuredSchemaData['name']}');
    print('  Capabilities: ${schemaResult.structuredSchemaData['capabilities']}');
    
  } catch (e) {
    print('Error: $e');
  } finally {
    // Always dispose of resources
    await chat.dispose();
    await claudeSDK.dispose();
  }
}
