// ignore_for_file: non_constant_identifier_names

// Simple data models used by the OpenAI chat controller to keep the server
// independent from the removed external generator packages.

sealed class WebScrapperChatAIResponse {
  const WebScrapperChatAIResponse();
}

final class WebScrapperChatAIResponseJustMessage
    extends WebScrapperChatAIResponse {
  final String message;
  const WebScrapperChatAIResponseJustMessage(this.message);

  @override
  String toString() => message;
}

final class WebScrapperChatAIResponseErrorMessage
    extends WebScrapperChatAIResponse {
  final String errorDescription;
  const WebScrapperChatAIResponseErrorMessage(this.errorDescription);

  @override
  String toString() => errorDescription;
}

final class WebScrapperChatAIResponseOnlyExtractRulesModified
    extends WebScrapperChatAIResponse {
  final String resumeActionMessage;
  final ScrappingBeeFetchSettings fetchSettings;

  const WebScrapperChatAIResponseOnlyExtractRulesModified({
    required this.fetchSettings,
    required this.resumeActionMessage,
  });

  @override
  String toString() =>
      '$resumeActionMessage\nFetch Settings: ${fetchSettings.toString()}';
}

final class WebScrapperChatAIResponseOnlyRequestModified
    extends WebScrapperChatAIResponse {
  final String resumeActionMessage;
  final WebScrapperRequest scrappableRequest;

  const WebScrapperChatAIResponseOnlyRequestModified({
    required this.scrappableRequest,
    required this.resumeActionMessage,
  });

  @override
  String toString() =>
      '$resumeActionMessage\nRequest: ${scrappableRequest.toString()}';
}

final class WebScrapperChatAIResponseBothModified
    extends WebScrapperChatAIResponse {
  final String resumeActionMessage;
  final ScrappingBeeFetchSettings fetchSettings;
  final WebScrapperRequest scrappableRequest;

  const WebScrapperChatAIResponseBothModified({
    required this.fetchSettings,
    required this.scrappableRequest,
    required this.resumeActionMessage,
  });

  @override
  String toString() =>
      '$resumeActionMessage\nFetch Settings: ${fetchSettings.toString()}\nRequest: ${scrappableRequest.toString()}';
}

class WebScrapperRequest {
  final String url;
  final Map<String, String?> queryParam;
  final Map<String, String?> queryParamsNotRelatedToUrl;
  final List<String> pathParams;

  const WebScrapperRequest({
    required this.url,
    required this.queryParam,
    this.queryParamsNotRelatedToUrl = const {},
    required this.pathParams,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'url': url,
        'queryParam': queryParam,
        'queryParamsNotRelatedToUrl': queryParamsNotRelatedToUrl,
        'pathParams': pathParams,
      };

  @override
  String toString() =>
      'WebScrapperRequest(url: $url, queryParam: $queryParam, queryParamsNotRelatedToUrl: $queryParamsNotRelatedToUrl, pathParams: $pathParams)';
}

class ScrappingBeeFetchSettings {
  final String url;
  final String extract_rules;
  final String? js_scenario;
  final bool render_js;
  final int? wait;
  final String? wait_for;
  final String? wait_browser;
  final bool premium_proxy;
  final bool stealth_proxy;
  final String? country_code;
  final String? session_id;
  final bool? custom_google;

  const ScrappingBeeFetchSettings({
    required this.url,
    required this.extract_rules,
    this.js_scenario,
    required this.render_js,
    required this.premium_proxy,
    required this.stealth_proxy,
    this.wait,
    this.wait_for,
    this.wait_browser,
    this.country_code,
    this.session_id,
    this.custom_google,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'extract_rules': extract_rules,
      'js_scenario': js_scenario,
      'render_js': render_js,
      'wait': wait,
      'wait_for': wait_for,
      'wait_browser': wait_browser,
      'premium_proxy': premium_proxy,
      'stealth_proxy': stealth_proxy,
      'country_code': country_code,
      'session_id': session_id,
      'custom_google': custom_google,
    };
  }

  @override
  String toString() {
    return 'ScrappingBeeFetchSettings(url: $url, extract_rules: $extract_rules, js_scenario: $js_scenario, render_js: $render_js, wait: $wait, wait_for: $wait_for, wait_browser: $wait_browser, premium_proxy: $premium_proxy, stealth_proxy: $stealth_proxy, country_code: $country_code, session_id: $session_id, custom_google: $custom_google)';
  }
}

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

/// JSON schema passed to OpenAI for the structured response.
/// Note: Using non-strict mode due to complex optional object requirements
const Map<String, dynamic> webScraperResponseJsonSchema = {
  'name': 'WebScraperResponse',
  'strict': false,
  'schema': {
    'type': 'object',
    'additionalProperties': false,
    'properties': {
      'responseType': {
        'type': 'string',
        'enum': ['message', 'error', 'data']
      },
      'message': {'type': 'string'},
      'errorMessage': {'type': 'string'},
      'resumeActionMessage': {'type': 'string'},
      'scrappableRequest': {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'url': {'type': 'string'},
          'queryParam': {
            'type': 'object',
            'additionalProperties': {
              'type': ['string', 'null']
            }
          },
          'queryParamsNotRelatedToUrl': {
            'type': 'object',
            'additionalProperties': {
              'type': ['string', 'null']
            }
          },
          'pathParams': {
            'type': 'array',
            'items': {'type': 'string'}
          },
        },
        'required': [
          'url',
          'queryParam',
          'queryParamsNotRelatedToUrl',
          'pathParams'
        ],
      },
      'scrappingBeeFetchSettings': {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'url': {'type': 'string'},
          'extract_rules': {'type': 'string'},
          'js_scenario': {
            'type': ['string', 'null']
          },
          'render_js': {'type': 'boolean'},
          'wait': {
            'type': ['integer', 'null'],
            'minimum': 0,
            'maximum': 35000,
          },
          'wait_for': {
            'type': ['string', 'null']
          },
          'wait_browser': {
            'type': ['string', 'null']
          },
          'premium_proxy': {'type': 'boolean'},
          'stealth_proxy': {'type': 'boolean'},
          'country_code': {
            'type': ['string', 'null']
          },
          'session_id': {
            'type': ['string', 'null']
          },
          'custom_google': {
            'type': ['boolean', 'null']
          },
        },
        'required': [
          'url',
          'extract_rules',
          'render_js',
          'premium_proxy',
          'stealth_proxy',
        ],
      },
    },
    'required': ['responseType'],
  },
};

WebScrapperChatAIResponse parseStructuredResponse(
  Map<String, dynamic> data,
) {
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
      final scrappingBeeFetchSettingsData =
          data['scrappingBeeFetchSettings'] as Map<String, dynamic>?;
      final scrappableRequestData =
          data['scrappableRequest'] as Map<String, dynamic>?;

      if (resumeActionMessage == null) {
        return const WebScrapperChatAIResponseErrorMessage(
          'Invalid response: data type but missing resumeActionMessage',
        );
      }

      if (scrappingBeeFetchSettingsData == null &&
          scrappableRequestData == null) {
        return const WebScrapperChatAIResponseErrorMessage(
          'Invalid response: data type must include either scrappingBeeFetchSettings, scrappableRequest, or both',
        );
      }

      ScrappingBeeFetchSettings? fetchSettings;
      if (scrappingBeeFetchSettingsData != null) {
        try {
          fetchSettings = ScrappingBeeFetchSettings(
            url: scrappingBeeFetchSettingsData['url'] as String,
            extract_rules:
                scrappingBeeFetchSettingsData['extract_rules'] as String,
            js_scenario:
                scrappingBeeFetchSettingsData['js_scenario'] as String?,
            render_js: scrappingBeeFetchSettingsData['render_js'] as bool,
            premium_proxy:
                scrappingBeeFetchSettingsData['premium_proxy'] as bool,
            stealth_proxy:
                scrappingBeeFetchSettingsData['stealth_proxy'] as bool,
            wait: scrappingBeeFetchSettingsData['wait'] as int?,
            wait_for: scrappingBeeFetchSettingsData['wait_for'] as String?,
            wait_browser:
                scrappingBeeFetchSettingsData['wait_browser'] as String?,
            country_code:
                scrappingBeeFetchSettingsData['country_code'] as String?,
            session_id:
                scrappingBeeFetchSettingsData['session_id'] as String?,
            custom_google:
                scrappingBeeFetchSettingsData['custom_google'] as bool?,
          );
        } catch (e) {
          return WebScrapperChatAIResponseErrorMessage(
            'Invalid response: could not parse scrappingBeeFetchSettings ($e)',
          );
        }
      }

      WebScrapperRequest? scrappableRequest;
      if (scrappableRequestData != null) {
        try {
          scrappableRequest = WebScrapperRequest(
            url: scrappableRequestData['url'] as String,
            queryParam:
                (scrappableRequestData['queryParam'] as Map<String, dynamic>)
                    .map(
              (k, v) => MapEntry(k, v as String?),
            ),
            queryParamsNotRelatedToUrl:
                (scrappableRequestData['queryParamsNotRelatedToUrl']
                            as Map<String, dynamic>?)
                        ?.map((k, v) => MapEntry(k, v as String?)) ??
                    {},
            pathParams: (scrappableRequestData['pathParams'] as List)
                .map((e) => e as String)
                .toList(),
          );
        } catch (e) {
          return WebScrapperChatAIResponseErrorMessage(
            'Invalid response: could not parse scrappableRequest ($e)',
          );
        }
      }

      final parsedResponse =
          [fetchSettings, scrappableRequest].nonNulls.length; // 1 or 2

      if (parsedResponse == 2 && fetchSettings != null && scrappableRequest != null) {
        return WebScrapperChatAIResponseBothModified(
          resumeActionMessage: resumeActionMessage,
          fetchSettings: fetchSettings,
          scrappableRequest: scrappableRequest,
        );
      }

      if (fetchSettings != null) {
        return WebScrapperChatAIResponseOnlyExtractRulesModified(
          fetchSettings: fetchSettings,
          resumeActionMessage: resumeActionMessage,
        );
      }

      if (scrappableRequest != null) {
        return WebScrapperChatAIResponseOnlyRequestModified(
          scrappableRequest: scrappableRequest,
          resumeActionMessage: resumeActionMessage,
        );
      }

      return const WebScrapperChatAIResponseErrorMessage(
        'Invalid response: unexpected state in data parsing',
      );

    default:
      return WebScrapperChatAIResponseErrorMessage(
        'Invalid response type: $responseType',
      );
  }
}
