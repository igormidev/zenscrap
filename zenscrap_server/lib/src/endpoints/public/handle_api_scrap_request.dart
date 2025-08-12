import 'package:dio/dio.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable_target_request.dart';

class HandleApiScrapRequestEndpoint extends Endpoint {
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
      final String? payloadParam = payload[pathParam];
      if (payloadParam == null) {
        throw Exception(
          'Missing required path parameter: $pathParam',
        );
      }
      targetUrl = targetUrl.replaceAll('{$pathParam}', payloadParam);
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
    final String? scrapingBeeApiKey = session.passwords['scrapingBeeApiKey'];

    if (scrapingBeeApiKey == null) {
      throw Exception('ScrapingBee API key not configured');
    }

    final Dio dio = Dio();
    final String scrapingBeeUrl = 'https://app.scrapingbee.com/api/v1/';
    final Map<String, String> queryParameters = {
      'api_key': scrapingBeeApiKey,
      'url': targetUrl,
      'extract_rules': scrapExtractRules,
      'render_js': 'true',
      'json_response': 'true',
      'wait': '3000',
    };

    try {
      final Response<dynamic> response = await dio.get(
        scrapingBeeUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data is String
            ? Map<String, dynamic>.from(response.data as Map)
            : response.data as Map<String, dynamic>;

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
        final Map<String, dynamic> errorResponse = response.data is String
            ? Map<String, dynamic>.from(response.data as Map)
            : response.data as Map<String, dynamic>;
        throw Exception(
            'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final Map<String, dynamic> errorResponse = e.response!.data is String
            ? Map<String, dynamic>.from(e.response!.data as Map)
            : e.response!.data as Map<String, dynamic>;
        throw Exception(
            'ScrapingBee API error: ${errorResponse['message'] ?? 'Unknown error'} (Status: ${e.response!.statusCode})');
      }
      throw Exception('Failed to scrape data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to scrape data: $e');
    }
  }
}
