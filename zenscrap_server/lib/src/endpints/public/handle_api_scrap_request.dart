import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

class HandleApiScrapRequest extends Endpoint {
  Future<Map<String, dynamic>> call(
    Session session, {
    required int scrappableId,
    required Map<String, dynamic> payload,
  }) async {
    final Scrappable? scrappable =
        await Scrappable.db.findById(session, scrappableId,
            include: Scrappable.include(
              targetRequest: ScrappableTargetRequestStructure.include(),
            ));
    final ScrappableTargetRequestStructure? targetRequest =
        scrappable?.targetRequest;
    if (scrappable == null || targetRequest == null) {
      throw Exception('Scrappable not found');
    }
    if (scrappable.isActive == false) {
      throw Exception('This scrappable is no longer active');
    }

    String targetUrl = targetRequest.url;
    // First, add the path parameters
    for (final String pathParam in targetRequest.pathParams) {
      targetUrl = targetUrl.replaceAll('{$pathParam}', pathParam);
    }
    // Now, let's add query parameters
    final Map<String, String> queryParams = {};
    for (final MapEntry<String, String?> entry
        in targetRequest.queryParams.entries) {
      final String queryParamName = entry.key;
      final String? defaultQueryParam = entry.value;
      final String? payloadQueryParam = payload[queryParamName];
      final String? queryParam = payloadQueryParam ?? defaultQueryParam;
      if (queryParam != null) {
        queryParams[queryParamName] = queryParam;
      }
    }
    if (queryParams.isNotEmpty) {
      targetUrl += '?${Uri(queryParameters: queryParams).query}';
    }

    final String scrapExtractRules = scrappable.scrappingRules;
    final String? scrapingBeeApi = session.passwords['scrapingBeeApi'];

    if (scrapingBeeApi == null) {
      throw Exception('ScrapingBee API key not configured');
    }

    final Uri scrapingBeeUrl = Uri.parse('https://app.scrapingbee.com/api/v1/');
    final Map<String, String> queryParameters = {
      'api_key': scrapingBeeApi,
      'url': targetUrl,
      'extract_rules': scrapExtractRules,
      'render_js': 'true',
      'json_response': 'true',
      'wait': '3000',
    };

    try {
      final Uri requestUrl =
          scrapingBeeUrl.replace(queryParameters: queryParameters);
      final http.Response response = await http.get(requestUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('extract_rules')) {
          final dynamic extractedData = responseData['extract_rules'];
          if (extractedData is Map<String, dynamic>) {
            return extractedData;
          } else if (extractedData is List) {
            return {'data': extractedData};
          } else {
            return {'data': extractedData};
          }
        }

        return responseData;
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(
            'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to scrape data: $e');
    }
  }
}
