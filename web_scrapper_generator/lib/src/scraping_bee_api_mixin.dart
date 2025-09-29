// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

/// Response model for data extraction (without screenshot)
class ExtractDataByRule {
  final Map<String, dynamic>? result;
  final String? errorMessage;

  const ExtractDataByRule.withData({required Map<String, dynamic> this.result})
    : errorMessage = null;

  const ExtractDataByRule.error({required String this.errorMessage})
    : result = null;

  bool get hasError => errorMessage != null;

  T when<T>({
    required T Function(Map<String, dynamic> result) withData,
    required T Function(String errorMessage) error,
  }) {
    if (hasError) {
      return error(errorMessage!);
    } else {
      return withData(result!);
    }
  }
}

/// Response model for full data extraction (with screenshot)
class ExtractFullDataByRule {
  final Map<String, dynamic>? result;
  final String? html;
  final Uint8List? screenshot;
  final String? errorMessage;

  const ExtractFullDataByRule.withData({
    required Map<String, dynamic> this.result,
    required String this.html,
    required Uint8List this.screenshot,
  }) : errorMessage = null;

  const ExtractFullDataByRule.error({required String this.errorMessage})
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
    } else {
      return withData(result!, html!, screenshot!);
    }
  }
}

/// Unified mixin for ScrapingBee API interactions
/// This is the single source of truth for all ScrapingBee API calls
mixin ScrapingBeeApiMixin {
  static final String _apiKey =
      '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K';
  static const String _baseUrl = 'https://app.scrapingbee.com/api/v1/';

  // /// Set the API key for all ScrapingBee operations
  // static void setApiKey(String apiKey) => _apiKey = apiKey;

  // /// Get the current API key (for MCP server that has its own key)
  // static String get apiKey => _apiKey;

  /// Dio client for making requests
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  /// Check if a URL belongs to a Google domain
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
    } catch (e) {
      return false;
    }
  }

  /// Build query parameters for ScrapingBee API
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
    bool includeScreenshot = false,
  }) {
    final Map<String, String> queryParams = {
      'api_key': _apiKey,
      'url': targetUrl,
      'extract_rules': extract_rules,
      'json_response': 'true',
      'render_js': render_js ? 'true' : 'false',
    };

    // Add screenshot parameters if needed
    if (includeScreenshot) {
      queryParams['screenshot'] = 'true';
      queryParams['screenshot_full_page'] = 'true';
    }

    // Add optional JavaScript scenario
    if (js_scenario != null && js_scenario.isNotEmpty) {
      queryParams['js_scenario'] = js_scenario;
    }

    // Add wait time (0-35000 milliseconds)
    if (wait != null) {
      queryParams['wait'] = wait.toString();
    }

    // Add wait for selector (CSS or XPath)
    if (wait_for != null && wait_for.isNotEmpty) {
      queryParams['wait_for'] = wait_for;
    }

    // Add wait browser event
    if (wait_browser != null && wait_browser.isNotEmpty) {
      queryParams['wait_browser'] = wait_browser;
    }

    // Add proxy settings - IMPORTANT: stealth_proxy supersedes premium_proxy
    if (stealth_proxy) {
      queryParams['stealth_proxy'] = 'true';
      // Don't set premium_proxy when stealth_proxy is true
    } else if (premium_proxy) {
      queryParams['premium_proxy'] = 'true';
    }

    // Add country code for proxy geolocation
    if (country_code != null && country_code.isNotEmpty) {
      queryParams['country_code'] = country_code;
    }

    // Add session ID for sticky sessions
    if (session_id != null && session_id.isNotEmpty) {
      queryParams['session_id'] = session_id;
    }

    // Check if URL is a Google domain and set custom_google
    final bool isGoogle = isGoogleDomain(targetUrl);
    if (isGoogle || (custom_google == true)) {
      queryParams['custom_google'] = 'true';
    }

    return queryParams;
  }

  /// Extract data using rules (without screenshot)
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
    final queryParams = buildQueryParameters(
      targetUrl: targetUrl,
      extract_rules: extract_rules,
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
      print(Uri.https('app.scrapingbee.com', '/api/v1/', queryParams));
      final response = await dio.getUri<dynamic>(
        Uri.https('app.scrapingbee.com', '/api/v1/', queryParams),
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        // Handle different response formats from ScrapingBee
        try {
          Map<String, dynamic>? resultData;

          if (response.data is String) {
            try {
              resultData =
                  jsonDecode(response.data as String) as Map<String, dynamic>;
            } catch (e) {
              // If it's not JSON, treat it as raw HTML response
              return ExtractDataByRule.withData(
                result: {'raw_html': response.data},
              );
            }
          } else {
            resultData = response.data as Map<String, dynamic>;
          }

          // Extract the body which contains the extracted data
          final extractedData = resultData['body'] ?? resultData;

          return ExtractDataByRule.withData(result: extractedData);
        } catch (e) {
          return ExtractDataByRule.error(
            errorMessage: 'Failed to parse response: $e',
          );
        }
      } else {
        // Error response
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
      // Network or Dio-specific errors
      String errorMessage = 'Network error';

      if (e.response != null) {
        try {
          final Map<String, dynamic> errorDetails;
          if (e.response!.data is String) {
            try {
              errorDetails =
                  jsonDecode(e.response!.data as String)
                      as Map<String, dynamic>;
            } catch (_) {
              return ExtractDataByRule.error(
                errorMessage:
                    'ScrapingBee API error: ${e.response!.data} (Status: ${e.response!.statusCode})',
              );
            }
          } else {
            errorDetails = e.response!.data as Map<String, dynamic>;
          }
          errorMessage = errorDetails['message'] ?? 'ScrapingBee API error';
        } catch (_) {
          errorMessage =
              'ScrapingBee API error (Status: ${e.response!.statusCode})';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout - the target site may be slow or unresponsive';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Response timeout - the extraction took too long';
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }

      return ExtractDataByRule.error(errorMessage: errorMessage);
    } catch (e) {
      // Any other unexpected errors
      return ExtractDataByRule.error(errorMessage: 'Failed to scrape data: $e');
    }
  }

  /// Fetch HTML and screenshot
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
    final queryParams = buildQueryParameters(
      targetUrl: targetUrl,
      extract_rules: extract_rules,
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
        final body = (response.data?['body'] as String?) ?? '';
        final b64 = (response.data?['screenshot'] as String?) ?? '';

        // The 'body' field contains the extracted data when extract_rules are provided
        // Parse it as JSON to get the extracted data
        Map<String, dynamic> extractedData = {};
        try {
          if (body.isNotEmpty) {
            extractedData = jsonDecode(body) as Map<String, dynamic>;
          }
        } catch (e) {
          // If body is not JSON, it might be raw HTML
          extractedData = {'raw_html': body};
        }

        return ExtractFullDataByRule.withData(
          result: extractedData,
          html:
              response.data?['html'] ??
              body, // Use 'html' field if available, otherwise use body
          screenshot: base64Decode(b64),
        );
      } else {
        // Error response
        try {
          final Map<String, dynamic> errorResponse;
          if (response.data is String) {
            try {
              errorResponse =
                  jsonDecode(response.data as String) as Map<String, dynamic>;
            } catch (_) {
              return ExtractFullDataByRule.error(
                errorMessage:
                    'ScrapingBee API error: ${response.data} (Status: ${response.statusCode})',
              );
            }
          } else {
            errorResponse = response.data as Map<String, dynamic>;
          }
          return ExtractFullDataByRule.error(
            errorMessage:
                'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})',
          );
        } catch (e) {
          return ExtractFullDataByRule.error(
            errorMessage:
                'ScrapingBee API error (Status: ${response.statusCode})',
          );
        }
      }
    } on DioException catch (e) {
      // Network or Dio-specific errors
      String errorMessage = 'Network error';

      if (e.response != null) {
        try {
          final Map<String, dynamic> errorDetails;
          if (e.response!.data is String) {
            try {
              errorDetails =
                  jsonDecode(e.response!.data as String)
                      as Map<String, dynamic>;
            } catch (_) {
              return ExtractFullDataByRule.error(
                errorMessage:
                    'ScrapingBee API error: ${e.response!.data} (Status: ${e.response!.statusCode})',
              );
            }
          } else {
            errorDetails = e.response!.data as Map<String, dynamic>;
          }
          errorMessage = errorDetails['message'] ?? 'ScrapingBee API error';
        } catch (_) {
          errorMessage =
              'ScrapingBee API error (Status: ${e.response!.statusCode})';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout - the target site may be slow or unresponsive';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Response timeout - the extraction took too long';
      } else {
        errorMessage = e.message ?? 'Network error occurred';
      }

      return ExtractFullDataByRule.error(errorMessage: errorMessage);
    } catch (e) {
      // Any other unexpected errors
      return ExtractFullDataByRule.error(
        errorMessage: 'Failed to fetch data from ScrapingBee: $e',
      );
    }
  }
}
