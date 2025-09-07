import 'dart:io';
import 'dart:typed_data';

/// Abstract class representing content to send to Gemini
abstract class GeminiSdkContent {
  const GeminiSdkContent();

  /// Creates text content
  factory GeminiSdkContent.text(String text) = TextContent;

  /// Creates file content
  factory GeminiSdkContent.file(File file) = FileContent;

  /// Creates content from bytes (will be saved as temporary file)
  factory GeminiSdkContent.bytes({
    required Uint8List data,
    required String fileExtension,
  }) = BytesContent;
}

/// Text content to send to Gemini
class TextContent extends GeminiSdkContent {
  final String text;

  const TextContent(this.text);

  @override
  String toString() => 'TextContent($text)';
}

/// File content to send to Gemini
class FileContent extends GeminiSdkContent {
  final File file;

  const FileContent(this.file);

  /// Checks if the file exists
  bool get exists => file.existsSync();

  @override
  String toString() => 'FileContent(${file.path})';
}

/// Bytes content that will be saved as a temporary file
class BytesContent extends GeminiSdkContent {
  final Uint8List data;
  final String fileExtension;
  
  /// Reference to the temporary file created from bytes
  /// This is set internally by the SDK
  File? tempFile;

  BytesContent({
    required this.data,
    required this.fileExtension,
  });

  @override
  String toString() => 'BytesContent(${data.length} bytes, .$fileExtension)';
}