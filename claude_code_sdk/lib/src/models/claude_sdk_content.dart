import 'dart:io';
import 'dart:typed_data';

/// Represents content that can be sent to Claude
abstract class ClaudeSdkContent {
  const ClaudeSdkContent();

  /// Creates a text content
  factory ClaudeSdkContent.text(String text) = TextContent;

  /// Creates a file content
  factory ClaudeSdkContent.file(File file) = FileContent;

  /// Creates content from bytes that will be written to a temporary file
  factory ClaudeSdkContent.bytes({
    required Uint8List data,
    required String fileExtension,
  }) = BytesContent;

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

/// Bytes content to be sent to Claude
/// This content type will create a temporary file from the provided bytes
class BytesContent extends ClaudeSdkContent {
  final Uint8List data;
  final String fileExtension;
  
  /// The temporary file that will be created (populated when needed)
  File? tempFile;
  
  BytesContent({
    required this.data,
    required this.fileExtension,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': 'bytes',
        'data_length': data.length,
        'extension': fileExtension,
        'path': tempFile?.absolute.path,
      };

  @override
  String toCliString() => tempFile != null 
      ? 'File: ${tempFile!.absolute.path}'
      : 'BytesContent (not yet written to file)';
}