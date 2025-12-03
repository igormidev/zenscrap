import 'dart:convert';

mixin CurlBuilderMixin {
  String buildSimpleCurl({
    required String baseUrl,
    required int scrappableId,
    required bool isProd,
    required bool isDisplayCurl,
    String? apiKey,
    Map<String, dynamic>? examplePayload,
    Map<String, String>? additionalHeaders,
  }) {
    // Determine the endpoint based on prod/test mode (Route format)
    final String endpoint =
        isProd ? '/api/scrappable/prod' : '/api/scrappable/test';
    final String url = '$baseUrl$endpoint';

    // Build the request payload
    final Map<String, dynamic> payload = {
      'scrappableId': scrappableId,
      'payload': examplePayload ?? {},
    };

    // Add API key for prod mode
    if (isProd && apiKey != null) {
      payload['apiKey'] = apiKey;
    }

    // Use pretty-printed JSON for better readability
    final encoder = const JsonEncoder.withIndent('  ');

    final buffer = StringBuffer();
    buffer.write('curl -X POST "$url"');

    // Add default headers
    final allHeaders = {
      'Content-Type': 'application/json',
      ...?additionalHeaders,
    };

    // Headers
    allHeaders.forEach((key, value) {
      buffer.write(' \\\n  -H "$key: $value"');
    });

    // Payload - format JSON for better readability
    final jsonPayload = encoder.convert(payload);
    // Minimal escaping for compatibility with Postman/Insomnia
    final escapedPayload = jsonPayload.replaceAll('"', '\\"');
    buffer.write(' \\\n  -d "$escapedPayload"');

    String result = buffer.toString();

    if (isDisplayCurl) {
      result = result.replaceAll(r'\"', '"');
      if (apiKey != null) {
        result = result.replaceAll(apiKey, '${apiKey.substring(0, 8)}...');
      }
    }

    return result.replaceAll('//api', '/api');
  }
}
