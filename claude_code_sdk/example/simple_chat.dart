import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Create SDK instance with your API key
  final claude = Claude('sk-ant-api03-YOUR_API_KEY_HERE');

  // Check if Claude Code SDK is installed
  final isInstalled = await claude.isClaudeCodeSDKInstalled();
  if (!isInstalled) {
    print('Claude Code SDK is not installed.');
    print('Installing Claude Code SDK...');
    await claude.installClaudeCodeSDK();
  }

  // Create a new chat session
  final chat = claude.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a helpful assistant',
      maxTurns: 5,
      timeoutMs: 30000, // 30 seconds timeout
    ),
  );

  print('Chat session created');
  print('Initial session ID: ${chat.sessionId}'); // Will be null initially

  try {
    // Send a simple text message
    print('\nSending first message...');
    final response1 = await chat.sendMessage([
      ClaudeSdkContent.text('Hello! Can you tell me what 2 + 2 equals?'),
    ]);
    print('Response: $response1');
    print('Session ID after first message: ${chat.sessionId}');

    // Send a follow-up message (uses --resume internally)
    print('\nSending follow-up message...');
    final response2 = await chat.sendMessage([
      ClaudeSdkContent.text('What about 3 + 3?'),
    ]);
    print('Response: $response2');

    // Example with schema using new nullable pattern
    print('\nSending message with schema...');
    final schemaResult = await chat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text('Extract the numbers from: "I have 5 apples and 3 oranges"'),
      ],
      schema: SchemaObject(
        properties: {
          'apples': SchemaProperty.number(
            description: 'Number of apples',
            nullable: false, // Required field
          ),
          'oranges': SchemaProperty.number(
            description: 'Number of oranges',
            nullable: false, // Required field
          ),
          'bananas': SchemaProperty.number(
            description: 'Number of bananas if mentioned',
            nullable: true, // Optional field
          ),
        },
      ),
    );
    print('Schema result data: ${schemaResult.structuredSchemaData}');

  } catch (e) {
    print('Error: $e');
  } finally {
    // Clean up
    await chat.dispose();
    await claude.dispose();
  }
}