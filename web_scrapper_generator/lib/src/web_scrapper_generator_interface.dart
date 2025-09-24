import 'dart:async';

import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';
import 'package:web_scrapper_generator/src/schema_constants.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/playwright_setup.dart'
    show ScrappingBeeProxyConfig;

final SchemaDefinition webScrapperResponseSchema = SchemaDefinition(
  properties: {
    'responseType': SchemaProperty.enumeration(
      enumValues: SchemaDescriptions.responseTypeValues,
      nullable: false,
      description: SchemaDescriptions.responseType,
    ),
    'message': SchemaProperty.text(
      nullable: true,
      description: SchemaDescriptions.message,
    ),
    'errorMessage': SchemaProperty.text(
      nullable: true,
      description: SchemaDescriptions.errorMessage,
    ),
    'resumeActionMessage': SchemaProperty.text(
      nullable: true,
      description: SchemaDescriptions.resumeActionMessage,
    ),
    'request': SchemaProperty.structuredObject(
      nullable: true,
      description: SchemaDescriptions.request,
      properties: {
        'url': SchemaProperty.text(
          nullable: false,
          description: SchemaDescriptions.requestUrl,
        ),
        'queryParam': SchemaProperty.objectWithUndefinedProperties(
          nullable: false,
          description: SchemaDescriptions.requestQueryParam,
        ),
        'pathParams': SchemaProperty.array(
          items: SchemaProperty.text(nullable: false),
          nullable: false,
          description: SchemaDescriptions.requestPathParams,
        ),
      },
    ),
    'fetchSettings': SchemaProperty.structuredObject(
      nullable: true,
      description: SchemaDescriptions.fetchSettings,
      properties: {
        'url': SchemaProperty.text(
          nullable: false,
          description: SchemaDescriptions.fetchUrl,
        ),
        'extract_rules': SchemaProperty.text(
          nullable: false,
          description: SchemaDescriptions.fetchExtractRules,
        ),
        'js_scenario': SchemaProperty.text(
          nullable: true,
          description: SchemaDescriptions.fetchJsScenario,
        ),
        'render_js': SchemaProperty.boolean(
          nullable: false,
          description: SchemaDescriptions.fetchRenderJs,
        ),
        'wait': SchemaProperty.double(
          nullable: true,
          description: SchemaDescriptions.fetchWait,
        ),
        'wait_for': SchemaProperty.text(
          nullable: true,
          description: SchemaDescriptions.fetchWaitFor,
        ),
        'wait_browser': SchemaProperty.text(
          nullable: true,
          description: SchemaDescriptions.fetchWaitBrowser,
        ),
        'premium_proxy': SchemaProperty.boolean(
          nullable: false,
          description: SchemaDescriptions.fetchPremiumProxy,
        ),
        'country_code': SchemaProperty.text(
          nullable: true,
          description: SchemaDescriptions.fetchCountryCode,
        ),
        'session_id': SchemaProperty.text(
          nullable: true,
          description: SchemaDescriptions.fetchSessionId,
        ),
        'custom_google': SchemaProperty.boolean(
          nullable: true,
          description: SchemaDescriptions.fetchCustomGoogle,
        ),
      },
    ),
  },
);

/// Abstract interface for web scrapper generator controllers
abstract class WebScrapperGeneratorController<TModel> {
  /// The initial payload data for the conversation
  final InitialPayloadData initialPayload;

  WebScrapperGeneratorController({required this.initialPayload});

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
  Future<WebScrapperChatAIResponse> sendMessage({required String userPrompt});

  /// Send a message to the AI and get a response
  ({
    Stream<String> llmMessage,
    Future<WebScrapperChatAIResponse> structuredSchemaDataCompleter,
  })
  streamMessage({required String userPrompt});

  /// Change the AI model being used
  Future<void> changeModel(TModel model);

  /// Dispose of resources
  Future<void> dispose();

  /// Parse the structured response from the AI
  WebScrapperChatAIResponse parseStructuredResponse(Map<String, dynamic> data) {
    final responseType = data['responseType'] as String?;

    if (responseType == null) {
      return const WebScrapperChatAIResponseErrorMessage(
        'Invalid response: missing responseType field',
      );
    }

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
