// Integration test for the refactored Claude Code SDK
// Run this with your actual API key to test the implementation
// 
// Usage: dart test test/integration_test.dart --api-key=YOUR_API_KEY

import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() {
  // Get API key from environment or command line
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? 
                Platform.environment['CLAUDE_API_KEY'] ?? 
                'sk-ant-api03-YOUR_API_KEY_HERE';

  if (apiKey.contains('YOUR_API_KEY')) {
    print('Skipping integration tests - no API key provided');
    print('Set ANTHROPIC_API_KEY environment variable to run these tests');
    return;
  }

  group('Claude SDK Integration Tests', () {
    late Claude claude;

    setUpAll(() {
      claude = Claude(apiKey);
    });

    tearDownAll(() async {
      await claude.dispose();
    });

    test('should check if Claude Code SDK is installed', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      print('Claude Code SDK installed: $isInstalled');
      
      if (!isInstalled) {
        print('Claude Code SDK is not installed.');
        print('Run: npm install -g @anthropic-ai/claude-code');
        print('Or use: claude.installClaudeCodeSDK()');
      }
    });

    test('should create chat and send message using Process.run', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      if (!isInstalled) {
        print('Skipping test - Claude Code SDK not installed');
        return;
      }

      final chat = claude.createNewChat(
        options: ClaudeChatOptions(
          systemPrompt: 'You are a helpful assistant. Keep responses very brief.',
          timeoutMs: 30000,
        ),
      );

      // Session ID should be null initially
      expect(chat.sessionId, isNull);

      try {
        // Send first message
        print('Sending first message...');
        final response1 = await chat.sendMessage([
          ClaudeSdkContent.text('What is 2 + 2? Reply with just the number.'),
        ]);
        
        print('Response 1: $response1');
        expect(response1, isNotEmpty);
        
        // Session ID should be set after first message
        expect(chat.sessionId, isNotNull);
        final sessionId = chat.sessionId;
        print('Session ID: $sessionId');

        // Send follow-up message (tests --resume functionality)
        print('Sending follow-up message...');
        final response2 = await chat.sendMessage([
          ClaudeSdkContent.text('What about 3 + 3? Reply with just the number.'),
        ]);
        
        print('Response 2: $response2');
        expect(response2, isNotEmpty);
        
        // Session ID should remain the same
        expect(chat.sessionId, equals(sessionId));

      } finally {
        await chat.dispose();
      }
    });

    test('should handle conversation reset', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      if (!isInstalled) {
        print('Skipping test - Claude Code SDK not installed');
        return;
      }

      final chat = claude.createNewChat();

      try {
        // Send first message
        await chat.sendMessage([
          ClaudeSdkContent.text('Remember: the secret word is "banana"'),
        ]);
        
        final firstSessionId = chat.sessionId;
        expect(firstSessionId, isNotNull);
        
        // Reset conversation
        chat.resetConversation();
        expect(chat.sessionId, isNull);
        
        // Send new message (should start a new session)
        await chat.sendMessage([
          ClaudeSdkContent.text('What is 1 + 1?'),
        ]);
        
        final newSessionId = chat.sessionId;
        expect(newSessionId, isNotNull);
        expect(newSessionId, isNot(equals(firstSessionId)));
        
      } finally {
        await chat.dispose();
      }
    });

    test('should handle bytes content', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      if (!isInstalled) {
        print('Skipping test - Claude Code SDK not installed');
        return;
      }

      final chat = claude.createNewChat();

      try {
        // Create some test data
        final testData = 'This is test data in bytes format'.codeUnits;
        final bytes = Uint8List.fromList(testData);
        
        final response = await chat.sendMessage([
          ClaudeSdkContent.text('Can you read this file?'),
          ClaudeSdkContent.bytes(
            data: bytes,
            fileName: 'test',
            fileExtension: 'txt',
          ),
        ]);
        
        print('Response to bytes content: $response');
        expect(response, isNotEmpty);
        
      } finally {
        await chat.dispose();
      }
    });
    
    test('should handle schema-based messages', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      if (!isInstalled) {
        print('Skipping test - Claude Code SDK not installed');
        return;
      }

      final chat = claude.createNewChat();

      try {
        final result = await chat.sendMessageWithSchema(
          messages: [
            ClaudeSdkContent.text('I have 5 apples and 3 oranges. Extract these numbers.'),
          ],
          schema: SchemaObject(
            properties: {
              'apples': SchemaProperty.number(description: 'Number of apples'),
              'oranges': SchemaProperty.number(description: 'Number of oranges'),
            },
            required: ['apples', 'oranges'],
          ),
        );
        
        print('Schema result: ${result.structuredSchemaData}');
        expect(result.structuredSchemaData, isNotEmpty);
        
      } finally {
        await chat.dispose();
      }
    });

    test('should handle errors gracefully', () async {
      final isInstalled = await claude.isClaudeCodeSDKInstalled();
      if (!isInstalled) {
        print('Skipping test - Claude Code SDK not installed');
        return;
      }

      // Create chat with very short timeout
      final chat = claude.createNewChat(
        options: ClaudeChatOptions(
          timeoutMs: 1, // 1ms timeout - should fail
        ),
      );

      try {
        await expectLater(
          chat.sendMessage([
            ClaudeSdkContent.text('This should timeout'),
          ]),
          throwsA(isA<ClaudeSDKException>()),
        );
      } finally {
        await chat.dispose();
      }
    });

    test('should get SDK info', () async {
      final info = await claude.getSDKInfo();
      print('SDK Info:');
      info.forEach((key, value) {
        print('  $key: $value');
      });
      
      expect(info.containsKey('claude_cli_installed'), isTrue);
      expect(info.containsKey('npm_installed'), isTrue);
      expect(info.containsKey('python_sdk_installed'), isTrue);
      expect(info.containsKey('pip_installed'), isTrue);
    });
  });
}