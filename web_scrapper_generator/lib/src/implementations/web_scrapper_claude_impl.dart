import 'dart:async';
import 'dart:io';

import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:web_scrapper_generator/src/documentation/system_prompt.dart';
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

    // Verify MCPs are properly installed
    print('🔍 Verifying MCP server installation...\n');
    final mcpServers = await _claudeSDK.listMcpServers();

    // Log all registered MCP servers
    print('📋 Registered MCP servers (${mcpServers.length}):');
    for (final server in mcpServers) {
      print('  - ${server.name}: ${server.command} ${server.args.join(' ')}');
    }
    print('');

    // Check for required MCP servers
    final hasPlaywright = mcpServers.any(
      (s) => s.name.toLowerCase().contains('playwright'),
    );
    final hasScrapingBee = mcpServers.any(
      (s) => s.name == 'scraping-bee-mcp' || s.name.contains('scraping_bee'),
    );

    if (!hasPlaywright) {
      throw Exception(
        '❌ Playwright MCP server is not installed!\n'
        'The AI needs Playwright MCP to interact with web pages.\n'
        'Please check the setup logs above for errors.',
      );
    }

    if (!hasScrapingBee) {
      throw Exception(
        '❌ ScrapingBee MCP server is not installed!\n'
        'The AI needs ScrapingBee MCP to test extraction rules.\n'
        'Please check the setup logs above for errors.',
      );
    }

    print('✅ All required MCP servers are installed and ready!\n');
    print('   ✓ Playwright MCP: Available for web page interaction');
    print('   ✓ ScrapingBee MCP: Available for extraction rule testing\n');
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
    final initialOptions = ClaudeChatOptions(
      systemPrompt: _convertSystemPromptForClaude(),
      model: model.apiName,
      permissionMode: 'bypassPermissions',
      enableMcp: true, // Enable MCP to access globally configured servers
    );

    final chat = _claudeSDK.createNewChat(options: initialOptions);

    // Update the cwd to the chat-specific directory to scope all file operations
    // Use absolute path to prevent path duplication issues
    final scopedCwd =
        '${Directory.current.absolute.path}/ai_generated_files/${chat.chatId}';
    chat.updateOptions(initialOptions.copyWith(cwd: scopedCwd));

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
  }) streamMessage({required String userPrompt}) {
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
    // Claude Code has full MCP support - use complete prompt with MCP instructions
    return systemPrompt; // Use the full system prompt from documentation_constants.dart
  }

  /// Convert initial prompts from Gemini format to Claude format
  List<PromptContent> _convertInitialPromptsForClaude() {
    return List<PromptContent>.from(handleInitialPrompts(initialPayload));
  }
}
