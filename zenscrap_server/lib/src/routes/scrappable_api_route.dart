import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ScrappableApiRoute extends Route with ApiHelperMixin {
  final bool isProd;

  ScrappableApiRoute({required this.isProd});

  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
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
    final result = await callFunc(
      session,
      scrappableId: scrappableId,
      request: request,
      apiKey: apiKey,
      payload: payload,
    );
    await result.fold(
      (Map<String, dynamic> success) async {
        await _sendSuccess(request, success);
      },
      (ApiError error) async {
        await _sendError(
          request,
          switch (error.status) {
            RequestStatus.success => HttpStatus.ok,
            RequestStatus.clientError => HttpStatus.badRequest,
            RequestStatus.serverError => HttpStatus.internalServerError,
            RequestStatus.insufficientCredits => HttpStatus.paymentRequired,
            RequestStatus.maxConcurrencyExceeded => HttpStatus.tooManyRequests,
          },
          error.exception.title,
          error.exception.description,
        );
      },
    );
    return true;
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
