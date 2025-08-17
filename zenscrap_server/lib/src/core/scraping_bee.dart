import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scraping_bee.freezed.dart';

class ScrapingBee {
  ScrapingBee()
      : _dio = Dio(BaseOptions(baseUrl: 'https://app.scrapingbee.com/api/v1/'));
  static String _apiKey = '';
  static void initialize(String apiKey) => _apiKey = apiKey;

  final Dio _dio;

  /// Get the (optionally JS-rendered) HTML of a page
  Future<String> fetchHtml(
    String targetUrl, {
    bool renderJs = false,
    int? waitMs, // 0..35000
    String? waitForSelector,
    Map<String, String>? headers,
  }) async {
    final query = <String, dynamic>{
      'api_key': _apiKey,
      'url': targetUrl,
      if (renderJs) 'render_js': 'true',
      if (waitMs != null) 'wait': waitMs,
      if (waitForSelector != null && waitForSelector.isNotEmpty)
        'wait_for': waitForSelector,
    };

    final res = await _dio.getUri<String>(
      Uri.https('app.scrapingbee.com', '/api/v1/', query),
      options: Options(
        responseType: ResponseType.plain,
        headers: headers == null
            ? null
            : {
                // Forward custom headers to the target site:
                // Prefix with Spb- per docs.
                for (final e in headers.entries) 'Spb-${e.key}': e.value,
              },
      ),
    );
    return res.data ?? '';
  }

  /// Save a FULL-PAGE screenshot (PNG) to disk
  Future<File> takeFullPageScreenshot(
    String targetUrl, {
    required String savePath,
    int? windowWidth, // e.g., 1920
    int? windowHeight, // e.g., 1080
  }) async {
    final query = <String, dynamic>{
      'api_key': _apiKey,
      'url': targetUrl,
      'render_js': 'true', // screenshots require JS rendering
      'screenshot': 'true',
      'screenshot_full_page': 'true',
      if (windowWidth != null) 'window_width': windowWidth,
      if (windowHeight != null) 'window_height': windowHeight,
    };

    final res = await _dio.getUri<Uint8List>(
      Uri.https('app.scrapingbee.com', '/api/v1/', query),
      options: Options(responseType: ResponseType.bytes),
    );

    final file = File(savePath);
    await file.writeAsBytes(res.data as List<int>);
    return file;
  }

  /// One-call: get HTML + screenshot (base64) together using json_response
  /// Ps: the image is in png format
  Future<(String html, Uint8List screenshot)> fetchHtmlAndScreenshot(
      String targetUrl) async {
    final query = <String, dynamic>{
      'api_key': _apiKey,
      'url': targetUrl,
      'render_js': 'true',
      'screenshot': 'true',
      'wait': 4000.toString(),
      'screenshot_full_page': 'true',
      'json_response': 'true',
    };

    final res = await _dio.getUri<Map<String, dynamic>>(
      Uri.https('app.scrapingbee.com', '/api/v1/', query),
      options: Options(responseType: ResponseType.json),
    );

    final body = (res.data?['body'] as String?) ?? '';
    final b64 = (res.data?['screenshot'] as String?) ?? '';
    return (body, base64Decode(b64));
    // return (html: body, screenshot: base64Decode(b64));
  }

  Future<ExtractDataByRule> extractByRules({
    required String targetUrl,
    required String extractRules,
    bool renderJs = true,
    int waitMs = 4000,
  }) async {
    final Map<String, String> queryParameters = {
      'api_key': _apiKey,
      'url': targetUrl,
      'extract_rules': extractRules,
      'render_js': renderJs ? 'true' : 'false',
      'json_response': 'true',
      'wait': waitMs.toString(),
    };

    try {
      final Response<dynamic> response = await _dio.get(
        '',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data is String
            ? Map<String, dynamic>.from(response.data as Map)
            : response.data as Map<String, dynamic>;

        if (responseData.containsKey('extract_rules')) {
          final dynamic extractedData = responseData['extract_rules'];
          if (extractedData is Map<String, dynamic>) {
            return ExtractDataByRule.withData(result: extractedData);
          } else if (extractedData is List) {
            return ExtractDataByRule.withData(result: {'data': extractedData});
          } else {
            return ExtractDataByRule.withData(result: {'data': extractedData});
          }
        }

        return ExtractDataByRule.withData(result: responseData);
      } else {
        final Map<String, dynamic> errorResponse = response.data is String
            ? Map<String, dynamic>.from(response.data as Map)
            : response.data as Map<String, dynamic>;
        return ExtractDataByRule.erorr(
          errorMessage:
              'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final Map<String, dynamic> errorResponse = e.response!.data is String
            ? Map<String, dynamic>.from(e.response!.data as Map)
            : e.response!.data as Map<String, dynamic>;
        return ExtractDataByRule.erorr(
          errorMessage:
              'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${e.response!.statusCode})',
        );
      }
      return ExtractDataByRule.erorr(
        errorMessage: 'Failed to scrape data: ${e.message}',
      );
    } catch (e) {
      return ExtractDataByRule.erorr(
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

  const factory ExtractDataByRule.erorr({
    required String errorMessage,
  }) = _ExtractDataByRuleWithError;
}
