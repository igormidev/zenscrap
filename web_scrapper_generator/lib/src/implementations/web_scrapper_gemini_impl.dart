import 'dart:async';
import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import 'package:web_scrapper_generator/src/scraping_bee_mcp.dart';
import '../playwright_setup.dart';

/// Gemini implementation of the web scrapper generator
class WebScrapperGeminiImpl
    extends WebScrapperGeneratorController<GeminiModel> {
  static late final GeminiSDK _geminiSDK;

  /// Initialize the Gemini SDK and its MCP servers
  static Future<void> initGemini({
    required String geminiApiKey,
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
  }) async {
    // Initialize shared resources first
    await WebScrapperGeneratorController.initShared(
      scrappingBeeApiKey: scrappingBeeApiKey,
      proxyConfig: proxyConfig,
    );

    print('🚀 Initializing Gemini SDK for web scraper generator...\n');
    _geminiSDK = GeminiSDK(apiKey: geminiApiKey);

    // Ensure Gemini CLI is installed and up to date
    await _geminiSDK.updateToNewestVersionIfNeeded(global: true);

    // Setup Playwright and its MCP integration
    await PlaywrightSetup.instance.setupIfNeeded(
      _geminiSDK,
      proxyConfig: proxyConfig,
    );

    // Initialize ScrapingBee MCP server
    await ScrapingBeeMcpServerSetup.instance.setupIfNeeded(_geminiSDK);
  }

  final GeminiChat _chat;

  WebScrapperGeminiImpl._(InitialPayloadData initialPayload, GeminiChat chat)
      : _chat = chat,
        super(initialPayload: initialPayload);

  /// Factory method to create a new chat instance
  static WebScrapperGeminiImpl startChat({
    required InitialPayloadData initialPayload,
    GeminiModel model = GeminiModel.gemini25Flash,
  }) {
    final initialOptions = GeminiChatOptions(
      systemPrompt: systemPrompt,
      model: model.apiName,
      allowedMcpServerNames: ['playwright', 'scraping-bee-mcp'],
      allowedTools: ['*'], // Allow all tools from the allowed MCP servers
      approvalMode: 'yolo', // Automatically approve all tool usage
    );

    final chat = _geminiSDK.createNewChat(options: initialOptions);

    // Update the cwd to the chat-specific directory to scope all file operations
    // Use absolute path to prevent path duplication issues
    final scopedCwd =
        '${Directory.current.absolute.path}/ai_generated_files/${chat.chatNanoId}';
    chat.updateOptions(initialOptions.copyWith(cwd: scopedCwd));

    final instance = WebScrapperGeminiImpl._(initialPayload, chat);
    return instance;
  }

  @override
  Future<void> changeModel(GeminiModel model) async {
    _chat.changeModel(model.apiName);
  }

  @override
  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<PromptContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = _chat.isFirstMessage;
    if (isFirstMessage) {
      messages.addAll(handleInitialPrompts(initialPayload));
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
    final isFirstMessage = _chat.isFirstMessage;
    if (isFirstMessage) {
      messages.addAll(handleInitialPrompts(initialPayload));
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
}
