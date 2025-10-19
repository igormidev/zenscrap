import 'package:claude_code_sdk/claude_code_sdk.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Claude stream integration',
    () async {
      final claudeApiKey =
          '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';
      final sdk = Claude(apiKey: claudeApiKey);

      await sdk.addApiKeyToEnvironment(claudeApiKey);

      final chat = sdk.createNewChat(
        options: const ClaudeChatOptions(
          model: 'claude-haiku-4-5',
          permissionMode: 'bypassPermissions',
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
            'with their name and term start year. DO THIS TASK FAST - no need elaborate too much.',
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
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
