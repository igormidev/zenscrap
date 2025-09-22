import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:programming_cli_core_sdk/src/coding_cli_interface.dart';
import 'package:programming_cli_core_sdk/src/temporary_files.dart';
import 'package:synchronized/synchronized.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:programming_cli_core_sdk/src/prompt_content.dart';
import 'package:programming_cli_core_sdk/src/schema_property.dart';

typedef SchemaObject = SchemaPropertyStructuredObjectWithDefinedProperties;

abstract class CliChatInterface<T extends CliChatOptions> {
  CliChatInterface({required this.options});
  T? options;

  bool get didSendFirstMessage;

  final Lock _lock = Lock();
  final String _chatNanoId = nanoid(length: 4);
  String? get sessionId;

  final List<TemporaryFiles> _temporaryFiles = [];

  Future<void> dispose() async {
    await _cleanupTemporaryFiles();
    await _removeSchemaFiles();
  }

  @protected
  Future<SchemaWorkflowResult> runSchemaWorkflow({
    required List<PromptContent> messages,
    StreamSink<String>? streamSink,
  });

  @protected
  Future<void> runCodexCommand({
    required String message,
    required StreamSink<String> streamSink,
  });

  Directory get baseDir;
  Future<String> sendMessage(List<PromptContent> contents) async {
    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>?> structuredSchemaData,
    ) = _handleTemporaryFilesWrapper(
      promptsOfCurrentMessage: contents,
      schema: null,
    );

    return await llmMessage.join();
  }

  Stream<String> streamResponse(List<PromptContent> contents) {
    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>?> structuredSchemaData,
    ) = _handleTemporaryFilesWrapper(
      promptsOfCurrentMessage: contents,
      schema: null,
    );

    return llmMessage;
  }

  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
  sendMessageWithSchema({
    required List<PromptContent> messages,
    required SchemaObject schema,
  }) async {
    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>?> structuredSchemaData,
    ) = _handleTemporaryFilesWrapper(
      promptsOfCurrentMessage: messages,
      schema: schema,
    );

    final schemaData = await structuredSchemaData.future;
    final fullMessage = await llmMessage.join();
    if (schemaData == null) {
      throw Exception('Schema data is null');
    }
    return (llmMessage: fullMessage, structuredSchemaData: schemaData);
  }

  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>> structuredSchemaData,
  })
  streamResponseWithSchema({
    required List<PromptContent> messages,
    required SchemaObject schema,
  }) {
    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>?> structuredSchemaData,
    ) = _handleTemporaryFilesWrapper(
      promptsOfCurrentMessage: messages,
      schema: schema,
    );

    final completer = Completer<Map<String, dynamic>>();
    structuredSchemaData.future
        .then((value) {
          if (value == null) {
            completer.completeError(Exception('Schema data is null'));
          } else {
            completer.complete(value);
          }
        })
        .catchError((error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        });

    return (llmMessage: llmMessage, structuredSchemaData: completer);
  }

  String get schemaResponseFilePath =>
      '${baseDir.path}/schema_response_id-$_chatNanoId.json';
  String get schemaTestFilePath =>
      '${baseDir.path}/is_schema_id-${_chatNanoId}_correct_test.dart';

  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>?> structuredSchemaData,
  })
  _handleTemporaryFilesWrapper({
    required List<PromptContent> promptsOfCurrentMessage,
    required SchemaObject? schema,
  }) {
    final controller = StreamController<String>.broadcast();
    final responseCompleter = Completer<Map<String, dynamic>?>();

    () async {
      await _lock.synchronized(() async {
        try {
          if (schema != null) await _setupSchemaFiles(schema);
          await _saveNewPromptContents(promptsOfCurrentMessage);
          await _setTemporaryFiles();
          await runCodexCommand(
            message: [
              if (!didSendFirstMessage)
                PromptContent.text(
                  '''----------- SYSTEM PROMPT [START] -----------
${options?.systemPrompt}
----------- SYSTEM PROMPT [END] -----------''',
                ),
              if (schema != null)
                PromptContent.text(await _generateSchemaPrompt(schema: schema)),
              ...promptsOfCurrentMessage,
            ].join('\n\n'),
            streamSink: controller.sink,
          );

          if (schema == null) {
            controller.close();
            responseCompleter.complete(null);

            return;
          }

          final testErrorMessage = await _isSchemaResponseValid();
          final didSucceed = testErrorMessage == null;

          if (didSucceed == false) {
            // Let's do a recursive call to retry once more
            await runCodexCommand(
              message:
                  '''A error occoured when validating the schema. The test failed.
Please fix the schema to follow the test at $filePreffix$schemaTestFilePath
Make sure you are writing the json in the file at $filePreffix$schemaResponseFilePath and not in other places.

Remember to follow the schema EXACTLY as provided, otherwise the test will fail.
You should modify the file 
Currently, the test returns the following error message:
$testErrorMessage''',
              streamSink: controller.sink,
            );

            final errorMessage = await _isSchemaResponseValid();
            final stillFailed = errorMessage != null;
            if (stillFailed) {
              controller.close();
              responseCompleter.completeError(errorMessage);
              return;
            }
          }

          final fileContent = await File(schemaResponseFilePath).readAsString();
          final json = jsonDecode(fileContent) as Map<String, dynamic>;
          await _cleanupTemporaryFiles();
          await _removeSchemaFiles();
          controller.close();
          responseCompleter.complete(json);
        } catch (error, stackTrace) {
          await _cleanupTemporaryFiles();
          if (schema != null) await _removeSchemaFiles();
          controller.close();
          if (!responseCompleter.isCompleted) {
            responseCompleter.completeError(error, stackTrace);
          }
          rethrow;
        }
      });
    }();

    return (
      llmMessage: controller.stream,
      structuredSchemaData: responseCompleter,
    );
  }

  Future<String> _generateSchemaPrompt({required SchemaObject schema}) async {
    return '''----------- SCHEMA INSTRUCTIONS [START] -----------
    
I wan't the output in a json format. 
I wan't you to write the output in the json file located at: $filePreffix$schemaResponseFilePath

But I don't wan't the json in any random format.
It should be in a specific schema that I will provide you below.
You MUST follow the schema EXACTLY as I provide you.
If you don't follow the schema, I will not be able to parse it.
Because of that, since I need 100% of certainty, I created a dart test code that will validate if you followed the schema or not.
The test code is located at: $filePreffix$schemaTestFilePath

IMPORTANT: Open the test file - You will see that it reads the file at $filePreffix$schemaResponseFilePath and validates if it follows the schema or not.
So, you MUST follow the schema EXACTLY as I provide you below or the test will fail.

If the test fails, you can be sure you did not follow the schema - so see the errors logs of the test and fix it.
DO NOT change anything in this test file, it is perfect as it is - just focus on following the schema and it will naturally pass the test.

The schema expected is:
```json
${schema.toString()}
```

----------- SCHEMA INSTRUCTIONS [END] -----------''';
  }

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
    try {
      await File(schemaResponseFilePath).delete();
      await File(schemaTestFilePath).delete();
    } catch (_) {
      // Ignore errors during cleanup
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

  Future<TestErrorMessage?> _isSchemaResponseValid() async {
    try {
      final result = await Process.run('dart', ['test', schemaTestFilePath]);

      if (result.exitCode == 0) {
        print('✅ Tests in $schemaTestFilePath passed!');
        return null; // ✅ test passed
      } else {
        print('❌ Tests in $schemaTestFilePath failed.');
        // Return stderr if available, otherwise stdout (sometimes errors print to stdout)
        final errorOutput = (result.stderr as String).trim();
        return errorOutput.isNotEmpty
            ? errorOutput
            : (result.stdout as String).trim();
      }
    } catch (e, s) {
      log('Error reading schema response file: $e', stackTrace: s);
      return null;
    }
  }
}

typedef TestErrorMessage = String;

class SchemaWorkflowResult {
  final String llmMessage;
  final Map<String, dynamic> structuredSchemaData;

  const SchemaWorkflowResult({
    required this.llmMessage,
    required this.structuredSchemaData,
  });
}
