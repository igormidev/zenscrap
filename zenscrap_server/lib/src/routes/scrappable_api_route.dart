import 'dart:async';
import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ScrappableApiRoute extends Route with ApiHelperMixin {
  final bool isProd;

  ScrappableApiRoute({required this.isProd}) : super(methods: {Method.post});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    // Only accept POST requests
    if (request.method != Method.post) {
      return _sendError(
        405,
        'Method Not Allowed',
        'Only POST method is allowed',
      );
    }

    // Read and parse the request body
    final body = await request.readAsString();
    if (body.isEmpty) {
      return _sendError(
        400,
        'Bad Request',
        'Request body is required',
      );
    }

    Map<String, dynamic> requestData;
    try {
      requestData = jsonDecode(body);
    } catch (e) {
      return _sendError(
        400,
        'Bad Request',
        'Invalid JSON in request body',
      );
    }

    // Extract required parameters
    final scrappableId = requestData['scrappableId'];
    final payloadRaw = requestData['payload'];

    // Validate scrappableId
    if (scrappableId == null || scrappableId is! int) {
      return _sendError(
        400,
        'Bad Request',
        'scrappableId is required and must be an integer',
      );
    }

    // Validate and cast payload
    if (payloadRaw == null || payloadRaw is! Map) {
      return _sendError(
        400,
        'Bad Request',
        'payload is required and must be an object',
      );
    }

    // Cast payload to proper type
    final payload = Map<String, dynamic>.from(payloadRaw);

    // For production endpoint, extract and validate API key
    String? apiKey;
    if (isProd) {
      final apiKeyRaw = requestData['apiKey'];
      if (apiKeyRaw == null || apiKeyRaw is! String || apiKeyRaw.isEmpty) {
        return _sendError(
          401,
          'Unauthorized',
          'API key is required for production endpoint',
        );
      }
      apiKey = apiKeyRaw;
    }

    // Call the scraping logic
    final result = await callFunc(
      session,
      scrappableId: scrappableId,
      apiKey: apiKey,
      payload: payload,
    );

    return result.fold(
      (Map<String, dynamic> response) {
        // Extract data and credits from the response
        final data = response['data'] as Map<String, dynamic>;
        final credits = response['credits'] as Map<String, dynamic>?;
        return _sendSuccess(data, credits);
      },
      (ApiError error) {
        return _sendError(
          switch (error.status) {
            RequestStatus.success => 200,
            RequestStatus.clientError => 400,
            RequestStatus.serverError => 500,
            RequestStatus.insufficientCredits => 402,
            RequestStatus.maxConcurrencyExceeded => 429,
            RequestStatus.failedAtScrappingBee => 502,
          },
          error.exception.title,
          error.exception.description,
        );
      },
    );
  }
}

Response _sendError(
  int statusCode,
  String title,
  String description,
) {
  final errorResponse = {
    'error': {
      'title': title,
      'description': description,
      'statusCode': statusCode,
    },
  };

  return Response(
    statusCode,
    body: Body.fromString(
      jsonEncode(errorResponse),
      mimeType: MimeType.json,
    ),
  );
}

Response _sendSuccess(
  Map<String, dynamic> data,
  Map<String, dynamic>? credits,
) {
  final successResponse = <String, dynamic>{
    'success': true,
    'data': data,
    if (credits != null) 'credits': credits,
  };

  return Response.ok(
    body: Body.fromString(
      jsonEncode(successResponse),
      mimeType: MimeType.json,
    ),
  );
}
