import 'package:programming_cli_core_sdk/src/prompt_content.dart';

extension ListPromptContentExt on List<PromptContent> {
  String get getPromptMessage {
    final buffer = StringBuffer();

    join('\n\n');

    for (final content in this) {
      buffer.write('$content\n');
      if (content is TextContent) {
      } else if (content is FileContent) {
        buffer.writeln(content.toCliString());
      } else if (content is BytesContent) {
        final fileName = '${content.fileName}.${content.fileExtension}';
        buffer.writeln('$filePreffix$fileName');
      }
      buffer.writeln(); // Add a newline between contents
    }
    return buffer.toString();
  }
}
