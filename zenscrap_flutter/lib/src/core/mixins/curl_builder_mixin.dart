import 'dart:convert';

mixin CurlBuilderMixin {
  /// Converts the Serverpod API host to the web server host.
  ///
  /// In Serverpod Cloud, the API routes (RPC endpoints) are at api.domain.com,
  /// but webServer routes (added via addRoute) are at www.domain.com.
  ///
  /// - localhost:8080 (API) → localhost:8082 (web server)
  /// - api.zenscrap.com → www.zenscrap.com
  String _apiHostToWebHost(String apiHost) {
    // Handle localhost development
    if (apiHost.contains('localhost:8080')) {
      return apiHost.replaceAll('localhost:8080', 'localhost:8082');
    }
    // Handle production: api.domain.com → www.domain.com
    if (apiHost.contains('://api.')) {
      return apiHost.replaceAll('://api.', '://www.');
    }
    return apiHost;
  }

  String buildSimpleCurl({
    required String baseUrl,
    required int scrappableId,
    required bool isProd,
    required bool isDisplayCurl,
    String? apiKey,
    Map<String, dynamic>? examplePayload,
    Map<String, String>? additionalHeaders,
    Map<String, String?>? queryParams,
    Map<String, String?>? queryParamsNotRelatedToUrl,
    String? countryCode,
  }) {
    // Convert API host to web server host for webServer routes
    final webBaseUrl = _apiHostToWebHost(baseUrl);

    // Determine the endpoint based on prod/test mode (Route format)
    final String endpoint = isProd
        ? '/api/scrappable/prod'
        : '/api/scrappable/test';
    final String url = '$webBaseUrl$endpoint';

    // Build the merged payload:
    // 1. Start with example payload (from referenceTestData - path params with real values)
    // 2. Add queryParams (URL parameters) - use default value or null placeholder
    // 3. Add queryParamsNotRelatedToUrl (js_scenario placeholders) - use default value or null placeholder
    final Map<String, dynamic> mergedPayload = {...?examplePayload};

    // Add queryParams that aren't already in examplePayload
    // If value is null, keep it as null (user can optionally provide a value)
    queryParams?.forEach((key, value) {
      if (!mergedPayload.containsKey(key)) {
        mergedPayload[key] = value;
      }
    });

    // Add queryParamsNotRelatedToUrl that aren't already in payload
    // If value is null, keep it as null (user can optionally provide a value)
    queryParamsNotRelatedToUrl?.forEach((key, value) {
      if (!mergedPayload.containsKey(key)) {
        mergedPayload[key] = value;
      }
    });

    // Add countryCode to payload if provided (for proxy geolocation)
    if (countryCode != null && countryCode.isNotEmpty) {
      mergedPayload['countryCode'] = countryCode;
    }

    // Build the request payload
    final Map<String, dynamic> payload = {
      'scrappableId': scrappableId,
      'payload': mergedPayload,
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

    // Fix any double slashes in the URL path (but not in the protocol ://)
    // This handles cases where baseUrl ends with / and endpoint starts with /
    return result.replaceAllMapped(
      RegExp(r'(https?:)//+|//+'),
      (match) => match.group(1) != null ? '${match.group(1)}//' : '/',
    );
  }
}
