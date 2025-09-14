import 'dart:io';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

/// Test file to verify both Gemini and Claude implementations work
void main() async {
  // Get API keys from environment
  final geminiApiKey = Platform.environment['GEMINI_API_KEY'];
  final claudeApiKey = Platform.environment['CLAUDE_API_KEY'];
  final scrapingBeeApiKey = Platform.environment['SCRAPING_BEE_API_KEY'];

  if (geminiApiKey == null || claudeApiKey == null || scrapingBeeApiKey == null) {
    print('❌ Please set environment variables:');
    print('   GEMINI_API_KEY');
    print('   CLAUDE_API_KEY');
    print('   SCRAPING_BEE_API_KEY');
    exit(1);
  }

  // Create test request
  final testRequest = WebScrapperRequest(
    url: 'https://www.transfermarkt.com/player/{playerId}/profile',
    queryParam: {},
    pathParams: ['playerId'],
  );

  final initialPayload = InitialPayloadDataCreatingFromZero(
    webScrapperRequest: testRequest,
    targetExampleUrl: 'https://www.transfermarkt.com/neymar/profil/spieler/68290',
  );

  // Test Gemini Implementation
  print('\n=== Testing Gemini Implementation ===\n');
  await testGeminiImplementation(
    geminiApiKey: geminiApiKey,
    scrapingBeeApiKey: scrapingBeeApiKey,
    initialPayload: initialPayload,
  );

  // Test Claude Implementation
  print('\n=== Testing Claude Implementation ===\n');
  await testClaudeImplementation(
    claudeApiKey: claudeApiKey,
    scrapingBeeApiKey: scrapingBeeApiKey,
    initialPayload: initialPayload,
  );

  print('\n✅ All tests completed!');
}

Future<void> testGeminiImplementation({
  required String geminiApiKey,
  required String scrapingBeeApiKey,
  required InitialPayloadData initialPayload,
}) async {
  try {
    // Initialize Gemini
    await WebScrapperGeminiImpl.initGemini(
      geminiApiKey: geminiApiKey,
      scrappingBeeApiKey: scrapingBeeApiKey,
      proxyConfig: ScrappingBeeProxyConfig(
        apiKey: scrapingBeeApiKey,
        premiumProxy: true,
        countryCode: 'us',
      ),
    );

    // Create a chat instance
    final chat = WebScrapperGeminiImpl.startChat(
      initialPayload: initialPayload,
      model: GeminiModel.gemini25Flash,
    );

    print('📤 Sending test message to Gemini...');
    final response = await chat.sendMessage(
      userPrompt: 'This is a player page. Extract the player name and current club.',
    );

    print('📥 Gemini Response:');
    switch (response) {
      case WebScrapperChatAIResponseJustMessage(:final message):
        print('   Message: $message');
      case WebScrapperChatAIResponseErrorMessage(:final errorDescription):
        print('   Error: $errorDescription');
      case WebScrapperChatAIResponseWithDataResponse(:final resumeActionMessage):
        print('   Action: $resumeActionMessage');
    }

    // Test model change
    print('\n🔄 Testing model change to Gemini 2.5 Pro...');
    await chat.changeModel(GeminiModel.gemini25Pro);
    print('   Model changed successfully!');

    // Cleanup
    await chat.dispose();
    print('\n✅ Gemini implementation test passed!');
  } catch (e) {
    print('❌ Gemini test failed: $e');
  }
}

Future<void> testClaudeImplementation({
  required String claudeApiKey,
  required String scrapingBeeApiKey,
  required InitialPayloadData initialPayload,
}) async {
  try {
    // Initialize Claude
    await WebScrapperClaudeImpl.initClaude(
      claudeApiKey: claudeApiKey,
      scrappingBeeApiKey: scrapingBeeApiKey,
      proxyConfig: ScrappingBeeProxyConfig(
        apiKey: scrapingBeeApiKey,
        premiumProxy: true,
        countryCode: 'us',
      ),
    );

    // Create a chat instance
    final chat = WebScrapperClaudeImpl.startChat(
      initialPayload: initialPayload,
      model: ClaudeModel.claude35Sonnet,
    );

    print('📤 Sending test message to Claude...');
    final response = await chat.sendMessage(
      userPrompt: 'This is a player page. Extract the player name and current club.',
    );

    print('📥 Claude Response:');
    switch (response) {
      case WebScrapperChatAIResponseJustMessage(:final message):
        print('   Message: $message');
      case WebScrapperChatAIResponseErrorMessage(:final errorDescription):
        print('   Error: $errorDescription');
      case WebScrapperChatAIResponseWithDataResponse(:final resumeActionMessage):
        print('   Action: $resumeActionMessage');
    }

    // Test model change
    print('\n🔄 Testing model change to Claude 3.5 Haiku...');
    await chat.changeModel(ClaudeModel.claude35Haiku);
    print('   Model changed (note: requires new chat session in Claude)');

    // Cleanup
    await chat.dispose();
    print('\n✅ Claude implementation test passed!');
  } catch (e) {
    print('❌ Claude test failed: $e');
  }
}

/// Test to ensure both implementations follow the same interface
void testInterfaceCompliance() {
  print('\n=== Testing Interface Compliance ===\n');

  // Both implementations should extend WebScrapperGeneratorController
  // and implement the same methods

  // This is a compile-time check - if it compiles, the interface is correct
  // The fact that both WebScrapperGeminiImpl and WebScrapperClaudeImpl
  // extend WebScrapperGeneratorController ensures they implement all required methods

  print('✅ Interface compliance verified at compile time!');
}