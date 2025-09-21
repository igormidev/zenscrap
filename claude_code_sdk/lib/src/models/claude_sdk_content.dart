import 'dart:io';
import 'dart:typed_data';

/// Represents content that can be sent to Claude
abstract class ClaudeSdkContent {
  const ClaudeSdkContent();

  /// Creates a text content
  factory ClaudeSdkContent.text(String text) = TextContent;

  /// Creates a file content
  /// The file will be cloned to the current working directory for CLI access
  factory ClaudeSdkContent.file(
    File file, {
    String? fileDescription,
  }) = FileContent;

  /// Creates content from bytes that will be written to a temporary file
  factory ClaudeSdkContent.bytes({
    required Uint8List data,
    required String fileName,
    required String fileExtension,
    String? fileDescription,
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
      return '@${file.path}${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
    }
    // Claude CLI uses @ for file references, just the filename since it's in the working directory
    final tempFileName = tempFile!.uri.pathSegments.last;
    return '@$tempFileName${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
  }

  /// Gets the file name
  String get fileName => file.uri.pathSegments.last;

  /// Checks if the source file exists
  bool get exists => file.existsSync();
}

/// Bytes content to be sent to Claude
/// This content type will create a temporary file from the provided bytes
class BytesContent extends ClaudeSdkContent {
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
    // Claude CLI uses @ for file references, just the filename since it's in the working directory
    final tempFileName = tempFile!.uri.pathSegments.last;
    return '@$tempFileName${fileDescription != null ? '\n# File description: $fileDescription' : ''}';
  }
}