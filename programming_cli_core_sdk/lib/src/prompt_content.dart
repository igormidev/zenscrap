import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

/// In some cli's, like claude code, files are prefixed with @ - so we can change it here
String filePreffix = '';

abstract class PromptContent {
  const PromptContent();

  /// Creates a text content
  factory PromptContent.text(String text) = TextContent;

  /// Creates a file content
  /// The file will be cloned to the current working directory for CLI access
  factory PromptContent.file(File file, {String? fileDescription}) =
      FileContent;

  /// Creates a file content
  /// The file will be cloned to the current working directory for CLI access
  factory PromptContent.json(
    Map<String, dynamic> json, {
    required String fileName,
    String? fileDescription,
  }) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(json);

    final bytes = utf8.encode(jsonString);
    final String cleanFileName = p.basenameWithoutExtension(fileName);
    return PromptContent.bytes(
      data: bytes,
      fileDescription: fileDescription,
      fileExtension: 'json',
      fileName: cleanFileName,
    );
  }

  /// Creates content from bytes that will be written to a temporary file
  factory PromptContent.bytes({
    required Uint8List data,
    required String fileName,
    required String fileExtension,
    String? fileDescription,
  }) = BytesContent;

  /// Converts the content to a string representation for the CLI
  String toCliString();

  @override
  String toString() => toCliString();
}

/// Text content to be sent to Codex
class TextContent extends PromptContent {
  final String text;

  TextContent(this.text);

  @override
  String toCliString() => text;
}

class FileContent extends PromptContent {
  final File file;
  String get fileName => p.basenameWithoutExtension(file.path);
  String get fileExtension => p.extension(file.path);

  /// Optional description of what this file contains
  final String? fileDescription;

  String inChatFilePath(String nanoId) => '${fileName}_$nanoId.$fileExtension';

  FileContent(this.file, {this.fileDescription});

  @override
  String toCliString() =>
      // Codex works directly with files in the working directory, no @ prefix - but claude code needs @ for example.
      'File: $filePreffix$inChatFilePath${fileDescription != null ? '\nFile description: $fileDescription' : ''}';

  /// Checks if the source file exists
  Future<bool> get exists => file.exists();
}

/// This content type will create a temporary file from the provided bytes
class BytesContent extends PromptContent {
  final Uint8List data;
  final String fileName;
  final String fileExtension;

  /// Optional description of what this file contains
  final String? fileDescription;

  String inChatFilePath(String nanoId) => '${fileName}_$nanoId.$fileExtension';

  BytesContent({
    required this.data,
    required this.fileName,
    required this.fileExtension,
    this.fileDescription,
  });

  @override
  String toCliString() =>
      // Codex works directly with files in the working directory, no @ prefix - but claude code needs @ for example.
      'File: $filePreffix$inChatFilePath${fileDescription != null ? '\nFile description: $fileDescription' : ''}';
}
