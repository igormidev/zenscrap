import 'dart:io';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

/// Main example demonstrating the Gemini CLI SDK capabilities
void main() async {
  print('🚀 Gemini CLI SDK Example\n');
  print('=' * 50);
  
  // Get API key from environment or prompt user
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  
  if (apiKey.isEmpty) {
    print('⚠️  Please set your GEMINI_API_KEY environment variable');
    print('   You can get your API key from: https://makersuite.google.com/app/apikey');
    print('\nExample:');
    print('  export GEMINI_API_KEY="your-api-key-here"');
    return;
  }

  // Initialize the SDK
  final geminiSDK = GeminiSDK(apiKey);
  
  // Check if Gemini CLI is installed
  print('\n🔍 Checking Gemini CLI installation...');
  final isInstalled = await geminiSDK.isGeminiCLIInstalled();
  
  if (!isInstalled) {
    print('❌ Gemini CLI is not installed.');
    print('   Install it with: npm install -g @google/gemini-cli');
    print('   Or use: await geminiSDK.installGeminiCLI();');
    return;
  }
  
  print('✅ Gemini CLI is installed!');
  
  // Create a chat session
  print('\n💬 Creating chat session...');
  final chat = geminiSDK.createNewChat(
    options: GeminiChatOptions(
      model: 'gemini-2.5-flash', // Fast model for quick responses
      nonInteractive: true,
    ),
  );
  
  try {
    // Example 1: Simple text message
    print('\n📝 Example 1: Simple text message');
    print('-' * 40);
    
    final response = await chat.sendMessage([
      GeminiSdkContent.text('Hello! Can you explain what the Gemini CLI SDK is in one sentence?'),
    ]);
    
    print('Response: $response');
    
    // Example 2: Schema-based response
    print('\n📋 Example 2: Structured response with schema');
    print('-' * 40);
    
    final schema = SchemaObject(
      properties: {
        'language': SchemaProperty.string(
          description: 'Programming language name',
          nullable: false,
        ),
        'useCase': SchemaProperty.string(
          description: 'Primary use case',
          nullable: false,
        ),
        'popularity': SchemaProperty.string(
          description: 'Popularity level (high/medium/low)',
          nullable: true,
        ),
      },
    );
    
    final schemaResult = await chat.sendMessageWithSchema(
      messages: [
        GeminiSdkContent.text('Tell me about the Dart programming language'),
      ],
      schema: schema,
    );
    
    print('Structured data received:');
    print('  Language: ${schemaResult.structuredSchemaData['language']}');
    print('  Use Case: ${schemaResult.structuredSchemaData['useCase']}');
    print('  Popularity: ${schemaResult.structuredSchemaData['popularity'] ?? 'Not specified'}');
    
    // Example 3: Dynamic model switching
    print('\n🔄 Example 3: Dynamic model switching');
    print('-' * 40);
    
    // Start with flash model for simple task
    print('Current model: ${chat.currentModel}');
    
    final simpleResponse = await chat.sendMessage([
      GeminiSdkContent.text('What is 2+2?'),
    ]);
    print('Simple task response: $simpleResponse');
    
    // Switch to a more capable model for complex tasks
    print('\n🎯 Switching to gemini-2.5-pro for complex task...');
    chat.changeModel('gemini-2.5-pro');
    print('New model: ${chat.currentModel}');
    
    final complexResponse = await chat.sendMessage([
      GeminiSdkContent.text('Explain the implications of quantum computing on cryptography in detail.'),
    ]);
    print('Complex task response (first 200 chars): ${complexResponse.substring(0, complexResponse.length > 200 ? 200 : complexResponse.length)}...');
    
    // You can switch to ultra for the most demanding tasks
    // chat.changeModel('gemini-2.5-ultra');
    
    // Check MCP status
    print('\n🔌 MCP Status:');
    print('-' * 40);
    
    final mcpInfo = await geminiSDK.isMcpInstalled();
    print('MCP Support: ${mcpInfo.hasMcpSupport ? '✅ Enabled' : '❌ Disabled'}');
    print('Configured Servers: ${mcpInfo.servers.length}');
    
    if (mcpInfo.servers.isNotEmpty) {
      for (final server in mcpInfo.servers) {
        print('  • ${server.name}');
      }
    }
    
  } catch (e) {
    print('\n❌ Error: $e');
  } finally {
    // Always dispose of resources
    await chat.dispose();
    await geminiSDK.dispose();
  }
  
  print('\n✅ Example complete!');
  print('\n📚 For more examples, see:');
  print('  • example/basic_usage.dart - Basic messaging');
  print('  • example/file_analysis.dart - File analysis');
  print('  • example/schema_example.dart - Structured responses');
  print('  • example/streaming_example.dart - Streaming');
  print('  • example/mcp_management.dart - MCP servers');
  print('  • example/bytes_content_example.dart - In-memory data');
}
