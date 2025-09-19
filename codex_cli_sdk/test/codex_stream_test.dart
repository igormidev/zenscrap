import 'dart:async';

import 'package:test/test.dart';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() {
  test('Codex Stream Test', () async {
    final codexApiKey =
        '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';

    final codexSDK = Codex(codexApiKey);

    final chat = codexSDK.createNewChat(
      options: CodexChatOptions(
        model: 'gpt-5', // Use the latest GPT-5 model
        timeoutMs: 60000 * 6, // 3 minutes timeout
        enableMcp: true, // Enable MCP support
        sandboxMode: 'danger-full-access',
        approvalPolicy: 'never',
        outputJson: false,
      ),
    );

    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>> structuredSchemaData
    ) = chat.streamResponseWithSchema(
      messages: [
        CodexSdkContent.text(
          'List the first 10 presidents of the United States in JSON array format with their name and term start year.',
        ),
      ],
      schema: SchemaObject(properties: {
        'presidents': SchemaProperty.array(
          nullable: false,
          description: 'List of presidents with their name and term start year',
          items: SchemaProperty.string(),
        ),
      }),
    );

    print('----------- STARTING MESSAGES STREAM -----------\n');
    await for (final chunk in llmMessage) {
      print(chunk);
    }
    print('\n----------- END OF MESSAGES STREAM -----------\n');
    print('\n----------- Waiting for structured schema data... -----------\n');
    final response = await structuredSchemaData.future;
    print('Structured Schema Data:\n');
    print('$response');
    print('\n----------- END OF STRUCTURED SCHEMA DATA -----------\n');
  }, timeout: const Timeout(Duration(minutes: 3)));
}
