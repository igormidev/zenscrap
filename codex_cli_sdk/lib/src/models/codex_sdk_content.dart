import 'dart:io';
import 'dart:typed_data';

/// Represents content that can be sent to Codex
abstract class CodexSdkContent {
  const CodexSdkContent();

  /// Creates a text content
  factory CodexSdkContent.text(String text) = TextContent;

  /// Creates a file content
  /// The file will be cloned to the current working directory for CLI access
  factory CodexSdkContent.file(
    File file, {
    String? fileDescription,
  }) = FileContent;

  /// Creates content from bytes that will be written to a temporary file
  factory CodexSdkContent.bytes({
    required Uint8List data,
    required String fileName,
    required String fileExtension,
    String? fileDescription,
  }) = BytesContent;

  /// Converts the content to a format suitable for the Codex SDK
  Map<String, dynamic> toJson();

  /// Converts the content to a string representation for the CLI
  String toCliString();
}

/// Text content to be sent to Codex
class TextContent extends CodexSdkContent {
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

/// File content to be sent to Codex
class FileContent extends CodexSdkContent {
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

  @override
  Map<String, dynamic> toJson() => {
        'type': 'file',
        'path': tempFile?.absolute.path ?? file.absolute.path,
        'description': fileDescription,
      };

  @override
  String toCliString() {
    if (tempFile == null || !tempFile!.existsSync()) {
      // Fallback to original file path if temp file not yet created
      return 'File: ${file.path}${fileDescription != null ? '\nFile description: $fileDescription' : ''}';
    }
    // Codex works directly with files in the working directory, no @ prefix
    final tempFileName = tempFile!.uri.pathSegments.last;
    return 'File: $tempFileName${fileDescription != null ? '\nFile description: $fileDescription' : ''}';
  }

  /// Gets the file name
  String get fileName => file.uri.pathSegments.last;

  /// Checks if the source file exists
  bool get exists => file.existsSync();
}

/// Bytes content to be sent to Codex
/// This content type will create a temporary file from the provided bytes
class BytesContent extends CodexSdkContent {
  final Uint8List data;
  final String fileName;
  final String fileExtension;

  /// Optional description of what this file contains
  final String? fileDescription;

  /// The temporary file that will be created (populated when needed)
  /// This is set internally by the SDK
  File? tempFile;

  BytesContent({
    required this.data,
    required this.fileName,
    required this.fileExtension,
    this.fileDescription,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': 'bytes',
        'data_length': data.length,
        'fileName': fileName,
        'extension': fileExtension,
        'path': tempFile?.absolute.path,
        'description': fileDescription,
      };

  @override
  String toCliString() {
    if (tempFile == null || !tempFile!.existsSync()) {
      return 'BytesContent (not yet written to file)';
    }
    // Codex works directly with files in the working directory, no @ prefix
    final tempFileName = tempFile!.uri.pathSegments.last;
    return 'File: $tempFileName${fileDescription != null ? '\nFile description: $fileDescription' : ''}';
  }
}