import 'dart:async';

import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import '../playwright_setup.dart';
import '../mcp_adapters.dart';

/// Claude Code SDK implementation of the web scrapper generator
class WebScrapperClaudeImpl
    extends WebScrapperGeneratorController<ClaudeModel> {
  static late final Claude _claudeSDK;

  /// Initialize the Claude SDK and its MCP servers
  static Future<void> initClaude({
    required String claudeApiKey,
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
  }) async {
    // Initialize shared resources first
    await WebScrapperGeneratorController.initShared(
      scrappingBeeApiKey: scrappingBeeApiKey,
      proxyConfig: proxyConfig,
    );

    print('🚀 Initializing Claude SDK for web scraper generator...\n');
    _claudeSDK = Claude(apiKey: claudeApiKey);

    // Add API key to environment so CLI can authenticate
    await _claudeSDK.addApiKeyToEnvironment(claudeApiKey);

    // Ensure Claude Code CLI is installed and up to date
    await _claudeSDK.updateToNewestVersionIfNeeded(global: true);

    // Create adapter for MCP setup
    final adapter = ClaudeMcpAdapter(_claudeSDK);

    // Setup Playwright MCP integration using the unified setup
    await UnifiedPlaywrightSetup.instance.setupWithAdapter(
      adapter,
      proxyConfig: proxyConfig,
    );

    // Setup ScrapingBee MCP server using the unified setup
    await UnifiedScrapingBeeSetup.instance.setupWithAdapter(adapter);
  }

  final ClaudeChat _chat;

  WebScrapperClaudeImpl._(InitialPayloadData initialPayload, ClaudeChat chat)
    : _chat = chat,
      super(initialPayload: initialPayload);

  /// Factory method to create a new chat instance
  static WebScrapperClaudeImpl startChat({
    required InitialPayloadData initialPayload,
    ClaudeModel model = ClaudeModel.claudeSonnet4,
  }) {
    final chat = _claudeSDK.createNewChat(
      options: ClaudeChatOptions(
        systemPrompt: _convertSystemPromptForClaude(),
        model: model.apiName,
        // MCP servers are configured at SDK level in initClaude
      ),
    );

    return WebScrapperClaudeImpl._(initialPayload, chat);
  }

  @override
  Future<void> changeModel(ClaudeModel model) async {
    // Change the model using the new changeModel method
    _chat.changeModel(model.apiName);
    print('✨ Model changed to: ${model.displayName}');
    print('Note: This will start a new conversation session.');
  }

  @override
  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<PromptContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = !_chat.didSendFirstMessage;
    if (isFirstMessage) {
      messages.addAll(_convertInitialPromptsForClaude());
    }

    // Add the user's prompt
    messages.add(PromptContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = webScrapperResponseSchema;

    try {
      // Send message with schema for structured response
      final result = await _chat.sendMessageWithSchema(
        messages: messages,
        schema: responseSchema,
      );

      // Parse the structured response
      return parseStructuredResponse(result.structuredSchemaData);
    } catch (e) {
      // If there's an error, return an error response
      return WebScrapperChatAIResponseErrorMessage(
        'Failed to process your request: ${e.toString()}',
      );
    }
  }

  @override
  ({
    Stream<String> llmMessage,
    Future<WebScrapperChatAIResponse> structuredSchemaDataCompleter,
  })
  streamMessage({required String userPrompt}) {
    List<PromptContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = !_chat.didSendFirstMessage;
    if (isFirstMessage) {
      messages.addAll(_convertInitialPromptsForClaude());
    }

    // Add the user's prompt
    messages.add(PromptContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = webScrapperResponseSchema;

    try {
      // Send message with schema for structured response
      final (
        :Stream<String> llmMessage,
        :Completer<Map<String, dynamic>> structuredSchemaData,
      ) = _chat.streamResponseWithSchema(
        messages: messages,
        schema: responseSchema,
      );

      return (
        llmMessage: llmMessage,
        structuredSchemaDataCompleter: Future(() async {
          return parseStructuredResponse(await structuredSchemaData.future);
        }),
      );
      // parseStructuredResponse(result.structuredSchemaData);
    } catch (e) {
      // If there's an error, return an error response
      final structuredSchema = WebScrapperChatAIResponseErrorMessage(
        'Failed to process your request: ${e.toString()}',
      );

      final controller = StreamController<String>();
      controller.addError(e);
      controller.close();
      return (
        llmMessage: controller.stream,
        structuredSchemaDataCompleter: Future.value(structuredSchema),
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _chat.dispose();
  }

  /// Convert the system prompt to be Claude-compatible
  static String _convertSystemPromptForClaude() {
    // Claude doesn't have MCP support configured yet, so we use a simplified prompt
    return '''You are a world-class expert in web scraping, web automation, and web data extraction with deep knowledge of HTML, CSS, JavaScript, HTTP protocols, and modern web scraping techniques.

## Your Task
You are helping to create web scraping configurations using ScrapingBee API. You will analyze web pages and create extraction rules that work with ScrapingBee's data extraction system.

## ScrapingBee Extraction Rules
You need to create JSON extraction rules using CSS/XPath selectors. See: https://www.scrapingbee.com/documentation/data-extraction/

## Response Format
You MUST respond in a structured JSON format with one of three response types:

### 1. Message Response (responseType: "message")
Use when you need to ask for clarification or provide information.

### 2. Error Response (responseType: "error")
Use when something blocks you from creating extraction rules.

### 3. Data Response (responseType: "data")
Use when you have successfully created extraction rules. Include:
- resumeActionMessage: Summary of what you accomplished
- fetchSettings: The complete ScrapingBee configuration
- request: Modified WebScrapperRequest (or null if unchanged)

## Important Guidelines
1. Create reliable, cost-effective extraction rules
2. Start with premium settings (premium_proxy=true, render_js=true) for testing
3. Optimize for cost after confirming rules work
4. Handle dynamic content with appropriate wait parameters
5. For Google domains, always set custom_google=true

Remember: Your goal is to create extraction rules that consistently retrieve the requested data.''';
  }

  /// Convert initial prompts from Gemini format to Claude format
  List<PromptContent> _convertInitialPromptsForClaude() {
    return List<PromptContent>.from(handleInitialPrompts(initialPayload));
  }
}
