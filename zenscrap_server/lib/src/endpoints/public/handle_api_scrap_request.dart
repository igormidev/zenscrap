import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

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

    final ExtractDataByRule result = await scrapingBee.extractByRules(
      targetUrl: targetUrl,
      extractRules: scrapExtractRules,
    );

    return result.when(
      withData: (result) => result,
      erorr: (errorMessage) => throw Exception(errorMessage),
    );
  }
}
