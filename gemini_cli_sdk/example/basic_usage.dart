import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  if (apiKey == 'YOUR_API_KEY') {
    stderr.writeln('Set GEMINI_API_KEY before running this example.');
    return;
  }

  final gemini = Gemini(apiKey: apiKey);
  final chat = gemini.createNewChat(
    options: const GeminiChatOptions(model: 'gemini-2.5-flash'),
  );

  try {
    final response = await chat.sendMessage([
      PromptContent.text(
        'What are the main differences between Dart and JavaScript? Provide a concise comparison.',
      ),
    ]);

    stdout
      ..writeln('Gemini response:')
      ..writeln(response)
      ..writeln('\n---\nFollow-up question...');

    final followUp = await chat.sendMessage([
      PromptContent.text(
          'Which language would you recommend for mobile apps and why?'),
    ]);

    stdout
      ..writeln('Gemini response:')
      ..writeln(followUp);
  } finally {
    await chat.dispose();
    await gemini.dispose();
  }
}
