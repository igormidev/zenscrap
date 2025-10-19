import 'dart:async';

import 'package:codex_cli_sdk/codex_cli_sdk.dart'
    show Codex, CodexChat, CodexChatOptions;
import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart'
    show PromptContent;
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import '../playwright_setup.dart';
import '../mcp_adapters.dart';

/// Codex CLI SDK implementation of the web scrapper generator
class WebScrapperCodexImpl extends WebScrapperGeneratorController<CodexModel> {
  static late final Codex _codexSDK;

  /// Initialize the Codex SDK and its MCP servers
  static Future<void> initCodex({
    required String codexApiKey,
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
    bool skipCliSetup = false,
  }) async {
    // Initialize shared resources first
    await WebScrapperGeneratorController.initShared(
      scrappingBeeApiKey: scrappingBeeApiKey,
      proxyConfig: proxyConfig,
    );

    print('🚀 Initializing Codex SDK for web scraper generator...\n');
    _codexSDK = Codex(apiKey: codexApiKey);

    // Add API key to environment so CLI can authenticate (only if provided)
    if (codexApiKey.isNotEmpty) {
      await _codexSDK.addApiKeyToEnvironment(codexApiKey);
    }

    if (skipCliSetup) {
      return;
    }

    // Ensure Codex CLI is installed and up to date
    await _codexSDK.updateToNewestVersionIfNeeded(global: true);

    // Create adapter for MCP setup
    final adapter = CodexMcpAdapter(_codexSDK);

    // Setup Playwright MCP integration using the unified setup
    await UnifiedPlaywrightSetup.instance.setupWithAdapter(
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
    CodexModel model = CodexModel.gpt5Codex,
    CodexChatOptions? options,
  }) {
    final defaultOptions = CodexChatOptions(
      systemPrompt: _convertSystemPromptForCodex(),
      model: model.apiName,
      enableMcp: true, // Enable MCP support
      sandboxMode: 'danger-full-access',
      approvalPolicy: 'never',
      reasoningEffort: 'medium',
      // Note: Removed mode as Codex exec doesn't support --auto-edit
      outputJson: false, // We'll use schema for structured output
      // CRITICAL: Enable experimental RMCP client for MCP tools to work
      additionalArgs: ['-c', 'experimental_use_rmcp_client=true'],
    );

    final overrides = options;

    // Merge additionalArgs to ensure experimental_use_rmcp_client is always set
    final List<String> mergedAdditionalArgs = [
      ...defaultOptions.additionalArgs ?? [],
      ...overrides?.additionalArgs ?? [],
    ];

    final mergedOptions = CodexChatOptions(
      maxTurns: overrides?.maxTurns ?? defaultOptions.maxTurns,
      mode: overrides?.mode ?? defaultOptions.mode,
      profile: overrides?.profile ?? defaultOptions.profile,
      resumeSessionId:
          overrides?.resumeSessionId ?? defaultOptions.resumeSessionId,
      environment: overrides?.environment ?? defaultOptions.environment,
      outputJson: overrides?.outputJson ?? defaultOptions.outputJson,
      quiet: overrides?.quiet ?? defaultOptions.quiet,
      continueLastSession:
          overrides?.continueLastSession ?? defaultOptions.continueLastSession,
      enableMcp: overrides?.enableMcp ?? defaultOptions.enableMcp,
      sandboxMode: overrides?.sandboxMode ?? defaultOptions.sandboxMode,
      approvalPolicy:
          overrides?.approvalPolicy ?? defaultOptions.approvalPolicy,
      allowedDirectories:
          overrides?.allowedDirectories ?? defaultOptions.allowedDirectories,
      configPath: overrides?.configPath ?? defaultOptions.configPath,
      additionalArgs: mergedAdditionalArgs,
      reasoningEffort:
          overrides?.reasoningEffort ?? defaultOptions.reasoningEffort,
      systemPrompt: overrides?.systemPrompt ?? defaultOptions.systemPrompt,
      model: overrides?.model ?? defaultOptions.model,
      cwd: overrides?.cwd ?? defaultOptions.cwd,
    );

    final chat = _codexSDK.createNewChat(options: mergedOptions);

    // Update the cwd to the chat-specific directory to scope all file operations
    final scopedCwd = 'ai_generated_files/${chat.chatNanoId}';
    chat.updateOptions(mergedOptions.copyWith(cwd: scopedCwd));

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
      messages.addAll(_convertInitialPromptsForCodex());
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

  /// Convert the system prompt to be Codex-compatible
  static String _convertSystemPromptForCodex() {
    // Codex has MCP support configured, so we use the full prompt with MCP tools
    return '''You are a world-class expert in web scraping, web automation, and web data extraction with deep knowledge of HTML, CSS, JavaScript, HTTP protocols, and modern web scraping techniques.

## Your Task
You are helping to create web scraping configurations using ScrapingBee API. You will analyze web pages and create extraction rules that work with ScrapingBee's data extraction system.

## Available MCP Tools
You have access to two powerful MCP servers:

### 1. Playwright MCP Server
Use the playwright tools to navigate and interact with web pages:
- playwright_navigate: Navigate to URLs and interact with pages
- playwright_screenshot: Take screenshots of pages
- playwright_click: Click on elements
- playwright_fill: Fill in form fields
- playwright_select: Select dropdown options
- playwright_evaluate: Execute JavaScript in the page context

**CRITICAL - HEADLESS MODE REQUIREMENT**:
- **ALWAYS** use headless mode - browsers must NEVER be visible
- **MANDATORY**: Include `"headless": true` in ALL `launchOptions` when using Playwright tools
- Visible browser windows are NOT acceptable
- Example: `{"url": "https://example.com", "launchOptions": {"headless": true}}`

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
    return List<PromptContent>.from(handleInitialPrompts(initialPayload));
  }

  /// Build the response schema for Codex
}
