import 'dart:io';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    print('Please set the OPENAI_API_KEY environment variable');
    exit(1);
  }

  final codexSDK = Codex(apiKey);
  final chat = codexSDK.createNewChat();

  try {
    // Create a schema for extracting book information
    final bookSchema = SchemaObject(
      properties: {
        'title': SchemaProperty.string(
          description: 'The title of the book',
          nullable: false,
        ),
        'author': SchemaProperty.string(
          description: 'The author of the book',
          nullable: false,
        ),
        'year': SchemaProperty.number(
          description: 'The year the book was published',
          nullable: true,
        ),
        'genre': SchemaProperty.string(
          description: 'The genre or category of the book',
          nullable: true,
        ),
        'summary': SchemaProperty.string(
          description: 'A brief summary of the book',
          nullable: false,
        ),
        'themes': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'Main themes in the book',
          nullable: true,
        ),
      },
      description: 'Information about a book',
    );

    print('Requesting structured book information...\n');

    final result = await chat.sendMessageWithSchema(
      messages: [
        CodexSdkContent.text(
          'Give me information about the book "1984" by George Orwell',
        ),
      ],
      schema: bookSchema,
    );

    print('Model explanation:');
    print('${result.modelMessage}\n');

    print('Structured data:');
    print('Title: ${result.data['title']}');
    print('Author: ${result.data['author']}');
    print('Year: ${result.data['year']}');
    print('Genre: ${result.data['genre']}');
    print('Summary: ${result.data['summary']}');

    if (result.data['themes'] != null) {
      print('Themes:');
      for (final theme in result.data['themes']) {
        print('  - $theme');
      }
    }

    // Example with nested schema
    print('\n--- Nested Schema Example ---\n');

    final userSchema = SchemaObject(
      properties: {
        'user': SchemaProperty.object(
          properties: {
            'name': SchemaProperty.string(nullable: false),
            'email': SchemaProperty.string(nullable: false),
            'age': SchemaProperty.number(nullable: true),
          },
          description: 'User information',
          nullable: false,
        ),
        'preferences': SchemaProperty.object(
          properties: {
            'theme': SchemaProperty.string(
              defaultValue: 'light',
              enumValues: ['light', 'dark', 'auto'],
              nullable: false,
            ),
            'notifications': SchemaProperty.boolean(
              defaultValue: true,
              nullable: false,
            ),
            'language': SchemaProperty.string(
              defaultValue: 'en',
              nullable: false,
            ),
          },
          description: 'User preferences',
          nullable: true,
        ),
        'tags': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'User tags',
          nullable: true,
        ),
      },
      description: 'Complete user profile',
    );

    final userResult = await chat.sendMessageWithSchema(
      messages: [
        CodexSdkContent.text(
          'Generate a sample user profile for a developer named John Doe',
        ),
      ],
      schema: userSchema,
    );

    print('Generated User Profile:');
    print('${userResult.modelMessage}\n');
    print('Data: ${userResult.data}');
  } catch (e) {
    print('Error: $e');
  } finally {
    await chat.dispose();
    await codexSDK.dispose();
  }
}