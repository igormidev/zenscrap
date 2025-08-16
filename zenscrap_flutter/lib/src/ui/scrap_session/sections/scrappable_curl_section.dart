import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ScrappableCurlSection extends ConsumerStatefulWidget {
  final ScrappableRequest request;
  const ScrappableCurlSection({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableCurlSectionState();
}

class _ScrappableCurlSectionState extends ConsumerState<ScrappableCurlSection> {
  @override
  Widget build(BuildContext context) {
    return CodeBlock(
      code: buildCurl(),
    );
  }

  String buildCurl({
    Map<String, String>? headers,
    Map<String, dynamic>? payload,
    String method = 'POST',
  }) {
    final String url = ref.read(clientProvider).host;
    final Map<String, String?> queryParams = Map.fromEntries([
      for (final entry in widget.request.queryParams.entries)
        if (entry.value != null) MapEntry(entry.key, entry.value!)
    ]);
    final encoder = const JsonEncoder.withIndent('  ');

    // Build full URL with query parameters
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    final buffer = StringBuffer();
    buffer.write('curl -X ${method.toUpperCase()} "$uri"');

    // Headers
    headers?.forEach((key, value) {
      buffer.write(' \\\n  -H "$key: $value"');
    });

    // Add Content-Type if not provided and payload exists
    if (payload != null &&
        !(headers?.keys.any((h) => h.toLowerCase() == 'content-type') ??
            false)) {
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
}
