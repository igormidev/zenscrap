import 'dart:io';

/// Represents content that can be sent to Claude
abstract class ClaudeSdkContent {
  const ClaudeSdkContent();

  /// Creates a text content
  factory ClaudeSdkContent.text(String text) = TextContent;

  /// Creates a file content
  factory ClaudeSdkContent.file(File file) = FileContent;

  /// Converts the content to a format suitable for the Claude SDK
  Map<String, dynamic> toJson();

  /// Converts the content to a string representation for the CLI
  String toCliString();
}

/// Text content to be sent to Claude
class TextContent extends ClaudeSdkContent {
  final String text;

  const TextContent(this.text);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'text',
        'text': text,
      };

  @override
  String toCliString() => text;
}

/// File content to be sent to Claude
class FileContent extends ClaudeSdkContent {
  final File file;

  const FileContent(this.file);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'file',
        'path': file.absolute.path,
      };

  @override
  String toCliString() => 'File: ${file.absolute.path}';

  /// Gets the file name
  String get fileName => file.path.split(Platform.pathSeparator).last;

  /// Checks if the file exists
  bool get exists => file.existsSync();
}