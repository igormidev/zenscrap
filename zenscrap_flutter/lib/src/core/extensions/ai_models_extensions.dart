import 'package:zenscrap_client/zenscrap_client.dart';

extension AiModelsExtensions on AiModel {
  String get displayName {
    return switch (this) {
      AiModel.normal => 'Normal',
      AiModel.powerful => 'Powerful',
    };
  }

  String get briefDescription {
    return switch (this) {
      AiModel.normal => 'A fast and efficient AI model.',
      AiModel.powerful => 'A powerful AI model for complex tasks.',
    };
  }
}
