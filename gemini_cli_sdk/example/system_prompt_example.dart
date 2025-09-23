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
    options: const GeminiChatOptions(
      systemPrompt:
          'You are an expert technical writer. Keep answers short and actionable.',
      repeatSystemPrompt: true,
    ),
  );

  try {
    final first = await chat.sendMessage([
      PromptContent.text(
          'Give me three tips for maintaining a Flutter project.'),
    ]);
    stdout
      ..writeln('First response:')
      ..writeln(first)
      ..writeln('\n----');

    final second = await chat.sendMessage([
      PromptContent.text('Now list common performance pitfalls.'),
    ]);
    stdout
      ..writeln('Second response:')
      ..writeln(second);
  } finally {
    await chat.dispose();
    await gemini.dispose();
  }
}
