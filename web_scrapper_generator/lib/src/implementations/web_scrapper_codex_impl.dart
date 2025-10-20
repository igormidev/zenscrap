import 'dart:async';
import 'dart:io';

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
    CodexModel model = CodexModel.gpt5Mini,
    CodexChatOptions? options,
  }) {
    final defaultOptions = CodexChatOptions(
      systemPrompt: _convertSystemPromptForCodex(),
      model: model.apiName,
      enableMcp: true, // Enable MCP support
      sandboxMode: 'danger-full-access',
      approvalPolicy: 'never',
      reasoningEffort: 'high',
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
    // Use absolute path to prevent path duplication issues in Codex
    final scopedCwd =
        '${Directory.current.absolute.path}/ai_generated_files/${chat.chatNanoId}';
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
    // Codex has full MCP support - use complete prompt with MCP instructions
    return systemPrompt; // Use the full system prompt from prompts.dart
  }

  /// Convert initial prompts from Gemini format to Codex format
  List<PromptContent> _convertInitialPromptsForCodex() {
    return List<PromptContent>.from(handleInitialPrompts(initialPayload));
  }

  /// Build the response schema for Codex
}
