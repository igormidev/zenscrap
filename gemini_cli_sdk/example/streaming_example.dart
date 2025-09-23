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
    final stream = chat.streamResponse([
      PromptContent.text(
          'Explain the Gemini CLI in three concise bullet points.'),
    ]);

    await for (final chunk in stream) {
      stdout.write(chunk);
    }
  } finally {
    await chat.dispose();
    await gemini.dispose();
  }
}
