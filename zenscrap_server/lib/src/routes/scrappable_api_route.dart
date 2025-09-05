import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ScrappableApiRoute extends Route with ApiHelperMixin {
  final bool isProd;

  ScrappableApiRoute({required this.isProd});

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    try {
      // Only accept POST requests
      if (request.method != 'POST') {
        await _sendError(
          request,
          HttpStatus.methodNotAllowed,
          'Method Not Allowed',
          'Only POST method is allowed',
        );
        return true;
      }

      // Read and parse the request body
      final body = await utf8.decoder.bind(request).join();
      if (body.isEmpty) {
        await _sendError(
          request,
          HttpStatus.badRequest,
          'Bad Request',
          'Request body is required',
        );
        return true;
      }

      Map<String, dynamic> requestData;
      try {
        requestData = jsonDecode(body);
      } catch (e) {
        await _sendError(
          request,
          HttpStatus.badRequest,
          'Bad Request',
          'Invalid JSON in request body',
        );
        return true;
      }

      // Extract required parameters
      final scrappableId = requestData['scrappableId'];
      final payloadRaw = requestData['payload'];
      
      // Validate scrappableId
      if (scrappableId == null || scrappableId is! int) {
        await _sendError(
          request,
          HttpStatus.badRequest,
          'Bad Request',
          'scrappableId is required and must be an integer',
        );
        return true;
      }

      // Validate and cast payload
      if (payloadRaw == null || payloadRaw is! Map) {
        await _sendError(
          request,
          HttpStatus.badRequest,
          'Bad Request',
          'payload is required and must be an object',
        );
        return true;
      }
      
      // Cast payload to proper type
      final payload = Map<String, dynamic>.from(payloadRaw);

      // For production endpoint, extract and validate API key
      String? apiKey;
      if (isProd) {
        final apiKeyRaw = requestData['apiKey'];
        if (apiKeyRaw == null || apiKeyRaw is! String || apiKeyRaw.isEmpty) {
          await _sendError(
            request,
            HttpStatus.unauthorized,
            'Unauthorized',
            'API key is required for production endpoint',
          );
          return true;
        }
        apiKey = apiKeyRaw;
      }

      // Call the scraping logic
      Map<String, dynamic> result;
      try {
        result = await _callFunc(
          session,
          scrappableId: scrappableId,
          apiKey: apiKey,
          payload: payload,
        );
      } on ZenScrapException catch (e) {
        // Map ZenScrapException to appropriate HTTP status codes
        final statusCode = _getStatusCodeForException(e);
        await _sendError(
          request,
          statusCode,
          e.title,
          e.description,
        );
        return true;
      } catch (e) {
        // Handle unexpected errors
        session.log('Unexpected error in ScrappableApiRoute: $e', level: LogLevel.error);
        await _sendError(
          request,
          HttpStatus.internalServerError,
          'Internal Server Error',
          'An unexpected error occurred',
        );
        return true;
      }

      // Send successful response
      await _sendSuccess(request, result);
      return true;
    } catch (e) {
      session.log('Error in ScrappableApiRoute handleCall: $e', level: LogLevel.error);
      await _sendError(
        request,
        HttpStatus.internalServerError,
        'Internal Server Error',
        'An unexpected error occurred',
      );
      return true;
    }
  }

  Future<Map<String, dynamic>> _callFunc(
    Session session, {
    required int scrappableId,
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

  int _getStatusCodeForException(ZenScrapException exception) {
    // Map exception titles to appropriate HTTP status codes
    switch (exception.title) {
      case 'Valid API Key Not Found':
      case 'API Key Not Found':
      case 'Invalid API Key':
      case 'Invalid API Key Format':
        return HttpStatus.unauthorized;
      
      case 'No Active Test Session Found':
      case 'Test Period Expired':
      case 'Missing Extract Rules':
      case 'Missing Path Parameter':
      case 'Scrappable Not Found':
        return HttpStatus.badRequest;
      
      case 'No Active Plan':
      case 'Insufficient Credits':
        return HttpStatus.paymentRequired;
      
      case 'Concurrency Limit Exceeded':
        return HttpStatus.tooManyRequests;
      
      case 'Scraping Error':
      case 'Unexpected Error':
      default:
        return HttpStatus.internalServerError;
    }
  }

  Future<void> _sendError(
    HttpRequest request,
    int statusCode,
    String title,
    String description,
  ) async {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.json;
    
    final errorResponse = {
      'error': {
        'title': title,
        'description': description,
        'statusCode': statusCode,
      },
    };
    
    request.response.write(jsonEncode(errorResponse));
    await request.response.close();
  }

  Future<void> _sendSuccess(
    HttpRequest request,
    Map<String, dynamic> data,
  ) async {
    request.response.statusCode = HttpStatus.ok;
    request.response.headers.contentType = ContentType.json;
    
    final successResponse = {
      'success': true,
      'data': data,
    };
    
    request.response.write(jsonEncode(successResponse));
    await request.response.close();
  }
}