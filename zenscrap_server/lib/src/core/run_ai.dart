import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class RunAiSession {
  final String geminiApiKey;

  RunAiSession({required this.geminiApiKey});

  late final GenerativeModel geminiModel = GenerativeModel(
    model: 'gemini-2.5-pro',
    apiKey: geminiApiKey,
    generationConfig: GenerationConfig(
      responseSchema: generateExtractRulesSchema,
    ),
  );

  late final ChatSession chat = geminiModel.startChat();

  Stream<ChatResponse> runAiChat<T>({
    required void Function() onDataMap,
  }) async* {
    final response1 = await chat.sendMessage(
      Content(, []),
    );
  }
}
