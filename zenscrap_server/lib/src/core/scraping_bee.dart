// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Field used to capture the full HTML when testing extract rules.
const String kZenscrapHtmlCaptureField = '__zenscrap_full_html__';

/// Response model for data extraction (without screenshot).
class ExtractDataByRule {
  final Map<String, dynamic>? result;
  final String? errorMessage;

  const ExtractDataByRule.withData({required this.result})
    : errorMessage = null;

  const ExtractDataByRule.error({required this.errorMessage}) : result = null;

  bool get hasError => errorMessage != null;

  T when<T>({
    required T Function(Map<String, dynamic> result) withData,
    required T Function(String errorMessage) error,
  }) {
    if (hasError) {
      return error(errorMessage!);
    }
    return withData(result!);
  }
}

/// Response model for full data extraction (with screenshot).
class ExtractFullDataByRule {
  final Map<String, dynamic>? result;
  final String? html;
  final Uint8List? screenshot;
  final String? errorMessage;

  const ExtractFullDataByRule.withData({
    required this.result,
    required this.html,
    required this.screenshot,
  }) : errorMessage = null;

  const ExtractFullDataByRule.error({required this.errorMessage})
    : result = null,
      html = null,
      screenshot = null;

  bool get hasError => errorMessage != null;

  T when<T>({
    required T Function(
      Map<String, dynamic> result,
      String html,
      Uint8List screenshot,
    )
    withData,
    required T Function(String errorMessage) error,
  }) {
    if (hasError) {
      return error(errorMessage!);
    }
    return withData(result!, html!, screenshot!);
  }
}

/// Low-level client that wraps the ScrapingBee REST API.
class ScrapingBeeClient {
  ScrapingBeeClient({
    required this.apiKey,
    Dio? dio,
    int defaultRequestTimeoutMs = 140000,
  }) : _defaultRequestTimeoutMs = defaultRequestTimeoutMs,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: _baseUrl,
               connectTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 180),
             ),
           );

  final String apiKey;
  final Dio _dio;
  final int _defaultRequestTimeoutMs;

  static const String _baseUrl = 'https://app.scrapingbee.com/api/v1/';

  Dio get dio => _dio;

  bool isGoogleDomain(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();
      return host.contains('google.') ||
          host.contains('googleapis.') ||
          host.contains('googlevideo.') ||
          host.contains('googleusercontent.') ||
          host.contains('gstatic.') ||
          host.contains('youtube.') ||
          host.contains('ytimg.');
    } catch (_) {
      return false;
    }
  }

  /// Validates and corrects extract_rules format to ensure compatibility with ScrapingBee API.
  String validateAndCorrectExtractRules(String extractRules) {
    try {
      final decoded = jsonDecode(extractRules);

      if (decoded is! Map<String, dynamic>) return extractRules;

      bool needsCorrection = false;
      final corrected = <String, dynamic>{};

      for (final entry in decoded.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is Map<String, dynamic>) {
          // Keep complex types as-is: list, output specifiers, nested structures
          if (value['type'] == 'list' ||
              value.containsKey('output') ||
              value.containsKey('all')) {
            corrected[key] = value;
          } else if (value.containsKey('selector')) {
            needsCorrection = true;
            final selector = value['selector'] as String;

            if (value['type'] == 'attribute' &&
                value.containsKey('attribute')) {
              final attribute = value['attribute'] as String;
              corrected[key] = '$selector@$attribute';
            } else {
              corrected[key] = selector;
            }
          } else {
            corrected[key] = value;
          }
        } else {
          corrected[key] = value;
        }
      }

      if (needsCorrection) {
        final correctedJson = jsonEncode(corrected);
        // ignore: avoid_print
        print(
          '⚠️ Auto-corrected extract_rules format for ScrapingBee. '
          'Original: $extractRules | Corrected: $correctedJson',
        );
        return correctedJson;
      }

      return extractRules;
    } catch (_) {
      return extractRules;
    }
  }

  Map<String, String> buildQueryParameters({
    required String targetUrl,
    required String extract_rules,
    required String? js_scenario,
    required bool render_js,
    required int? wait,
    required String? wait_for,
    required String? wait_browser,
    required bool premium_proxy,
    required bool stealth_proxy,
    required String? country_code,
    required String? session_id,
    required bool? custom_google,
    int? timeout,
    bool jsonResponse = true,
    bool includeScreenshot = false,
  }) {
    final Map<String, String> queryParams = {
      'api_key': apiKey,
      'url': targetUrl,
      'extract_rules': extract_rules,
      'json_response': jsonResponse ? 'true' : 'false',
      'render_js': render_js ? 'true' : 'false',
      'timeout': (timeout ?? _defaultRequestTimeoutMs).toString(),
    };

    if (includeScreenshot) {
      queryParams['screenshot'] = 'true';
      queryParams['screenshot_full_page'] = 'true';
    }

    if (js_scenario != null && js_scenario.isNotEmpty) {
      queryParams['js_scenario'] = js_scenario;
    }

    if (wait != null) queryParams['wait'] = wait.toString();
    if (wait_for != null && wait_for.isNotEmpty) {
      queryParams['wait_for'] = wait_for;
    }
    if (wait_browser != null && wait_browser.isNotEmpty) {
      queryParams['wait_browser'] = wait_browser;
    }

    if (stealth_proxy) {
      queryParams['stealth_proxy'] = 'true';
    } else if (premium_proxy) {
      queryParams['premium_proxy'] = 'true';
    }

    if (country_code != null && country_code.isNotEmpty) {
      queryParams['country_code'] = country_code;
    }
    if (session_id != null && session_id.isNotEmpty) {
      queryParams['session_id'] = session_id;
    }

    final bool isGoogle = isGoogleDomain(targetUrl);
    if (isGoogle || (custom_google == true)) {
      queryParams['custom_google'] = 'true';
    }

    return queryParams;
  }

  Future<ExtractDataByRule> extractByRules({
    required String targetUrl,
    required String extract_rules,
    required String? js_scenario,
    required bool render_js,
    required int? wait,
    required String? wait_for,
    required String? wait_browser,
    required bool premium_proxy,
    required bool stealth_proxy,
    required String? country_code,
    required String? session_id,
    required bool? custom_google,
  }) async {
    final correctedExtractRules = validateAndCorrectExtractRules(extract_rules);

    final queryParams = buildQueryParameters(
      targetUrl: targetUrl,
      extract_rules: correctedExtractRules,
      js_scenario: js_scenario,
      render_js: render_js,
      wait: wait,
      wait_for: wait_for,
      wait_browser: wait_browser,
      premium_proxy: premium_proxy,
      stealth_proxy: stealth_proxy,
      country_code: country_code,
      session_id: session_id,
      custom_google: custom_google,
      includeScreenshot: false,
    );

    try {
      final response = await dio.getUri<dynamic>(
        Uri.https('app.scrapingbee.com', '/api/v1/', queryParams),
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        try {
          Map<String, dynamic>? resultData;

          if (response.data is String) {
            resultData =
                jsonDecode(response.data as String) as Map<String, dynamic>;
          } else {
            resultData = response.data as Map<String, dynamic>;
          }

          final extractedData = resultData['body'] ?? resultData;
          return ExtractDataByRule.withData(
            result: extractedData as Map<String, dynamic>,
          );
        } catch (e) {
          return ExtractDataByRule.error(
            errorMessage: 'Failed to parse response: $e',
          );
        }
      } else {
        return _handleErrorResponse<ExtractDataByRule>(
          response,
          (message) => ExtractDataByRule.error(errorMessage: message),
        );
      }
    } on DioException catch (e) {
      return ExtractDataByRule.error(
        errorMessage: _mapDioExceptionToScrapingBeeError(e),
      );
    }
  }

  Future<ExtractFullDataByRule> fetchHtmlAndScreenshot({
    required String targetUrl,
    required String extract_rules,
    required String? js_scenario,
    required bool render_js,
    required int? wait,
    required String? wait_for,
    required String? wait_browser,
    required bool premium_proxy,
    required bool stealth_proxy,
    required String? country_code,
    required String? session_id,
    required bool? custom_google,
  }) async {
    final correctedExtractRules = validateAndCorrectExtractRules(extract_rules);

    final queryParams = buildQueryParameters(
      targetUrl: targetUrl,
      extract_rules: correctedExtractRules,
      js_scenario: js_scenario,
      render_js: render_js,
      wait: wait,
      wait_for: wait_for,
      wait_browser: wait_browser,
      premium_proxy: premium_proxy,
      stealth_proxy: stealth_proxy,
      country_code: country_code,
      session_id: session_id,
      custom_google: custom_google,
      includeScreenshot: true,
    );

    try {
      final response = await dio.getUri<Map<String, dynamic>>(
        Uri.https('app.scrapingbee.com', '/api/v1/', queryParams),
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        final bodyData = response.data?['body'];
        final String htmlContent = (response.data?['html'] as String?) ?? '';
        final String b64Screenshot =
            (response.data?['screenshot'] as String?) ?? '';

        Map<String, dynamic> extractedData = {};

        if (bodyData != null) {
          if (bodyData is Map<String, dynamic>) {
            extractedData = bodyData;
          } else if (bodyData is String) {
            try {
              extractedData = jsonDecode(bodyData) as Map<String, dynamic>;
            } catch (_) {
              extractedData = {'raw_html': bodyData};
            }
          }
        }

        String finalHtml = htmlContent;
        if (finalHtml.isEmpty &&
            extractedData.containsKey(kZenscrapHtmlCaptureField)) {
          final capturedHtml = extractedData.remove(kZenscrapHtmlCaptureField);
          if (capturedHtml is String && capturedHtml.isNotEmpty) {
            finalHtml = capturedHtml;
          }
        }

        if (finalHtml.isEmpty && bodyData is String) {
          finalHtml = bodyData;
        }

        return ExtractFullDataByRule.withData(
          result: extractedData,
          html: finalHtml,
          screenshot: base64Decode(b64Screenshot),
        );
      } else {
        return _handleErrorResponse<ExtractFullDataByRule>(
          response,
          (message) => ExtractFullDataByRule.error(errorMessage: message),
        );
      }
    } on DioException catch (e) {
      return ExtractFullDataByRule.error(
        errorMessage: _mapDioExceptionToScrapingBeeError(e),
      );
    }
  }

  String _mapDioExceptionToScrapingBeeError(DioException e) {
    final message = e.message ?? 'Unknown network error';
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'ScrapingBee timeout error: $message';
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return 'ScrapingBee network error: $message';
      case DioExceptionType.badResponse:
        return 'ScrapingBee API response error: $message';
    }
  }

  T _handleErrorResponse<T>(
    Response<dynamic> response,
    T Function(String message) onError,
  ) {
    try {
      final data = response.data;
      final statusCode = response.statusCode;
      final isTimeoutLike = statusCode == 408 || statusCode == 504;

      if (data is String) {
        if (isTimeoutLike) {
          return onError(
            'ScrapingBee timeout error: $data (Status: $statusCode)',
          );
        }
        return onError('ScrapingBee API error: $data (Status: $statusCode)');
      }
      if (data is Map<String, dynamic>) {
        final message = data['message'] ?? data;
        if (isTimeoutLike) {
          return onError(
            'ScrapingBee timeout error: $message (Status: $statusCode)',
          );
        }
        return onError('ScrapingBee API error: $message (Status: $statusCode)');
      }
      if (isTimeoutLike) {
        return onError('ScrapingBee timeout error (Status: $statusCode)');
      }
      return onError('ScrapingBee API error (Status: $statusCode)');
    } catch (_) {
      return onError('ScrapingBee API error (Status: ${response.statusCode})');
    }
  }
}

/// Convenience wrapper used across the server to interact with ScrapingBee.
class ScrapingBee {
  ScrapingBee({String apiKey = '', Dio? dio})
    : _client = ScrapingBeeClient(apiKey: apiKey, dio: dio);

  final ScrapingBeeClient _client;

  Future<ExtractFullDataByRule> fetchHtmlAndScreenshotWithLogic({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    final String extractRulesWithHtml = _withHtmlCapture(
      scrappingBeeExtractLogic.extractRules,
    );

    return _client.fetchHtmlAndScreenshot(
      targetUrl: targetUrl,
      extract_rules: extractRulesWithHtml,
      js_scenario: scrappingBeeExtractLogic.jsScenario,
      render_js: scrappingBeeExtractLogic.renderJs,
      wait: scrappingBeeExtractLogic.wait,
      wait_for: scrappingBeeExtractLogic.waitFor,
      wait_browser: scrappingBeeExtractLogic.waitBrowser,
      premium_proxy: scrappingBeeExtractLogic.premiumProxy,
      stealth_proxy: scrappingBeeExtractLogic.stealthProxy,
      country_code: scrappingBeeExtractLogic.countryCode,
      session_id: scrappingBeeExtractLogic.sessionId,
      custom_google: scrappingBeeExtractLogic.customGoogle,
    );
  }

  Future<ExtractDataByRule> extractByRulesWithLogic({
    required String targetUrl,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
  }) async {
    return _client.extractByRules(
      targetUrl: targetUrl,
      extract_rules: scrappingBeeExtractLogic.extractRules,
      js_scenario: scrappingBeeExtractLogic.jsScenario,
      render_js: scrappingBeeExtractLogic.renderJs,
      wait: scrappingBeeExtractLogic.wait,
      wait_for: scrappingBeeExtractLogic.waitFor,
      wait_browser: scrappingBeeExtractLogic.waitBrowser,
      premium_proxy: scrappingBeeExtractLogic.premiumProxy,
      stealth_proxy: scrappingBeeExtractLogic.stealthProxy,
      country_code: scrappingBeeExtractLogic.countryCode,
      session_id: scrappingBeeExtractLogic.sessionId,
      custom_google: scrappingBeeExtractLogic.customGoogle,
    );
  }

  String _withHtmlCapture(String extractRules) {
    try {
      final decoded = jsonDecode(extractRules);
      if (decoded is Map<String, dynamic>) {
        if (!decoded.containsKey(kZenscrapHtmlCaptureField)) {
          decoded[kZenscrapHtmlCaptureField] = {
            'selector': 'html',
            'output': 'html',
          };
          return jsonEncode(decoded);
        }
      }
    } catch (_) {
      // ignore parsing issues and return the original rules
    }

    return extractRules;
  }
}

ScrapingBee scrappingBee = ScrapingBee(apiKey: '');
