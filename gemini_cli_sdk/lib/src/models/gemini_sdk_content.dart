import 'dart:io';
import 'dart:typed_data';

/// Abstract class representing content to send to Gemini
abstract class GeminiSdkContent {
  const GeminiSdkContent();

  /// Creates text content
  factory GeminiSdkContent.text(String text) = TextContent;

  /// Creates file content
  /// The file will be cloned to the current working directory for CLI access
  factory GeminiSdkContent.file(
    File file, {
    String? fileDescription,
  }) = FileContent;

  /// Creates content from bytes (will be saved as temporary file)
  factory GeminiSdkContent.bytes({
    required Uint8List data,
    required String fileName,
    required String fileExtension,
    String? fileDescription,
  }) = BytesContent;

  /// Converts the content to a string suitable for the Gemini CLI
  String toCliString();
}

/// Text content to send to Gemini
class TextContent extends GeminiSdkContent {
  final String text;

  const TextContent(this.text);

  @override
  String toCliString() => text;

  @override
  String toString() => 'TextContent($text)';
}

/// File content to send to Gemini
class FileContent extends GeminiSdkContent {
  final File file;

  /// Optional description of what this file contains
  final String? fileDescription;

  /// The temporary cloned file in the working directory
  /// This is set internally by the SDK
  File? tempFile;

  FileContent(
    this.file, {
    this.fileDescription,
  });

  /// Checks if the source file exists
  bool get exists => file.existsSync();

  /// Gets just the file name without path
  String get fileName => file.uri.pathSegments.last;

  @override
  String toCliString() {
    if (tempFile == null || !tempFile!.existsSync()) {
      // Fallback to original file path if temp file not yet created
      return '@${file.path}${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
    }
    // Gemini CLI uses @ for file references, just the filename since it's in the working directory
    final tempFileName = tempFile!.uri.pathSegments.last;
    return '@$tempFileName${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
  }

  @override
  String toString() => 'FileContent(${file.path})';
}

/// Bytes content that will be saved as a temporary file
class BytesContent extends GeminiSdkContent {
  final Uint8List data;
  final String fileName;
  final String fileExtension;

  /// Optional description of what this file contains
  final String? fileDescription;

  /// Reference to the temporary file created from bytes
  /// This is set internally by the SDK
  File? tempFile;

  BytesContent({
    required this.data,
    required this.fileName,
    required this.fileExtension,
    this.fileDescription,
  });

  @override
  String toCliString() {
    if (tempFile == null || !tempFile!.existsSync()) {
      return 'BytesContent(not yet written to file)';
    }
    // Gemini CLI uses @ for file references, just the filename since it's in the working directory
    final tempFileName = tempFile!.uri.pathSegments.last;
    return '@$tempFileName${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
  }

  @override
  String toString() => 'BytesContent(${data.length} bytes, $fileName.$fileExtension)';
}