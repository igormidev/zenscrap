import 'package:programming_cli_core_sdk/src/prompt_content.dart';

extension ListPromptContentExt on List<PromptContent> {
  String getPromptMessage(String nanoId) {
    final buffer = StringBuffer();

    join('\n\n');

    for (final content in this) {
      buffer.write('${content.toCliString(nanoId)}\n\n');
    }
    return buffer.toString();
  }
}
