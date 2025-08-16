import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ScrappableCurlSection extends ConsumerStatefulWidget {
  final ReferenceTestData? testData;
  const ScrappableCurlSection({
    super.key,
    required this.testData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableCurlSectionState();
}

class _ScrappableCurlSectionState extends ConsumerState<ScrappableCurlSection> {
  late final String code;
  @override
  void initState() {
    super.initState();
    code = buildCurl(widget.testData) ?? 'No curl command available';
  }

  @override
  Widget build(BuildContext context) {
    return CodeBlock(code: code);
  }

  String? buildCurl(ReferenceTestData? testData,
      {Map<String, String>? headers}) {
    if (testData == null) return null;
    final String url = ref.read(clientProvider).host;
    final Map<String, dynamic> queryParams = {};
    final Map<String, dynamic>? payload =
        tryDecode(testData.referenceQueryParametersJson);
    final encoder = const JsonEncoder.withIndent('  ');

    // Build full URL with query parameters
    final uri = Uri.parse(url)
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final buffer = StringBuffer();
    buffer.write('curl -X POST "$uri"');

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
