import 'package:codex_cli_sdk/codex_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Codex stream integration',
    () async {
      final codexApiKey =
          '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';
      final sdk = Codex(apiKey: codexApiKey);

      await sdk.exportApiKeyToEnvironment();

      final chat = sdk.createNewChat(
        options: const CodexChatOptions(
          model: 'gpt-5',
          sandboxMode: 'danger-full-access',
          approvalPolicy: 'never',
          enableMcp: true,
        ),
      );

      final schema = SchemaDefinition(
        properties: {
          'presidents': SchemaProperty.array(
            nullable: false,
            description:
                'List of presidents with their name and term start year.',
            items: SchemaProperty.structuredObject(
              nullable: false,
              properties: {
                'name': SchemaProperty.text(nullable: false),
                'termStartYear': SchemaProperty.text(nullable: false),
              },
            ),
          ),
        },
      );

      final result = chat.streamResponseWithSchema(
        messages: [
          PromptContent.text(
            'List the first 10 presidents of the United States in JSON format '
            'with their name and term start year.',
          ),
        ],
        schema: schema,
      );

      await for (final chunk in result.llmMessage) {
        // ignore: avoid_print
        print(chunk);
      }

      final structured = await result.structuredSchemaData.future;
      // ignore: avoid_print
      print(structured);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
