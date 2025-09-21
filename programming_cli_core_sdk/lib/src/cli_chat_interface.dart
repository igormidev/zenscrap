import 'dart:async';
import 'dart:io';
import 'package:programming_cli_core_sdk/src/temporary_files.dart';
import 'package:synchronized/synchronized.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:programming_cli_core_sdk/src/prompt_content.dart';
import 'package:programming_cli_core_sdk/src/schema_property.dart';

typedef SchemaObject = SchemaPropertyStructuredObjectWithDefinedProperties;

abstract class CliChatInterface {
  CliChatInterface({required this.systemPrompt});

  final String systemPrompt;

  bool get didSendFirstMessage;

  final Lock _lock = Lock();
  final String _chatNanoId = nanoid(length: 4);
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

  String get schemaResponseFilePath =>
      '${baseDir.path}/schema_response_id-$_chatNanoId.json';
  String get schemaTestFilePath =>
      '${baseDir.path}/is_schema_id-${_chatNanoId}_correct_test.dart';

  Future<void> _setupSchemaFiles(SchemaObject schema) async {
    // First, lets create the json file where the AI will write the response in the json schema format
    final schemaFile = await File(schemaResponseFilePath).create();
    await schemaFile.writeAsString('{}');
    // Now, create the schema instructions file
    final schemaTestFolder = await File(schemaTestFilePath).create();

    final String testContent =
        '''import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('Is correct schema', () async {
    final currDir = Directory.current;
    final schemaFile = File('$schemaResponseFilePath');
    final schemaContent = await schemaFile.readAsString();
    final Map<String, dynamic> schemaJson = jsonDecode(schemaContent);
    final bool isValidSchema = schema.validateIdJsonFollowsSchemaStructure(
      schemaJson,
    );
    expect(isValidSchema, true);
  });
}

final SchemaPropertyStructuredObjectWithDefinedProperties schema = ${schema.toDartClassDeclaration} as SchemaPropertyStructuredObjectWithDefinedProperties;''';

    await schemaTestFolder.writeAsString(testContent);
  }

  Future<void> _removeSchemaFiles() async {
    await File(schemaResponseFilePath).delete();
    await File(schemaTestFilePath).delete();
  }

  Future<String> _generateSchemaPrompt<T>({
    required SchemaObject schema,
  }) async {
    return '''----------- SCHEMA INSTRUCTIONS [START] -----------
    
I wan't the output in a json format. But not in any json format.
It should be in a specific schema that I will provide you below.
You MUST follow the schema EXACTLY as I provide you.
If you don't follow the schema, I will not be able to parse it.
Because of that, since I need 100% of certainty, I created a dart test code that will validate if you followed the schema or not.
The test code is located at: $filePreffix$schemaTestFilePath
Read the test file to have an idea of how the schema is structured so you can pass in the test.
If the test fails, you can be sure you did not follow the schema - so see the errors logs of the test and fix it.

DO NOT change anything in this test file, it is perfect as it is - just focus on following the schema and it will naturally pass the test.

The schema expected is:
```json
${schema.toString()}
```

----------- SCHEMA INSTRUCTIONS [END] -----------''';
  }

  Future<T> handleTemporaryFilesWrapper<T>({
    required Future<T> Function() callback,
    required List<PromptContent> promptsOfCurrentMessage,
    required SchemaObject? schema,
  }) async {
    return _lock.synchronized(() async {
      try {
        if (schema != null) await _setupSchemaFiles(schema);
        await _saveNewPromptContents([
          if (!didSendFirstMessage)
            PromptContent.text('''----------- SYSTEM PROMPT [START] -----------
$systemPrompt
----------- SYSTEM PROMPT [END] -----------'''),
          if (schema != null)
            PromptContent.text(await _generateSchemaPrompt(schema: schema)),
          ...promptsOfCurrentMessage,
        ]);
        await _setTemporaryFiles();
        final result = await callback();
        await _cleanupTemporaryFiles();
        if (schema != null) await _removeSchemaFiles();
        return result;
      } catch (_) {
        await _cleanupTemporaryFiles();
        if (schema != null) await _removeSchemaFiles();
        rethrow;
      }
    });
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
