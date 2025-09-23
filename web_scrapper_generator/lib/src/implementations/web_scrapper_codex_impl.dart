import 'dart:async';

import 'package:codex_cli_sdk/codex_cli_sdk.dart'
    show Codex, CodexChat, CodexChatOptions;
import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart'
    show PromptContent, SchemaObject, SchemaProperty;
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' as gemini_sdk;
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/schema_constants.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import '../puppeteer_setup.dart';
import '../mcp_adapters.dart';

/// Codex CLI SDK implementation of the web scrapper generator
class WebScrapperCodexImpl extends WebScrapperGeneratorController<CodexModel> {
  static late final Codex _codexSDK;

  /// Initialize the Codex SDK and its MCP servers
  static Future<void> initCodex({
    required String codexApiKey,
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
  }) async {
    // Initialize shared resources first
    await WebScrapperGeneratorController.initShared(
      scrappingBeeApiKey: scrappingBeeApiKey,
      proxyConfig: proxyConfig,
    );

    print('🚀 Initializing Codex SDK for web scraper generator...\n');
    _codexSDK = Codex(apiKey: codexApiKey);

    // Ensure Codex CLI is installed and up to date
    await _codexSDK.updateToNewestVersionIfNeeded(global: true);

    // Create adapter for MCP setup
    final adapter = CodexMcpAdapter(_codexSDK);

    // Setup Puppeteer MCP integration using the unified setup
    await UnifiedPuppeteerSetup.instance.setupWithAdapter(
      adapter,
      proxyConfig: proxyConfig,
    );

    // Setup ScrapingBee MCP server using the unified setup
    await UnifiedScrapingBeeSetup.instance.setupWithAdapter(adapter);
  }

  final CodexChat _chat;

  WebScrapperCodexImpl._(InitialPayloadData initialPayload, CodexChat chat)
    : _chat = chat,
      super(initialPayload: initialPayload);

  /// Factory method to create a new chat instance
  static WebScrapperCodexImpl startChat({
    required InitialPayloadData initialPayload,
    CodexModel model = CodexModel.gptOss120b,
  }) {
    final chat = _codexSDK.createNewChat(
      options: CodexChatOptions(
        systemPrompt: _convertSystemPromptForCodex(),
        model: model.apiName,
        enableMcp: true, // Enable MCP support
        sandboxMode: 'danger-full-access',
        approvalPolicy: 'never',
        // Note: Removed mode as Codex exec doesn't support --auto-edit
        outputJson: false, // We'll use schema for structured output
      ),
    );

    return WebScrapperCodexImpl._(initialPayload, chat);
  }

  @override
  Future<void> changeModel(CodexModel model) async {
    // Change the model using the changeModel method
    _chat.changeModel(model.apiName);
    print('✨ Model changed to: ${model.displayName}');
    print('Note: This will start a new conversation session.');
  }

  /// Changes the model with a specific reasoning effort level
  Future<void> changeModelWithEffort(
    CodexModel model,
    String reasoningEffort,
  ) async {
    _chat.changeModelWithEffort(model.apiName, reasoningEffort);
    print(
      '✨ Model changed to: ${model.displayName} with $reasoningEffort reasoning effort',
    );
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
      messages.addAll(_convertInitialPromptsForCodex());
    }

    // Add the user's prompt
    messages.add(PromptContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = buildCodexResponseSchema();

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
      messages.addAll(_convertInitialPromptsForCodex());
    }

    // Add the user's prompt
    messages.add(PromptContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = buildCodexResponseSchema();

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

  /// Convert the system prompt to be Codex-compatible
  static String _convertSystemPromptForCodex() {
    // Codex has MCP support configured, so we use the full prompt with MCP tools
    return '''You are a world-class expert in web scraping, web automation, and web data extraction with deep knowledge of HTML, CSS, JavaScript, HTTP protocols, and modern web scraping techniques.

## Your Task
You are helping to create web scraping configurations using ScrapingBee API. You will analyze web pages and create extraction rules that work with ScrapingBee's data extraction system.

## Available MCP Tools
You have access to two powerful MCP servers:

### 1. Puppeteer MCP Server
Use the puppeteer tools to navigate and interact with web pages:
- puppeteer_navigate: Navigate to URLs and interact with pages
- puppeteer_screenshot: Take screenshots of pages
- puppeteer_click: Click on elements
- puppeteer_fill: Fill in form fields
- puppeteer_select: Select dropdown options
- puppeteer_evaluate: Execute JavaScript in the page context

### 2. ScrapingBee MCP Server
Use the test_extract_rules tool to validate your extraction rules:
- test_extract_rules: Test extraction rules against real web pages using ScrapingBee API

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
1. Use MCP tools to inspect and test pages before creating extraction rules
2. Always test extraction rules with test_extract_rules before finalizing
3. Create reliable, cost-effective extraction rules
4. Start with premium settings (premium_proxy=true, render_js=true) for testing
5. Optimize for cost after confirming rules work
6. Handle dynamic content with appropriate wait parameters
7. For Google domains, always set custom_google=true

Remember: Your goal is to create extraction rules that consistently retrieve the requested data.''';
  }

  /// Convert initial prompts from Gemini format to Codex format
  List<PromptContent> _convertInitialPromptsForCodex() {
    final geminiPrompts = handleInitialPrompts(initialPayload);
    final codexPrompts = <PromptContent>[];

    for (final prompt in geminiPrompts) {
      // GeminiSdkContent is a sealed class, check the type directly
      if (prompt is gemini_sdk.TextContent) {
        codexPrompts.add(PromptContent.text(prompt.text));
      } else if (prompt is gemini_sdk.BytesContent) {
        // Codex handles bytes similarly
        codexPrompts.add(
          PromptContent.bytes(
            data: prompt.data,
            fileName: prompt.fileName,
            fileExtension: prompt.fileExtension,
            fileDescription: prompt.fileDescription,
          ),
        );
      } else if (prompt is gemini_sdk.FileContent) {
        // Convert file content to Codex format
        codexPrompts.add(
          PromptContent.file(
            prompt.file,
            fileDescription: prompt.fileDescription,
          ),
        );
      }
    }

    return codexPrompts;
  }

  /// Build the response schema for Codex
  SchemaObject buildCodexResponseSchema() {
    return SchemaProperty.structuredObject(
          nullable: false,
          description: SchemaDescriptions.overallDescription,
          properties: {
            'responseType': SchemaProperty.enumeration(
              enumValues: SchemaDescriptions.responseTypeValues,
              description: SchemaDescriptions.responseType,
              nullable: false,
            ),
            'message': SchemaProperty.text(
              description: SchemaDescriptions.message,
              nullable: true,
            ),
            'errorMessage': SchemaProperty.text(
              description: SchemaDescriptions.errorMessage,
              nullable: true,
            ),
            'resumeActionMessage': SchemaProperty.text(
              description: SchemaDescriptions.resumeActionMessage,
              nullable: true,
            ),
            'request': SchemaProperty.structuredObject(
              description: SchemaDescriptions.request,
              nullable: true,
              properties: {
                'url': SchemaProperty.text(
                  description: SchemaDescriptions.requestUrl,
                  nullable: false,
                ),
                'queryParam': SchemaProperty.objectWithUndefinedProperties(
                  description: SchemaDescriptions.requestQueryParam,
                  nullable: false,
                ),
                'pathParams': SchemaProperty.array(
                  description: SchemaDescriptions.requestPathParams,
                  nullable: false,
                  items: SchemaProperty.text(nullable: false),
                ),
              },
            ),
            'fetchSettings': SchemaProperty.structuredObject(
              description: SchemaDescriptions.fetchSettings,
              nullable: true,
              properties: {
                'url': SchemaProperty.text(
                  description: SchemaDescriptions.fetchUrl,
                  nullable: false,
                ),
                'extract_rules': SchemaProperty.text(
                  description: SchemaDescriptions.fetchExtractRules,
                  nullable: false,
                ),
                'js_scenario': SchemaProperty.text(
                  description: SchemaDescriptions.fetchJsScenario,
                  nullable: true,
                ),
                'render_js': SchemaProperty.boolean(
                  description: SchemaDescriptions.fetchRenderJs,
                  nullable: false,
                ),
                'wait': SchemaProperty.double(
                  description: SchemaDescriptions.fetchWait,
                  nullable: true,
                ),
                'wait_for': SchemaProperty.text(
                  description: SchemaDescriptions.fetchWaitFor,
                  nullable: true,
                ),
                'wait_browser': SchemaProperty.text(
                  description: SchemaDescriptions.fetchWaitBrowser,
                  nullable: true,
                ),
                'premium_proxy': SchemaProperty.boolean(
                  description: SchemaDescriptions.fetchPremiumProxy,
                  nullable: false,
                ),
                'country_code': SchemaProperty.text(
                  description: SchemaDescriptions.fetchCountryCode,
                  nullable: true,
                ),
                'session_id': SchemaProperty.text(
                  description: SchemaDescriptions.fetchSessionId,
                  nullable: true,
                ),
                'custom_google': SchemaProperty.boolean(
                  description: SchemaDescriptions.fetchCustomGoogle,
                  nullable: true,
                ),
              },
            ),
          },
        )
        as SchemaObject;
  }
}
