import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' as gemini_sdk;
import 'package:claude_code_sdk/claude_code_sdk.dart' as claude_sdk;
import 'package:web_scrapper_generator/src/schema_constants.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/puppeteer_setup.dart' show ScrappingBeeProxyConfig;

/// Abstract interface for web scrapper generator controllers
abstract class WebScrapperGeneratorController<TModel> {
  /// The initial payload data for the conversation
  final InitialPayloadData initialPayload;

  WebScrapperGeneratorController({
    required this.initialPayload,
  });

  /// Static initialization for all implementations
  /// Sets up shared resources like MCP servers
  static Future<void> initShared({
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
  }) async {
    // This will be called before any implementation-specific init
    // It sets up resources that are shared across all implementations
    print('🚀 Initializing shared resources for web scraper generator...\n');
  }

  /// Send a message to the AI and get a response
  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  });

  /// Change the AI model being used
  Future<void> changeModel(TModel model);

  /// Dispose of resources
  Future<void> dispose();

  /// Build the response schema that all implementations must use
  gemini_sdk.SchemaObject buildGeminiResponseSchema() {
    return gemini_sdk.SchemaObject(
      properties: {
        'responseType': gemini_sdk.SchemaProperty.string(
          description: SchemaDescriptions.responseType,
          nullable: false,
          enumValues: SchemaDescriptions.responseTypeValues,
        ),
        'message': gemini_sdk.SchemaProperty.string(
          description: SchemaDescriptions.message,
          nullable: true,
        ),
        'errorMessage': gemini_sdk.SchemaProperty.string(
          description: SchemaDescriptions.errorMessage,
          nullable: true,
        ),
        'resumeActionMessage': gemini_sdk.SchemaProperty.string(
          description: SchemaDescriptions.resumeActionMessage,
          nullable: true,
        ),
        'request': gemini_sdk.SchemaProperty.object(
          description: SchemaDescriptions.request,
          nullable: true,
          properties: {
            'url': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.requestUrl,
              nullable: false,
            ),
            'queryParam': gemini_sdk.SchemaProperty.object(
              description: SchemaDescriptions.requestQueryParam,
              nullable: false,
              properties: {
                '__dynamic__': gemini_sdk.SchemaProperty.string(
                  description: SchemaDescriptions.requestQueryParamDynamic,
                  nullable: true,
                ),
              },
            ),
            'pathParams': gemini_sdk.SchemaProperty.array(
              description: SchemaDescriptions.requestPathParams,
              nullable: false,
              items: gemini_sdk.SchemaProperty.string(nullable: false),
            ),
          },
        ),
        'fetchSettings': gemini_sdk.SchemaProperty.object(
          description: SchemaDescriptions.fetchSettings,
          nullable: true,
          properties: {
            'url': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchUrl,
              nullable: false,
            ),
            'extract_rules': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchExtractRules,
              nullable: false,
            ),
            'js_scenario': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchJsScenario,
              nullable: true,
            ),
            'render_js': gemini_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchRenderJs,
              nullable: false,
            ),
            'wait': gemini_sdk.SchemaProperty.number(
              description: SchemaDescriptions.fetchWait,
              nullable: true,
            ),
            'wait_for': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitFor,
              nullable: true,
            ),
            'wait_browser': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitBrowser,
              nullable: true,
            ),
            'premium_proxy': gemini_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchPremiumProxy,
              nullable: false,
            ),
            'country_code': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchCountryCode,
              nullable: true,
            ),
            'session_id': gemini_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchSessionId,
              nullable: true,
            ),
            'custom_google': gemini_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchCustomGoogle,
              nullable: true,
            ),
          },
        ),
      },
      description: SchemaDescriptions.overallDescription,
    );
  }

  /// Build the response schema for Claude
  claude_sdk.SchemaObject buildClaudeResponseSchema() {
    return claude_sdk.SchemaObject(
      properties: {
        'responseType': claude_sdk.SchemaProperty.string(
          description: SchemaDescriptions.responseType,
          nullable: false,
          enumValues: SchemaDescriptions.responseTypeValues,
        ),
        'message': claude_sdk.SchemaProperty.string(
          description: SchemaDescriptions.message,
          nullable: true,
        ),
        'errorMessage': claude_sdk.SchemaProperty.string(
          description: SchemaDescriptions.errorMessage,
          nullable: true,
        ),
        'resumeActionMessage': claude_sdk.SchemaProperty.string(
          description: SchemaDescriptions.resumeActionMessage,
          nullable: true,
        ),
        'request': claude_sdk.SchemaProperty.object(
          description: SchemaDescriptions.request,
          nullable: true,
          properties: {
            'url': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.requestUrl,
              nullable: false,
            ),
            'queryParam': claude_sdk.SchemaProperty.object(
              description: SchemaDescriptions.requestQueryParam,
              nullable: false,
              properties: {
                '__dynamic__': claude_sdk.SchemaProperty.string(
                  description: SchemaDescriptions.requestQueryParamDynamic,
                  nullable: true,
                ),
              },
            ),
            'pathParams': claude_sdk.SchemaProperty.array(
              description: SchemaDescriptions.requestPathParams,
              nullable: false,
              items: claude_sdk.SchemaProperty.string(nullable: false),
            ),
          },
        ),
        'fetchSettings': claude_sdk.SchemaProperty.object(
          description: SchemaDescriptions.fetchSettings,
          nullable: true,
          properties: {
            'url': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchUrl,
              nullable: false,
            ),
            'extract_rules': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchExtractRules,
              nullable: false,
            ),
            'js_scenario': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchJsScenario,
              nullable: true,
            ),
            'render_js': claude_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchRenderJs,
              nullable: false,
            ),
            'wait': claude_sdk.SchemaProperty.number(
              description: SchemaDescriptions.fetchWait,
              nullable: true,
            ),
            'wait_for': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitFor,
              nullable: true,
            ),
            'wait_browser': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchWaitBrowser,
              nullable: true,
            ),
            'premium_proxy': claude_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchPremiumProxy,
              nullable: false,
            ),
            'country_code': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchCountryCode,
              nullable: true,
            ),
            'session_id': claude_sdk.SchemaProperty.string(
              description: SchemaDescriptions.fetchSessionId,
              nullable: true,
            ),
            'custom_google': claude_sdk.SchemaProperty.boolean(
              description: SchemaDescriptions.fetchCustomGoogle,
              nullable: true,
            ),
          },
        ),
      },
      description: SchemaDescriptions.overallDescription,
    );
  }

  /// Parse the structured response from the AI
  WebScrapperChatAIResponse parseStructuredResponse(Map<String, dynamic> data) {
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

/// Initial payload data classes
sealed class InitialPayloadData {
  const InitialPayloadData();
}

final class InitialPayloadDataCreatingFromZero extends InitialPayloadData {
  final String targetExampleUrl;
  final WebScrapperRequest webScrapperRequest;
  const InitialPayloadDataCreatingFromZero({
    required this.webScrapperRequest,
    required this.targetExampleUrl,
  });
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