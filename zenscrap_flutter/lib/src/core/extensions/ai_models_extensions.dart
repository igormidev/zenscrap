import 'package:zenscrap_client/zenscrap_client.dart';

extension AiModelsExtensions on AiModel {
  String get displayName {
    return switch (this) {
      AiModel.gemini_2_5_flash => 'Gemini 2.5 Flash',
      AiModel.gemini_2_5_pro => 'Gemini 2.5 Pro',
    };
  }

  String get briefDescription {
    return switch (this) {
      AiModel.gemini_2_5_flash => 'A fast and efficient AI model.',
      AiModel.gemini_2_5_pro => 'A powerful AI model for complex tasks.',
    };
  }
}
