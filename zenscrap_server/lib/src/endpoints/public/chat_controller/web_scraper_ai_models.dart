// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// Simple data models used by the OpenAI chat controller to keep the server
// independent from the removed external generator packages.

sealed class WebScrapperChatAIResponse {
  const WebScrapperChatAIResponse();
}

enum StructuredResponseValidationReason {
  extractRulesTypeInvalid,
  scrappableRequestInvalid,
  missingRequiredData,
}

extension StructuredResponseValidationReasonExt
    on StructuredResponseValidationReason {
  String get code => switch (this) {
    StructuredResponseValidationReason.extractRulesTypeInvalid =>
      'extract_rules_type_invalid',
    StructuredResponseValidationReason.scrappableRequestInvalid =>
      'scrappable_request_invalid',
    StructuredResponseValidationReason.missingRequiredData =>
      'missing_required_data',
  };
}

class StructuredResponseParseResult {
  final WebScrapperChatAIResponse response;
  final StructuredResponseValidationReason? validationReason;

  const StructuredResponseParseResult({
    required this.response,
    required this.validationReason,
  });

  bool get isRetryableValidationFailure => validationReason != null;
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
///
/// **Why `strict: false`?**
/// This schema uses a discriminated union pattern where different fields are
/// required based on `responseType`. OpenAI's strict mode requires ALL properties
/// to appear in every response, which doesn't work well with:
/// - Optional nested objects (`scrappingBeeFetchSettings`, `scrappableRequest`)
/// - Conditional requirements based on response type
///
/// **Consequence of non-strict mode:**
/// The AI may occasionally return null for "required" fields or omit them entirely.
/// The `parseStructuredResponse()` function handles these cases defensively with
/// sensible defaults (e.g., `render_js: false` if null).
///
/// The schema still declares fields as required to encourage the AI to return
/// proper values - it's "aspirational" rather than "contractual".
const Map<String, dynamic> webScraperResponseJsonSchema = {
  'name': 'WebScraperResponse',
  'strict': false,
  'schema': {
    'type': 'object',
    'additionalProperties': false,
    'properties': {
      'responseType': {
        'type': 'string',
        'enum': ['message', 'error', 'data'],
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
              'type': ['string', 'null'],
            },
          },
          'queryParamsNotRelatedToUrl': {
            'type': 'object',
            'additionalProperties': {
              'type': ['string', 'null'],
            },
          },
          'pathParams': {
            'type': 'array',
            'items': {'type': 'string'},
          },
        },
        'required': [
          'url',
          'queryParam',
          'queryParamsNotRelatedToUrl',
          'pathParams',
        ],
      },
      'scrappingBeeFetchSettings': {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'url': {'type': 'string'},
          'extract_rules': {'type': 'string'},
          'js_scenario': {
            'type': ['string', 'null'],
          },
          'render_js': {'type': 'boolean'},
          'wait': {
            'type': ['integer', 'null'],
            'minimum': 0,
            'maximum': 35000,
          },
          'wait_for': {
            'type': ['string', 'null'],
          },
          'wait_browser': {
            'type': ['string', 'null'],
          },
          'premium_proxy': {'type': 'boolean'},
          'stealth_proxy': {'type': 'boolean'},
          'country_code': {
            'type': ['string', 'null'],
          },
          'session_id': {
            'type': ['string', 'null'],
          },
          'custom_google': {
            'type': ['boolean', 'null'],
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

StructuredResponseParseResult parseStructuredResponseWithValidation(
  Map<String, dynamic> data,
) {
  final responseType = data['responseType'] as String?;

  if (responseType == null) {
    return const StructuredResponseParseResult(
      response: WebScrapperChatAIResponseErrorMessage(
        'Invalid response: missing responseType field',
      ),
      validationReason: StructuredResponseValidationReason.missingRequiredData,
    );
  }

  switch (responseType) {
    case 'message':
      final message = data['message'] as String?;
      if (message == null || message.isEmpty) {
        return const StructuredResponseParseResult(
          response: WebScrapperChatAIResponseErrorMessage(
            'Invalid response: message type but no message content',
          ),
          validationReason:
              StructuredResponseValidationReason.missingRequiredData,
        );
      }
      return StructuredResponseParseResult(
        response: WebScrapperChatAIResponseJustMessage(message),
        validationReason: null,
      );

    case 'error':
      final errorMessage = data['errorMessage'] as String?;
      if (errorMessage == null || errorMessage.isEmpty) {
        return const StructuredResponseParseResult(
          response: WebScrapperChatAIResponseErrorMessage(
            'Invalid response: error type but no error message',
          ),
          validationReason:
              StructuredResponseValidationReason.missingRequiredData,
        );
      }
      return StructuredResponseParseResult(
        response: WebScrapperChatAIResponseErrorMessage(errorMessage),
        validationReason: null,
      );

    case 'data':
      final resumeActionMessage = data['resumeActionMessage'] as String?;
      final scrappingBeeFetchSettingsData = _asStringDynamicMap(
        data['scrappingBeeFetchSettings'],
      );
      final scrappableRequestData = _asStringDynamicMap(
        data['scrappableRequest'],
      );

      if (resumeActionMessage == null) {
        return const StructuredResponseParseResult(
          response: WebScrapperChatAIResponseErrorMessage(
            'Invalid response: data type but missing resumeActionMessage',
          ),
          validationReason:
              StructuredResponseValidationReason.missingRequiredData,
        );
      }

      if (scrappingBeeFetchSettingsData == null &&
          scrappableRequestData == null) {
        return const StructuredResponseParseResult(
          response: WebScrapperChatAIResponseErrorMessage(
            'Invalid response: data type must include either scrappingBeeFetchSettings, scrappableRequest, or both',
          ),
          validationReason:
              StructuredResponseValidationReason.missingRequiredData,
        );
      }

      ScrappingBeeFetchSettings? fetchSettings;
      if (scrappingBeeFetchSettingsData != null) {
        try {
          // Handle extract_rules - AI might return as object instead of JSON string
          final extractRulesRaw =
              scrappingBeeFetchSettingsData['extract_rules'];
          final String extractRules;
          if (extractRulesRaw is String) {
            extractRules = extractRulesRaw;
          } else if (extractRulesRaw is Map) {
            extractRules = jsonEncode(extractRulesRaw);
          } else {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: extract_rules must be a string or object',
              ),
              validationReason:
                  StructuredResponseValidationReason.extractRulesTypeInvalid,
            );
          }

          final fetchUrl = scrappingBeeFetchSettingsData['url'] as String?;
          if (fetchUrl == null || fetchUrl.isEmpty) {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: scrappingBeeFetchSettings.url is required',
              ),
              validationReason:
                  StructuredResponseValidationReason.missingRequiredData,
            );
          }

          // Handle js_scenario - AI might return as object instead of JSON string
          final jsScenarioRaw = scrappingBeeFetchSettingsData['js_scenario'];
          final String? jsScenario;
          if (jsScenarioRaw == null) {
            jsScenario = null;
          } else if (jsScenarioRaw is String) {
            jsScenario = jsScenarioRaw;
          } else if (jsScenarioRaw is Map || jsScenarioRaw is List) {
            jsScenario = jsonEncode(jsScenarioRaw);
          } else {
            jsScenario = null;
          }

          // Handle wait - AI might return as string instead of int
          final waitRaw = scrappingBeeFetchSettingsData['wait'];
          final int? wait = waitRaw is int
              ? waitRaw
              : (waitRaw is String ? int.tryParse(waitRaw) : null);

          // Handle boolean fields defensively - see schema comment above.
          // Since strict: false, AI might return null for "required" booleans.
          // Default to false (most conservative/cheapest option for ScrapingBee).
          final renderJs =
              scrappingBeeFetchSettingsData['render_js'] as bool? ?? false;
          final premiumProxy =
              scrappingBeeFetchSettingsData['premium_proxy'] as bool? ?? false;
          final stealthProxy =
              scrappingBeeFetchSettingsData['stealth_proxy'] as bool? ?? false;

          fetchSettings = ScrappingBeeFetchSettings(
            url: fetchUrl,
            extract_rules: extractRules,
            js_scenario: jsScenario,
            render_js: renderJs,
            premium_proxy: premiumProxy,
            stealth_proxy: stealthProxy,
            wait: wait,
            wait_for: scrappingBeeFetchSettingsData['wait_for'] as String?,
            wait_browser:
                scrappingBeeFetchSettingsData['wait_browser'] as String?,
            country_code:
                scrappingBeeFetchSettingsData['country_code'] as String?,
            // session_id can come as int or string from AI, so convert to string
            session_id: scrappingBeeFetchSettingsData['session_id']?.toString(),
            custom_google:
                scrappingBeeFetchSettingsData['custom_google'] as bool?,
          );
        } catch (e) {
          return StructuredResponseParseResult(
            response: WebScrapperChatAIResponseErrorMessage(
              'Invalid response: could not parse scrappingBeeFetchSettings ($e)',
            ),
            validationReason:
                StructuredResponseValidationReason.missingRequiredData,
          );
        }
      }

      WebScrapperRequest? scrappableRequest;
      if (scrappableRequestData != null) {
        try {
          final requestUrl = scrappableRequestData['url'] as String?;
          if (requestUrl == null || requestUrl.isEmpty) {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: scrappableRequest.url is required',
              ),
              validationReason:
                  StructuredResponseValidationReason.missingRequiredData,
            );
          }

          final queryParam = _parseNullableStringMap(
            scrappableRequestData['queryParam'],
          );
          if (queryParam == null) {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: scrappableRequest.queryParam must be an object or null',
              ),
              validationReason:
                  StructuredResponseValidationReason.scrappableRequestInvalid,
            );
          }

          final queryParamsNotRelatedToUrl = _parseNullableStringMap(
            scrappableRequestData['queryParamsNotRelatedToUrl'],
          );
          if (queryParamsNotRelatedToUrl == null) {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: scrappableRequest.queryParamsNotRelatedToUrl must be an object or null',
              ),
              validationReason:
                  StructuredResponseValidationReason.scrappableRequestInvalid,
            );
          }

          final pathParams = _parseStringList(
            scrappableRequestData['pathParams'],
          );
          if (pathParams == null) {
            return const StructuredResponseParseResult(
              response: WebScrapperChatAIResponseErrorMessage(
                'Invalid response: scrappableRequest.pathParams must be an array or null',
              ),
              validationReason:
                  StructuredResponseValidationReason.scrappableRequestInvalid,
            );
          }

          scrappableRequest = WebScrapperRequest(
            url: requestUrl,
            queryParam: queryParam,
            queryParamsNotRelatedToUrl: queryParamsNotRelatedToUrl,
            pathParams: pathParams,
          );
        } catch (e) {
          return StructuredResponseParseResult(
            response: WebScrapperChatAIResponseErrorMessage(
              'Invalid response: could not parse scrappableRequest ($e)',
            ),
            validationReason:
                StructuredResponseValidationReason.scrappableRequestInvalid,
          );
        }
      }

      final parsedResponse = [
        fetchSettings,
        scrappableRequest,
      ].nonNulls.length; // 1 or 2

      if (parsedResponse == 2 &&
          fetchSettings != null &&
          scrappableRequest != null) {
        return StructuredResponseParseResult(
          response: WebScrapperChatAIResponseBothModified(
            resumeActionMessage: resumeActionMessage,
            fetchSettings: fetchSettings,
            scrappableRequest: scrappableRequest,
          ),
          validationReason: null,
        );
      }

      if (fetchSettings != null) {
        return StructuredResponseParseResult(
          response: WebScrapperChatAIResponseOnlyExtractRulesModified(
            fetchSettings: fetchSettings,
            resumeActionMessage: resumeActionMessage,
          ),
          validationReason: null,
        );
      }

      if (scrappableRequest != null) {
        return StructuredResponseParseResult(
          response: WebScrapperChatAIResponseOnlyRequestModified(
            scrappableRequest: scrappableRequest,
            resumeActionMessage: resumeActionMessage,
          ),
          validationReason: null,
        );
      }

      return const StructuredResponseParseResult(
        response: WebScrapperChatAIResponseErrorMessage(
          'Invalid response: unexpected state in data parsing',
        ),
        validationReason:
            StructuredResponseValidationReason.missingRequiredData,
      );

    default:
      return StructuredResponseParseResult(
        response: WebScrapperChatAIResponseErrorMessage(
          'Invalid response type: $responseType',
        ),
        validationReason:
            StructuredResponseValidationReason.missingRequiredData,
      );
  }
}

WebScrapperChatAIResponse parseStructuredResponse(Map<String, dynamic> data) {
  return parseStructuredResponseWithValidation(data).response;
}

Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}

Map<String, String?>? _parseNullableStringMap(dynamic value) {
  if (value == null) return <String, String?>{};
  if (value is! Map) return null;

  return value.map(
    (key, mapValue) => MapEntry(key.toString(), mapValue?.toString()),
  );
}

List<String>? _parseStringList(dynamic value) {
  if (value == null) return <String>[];
  if (value is! List) return null;
  return value.map((e) => e.toString()).toList();
}
