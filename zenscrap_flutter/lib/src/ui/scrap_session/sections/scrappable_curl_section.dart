import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';

class ScrappableCurlSection extends StatelessWidget {
  final ScrappableRequest request;
  const ScrappableCurlSection({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final queryParams = Map.fromEntries([
      for (final entry in request.queryParams.entries)
        if (entry.value != null) MapEntry(entry.key, entry.value!)
    ]);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Endpoint:'),
        CodeBlock(
          code: buildCurl(
            url: request.url,
            queryParams: queryParams,
          ),
        ),
      ],
    );
  }
}

String buildCurl({
  required String url,
  Map<String, String>? queryParams,
  Map<String, String>? headers,
  Map<String, dynamic>? payload,
  String method = 'POST',
}) {
  final encoder = const JsonEncoder.withIndent('  ');

  // Build full URL with query parameters
  final uri = Uri.parse(url).replace(queryParameters: queryParams);

  final buffer = StringBuffer();
  buffer.write('curl -X ${method.toUpperCase()} "${uri.toString()}"');

  // Headers
  headers?.forEach((key, value) {
    buffer.write(' \\\n  -H "$key: $value"');
  });

  // Add Content-Type if not provided and payload exists
  if (payload != null &&
      !(headers?.keys.any((h) => h.toLowerCase() == 'content-type') ?? false)) {
    buffer.write(' \\\n  -H "Content-Type: application/json"');
  }

  // Payload
  if (payload != null) {
    final jsonPayload = encoder.convert(payload);
    // Escape quotes for shell safety
    final escapedPayload = jsonPayload.replaceAll('"', '\\"');
    buffer.write(' \\\n  -d "$escapedPayload"');
  }

  return buffer.toString();
}
