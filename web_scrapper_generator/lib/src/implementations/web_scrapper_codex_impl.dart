import 'package:codex_cli_sdk/codex_cli_sdk.dart';
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
    _codexSDK = Codex(codexApiKey);

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
        // Don't include long system prompt in CLI args - will be added as first message
        model: model.apiName,
        // Note: Removed reasoningEffort as it may not be supported by Codex CLI
        timeoutMs: 300000, // 5 minutes timeout - increased for complex prompts
        enableMcp: true, // Enable MCP support
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
    List<CodexSdkContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = _chat.sessionId == null;
    if (isFirstMessage) {
      // For Codex, just provide a simple prompt since MCP tools aren't available
      messages.add(
        CodexSdkContent.text('''
You are a web scraping expert. However, in this sandboxed environment, you cannot access network or MCP tools.

When asked to create web scraping rules, respond with an error indicating network access is not available.

Use the JSON schema to structure your response with responseType: "error" and an appropriate errorMessage.
'''),
      );
    }

    // Add the user's prompt
    messages.add(CodexSdkContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = buildCodexResponseSchema();

    try {
      // Send message with schema for structured response
      final (:llmMessage, :structuredSchemaData) = await _chat
          .sendMessageWithSchema(messages: messages, schema: responseSchema);
      print('[------------ LLM Raw Message ------------]');
      print(llmMessage);
      print('\n\n');
      print(structuredSchemaData);
      print('[------------ LLM Raw Message ------------]');

      // Parse the structured response
      return parseStructuredResponse(structuredSchemaData);
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

  /// Build the response schema for Codex
  SchemaObject buildCodexResponseSchema() {
    return SchemaObject(
      properties: {
        'responseType': SchemaProperty.string(
          description: SchemaDescriptions.responseType,
          nullable: false,
          enumValues: SchemaDescriptions.responseTypeValues,
        ),
        'message': SchemaProperty.string(
          description: SchemaDescriptions.message,
          nullable: true,
        ),
        'errorMessage': SchemaProperty.string(
          description: SchemaDescriptions.errorMessage,
          nullable: true,
        ),
        'resumeActionMessage': SchemaProperty.string(
          description: SchemaDescriptions.resumeActionMessage,
          nullable: true,
        ),
        'request': SchemaProperty.object(
          description: SchemaDescriptions.request,
          nullable: true,
          properties: {
            'url': SchemaProperty.string(
              description: SchemaDescriptions.requestUrl,
              nullable: false,
            ),
            'queryParam': SchemaProperty.object(
              description: SchemaDescriptions.requestQueryParam,
              nullable: false,
              properties: {
                '__dynamic__': SchemaProperty.string(
                  description: SchemaDescriptions.requestQueryParamDynamic,
                  nullable: true,
                ),
              },
            ),
            'pathParams': SchemaProperty.array(
              description: SchemaDescriptions.requestPathParams,
              nullable: false,
              items: SchemaProperty.string(nullable: false),
            ),
          },
        ),
        'fetchSettings': SchemaProperty.object(
          description: SchemaDescriptions.fetchSettings,
          nullable: true,
          properties: {
            'url': SchemaProperty.string(
              description: SchemaDescriptions.fetchUrl,
              nullable: false,
            ),
            'extract_rules': SchemaProperty.string(
              description: SchemaDescriptions.fetchExtractRules,
              nullable: false,
            ),
            'js_scenario': SchemaProperty.string(
              description: SchemaDescriptions.fetchJsScenario,
              nullable: true,
            ),
            'render_js': SchemaProperty.boolean(
              description: SchemaDescriptions.fetchRenderJs,
              nullable: false,
            ),
            'wait': SchemaProperty.number(
              description: SchemaDescriptions.fetchWait,
              nullable: true,
            ),
            'wait_for': SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitFor,
              nullable: true,
            ),
            'wait_browser': SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitBrowser,
              nullable: true,
            ),
            'premium_proxy': SchemaProperty.boolean(
              description: SchemaDescriptions.fetchPremiumProxy,
              nullable: false,
            ),
            'country_code': SchemaProperty.string(
              description: SchemaDescriptions.fetchCountryCode,
              nullable: true,
            ),
            'session_id': SchemaProperty.string(
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
      description: SchemaDescriptions.overallDescription,
    );
  }
}
