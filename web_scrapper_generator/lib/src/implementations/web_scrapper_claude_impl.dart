import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' as gemini_sdk;
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import '../puppeteer_setup.dart';

/// Claude Code SDK implementation of the web scrapper generator
class WebScrapperClaudeImpl extends WebScrapperGeneratorController<ClaudeModel> {
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
    _claudeSDK = Claude(claudeApiKey);

    // Ensure Claude Code CLI is installed
    final bool isInstalled = await _claudeSDK.isClaudeCodeSDKInstalled();
    if (!isInstalled) {
      await _claudeSDK.installClaudeCodeSDK(global: true);
    }

    // TODO: Setup Puppeteer and ScrapingBee MCP servers for Claude
    // Note: Claude uses a different MCP setup process than Gemini
    // We'll need to adapt the MCP server configurations
  }

  final ClaudeChat _chat;

  WebScrapperClaudeImpl._(
    InitialPayloadData initialPayload,
    ClaudeChat chat,
  ) : _chat = chat,
      super(initialPayload: initialPayload);

  /// Factory method to create a new chat instance
  static WebScrapperClaudeImpl startChat({
    required InitialPayloadData initialPayload,
    ClaudeModel model = ClaudeModel.claude35Sonnet,
  }) {
    final chat = _claudeSDK.createNewChat(
      options: ClaudeChatOptions(
        systemPrompt: _convertSystemPromptForClaude(),
        model: model.apiName,
        // Claude MCP configuration will be different
        // TODO: Configure MCP servers for Claude
      ),
    );
    
    return WebScrapperClaudeImpl._(
      initialPayload,
      chat,
    );
  }

  @override
  Future<void> changeModel(ClaudeModel model) async {
    // Claude doesn't have a direct changeModel method like Gemini
    // We would need to create a new chat with the new model
    print('Model changed to: ${model.displayName}');
    print('Note: Claude requires creating a new chat session for model changes.');
  }

  @override
  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<ClaudeSdkContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = _chat.sessionId == null;
    if (isFirstMessage) {
      messages.addAll(_convertInitialPromptsForClaude());
    }

    // Add the user's prompt
    messages.add(ClaudeSdkContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = buildClaudeResponseSchema();

    try {
      // Send message with schema for structured response
      final result = await _chat.sendMessageWithSchema(
        messages: messages,
        schema: responseSchema,
      );

      // Parse the structured response
      return parseStructuredResponse(result.data);
    } catch (e) {
      // If there's an error, return an error response
      return WebScrapperChatAIResponseErrorMessage(
        'Failed to process your request: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _chat.dispose();
  }

  /// Convert the system prompt to be Claude-compatible
  static String _convertSystemPromptForClaude() {
    // Claude may need slight adjustments to the system prompt
    // For now, we'll use the same prompt
    return systemPrompt;
  }

  /// Convert initial prompts from Gemini format to Claude format
  List<ClaudeSdkContent> _convertInitialPromptsForClaude() {
    final geminiPrompts = handleInitialPrompts(initialPayload);
    final claudePrompts = <ClaudeSdkContent>[];

    for (final prompt in geminiPrompts) {
      // GeminiSdkContent is a sealed class, check the type directly
      if (prompt is gemini_sdk.TextContent) {
        claudePrompts.add(ClaudeSdkContent.text(prompt.text));
      } else if (prompt is gemini_sdk.BytesContent) {
        // Claude handles bytes similarly
        claudePrompts.add(ClaudeSdkContent.bytes(
          data: prompt.data,
          fileExtension: prompt.fileExtension,
        ));
      } else if (prompt is gemini_sdk.FileContent) {
        // Convert file content to Claude format
        claudePrompts.add(ClaudeSdkContent.file(prompt.file));
      }
    }

    return claudePrompts;
  }
}