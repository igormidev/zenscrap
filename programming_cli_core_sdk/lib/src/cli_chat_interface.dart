import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:meta/meta.dart';
import 'package:programming_cli_core_sdk/src/cli_chat_options_interface.dart';
import 'package:programming_cli_core_sdk/src/extensions.dart';
import 'package:programming_cli_core_sdk/src/temporary_files.dart';
import 'package:synchronized/synchronized.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:programming_cli_core_sdk/src/prompt_content.dart';
import 'package:programming_cli_core_sdk/src/schema_property.dart';

abstract class CliChatInterface<T extends CliChatOptions> {
  CliChatInterface({required this.options, this.apiKey});
  T? options;

  /// Optional API key for this specific chat session.
  /// If provided, this overrides any default API key from the SDK instance.
  final String? apiKey;

  bool get didSendFirstMessage;

  final Lock _lock = Lock();
  final String chatId = nanoid(length: 4);
  String? get sessionId;

  final List<TemporaryFiles> _temporaryFiles = [];

  Future<void> dispose() async {
    await _cleanupTemporaryFiles();
    await _removeSchemaFiles();
  }

  @protected
  Future<Process> createProcess({required String message});

  Directory get baseDir;

  /// Returns the directory where AI-generated files should be stored.
  /// If cwd is set in options, assumes it already points to the scoped directory.
  /// Otherwise, creates a scoped directory under baseDir.
  Directory get aiGeneratedFilesDir {
    // If cwd is explicitly set (like in web scrapper implementations),
    // baseDir already points to the scoped directory
    if (options?.cwd != null) {
      return baseDir;
    }
    // Otherwise, create the scoped directory under baseDir
    return Directory('${baseDir.path}/ai_generated_files/$chatId');
  }

  /// Updates the chat options.
  /// This allows modifying options like cwd after the chat has been created.
  void updateOptions(T newOptions) {
    options = newOptions;
  }

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
    required SchemaDefinition schema,
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
  }) streamResponseWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) {
    final (
      :Stream<String> llmMessage,
      :Completer<Map<String, dynamic>?> structuredSchemaData,
    ) = _handleTemporaryFilesWrapper(
      promptsOfCurrentMessage: messages,
      schema: schema,
    );

    final completer = Completer<Map<String, dynamic>>();
    structuredSchemaData.future.then((value) {
      if (value == null) {
        completer.completeError(Exception('Schema data is null'));
      } else {
        completer.complete(value);
      }
    }).catchError((error, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    });

    return (llmMessage: llmMessage, structuredSchemaData: completer);
  }

  String get schemaResponseFilePath =>
      '${aiGeneratedFilesDir.path}/schema_response.json';
  String get schemaTestFilePath =>
      '${aiGeneratedFilesDir.path}/is_schema_correct_test.dart';
  String get schemaPubspecFilePath => '${baseDir.path}/pubspec.yaml';

  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>?> structuredSchemaData,
  }) _handleTemporaryFilesWrapper({
    required List<PromptContent> promptsOfCurrentMessage,
    required SchemaDefinition? schema,
  }) {
    final controller = StreamController<String>.broadcast();
    final responseCompleter = Completer<Map<String, dynamic>?>();

    () async {
      await _lock.synchronized(() async {
        bool schemaFilesCreated = false;
        bool temporaryFilesCreated = false;

        try {
          if (schema != null) {
            await _setupSchemaFiles(schema);
            schemaFilesCreated = true;
          }
          await _saveNewPromptContents(promptsOfCurrentMessage);
          await _setTemporaryFiles();
          temporaryFilesCreated = true;

          await _runCli(
            await createProcess(
              message: [
                if (!didSendFirstMessage &&
                    (options?.systemPrompt?.isNotEmpty ?? false))
                  PromptContent.text(
                    '''[----------- SYSTEM PROMPT [START] -----------]
${options?.systemPrompt}
[----------- SYSTEM PROMPT [END] -----------]''',
                  ),
                if (schema != null)
                  PromptContent.text(
                    await _generateSchemaPrompt(schema: schema),
                  ),
                ...promptsOfCurrentMessage,
              ].getPromptMessage(),
            ),
            controller.sink,
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
            await _runCli(
              await createProcess(
                message: '''❌ SCHEMA VALIDATION FAILED

The test failed to validate your JSON output.

CRITICAL REMINDERS:
1. You MUST write the JSON to the file: $filePreffix${p.basename(schemaResponseFilePath)}
2. DO NOT output JSON as text - ONLY write it to the file
3. The file MUST contain valid JSON that matches the schema

Test file location: $filePreffix${p.basename(schemaTestFilePath)}
JSON output file: $filePreffix${p.basename(schemaResponseFilePath)}

ERROR DETAILS:
$testErrorMessage

ACTION REQUIRED:
Write valid JSON to the file $filePreffix${p.basename(schemaResponseFilePath)} that matches the schema exactly.''',
              ),
              controller.sink,
            );

            final errorMessage = await _isSchemaResponseValid();
            final stillFailed = errorMessage != null;
            if (stillFailed) {
              controller.close();
              responseCompleter.completeError(errorMessage);
              // Don't return here - let finally block handle cleanup
              return;
            }
          }

          final schemaFile = File(schemaResponseFilePath);
          if (!await schemaFile.exists()) {
            throw Exception(
              'Schema JSON file was not created at $schemaResponseFilePath',
            );
          }
          final fileContent = await schemaFile.readAsString();
          if (fileContent.trim().isEmpty) {
            throw Exception(
              'Schema JSON file is empty at $schemaResponseFilePath',
            );
          }
          final json = jsonDecode(fileContent) as Map<String, dynamic>;
          controller.close();
          responseCompleter.complete(json);
        } catch (error, stackTrace) {
          controller.close();
          if (!responseCompleter.isCompleted) {
            responseCompleter.completeError(error, stackTrace);
          }
          rethrow;
        } finally {
          // GUARANTEED CLEANUP: This ALWAYS runs, no matter what happens above
          if (temporaryFilesCreated) {
            await _cleanupTemporaryFiles();
          }
          if (schemaFilesCreated) {
            await _removeSchemaFiles();
          }
        }
      });
    }();

    return (
      llmMessage: controller.stream,
      structuredSchemaData: responseCompleter,
    );
  }

  Future<void> _runCli(Process process, StreamSink<String> streamSink) async {
    final stdoutBuffer = StringBuffer();
    final stderrBuffer = StringBuffer();
    final stdoutDone = Completer<void>();
    final stderrDone = Completer<void>();

    final StreamSubscription<List<int>> outSub;
    final StreamSubscription<List<int>> errSub;

    // Start listening to stdout/stderr
    outSub = process.stdout.listen(
      (data) {
        final chunk = utf8.decode(data, allowMalformed: true);
        stdoutBuffer.write(chunk);
        streamSink.add(chunk);
      },
      onError: (e, st) {
        if (!stdoutDone.isCompleted) stdoutDone.completeError(e, st);
      },
      onDone: () {
        if (!stdoutDone.isCompleted) stdoutDone.complete();
      },
      cancelOnError: true,
    );

    errSub = process.stderr.listen(
      (data) => stderrBuffer.write(utf8.decode(data, allowMalformed: true)),
      onError: (e, st) {
        if (!stderrDone.isCompleted) stderrDone.completeError(e, st);
      },
      onDone: () {
        if (!stderrDone.isCompleted) stderrDone.complete();
      },
      cancelOnError: true,
    );
    try {
      // Wait for the process to exit and streams to finish.
      final exitCode = await process.exitCode;
      // Ensure both streams completed (ignore stream errors so we still throw on exitCode below).
      await Future.wait([
        stdoutDone.future.catchError((_) {}),
        stderrDone.future.catchError((_) {}),
      ]);

      if (exitCode != 0) {
        final errorOutput = stderrBuffer.toString().trim();
        final output = errorOutput.isNotEmpty
            ? errorOutput
            : stdoutBuffer.toString().trim();
        throw Exception('Process exited with code $exitCode: $output');
      }
    } finally {
      // Dispose listeners to avoid leaks.
      await outSub.cancel();
      await errSub.cancel();
    }
  }

  Future<String> _generateSchemaPrompt({
    required SchemaDefinition schema,
  }) async {
    return '''[----------- CRITICAL SCHEMA OUTPUT INSTRUCTIONS [START] -----------]

⚠️ CRITICAL: This is a FILE OPERATION task, NOT a text response task!

YOU MUST DO THE FOLLOWING IN THIS EXACT ORDER:
1. Generate a JSON response that follows the schema below EXACTLY
2. Write that JSON to the file: " $filePreffix${p.basename(schemaResponseFilePath)} "
3. DO NOT output the JSON as text in your response - ONLY write it to the file
4. After writing the JSON file, IMMEDIATELY run this test command to validate your output:
   dart test --chain-stack-traces ${p.basename(schemaTestFilePath)}

IMPORTANT FILE WRITING RULES:
- You MUST write the JSON content to the file using file writing tools
- The file is currently empty and WILL FAIL the test if left empty
- Do NOT return the JSON in your text response - ONLY write it to the file
- The test will read the file to validate your JSON, not your text output

VALIDATION PROCESS:
- A test file has been created at: " $filePreffix${p.basename(schemaTestFilePath)} "
- You MUST run the test yourself using: dart test --chain-stack-traces ${p.basename(schemaTestFilePath)}
- This test will:
  1. Check if the file exists (fails if missing)
  2. Check if the file has content (fails if empty)
  3. Parse the JSON from the file
  4. Validate it matches the schema exactly
- If the test fails, fix the JSON and run the test again until it passes
- The test MUST pass before you finish your response

SCHEMA TO FOLLOW:
```json
${schema.toString()}
```

REMEMBER:
✅ DO: Write JSON to the file " $filePreffix${p.basename(schemaResponseFilePath)} "
✅ DO: Run the test command: dart test --chain-stack-traces ${p.basename(schemaTestFilePath)}
✅ DO: Ensure the test passes before completing your response
❌ DON'T: Output JSON as text in your response
❌ DON'T: Leave the file empty
❌ DON'T: Modify the test file
❌ DON'T: Complete your response without running and passing the test

Your task is to:
1. Write valid JSON to the file that matches the schema
2. Run the test to validate your output
3. Ensure the test passes

[----------- CRITICAL SCHEMA OUTPUT INSTRUCTIONS [END] -----------]''';
  }

  Future<void> _setupSchemaFiles(SchemaDefinition schema) async {
    // First, lets create the json file where the AI will write the response in the json schema format
    await File(schemaResponseFilePath).create(recursive: true);
    // Don't write empty JSON - let the AI populate it
    // Now, create the schema instructions file
    final schemaTestFolder = await File(
      schemaTestFilePath,
    ).create(recursive: true);

    final String testContent = '''// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

void main() {
  test('Is correct schema', () async {
    final schemaFile = File('$schemaResponseFilePath');
    if (!await schemaFile.exists()) {
      throw Exception('Schema file does not exist at " $schemaResponseFilePath " - AI did not write any JSON output to the file');
    }
    final schemaContent = await schemaFile.readAsString();
    if (schemaContent.trim().isEmpty) {
      throw Exception('Schema file is empty at " $schemaResponseFilePath " - AI did not write any JSON output to the file');
    }
    final Map<String, dynamic> schemaJson = jsonDecode(schemaContent);
    final String? validationError = schema.validateIdJsonFollowsSchemaStructure(
      schemaJson,
    );
    if (validationError != null) {
      throw Exception('Schema validation failed: \$validationError');
    }
  }, timeout: Timeout(Duration(minutes: 2)));
}

final SchemaPropertyStructuredObjectWithDefinedProperties schema = ${schema.toSchemaProperty().toDartClassDeclaration} as SchemaPropertyStructuredObjectWithDefinedProperties;

$schemaClassDeclaration
''';

    await schemaTestFolder.writeAsString(testContent);

    // Create a minimal pubspec.yaml so dart test can run
    // Use chatId to ensure unique package name (no spaces or special chars)
    final pubspecFile = File(schemaPubspecFilePath);
    final pubspecContent = '''name: cli_schema_test_$chatId
description: Temporary package for schema validation testing
version: 1.0.0
publish_to: none

environment:
  sdk: ^3.0.0

dependencies:
  test: ^1.24.0
''';

    await pubspecFile.create(recursive: true);
    await pubspecFile.writeAsString(pubspecContent);
  }

  Future<void> _removeSchemaFiles() async {
    try {
      print(
        '[$chatId] _removeSchemaFiles - $schemaResponseFilePath - $schemaTestFilePath - $schemaPubspecFilePath',
      );
      await File(schemaResponseFilePath).delete();
      await File(schemaTestFilePath).delete();
      await File(schemaPubspecFilePath).delete();
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
            fileName: p.inChatFilePath(),
            fileContent: await p.file.readAsBytes(),
          ),
        );
      } else if (p is BytesContent) {
        _temporaryFiles.add(
          TemporaryFiles(
            fileName: p.inChatFilePath(),
            fileContent: p.data,
          ),
        );
      }
    }
  }

  Future<void> _setTemporaryFiles() async {
    for (final tempFile in _temporaryFiles) {
      final file = File(
        '${aiGeneratedFilesDir.path}/${tempFile.fileName}',
      );
      if (!await file.exists()) {
        final createdFile = await file.create(recursive: true);
        await createdFile.writeAsBytes(tempFile.fileContent);
      } else {
        await file.writeAsBytes(tempFile.fileContent);
      }
    }
  }

  Future<void> _cleanupTemporaryFiles() async {
    try {
      final chatDir = aiGeneratedFilesDir;
      if (await chatDir.exists()) {
        print('[$chatId] Deleting directory: ${chatDir.path}');
        await chatDir.delete(recursive: true);
      }
    } catch (e) {
      print('[$chatId] Error during cleanup: $e');
      // Ignore errors during cleanup
    }
  }

  Future<TestErrorMessage?> _isSchemaResponseValid() async {
    try {
      // First check if the file even exists
      final schemaFile = File(schemaResponseFilePath);
      if (!await schemaFile.exists()) {
        return 'Schema file does not exist at " ${p.basename(schemaResponseFilePath)} " - You must write JSON to this file';
      }

      // Check if file has content
      final content = await schemaFile.readAsString();
      if (content.trim().isEmpty) {
        return 'Schema file is empty at " ${p.basename(schemaResponseFilePath)} " - You must write JSON content to this file';
      }

      // Now run the actual test
      final result = await Process.run(
          'dart',
          [
            'test',
            '--chain-stack-traces',
            schemaTestFilePath,
          ],
          workingDirectory: baseDir.path);

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
      return 'Error validating schema: $e';
    }
  }
}

typedef TestErrorMessage = String;

final schemaClassDeclaration = r'''sealed class SchemaProperty {
  final String type;
  final bool nullable;
  final String? description;
  SchemaProperty({required this.type, this.nullable = false, this.description});

  factory SchemaProperty.text({required bool nullable, String? description}) =
      SchemaPropertyString;
  factory SchemaProperty.integer({
    required bool nullable,
    String? description,
  }) = SchemaPropertyInteger;
  factory SchemaProperty.double({required bool nullable, String? description}) =
      SchemaPropertyDouble;
  factory SchemaProperty.boolean({
    required bool nullable,
    String? description,
  }) = SchemaPropertyBoolean;
  factory SchemaProperty.enumeration({
    required List<String> enumValues,
    required bool nullable,
    String? description,
  }) = SchemaPropertyEnum;
  factory SchemaProperty.array({
    required SchemaProperty items,
    required bool nullable,
    String? description,
  }) = SchemaPropertyArray;
  factory SchemaProperty.structuredObject({
    required Map<String, SchemaProperty> properties,
    required bool nullable,
    String? description,
  }) = SchemaPropertyStructuredObjectWithDefinedProperties;
  factory SchemaProperty.objectWithUndefinedProperties({
    required bool nullable,
    String? description,
  }) = SchemaPropertyObjectWithUndefinedProperties;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'type': type,
      'nullable': nullable,
      if (description != null) 'description': description,
    };

    switch (this) {
      case SchemaPropertyEnum():
        json['possibleEnumValues'] = (this as SchemaPropertyEnum).enumValues;
      case SchemaPropertyArray():
        json['items'] = (this as SchemaPropertyArray).items.toJson();
      case SchemaPropertyStructuredObjectWithDefinedProperties():
        json['properties'] =
            (this as SchemaPropertyStructuredObjectWithDefinedProperties)
                .properties
                .map((key, value) => MapEntry(key, value.toJson()));
      default:
        // No additional fields for other types
        break;
    }
    return json;
  }

  @override
  String toString() => JsonEncoder.withIndent('  ').convert(toJson());
}

class SchemaPropertyString extends SchemaProperty {
  SchemaPropertyString({required super.nullable, super.description})
    : super(type: 'string');
}

class SchemaPropertyInteger extends SchemaProperty {
  SchemaPropertyInteger({required super.nullable, super.description})
    : super(type: 'integer');
}

class SchemaPropertyDouble extends SchemaProperty {
  SchemaPropertyDouble({required super.nullable, super.description})
    : super(type: 'double');
}

class SchemaPropertyBoolean extends SchemaProperty {
  SchemaPropertyBoolean({required super.nullable, super.description})
    : super(type: 'boolean');
}

class SchemaPropertyEnum extends SchemaProperty {
  final List<String> enumValues;
  SchemaPropertyEnum({
    required this.enumValues,
    required super.nullable,
    super.description,
  }) : super(type: 'enum');
}

class SchemaPropertyArray extends SchemaProperty {
  final SchemaProperty items;
  SchemaPropertyArray({
    required this.items,
    required super.nullable,
    super.description,
  }) : super(type: 'array');
}

class SchemaPropertyObjectWithUndefinedProperties extends SchemaProperty {
  SchemaPropertyObjectWithUndefinedProperties({
    required super.nullable,
    super.description,
  }) : super(type: 'dynamic_object_with_undefined_properties');
}

class SchemaPropertyStructuredObjectWithDefinedProperties
    extends SchemaProperty {
  final Map<String, SchemaProperty> properties;
  SchemaPropertyStructuredObjectWithDefinedProperties({
    required this.properties,
    required super.nullable,
    super.description,
  }) : super(type: 'structured_object_with_defined_properties');

  // Will see if a given JSON object follows this schema structure
  // If a field is required (not nullable) it must be present
  // If a field is nullable it can be absent or null, but if it is present it must follow the schema
  // Returns null if valid, error message if invalid
  String? validateIdJsonFollowsSchemaStructure(Map<String, dynamic> model) {
    return _validateValueForSchema(this, model, 'root');
  }

  static String? _validateValueForSchema(SchemaProperty schema, dynamic value, String path) {
    if (value == null) {
      if (!schema.nullable) {
        return 'Expected non-null value at $path but got null (field is not nullable)';
      }
      return null;
    }

    switch (schema) {
      case SchemaPropertyString():
        if (value is! String) {
          return 'Expected String at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyInteger():
        if (value is! int) {
          return 'Expected int at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyDouble():
        if (value is! num) {
          return 'Expected num (double) at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyBoolean():
        if (value is! bool) {
          return 'Expected bool at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyEnum(:final enumValues):
        if (value is! String) {
          return 'Expected String (enum) at $path but got ${value.runtimeType}';
        }
        if (!enumValues.contains(value)) {
          return 'Invalid enum value at $path: "$value" is not one of [${enumValues.join(', ')}]';
        }
        return null;
      case SchemaPropertyArray(:final items):
        if (value is! List) {
          return 'Expected List at $path but got ${value.runtimeType}';
        }
        for (var i = 0; i < value.length; i++) {
          final error = _validateValueForSchema(items, value[i], '$path[$i]');
          if (error != null) {
            return error;
          }
        }
        return null;
      case SchemaPropertyObjectWithUndefinedProperties():
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }
        return null;
      case SchemaPropertyStructuredObjectWithDefinedProperties(
        :final properties,
      ):
        if (value is! Map<String, dynamic>) {
          return 'Expected Map<String, dynamic> at $path but got ${value.runtimeType}';
        }

        for (final entry in properties.entries) {
          final key = entry.key;
          final propertySchema = entry.value;
          final hasKey = value.containsKey(key);

          if (!hasKey) {
            if (!propertySchema.nullable) {
              return 'Missing required field "$key" at $path (field is not nullable)';
            }
            continue;
          }

          final propertyValue = value[key];
          final error = _validateValueForSchema(propertySchema, propertyValue, '$path.$key');
          if (error != null) {
            return error;
          }
        }
        return null;
    }
  }

  // This will be a Dart class declaration. This will be a extremely basic and naive implementation.
  String get toDartClassDeclaration {
    return _toCode(this, 0);
  }

  static String _escape(String value) => value.replaceAll("'", r"\'");

  static String _toCode(SchemaProperty schema, int indentLevel) {
    final buffer = StringBuffer();
    final indent = '  ' * indentLevel;
    final childIndent = '  ' * (indentLevel + 1);

    void writeDescriptionLine() {
      if (schema.description != null) {
        buffer.writeln(
          "${childIndent}description: '${_escape(schema.description!)}',",
        );
      }
    }

    switch (schema) {
      case SchemaPropertyString():
        buffer.writeln('${indent}SchemaProperty.text(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyInteger():
        buffer.writeln('${indent}SchemaProperty.integer(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyDouble():
        buffer.writeln('${indent}SchemaProperty.double(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyBoolean():
        buffer.writeln('${indent}SchemaProperty.boolean(');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyEnum():
        final enumValues = schema.enumValues
            .map((value) => "'${_escape(value)}'")
            .join(', ');
        buffer.writeln('${indent}SchemaProperty.enumeration(');
        buffer.writeln('${childIndent}enumValues: [$enumValues],');
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyArray():
        buffer.writeln('${indent}SchemaProperty.array(');
        final itemCode = _toCode(schema.items, indentLevel + 1);
        final itemLines = itemCode.split('\n');
        final trimPrefix = '  ' * (indentLevel + 1);
        for (var i = 0; i < itemLines.length; i++) {
          final line = itemLines[i];
          final trimmed = line.startsWith(trimPrefix)
              ? line.substring(trimPrefix.length)
              : line;
          final isLastLine = i == itemLines.length - 1;
          String prefix;
          if (i == 0) {
            prefix = '${childIndent}items: ';
          } else if (isLastLine) {
            prefix = childIndent;
          } else {
            prefix = '$childIndent  ';
          }
          final content = (i > 0 && trimmed.startsWith('  '))
              ? trimmed.substring(2)
              : trimmed;
          final suffix = i == itemLines.length - 1 ? ',' : '';
          buffer.writeln('$prefix$content$suffix');
        }
        if (schema.description != null) {
          buffer.writeln(
            "${childIndent}description: '${_escape(schema.description!)}',",
          );
        }
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyObjectWithUndefinedProperties():
        buffer.writeln(
          '${indent}SchemaProperty.objectWithUndefinedProperties(',
        );
        writeDescriptionLine();
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
      case SchemaPropertyStructuredObjectWithDefinedProperties():
        final objectSchema = schema;
        buffer.writeln('${indent}SchemaProperty.structuredObject(');
        buffer.writeln('${childIndent}properties: {');
        objectSchema.properties.forEach((key, value) {
          final valueCode = _toCode(value, indentLevel + 2);
          final valueLines = valueCode.split('\n');
          final valueTrimPrefix = '  ' * (indentLevel + 2);
          for (var i = 0; i < valueLines.length; i++) {
            final line = valueLines[i];
            final trimmed = line.startsWith(valueTrimPrefix)
                ? line.substring(valueTrimPrefix.length)
                : line;
            final prefix = i == 0
                ? "$childIndent  '${_escape(key)}': "
                : '$childIndent  ';
            final suffix = i == valueLines.length - 1 ? ',' : '';
            buffer.writeln('$prefix$trimmed$suffix');
          }
        });
        buffer.writeln('$childIndent},');
        if (schema.description != null) {
          buffer.writeln(
            "${childIndent}description: '${_escape(schema.description!)}',",
          );
        }
        buffer.writeln('${childIndent}nullable: ${schema.nullable},');
        buffer.write('$indent)');
        break;
    }

    return buffer.toString();
  }
}''';
