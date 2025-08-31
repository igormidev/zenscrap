import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ScrappableApiEndpoint extends Endpoint with ApiHelperMixin {
  Future<Map<String, dynamic>> prod(
    Session session, {
    required String scrappableId,
    required String apiKey,
    required Map<String, dynamic> payload,
  }) async =>
      _callFunc(session,
          apiKey: apiKey, payload: payload, scrappableId: scrappableId);

  Future<Map<String, dynamic>> test(
    Session session, {
    required String scrappableId,
    required Map<String, dynamic> payload,
  }) async =>
      _callFunc(session, payload: payload, scrappableId: scrappableId);

  Future<Map<String, dynamic>> _callFunc(
    Session session, {
    required String scrappableId,
    String? apiKey,
    required Map<String, dynamic> payload,
  }) async {
    return wrapAnalytics(session, apiKey,
        (setScrappableCallback, nanoId) async {
      await discountApiTokens(session, nanoId: nanoId);

      final (Scrappable scrappable, ScrappableRequest targetRequest) =
          await getScrappableById(session, scrappableId, nanoId);
      setScrappableCallback(scrappable);
      throwErrorIfIsATestRequestAndTestTimeExpired(apiKey, scrappable);
      final String targetUrl = composeUrl(payload, targetRequest);
      final extractRules = await getExtractRules(session, scrappable, apiKey);

      final ExtractDataByRule result = await scrapingBee.extractByRules(
        targetUrl: targetUrl,
        extractRules: extractRules,
      );

      return result.when(withData: (r) => r, error: scrappingError);
    });
  }
}
