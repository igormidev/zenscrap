import 'dart:convert';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';

mixin CurlBuilderMixin {
  String buildCurl({
    required String baseUrl,
    required int scrappableId,
    required ReferenceTestData? testData,
    required bool isProd,
    String? apiKey,
    Map<String, String>? additionalHeaders,
  }) {
    if (testData == null) return 'No test data available';

    // Determine the endpoint based on prod/test mode (Route format)
    final String endpoint =
        isProd ? '/api/scrappable/prod' : '/api/scrappable/test';
    final String url = '$baseUrl$endpoint';

    // Parse the example payload from the test data
    final examplePayload = tryDecode(testData.referenceQueryParametersJson);

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

    return buffer.toString();
  }

  String buildSimpleCurl({
    required String baseUrl,
    required int scrappableId,
    required String apiKey,
    Map<String, dynamic>? examplePayload,
    Map<String, String>? additionalHeaders,
  }) {
    // Always use prod endpoint for marketplace (Route format)
    final String url = '$baseUrl/api/scrappable/prod';

    // Build the request payload
    final Map<String, dynamic> payload = {
      'scrappableId': scrappableId,
      'apiKey': apiKey,
      'payload': examplePayload ?? {},
    };

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

    return buffer.toString();
  }
}
