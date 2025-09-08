// ignore_for_file: constant_identifier_names
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/scraping_bee_mcp.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'puppeteer_setup.dart';

class WebScrapperGeneratorController {
  static late final GeminiSDK _geminiSDK;

  static Future<void> init(
    String geminiApiKey,
    String scrappingBeeApiKey,
    ScrappingBeeProxyConfig proxyConfig,
  ) async {
    _geminiSDK = GeminiSDK(geminiApiKey);

    // Ensure Gemini CLI is installed
    final bool isInstalled = await _geminiSDK.isGeminiCLIInstalled();
    if (!isInstalled) {
      await _geminiSDK.installGeminiCLI(global: true);
    }

    // Setup Puppeteer and its MCP integration
    await PuppeteerSetup.instance.setupIfNeeded(
      _geminiSDK,
      proxyConfig: proxyConfig,
    );

    // Initialize ScrapingBee MCP server
    await ScrapingBeeMcpServerSetup.instance.setupIfNeeded(_geminiSDK);
  }

  final GeminiChat _chat;
  final InitialPayloadData _initialPayload;

  WebScrapperGeneratorController._({
    required GeminiChat chat,
    required InitialPayloadData initialPayload,
  }) : _chat = chat,
       _initialPayload = initialPayload;

  static WebScrapperGeneratorController startChat({
    required InitialPayloadDataCreatingFromZero currentRequest,
  }) {
    final chat = _geminiSDK.createNewChat(
      options: GeminiChatOptions(
        systemPrompt: systemPrompt,
        model: ScrappableSource.gemini_2_5_pro.apiName,
      ),
    );
    final instance = WebScrapperGeneratorController._(
      chat: chat,
      initialPayload: currentRequest,
    );
    return instance;
  }

  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<GeminiSdkContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = _chat.isFirstMessage;
    if (isFirstMessage) {
      messages.addAll(handleInitialPrompts(_initialPayload));
    }

    // Add the user's prompt
    messages.add(GeminiSdkContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = _buildResponseSchema();

    try {
      // Send message with schema for structured response
      final result = await _chat.sendMessageWithSchema(
        messages: messages,
        schema: responseSchema,
      );

      // Parse the structured response
      return _parseStructuredResponse(result);
    } catch (e) {
      // If there's an error, return an error response
      return WebScrapperChatAIResponseErrorMessage(
        'Failed to process your request: ${e.toString()}',
      );
    }
  }

  /// Builds the schema for the AI response
  SchemaObject _buildResponseSchema() {
    return SchemaObject(
      properties: {
        'responseType': SchemaProperty.string(
          description: 'The type of response: "message", "error", or "data"',
          nullable: false,
          enumValues: ['message', 'error', 'data'],
        ),
        'message': SchemaProperty.string(
          description:
              'A message from the AI (used for responseType "message")',
          nullable: true,
        ),
        'errorMessage': SchemaProperty.string(
          description: 'An error message (used for responseType "error")',
          nullable: true,
        ),
        'resumeActionMessage': SchemaProperty.string(
          description:
              'A summary of what the AI did (used for responseType "data")',
          nullable: true,
        ),
        'request': SchemaProperty.object(
          description:
              'Modified WebScrapperRequest if changes were made, null if no changes needed',
          nullable: true,
          properties: {
            'url': SchemaProperty.string(
              description:
                  'URL pattern with {paramName} placeholders for dynamic segments',
              nullable: false,
            ),
            'queryParam': SchemaProperty.object(
              description: 'Query parameters with optional default values',
              nullable: false,
              properties: {
                '__dynamic__': SchemaProperty.string(
                  description: 'Dynamic key-value pairs for query parameters',
                  nullable: true,
                ),
              },
            ),
            'pathParams': SchemaProperty.array(
              description: 'List of path parameter names',
              nullable: false,
              items: SchemaProperty.string(nullable: false),
            ),
          },
        ),
        'fetchSettings': SchemaProperty.object(
          description:
              'ScrapingBee fetch settings (used for responseType "data")',
          nullable: true,
          properties: {
            'url': SchemaProperty.string(
              description: 'The target URL for scraping',
              nullable: false,
            ),
            'extract_rules': SchemaProperty.string(
              description: 'JSON-encoded extraction rules',
              nullable: false,
            ),
            'js_scenario': SchemaProperty.string(
              description: 'JSON-encoded JavaScript scenario for interactions',
              nullable: true,
            ),
            'render_js': SchemaProperty.boolean(
              description: 'Whether to render JavaScript',
              nullable: false,
            ),
            'wait': SchemaProperty.number(
              description: 'Fixed delay in milliseconds',
              nullable: true,
            ),
            'wait_for': SchemaProperty.string(
              description: 'CSS/XPath selector to wait for',
              nullable: true,
            ),
            'wait_browser': SchemaProperty.string(
              description: 'Browser event to wait for',
              nullable: true,
            ),
            'premium_proxy': SchemaProperty.boolean(
              description: 'Whether to use premium residential proxy',
              nullable: false,
            ),
            'country_code': SchemaProperty.string(
              description: 'Proxy geolocation code (2-letter country code)',
              nullable: true,
            ),
            'session_id': SchemaProperty.string(
              description: 'Session ID for sticky sessions',
              nullable: true,
            ),
            'custom_google': SchemaProperty.boolean(
              description: 'Whether to use Google-specific handling',
              nullable: true,
            ),
          },
        ),
      },
      description: 'Structured response from the AI for web scraper generation',
    );
  }

  /// Parses the structured response from the AI
  WebScrapperChatAIResponse _parseStructuredResponse(SchemaResult result) {
    final data = result.data;
    final responseType = data['responseType'] as String;

    switch (responseType) {
      case 'message':
        final message = data['message'] as String?;
        if (message == null || message.isEmpty) {
          return const WebScrapperChatAIResponseErrorMessage(
            'Invalid response: message type but no message content',
          );
        }
        return WebScrapperChatAIResponseJustMessage(message);

      case 'error':
        final errorMessage = data['errorMessage'] as String?;
        if (errorMessage == null || errorMessage.isEmpty) {
          return const WebScrapperChatAIResponseErrorMessage(
            'Invalid response: error type but no error message',
          );
        }
        return WebScrapperChatAIResponseErrorMessage(errorMessage);

      case 'data':
        final resumeActionMessage = data['resumeActionMessage'] as String?;
        final fetchSettingsData =
            data['fetchSettings'] as Map<String, dynamic>?;

        if (resumeActionMessage == null || fetchSettingsData == null) {
          return const WebScrapperChatAIResponseErrorMessage(
            'Invalid response: data type but missing required fields',
          );
        }

        // Parse the request if it was modified
        WebScrapperRequest? modifiedRequest;
        final requestData = data['request'] as Map<String, dynamic>?;
        if (requestData != null) {
          modifiedRequest = WebScrapperRequest(
            url: requestData['url'] as String,
            queryParam: Map<String, String?>.from(
              requestData['queryParam'] as Map? ?? {},
            ),
            pathParams: List<String>.from(
              requestData['pathParams'] as List? ?? [],
            ),
          );
        }

        // Parse the fetch settings
        final fetchSettings = ScrappingBeeFetchSettings(
          url: fetchSettingsData['url'] as String,
          extract_rules: fetchSettingsData['extract_rules'] as String,
          js_scenario: fetchSettingsData['js_scenario'] as String?,
          render_js: fetchSettingsData['render_js'] as bool,
          premium_proxy: fetchSettingsData['premium_proxy'] as bool,
          wait: fetchSettingsData['wait'] as int?,
          wait_for: fetchSettingsData['wait_for'] as String?,
          wait_browser: fetchSettingsData['wait_browser'] as String?,
          country_code: fetchSettingsData['country_code'] as String?,
          session_id: fetchSettingsData['session_id'] as String?,
          custom_google: fetchSettingsData['custom_google'] as bool?,
        );

        return WebScrapperChatAIResponseWithDataResponse(
          resumeActionMessage: resumeActionMessage,
          request: modifiedRequest,
          fetchSettings: fetchSettings,
        );

      default:
        return WebScrapperChatAIResponseErrorMessage(
          'Invalid response type: $responseType',
        );
    }
  }
}

enum ScrappableSource {
  gemini_2_5_flash,
  gemini_2_5_pro;

  String get apiName {
    switch (this) {
      case gemini_2_5_flash:
        return 'gemini-2.5-flash';
      case gemini_2_5_pro:
        return 'gemini-2.5-pro';
    }
  }
}

sealed class InitialPayloadData {
  const InitialPayloadData();
}

final class InitialPayloadDataCreatingFromZero extends InitialPayloadData {
  final String targetExampleUrl;
  final WebScrapperRequest webScrapperRequest;
  const InitialPayloadDataCreatingFromZero(
    this.webScrapperRequest,
    this.targetExampleUrl,
  );
}

final class InitialPayloadDataEditingExistingWebScrapper
    extends InitialPayloadData {
  final WebScrapperRequest currentRequest;
  final ScrappingBeeFetchSettings currentFetchSettings;
  const InitialPayloadDataEditingExistingWebScrapper({
    required this.currentRequest,
    required this.currentFetchSettings,
  });
}
