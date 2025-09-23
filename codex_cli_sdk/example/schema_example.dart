import 'dart:io';

import 'package:codex_cli_sdk/codex_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    exit(1);
  }

  final codexSDK = Codex(apiKey: apiKey);
  final chat = codexSDK.createNewChat();

  try {
    final bookSchema = SchemaDefinition(
      properties: {
        'title': SchemaProperty.text(
            nullable: false, description: 'The title of the book'),
        'author': SchemaProperty.text(
            nullable: false, description: 'The author of the book'),
        'year': SchemaProperty.text(
            nullable: true, description: 'The publication year'),
        'genre': SchemaProperty.text(
            nullable: true, description: 'The genre or category'),
        'summary': SchemaProperty.text(
            nullable: false, description: 'A brief summary'),
        'themes': SchemaProperty.array(
          nullable: true,
          description: 'Main themes in the book',
          items: SchemaProperty.text(nullable: false),
        ),
      },
    );

    print('Requesting structured book information...\n');

    final bookResult = await chat.sendMessageWithSchema(
      messages: [
        PromptContent.text(
            'Give me information about the book "1984" by George Orwell'),
      ],
      schema: bookSchema,
    );

    print('Model explanation:');
    print('${bookResult.llmMessage}\n');

    print('Structured data:');
    final bookData = bookResult.structuredSchemaData;
    print('Title: ${bookData['title']}');
    print('Author: ${bookData['author']}');
    print('Year: ${bookData['year']}');
    print('Genre: ${bookData['genre']}');
    print('Summary: ${bookData['summary']}');

    final themes = bookData['themes'];
    if (themes is List) {
      print('Themes:');
      for (final theme in themes) {
        print('  - $theme');
      }
    }

    print('\n--- Nested Schema Example ---\n');

    final userSchema = SchemaDefinition(
      properties: {
        'user': SchemaProperty.structuredObject(
          nullable: false,
          description: 'User information',
          properties: {
            'name': SchemaProperty.text(nullable: false),
            'email': SchemaProperty.text(nullable: false),
            'age': SchemaProperty.text(nullable: true),
          },
        ),
        'preferences': SchemaProperty.structuredObject(
          nullable: true,
          description: 'User preferences',
          properties: {
            'theme': SchemaProperty.enumeration(
              enumValues: ['light', 'dark', 'auto'],
              nullable: false,
              description: 'Preferred application theme',
            ),
            'notifications': SchemaProperty.boolean(
              nullable: false,
              description: 'Whether notifications are enabled',
            ),
            'language': SchemaProperty.text(
              nullable: false,
              description: 'Preferred language',
            ),
          },
        ),
        'tags': SchemaProperty.array(
          nullable: true,
          description: 'User tags',
          items: SchemaProperty.text(nullable: false),
        ),
      },
    );

    final userResult = await chat.sendMessageWithSchema(
      messages: [
        PromptContent.text(
            'Generate a sample user profile for a developer named John Doe'),
      ],
      schema: userSchema,
    );

    print('Generated User Profile:');
    print('${userResult.llmMessage}\n');
    print('Data: ${userResult.structuredSchemaData}');
  } catch (e) {
    print('Error: $e');
  } finally {
    await chat.dispose();
    await codexSDK.dispose();
  }
}
