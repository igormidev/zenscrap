import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

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
    final String url = '${baseUrl}scrappableApi/test';
    
    // Parse the example payload from the test data
    final examplePayload = tryDecode(testData.referenceQueryParametersJson);
    
    // Build the request payload matching the server endpoint format
    final Map<String, dynamic> payload = {
      'scrappableId': widget.scrappableId.toString(),
      'payload': examplePayload ?? {},
    };
    
    // Use compact JSON format for better readability in curl
    final encoder = const JsonEncoder();

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

    // Payload - format JSON without excessive escaping for better readability
    final jsonPayload = encoder.convert(payload);
    // Single escape for quotes to work in both terminal and Postman/Insomnia
    final escapedPayload = jsonPayload.replaceAll('"', '\\"');
    buffer.write(' \\\n  -d "$escapedPayload"');

    return buffer.toString();
  }
}
