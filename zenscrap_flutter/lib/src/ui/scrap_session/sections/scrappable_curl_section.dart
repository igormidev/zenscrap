import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';

class ScrappableCurlSection extends ConsumerStatefulWidget {
  final UuidValue scrappableId;
  final ReferenceTestData? testData;
  const ScrappableCurlSection({
    super.key,
    required this.scrappableId,
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
    final isChatLoading = ref.watch(isChatLoadingProvider);
    if (isChatLoading) {
      return Tooltip(
        message: 'Chat is loading...',
        child: Opacity(
          opacity: 0.6,
          child: CodeBlock(code: code),
        ),
      );
    }
    return CodeBlock(code: code);
  }

  String? buildCurl(
    ReferenceTestData? testData, {
    Map<String, String>? headers,
  }) {
    if (testData == null) return null;

    // Get the full server URL properly
    final client = ref.read(clientProvider);
    final baseUrl = client.host;
    // Use the new route-based endpoint
    final String url = '${baseUrl}api/scrappable/test';

    // Parse the example payload from the test data
    final examplePayload = tryDecode(testData.referenceQueryParametersJson);

    // Build the request payload matching the new route format
    final Map<String, dynamic> payload = {
      'scrappableId': widget.scrappableId.toString(),
      'payload': examplePayload ?? {},
    };

    // Use pretty-printed JSON for better readability
    final encoder = const JsonEncoder.withIndent('  ');

    final buffer = StringBuffer();
    buffer.write('curl -X POST "$url"');

    // Add default headers
    final allHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
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
