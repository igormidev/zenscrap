import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  if (apiKey == 'YOUR_API_KEY') {
    stderr.writeln('Set GEMINI_API_KEY before running this example.');
    return;
  }

  final gemini = Gemini(apiKey: apiKey);
  final chat = gemini.createNewChat();

  final profile = File('profile.html');
  await profile.writeAsString('''
<!doctype html>
<html>
  <body>
    <div class="employee">
      <h1>Sarah Johnson</h1>
      <p class="email">sarah.johnson@example.com</p>
      <p class="phone">+1 555 0101</p>
    </div>
  </body>
</html>
''');

  final schema = SchemaDefinition(
    properties: {
      'name': SchemaProperty.text(nullable: false),
      'email': SchemaProperty.text(nullable: false),
      'phone': SchemaProperty.text(nullable: true),
    },
  );

  try {
    final result = await chat.sendMessageWithSchema(
      messages: [
        PromptContent.text(
            'Extract the employee information from this HTML file.'),
        PromptContent.file(profile),
      ],
      schema: schema,
    );

    stdout
      ..writeln(result.llmMessage)
      ..writeln('Structured data: ${result.structuredSchemaData}');
  } finally {
    await chat.dispose();
    await gemini.dispose();
    if (await profile.exists()) {
      await profile.delete();
    }
  }
}
