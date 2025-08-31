import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ScrappableApiRoute extends Route with ApiHelperMixin {
  final scrapingBee = ScrapingBee();

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    try {
      // Only handle POST requests
      if (request.method != 'POST') {
        request.response.statusCode = HttpStatus.methodNotAllowed;
        request.response
            .write(jsonEncode({'error': 'Method not allowed. Use POST.'}));
        await request.response.close();
        return true;
      }

      // Read the request body
      final body = await utf8.decoder.bind(request).join();

      // Parse JSON body
      Map<String, dynamic> requestData;
      try {
        requestData = jsonDecode(body) as Map<String, dynamic>;
      } catch (e) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write(jsonEncode({'error': 'Invalid JSON body'}));
        await request.response.close();
        return true;
      }

      // Extract parameters
      final scrappableId = requestData['scrappableId'] as String?;
      final payload = requestData['payload'] as Map<String, dynamic>? ?? {};

      if (scrappableId == null) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write(
            jsonEncode({'error': 'Missing required parameter: scrappableId'}));
        await request.response.close();
        return true;
      }

      // Check if this is a test or production call based on the path
      final isTest = request.uri.path.endsWith('/test');
      final apiKey = isTest ? null : requestData['apiKey'] as String?;

      if (!isTest && apiKey == null) {
        request.response.statusCode = HttpStatus.unauthorized;
        request.response.write(
            jsonEncode({'error': 'API key required for production calls'}));
        await request.response.close();
        return true;
      }

      // Process the scrappable request
      final result = await _processScrappableRequest(
        session,
        scrappableId: scrappableId,
        apiKey: apiKey,
        payload: payload,
      );

      // Send response
      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(result));
      await request.response.close();
      return true;
    } catch (e) {
      session.log('Error in ScrappableApiRoute: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(jsonEncode({
        'error': 'Internal server error',
        'message': e.toString(),
      }));
      await request.response.close();
      return true;
    }
  }

  Future<Map<String, dynamic>> _processScrappableRequest(
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
