import 'package:programming_cli_core_sdk/src/prompt_content.dart';

abstract class CliChatInterface {
  String? get sessionId;

  final List<TemporaryFiles> _temporaryFiles = [];

  Future<String> sendMessage(List<PromptContent> contents);
  Stream<String> streamResponse(List<PromptContent> contents);
  // Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
  //     sendMessageWithSchema({
  //   required List<PromptContent> messages,
  //   required SchemaObject schema,
  // });
}

class TemporaryFiles {
  final String fileName;
  final String fileContent;
  const TemporaryFiles({required this.fileName, required this.fileContent});
}
