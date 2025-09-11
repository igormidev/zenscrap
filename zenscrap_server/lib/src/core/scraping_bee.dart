import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_server/src/core/extension/convert_extensions.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

part 'scraping_bee.freezed.dart';

class ScrapingBee {
  ScrapingBee()
      : _dio = Dio(BaseOptions(baseUrl: 'https://app.scrapingbee.com/api/v1/'));
  static String _apiKey = '';
  static void initialize(String apiKey) => _apiKey = apiKey;

  final Dio _dio;

  Future<ExtractFullDataByRule> fetchHtmlAndScreenshot({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    try {
      final Map<String, String> queryParameters = {
        'api_key': _apiKey,
        'url': targetUrl,
        'screenshot': 'true',
        'screenshot_full_page': 'true',
        'json_response': 'true',
        'render_js': scrappingBeeExtractLogic.renderJs ? 'true' : 'false',
        'extract_rules': scrappingBeeExtractLogic.extractRules,
      };

      // Add optional JavaScript scenario
      if (scrappingBeeExtractLogic.jsScenario != null &&
          scrappingBeeExtractLogic.jsScenario!.isNotEmpty) {
        queryParameters['js_scenario'] = scrappingBeeExtractLogic.jsScenario!;
      }

      // Add wait time (0-35000 milliseconds)
      if (scrappingBeeExtractLogic.wait != null) {
        queryParameters['wait'] = scrappingBeeExtractLogic.wait.toString();
      }

      // Add wait for selector (CSS or XPath)
      if (scrappingBeeExtractLogic.waitFor != null &&
          scrappingBeeExtractLogic.waitFor!.isNotEmpty) {
        queryParameters['wait_for'] = scrappingBeeExtractLogic.waitFor!;
      }

      // Add wait browser event (domcontentloaded, load, networkidle0, networkidle2)
      if (scrappingBeeExtractLogic.waitBrowser != null &&
          scrappingBeeExtractLogic.waitBrowser!.isNotEmpty) {
        queryParameters['wait_browser'] = scrappingBeeExtractLogic.waitBrowser!;
      }

      // Add premium proxy setting
      if (scrappingBeeExtractLogic.premiumProxy) {
        queryParameters['premium_proxy'] = 'true';
      }

      // Add country code for proxy geolocation
      if (scrappingBeeExtractLogic.countryCode != null &&
          scrappingBeeExtractLogic.countryCode!.isNotEmpty) {
        queryParameters['country_code'] = scrappingBeeExtractLogic.countryCode!;
      }

      // Add session ID for sticky sessions
      if (scrappingBeeExtractLogic.sessionId != null &&
          scrappingBeeExtractLogic.sessionId!.isNotEmpty) {
        queryParameters['session_id'] = scrappingBeeExtractLogic.sessionId!;
      }

      // Add custom Google handling
      if (scrappingBeeExtractLogic.customGoogle != null &&
          scrappingBeeExtractLogic.customGoogle!) {
        queryParameters['custom_google'] = 'true';
      }

      final res = await _dio.getUri<Map<String, dynamic>>(
        Uri.https('app.scrapingbee.com', '/api/v1/', queryParameters),
        options: Options(responseType: ResponseType.json),
      );

      final body = (res.data?['body'] as String?) ?? '';
      final b64 = (res.data?['screenshot'] as String?) ?? '';
      final bodyExtract = (res.data?['body_extract'] as Map<String, dynamic>?) ?? {};
      return ExtractFullDataByRule.withData(
        result: bodyExtract,
        html: body,
        screenshot: base64Decode(b64),
      );
    } on DioException catch (e) {
      // Return error for any Dio errors (including 500 status codes)
      return ExtractFullDataByRule.error(
        errorMessage: e.response?.data?.toString() ?? e.message ?? 'Failed to fetch data from ScrapingBee',
      );
    } catch (e) {
      // Return error for any other unexpected errors
      return ExtractFullDataByRule.error(
        errorMessage: e.toString(),
      );
    }
  }

  Future<ExtractDataByRule> extractByRules({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    final Map<String, String> queryParameters = {
      'api_key': _apiKey,
      'url': targetUrl,
      'extract_rules': scrappingBeeExtractLogic.extractRules,
      'json_response': 'true',
      'render_js': scrappingBeeExtractLogic.renderJs ? 'true' : 'false',
    };

    // Add optional JavaScript scenario
    if (scrappingBeeExtractLogic.jsScenario != null &&
        scrappingBeeExtractLogic.jsScenario!.isNotEmpty) {
      queryParameters['js_scenario'] = scrappingBeeExtractLogic.jsScenario!;
    }

    // Add wait time (0-35000 milliseconds)
    if (scrappingBeeExtractLogic.wait != null) {
      queryParameters['wait'] = scrappingBeeExtractLogic.wait.toString();
    }

    // Add wait for selector (CSS or XPath)
    if (scrappingBeeExtractLogic.waitFor != null &&
        scrappingBeeExtractLogic.waitFor!.isNotEmpty) {
      queryParameters['wait_for'] = scrappingBeeExtractLogic.waitFor!;
    }

    // Add wait browser event (domcontentloaded, load, networkidle0, networkidle2)
    if (scrappingBeeExtractLogic.waitBrowser != null &&
        scrappingBeeExtractLogic.waitBrowser!.isNotEmpty) {
      queryParameters['wait_browser'] = scrappingBeeExtractLogic.waitBrowser!;
    }

    // Add premium proxy setting
    if (scrappingBeeExtractLogic.premiumProxy) {
      queryParameters['premium_proxy'] = 'true';
    }

    // Add country code for proxy geolocation
    if (scrappingBeeExtractLogic.countryCode != null &&
        scrappingBeeExtractLogic.countryCode!.isNotEmpty) {
      queryParameters['country_code'] = scrappingBeeExtractLogic.countryCode!;
    }

    // Add session ID for sticky sessions
    if (scrappingBeeExtractLogic.sessionId != null &&
        scrappingBeeExtractLogic.sessionId!.isNotEmpty) {
      queryParameters['session_id'] = scrappingBeeExtractLogic.sessionId!;
    }

    // Add custom Google handling
    if (scrappingBeeExtractLogic.customGoogle != null &&
        scrappingBeeExtractLogic.customGoogle!) {
      queryParameters['custom_google'] = 'true';
    }

    try {
      final Response<dynamic> response = await _dio.getUri(
        Uri.https('app.scrapingbee.com', '/api/v1/', queryParameters),
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        // Handle different response formats from ScrapingBee
        try {
          Map<String, dynamic>? resultData = tryDecode(response.data);

          return ExtractDataByRule.withData(result: resultData?['body'] ?? {});
        } catch (e) {
          return ExtractDataByRule.error(
            errorMessage: 'Failed to parse response: $e',
          );
        }
      } else {
        try {
          final Map<String, dynamic> errorResponse;
          if (response.data is String) {
            try {
              errorResponse =
                  jsonDecode(response.data as String) as Map<String, dynamic>;
            } catch (_) {
              return ExtractDataByRule.error(
                errorMessage:
                    'ScrapingBee API error: ${response.data} (Status: ${response.statusCode})',
              );
            }
          } else {
            errorResponse = response.data as Map<String, dynamic>;
          }
          return ExtractDataByRule.error(
            errorMessage:
                'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})',
          );
        } catch (e) {
          return ExtractDataByRule.error(
            errorMessage:
                'ScrapingBee API error (Status: ${response.statusCode})',
          );
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          final Map<String, dynamic> errorResponse;
          if (e.response!.data is String) {
            try {
              errorResponse = jsonDecode(e.response!.data as String)
                  as Map<String, dynamic>;
            } catch (_) {
              return ExtractDataByRule.error(
                errorMessage:
                    'ScrapingBee API error: ${e.response!.data} (Status: ${e.response!.statusCode})',
              );
            }
          } else {
            errorResponse = e.response!.data as Map<String, dynamic>;
          }
          return ExtractDataByRule.error(
            errorMessage:
                'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${e.response!.statusCode})',
          );
        } catch (_) {
          return ExtractDataByRule.error(
            errorMessage:
                'ScrapingBee API error (Status: ${e.response!.statusCode})',
          );
        }
      }
      return ExtractDataByRule.error(
        errorMessage: 'Failed to scrape data: ${e.message}',
      );
    } catch (e) {
      return ExtractDataByRule.error(
        errorMessage: 'Failed to scrape data: $e',
      );
    }
  }
}

@freezed
class ExtractDataByRule with _$ExtractDataByRule {
  const ExtractDataByRule._();

  const factory ExtractDataByRule.withData({
    required Map<String, dynamic> result,
  }) = _ExtractDataByRuleWithData;

  const factory ExtractDataByRule.error({
    required String errorMessage,
  }) = _ExtractDataByRuleWithError;
}

@freezed
class ExtractFullDataByRule with _$ExtractFullDataByRule {
  const ExtractFullDataByRule._();

  const factory ExtractFullDataByRule.withData({
    required Map<String, dynamic> result,
    required String html,
    required Uint8List screenshot,
  }) = _ExtractFullDataByRuleWithData;

  const factory ExtractFullDataByRule.error({
    required String errorMessage,
  }) = _ExtractFullDataByRuleWithError;
}
