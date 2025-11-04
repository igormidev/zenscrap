import 'dart:io';
import 'package:web_scrapper_generator/src/implementations/web_scrapper_codex_impl.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/playwright_setup.dart';

void main() async {
  // Get API keys from environment
  final codexApiKey = Platform.environment['OPENAI_API_KEY'] ?? '';
  final scrapingBeeApiKey = Platform.environment['SCRAPING_BEE_API_KEY'] ?? '';

  if (codexApiKey.isEmpty) {
    print('Please set OPENAI_API_KEY environment variable');
    exit(1);
  }

  // Initialize Codex SDK with MCP servers
  print('🚀 Initializing Codex for web scraping...\n');
  await WebScrapperCodexImpl.initCodex(
    codexApiKey: codexApiKey,
    scrappingBeeApiKey: scrapingBeeApiKey,
    proxyConfig: ScrappingBeeProxyConfig(
      apiKey: scrapingBeeApiKey,
      // Optional: customize proxy settings
      // proxyHost: 'proxy.scrapingbee.com',
      // proxyPort: 8886,
      // countryCode: 'us',
    ),
  );

  // Create initial payload for a new web scrapper
  final initialPayload = InitialPayloadDataCreatingFromZero(
    webScrapperRequest: WebScrapperRequest(
      url: 'https://example.com/products/{productId}',
      queryParam: {
        'sort': 'price',
        'filter': null, // Will be provided dynamically
      },
      pathParams: ['productId'],
    ),
    targetExampleUrl:
        'https://example.com/products/123?sort=price&filter=electronics',
  );

  // Start a chat session with Codex
  final codexChat = WebScrapperCodexImpl.startChat(
    initialPayload: initialPayload,
    model: CodexModel
        .gpt5Codex, // Use GPT-5 Codex with powerful reasoning by default
  );

  try {
    // Send first message
    print('💬 Sending request to Codex...\n');
    final response = await codexChat.sendMessage(
      userPrompt: '''
      I need to scrape product information from this e-commerce website.
      Please analyze the page and create extraction rules for:
      - Product title
      - Price
      - Description
      - Images
      - Availability status

      The page uses JavaScript for rendering, so we'll need to handle that.
      ''',
    );

    // Handle the response
    switch (response) {
      case WebScrapperChatAIResponseJustMessage(:final message):
        print('📝 Message from Codex: $message\n');
        break;

      case WebScrapperChatAIResponseErrorMessage(:final errorDescription):
        print('❌ Error: $errorDescription\n');
        break;

      case WebScrapperChatAIResponseOnlyExtractRulesModified(
        :final resumeActionMessage,
        :final fetchSettings,
      ):
        print('✅ Success! Codex created extraction rules.\n');
        print('📋 Summary: $resumeActionMessage\n');

        print('⚙️ Fetch Settings:');
        print('  - URL: ${fetchSettings.url}');
        print('  - Render JS: ${fetchSettings.render_js}');
        print('  - Premium Proxy: ${fetchSettings.premium_proxy}');
        print('  - Extract Rules: ${fetchSettings.extract_rules}');

        if (fetchSettings.js_scenario != null) {
          print('  - JS Scenario: ${fetchSettings.js_scenario}');
        }

        if (fetchSettings.wait != null) {
          print('  - Wait: ${fetchSettings.wait}ms');
        }
        break;

      case WebScrapperChatAIResponseOnlyRequestModified(
        :final resumeActionMessage,
      ):
        print('✅ Success! Codex modified the request structure.\n');
        print('📋 Summary: $resumeActionMessage\n');
        break;

      case WebScrapperChatAIResponseBothModified(
        :final resumeActionMessage,
        :final fetchSettings,
      ):
        print('✅ Success! Codex modified both extraction rules and request.\n');
        print('📋 Summary: $resumeActionMessage\n');
        print('  - Updated fetch settings and request structure');

        print('\n⚙️ Fetch Settings:');
        print('  - URL: ${fetchSettings.url}');
        print('  - Render JS: ${fetchSettings.render_js}');
        print('  - Premium Proxy: ${fetchSettings.premium_proxy}');
        print('  - Extract Rules: ${fetchSettings.extract_rules}');

        if (fetchSettings.js_scenario != null) {
          print('  - JS Scenario: ${fetchSettings.js_scenario}');
        }

        if (fetchSettings.wait != null) {
          print('  - Wait: ${fetchSettings.wait}ms');
        }
        break;
    }

    // Example: Change model mid-conversation
    print('\n🔄 Switching to GPT-5 model for faster analysis...\n');
    await codexChat.changeModel(CodexModel.gpt5);

    // Send another message with the new model
    final refinedResponse = await codexChat.sendMessage(
      userPrompt: '''
      The extraction rules look good, but I also need to handle pagination.
      Can you add support for navigating through multiple pages of products?
      ''',
    );

    switch (refinedResponse) {
      case WebScrapperChatAIResponseJustMessage(:final message):
        print('📝 GPT-5 says: $message\n');
        break;

      case WebScrapperChatAIResponseOnlyExtractRulesModified(
        :final resumeActionMessage,
      ):
        print('✅ GPT-5 updated the extraction rules: $resumeActionMessage\n');
        break;

      case WebScrapperChatAIResponseOnlyRequestModified(
        :final resumeActionMessage,
      ):
        print('✅ GPT-5 updated the request structure: $resumeActionMessage\n');
        break;

      case WebScrapperChatAIResponseBothModified(
        :final resumeActionMessage,
      ):
        print('✅ GPT-5 updated both extraction rules and request: $resumeActionMessage\n');
        break;

      case WebScrapperChatAIResponseErrorMessage(:final errorDescription):
        print('❌ Error: $errorDescription\n');
        break;
    }
  } catch (e) {
    print('💥 Unexpected error: $e');
  } finally {
    // Clean up resources
    await codexChat.dispose();
  }

  print('🎉 Example completed!');
}
