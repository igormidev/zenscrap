import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:programming_cli_core_sdk/src/prompt_content.dart';
import 'package:programming_cli_core_sdk/src/schema_property.dart';

typedef SchemaObject = SchemaPropertyStructuredObjectWithDefinedProperties;

abstract class CliChatInterface {
  String? get sessionId;

  final List<TemporaryFiles> _temporaryFiles = [];

  Directory get baseDir;
  Future<String> sendMessage(List<PromptContent> contents);
  Stream<String> streamResponse(List<PromptContent> contents);
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
  sendMessageWithSchema({
    required List<PromptContent> messages,
    required SchemaObject schema,
  });
  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>> structuredSchemaData,
  })
  streamResponseWithSchema({
    required List<PromptContent> messages,
    required SchemaObject schema,
  });

  Future<T> handleTemporaryFilesWrapper<T>({
    required Future<T> Function() callback,
    required List<PromptContent> promptsOfCurrentMessage,
  }) async {
    try {
      await _saveNewPromptContents(promptsOfCurrentMessage);
      await _setTemporaryFiles();
      final result = await callback();
      await _cleanupTemporaryFiles();
      return result;
    } catch (_) {
      await _cleanupTemporaryFiles();
      rethrow;
    }
  }

  Future<void> _saveNewPromptContents(
    List<PromptContent> promptsOfCurrentMessage,
  ) async {
    for (final p in promptsOfCurrentMessage) {
      if (p is FileContent) {
        _temporaryFiles.add(
          TemporaryFiles(
            fileName: p.inChatFilePath,
            fileContent: await p.file.readAsBytes(),
          ),
        );
      } else if (p is BytesContent) {
        _temporaryFiles.add(
          TemporaryFiles(fileName: p.inChatFilePath, fileContent: p.data),
        );
      }
    }
  }

  Future<void> _setTemporaryFiles() async {
    for (final tempFile in _temporaryFiles) {
      final file = File('${baseDir.path}/${tempFile.fileName}');
      if (!await file.exists()) {
        final createdFile = await file.create();
        await createdFile.writeAsBytes(tempFile.fileContent);
      } else {
        await file.writeAsBytes(tempFile.fileContent);
      }
    }
  }

  Future<void> _cleanupTemporaryFiles() async {
    for (final tempFile in _temporaryFiles) {
      try {
        final file = File('${baseDir.path}/${tempFile.fileName}');
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Ignore errors during cleanup
      }
    }
  }
}

class TemporaryFiles {
  final String fileName;
  final Uint8List fileContent;
  const TemporaryFiles({required this.fileName, required this.fileContent});
}
