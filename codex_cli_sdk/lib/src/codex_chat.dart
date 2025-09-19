import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import 'exceptions/codex_exceptions.dart';
import 'models/chat_options.dart';
import 'models/codex_sdk_content.dart';
import 'models/schema_models.dart';

/// Represents a chat session with Codex
class CodexChat {
  /// The API key for authentication
  final String apiKey;

  /// Options for this chat session
  CodexChatOptions? options;

  /// The current session ID (generated after first message)
  String? _sessionId;

  /// List of temporary files created during this session
  final List<File> _tempFiles = [];

  /// Whether the chat has been disposed
  bool _isDisposed = false;

  /// UUID generator for session IDs and temp files
  final _uuid = const Uuid();

  /// Current session identifier provided by Codex CLI (if any)
  String? get sessionId => _sessionId;


  CodexChat({
    required this.apiKey,
    this.options,
  });

  /// Sends a message to Codex and returns the response
  Future<String> sendMessage(List<CodexSdkContent> contents) async {
    _ensureNotDisposed();

    if (contents.isEmpty) {
      throw CodexSDKException('Cannot send empty message');
    }

    final message = await _prepareMessage(contents);
    final rawOutput = await _runCodexCommand(message);
    final response = _parseResponse(rawOutput);

    if (_sessionId == null && options?.continueLastSession != true) {
      _sessionId = _extractSessionId(response) ?? _sessionId;
    }

    return response.trim();
  }

  /// Streams the response from Codex
  Stream<String> streamResponse(List<CodexSdkContent> contents) {
    _ensureNotDisposed();

    if (contents.isEmpty) {
      throw CodexSDKException('Cannot send empty message');
    }

    final controller = StreamController<String>();

    () async {
      try {
        final message = await _prepareMessage(contents);
        await _runCodexCommand(
          message,
          streamSink: controller.sink,
        );
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(error, stackTrace);
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return controller.stream;
  }

  /// Sends a message with a schema and returns structured data
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
  }) async {
    _ensureNotDisposed();

    final result = await _runSchemaWorkflow(
      messages: messages,
      schema: schema,
    );

    return (
      llmMessage: result.llmMessage.trim(),
      structuredSchemaData: result.structuredSchemaData,
    );
  }

  /// Streams a response with schema parsing support
  ({Stream<String> llmMessage, Completer<Map<String, dynamic>> structuredSchemaData})
      streamResponseWithSchema({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
  }) {
    _ensureNotDisposed();

    final controller = StreamController<String>();
    final schemaCompleter = Completer<Map<String, dynamic>>();

    () async {
      try {
        final result = await _runSchemaWorkflow(
          messages: messages,
          schema: schema,
          streamSink: controller.sink,
        );

        if (!schemaCompleter.isCompleted) {
          schemaCompleter.complete(result.structuredSchemaData);
        }
      } catch (error, stackTrace) {
        if (!schemaCompleter.isCompleted) {
          schemaCompleter.completeError(error, stackTrace);
        }
        if (!controller.isClosed) {
          controller.addError(error, stackTrace);
        }
      } finally {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
    }();

    return (
      llmMessage: controller.stream,
      structuredSchemaData: schemaCompleter,
    );
  }

  /// Changes the model for this chat session
  /// This will reset the conversation as Codex requires a new session for model changes
  void changeModel(String model) {
    _ensureNotDisposed();

    options = (options ?? const CodexChatOptions()).copyWith(model: model);
    _sessionId = null;
  }

  /// Changes the model and reasoning effort for this chat session
  /// This will reset the conversation as Codex requires a new session for model changes
  void changeModelWithEffort(String model, String? reasoningEffort) {
    _ensureNotDisposed();

    options = (options ?? const CodexChatOptions()).copyWith(
      model: model,
      reasoningEffort: reasoningEffort,
    );
    _sessionId = null;
  }

  /// Resets the conversation, starting a new session
  void resetConversation() {
    _sessionId = null;
  }

  /// Disposes the chat session and cleans up resources
  Future<void> dispose() async {
    if (_isDisposed) return;

    for (final file in _tempFiles) {
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Ignore cleanup errors
      }
    }
    _tempFiles.clear();

    _isDisposed = true;
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }
  }

  Future<String> _runCodexCommand(
    String message, {
    StreamSink<String>? streamSink,
  }) async {
    final args = _buildCommandArgs(
      message,
      forStreaming: streamSink != null,
    );

    final environment = _buildEnvironment();

    if (streamSink != null) {
      final process = await Process.start(
        'codex',
        args,
        environment: environment,
        workingDirectory: options?.cwd,
      );

      final stdoutBuffer = StringBuffer();
      final stderrBuffer = StringBuffer();
      final stdoutDone = Completer<void>();
      final stderrDone = Completer<void>();

      process.stdout.listen(
        (data) {
          final chunk = utf8.decode(data, allowMalformed: true);
          stdoutBuffer.write(chunk);
          streamSink.add(chunk);
        },
        onDone: () => stdoutDone.complete(),
        onError: (error, stackTrace) {
          if (!stdoutDone.isCompleted) {
            stdoutDone.completeError(error, stackTrace);
          }
        },
      );

      process.stderr.listen(
        (data) {
          stderrBuffer.write(utf8.decode(data, allowMalformed: true));
        },
        onDone: () => stderrDone.complete(),
        onError: (error, stackTrace) {
          if (!stderrDone.isCompleted) {
            stderrDone.completeError(error, stackTrace);
          }
        },
      );

      final exitCode = await process.exitCode;
      await stdoutDone.future;
      await stderrDone.future;

      if (exitCode != 0) {
        throw ProcessException(
          'Codex command failed',
          exitCode: exitCode,
          stderr: stderrBuffer.toString(),
        );
      }

      return stdoutBuffer.toString();
    }

    final result = await Process.run(
      'codex',
      args,
      environment: environment,
      workingDirectory: options?.cwd,
    );

    if (result.exitCode != 0) {
      throw ProcessException(
        'Codex command failed',
        exitCode: result.exitCode,
        stderr: result.stderr.toString(),
      );
    }

    return result.stdout.toString();
  }

  Future<_SchemaWorkflowResult> _runSchemaWorkflow({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
    StreamSink<String>? streamSink,
  }) async {
    if (messages.isEmpty) {
      throw CodexSDKException('Cannot send empty message');
    }

    final schemaFile = await _createSchemaTempJsonFile();
    final schemaJsonPretty = const JsonEncoder.withIndent('  ').convert(schema.toJson());
    final schemaFilePath = schemaFile.absolute.path;

    String instruction = _buildSchemaInstruction(
      schemaJsonPretty: schemaJsonPretty,
      schemaFilePath: schemaFilePath,
    );

    String prompt = await _prepareMessage([
      CodexSdkContent.text(instruction),
      ...messages,
    ]);

    var jsonAttempts = 0;
    var schemaAttempts = 0;
    String llmMessage = '';

    try {
      while (true) {
        jsonAttempts += 1;
        await _resetSchemaTempFile(schemaFile);

        final rawOutput = await _runCodexCommand(
          prompt,
          streamSink: streamSink,
        );
        llmMessage = _parseResponse(rawOutput).trim();

        Map<String, dynamic> parsedJson;
        try {
          parsedJson = await _parseJsonFromTempFile(schemaFile);
        } on JSONDecodeException catch (jsonError) {
          if (jsonAttempts >= 2) {
            throw JSONDecodeException(
              'Failed to parse Codex JSON output after retry: ${jsonError.message}',
              jsonError.rawContent,
              jsonError,
            );
          }

          final currentContent = await _safeReadFile(schemaFile);
          instruction = _buildSchemaInstruction(
            schemaJsonPretty: schemaJsonPretty,
            schemaFilePath: schemaFilePath,
            jsonErrorMessage: jsonError.message,
            currentFileContent: currentContent,
          );

          prompt = await _prepareMessage([
            CodexSdkContent.text(instruction),
            ...messages,
          ]);
          continue;
        }

        try {
          final validated = _validateSchemaResponse(parsedJson, schema);
          return _SchemaWorkflowResult(
            llmMessage: llmMessage,
            structuredSchemaData: validated,
          );
        } on SchemaValidationException catch (validationError) {
          schemaAttempts += 1;
          if (schemaAttempts >= 2) {
            rethrow;
          }

          jsonAttempts = 0;
          final prettyJson = const JsonEncoder.withIndent('  ').convert(parsedJson);
          instruction = _buildSchemaInstruction(
            schemaJsonPretty: schemaJsonPretty,
            schemaFilePath: schemaFilePath,
            validationError: validationError,
            lastJsonPretty: prettyJson,
          );

          prompt = await _prepareMessage([
            CodexSdkContent.text(instruction),
            ...messages,
          ]);
        }
      }
    } finally {
      await _deleteSchemaTempFile(schemaFile);
    }
  }

  Future<String> _prepareMessage(List<CodexSdkContent> contents) async {
    final buffer = StringBuffer();

    for (final content in contents) {
      if (content is TextContent) {
        buffer.writeln(content.text);
      } else if (content is FileContent) {
        if (!content.exists) {
          throw CodexSDKException('File does not exist: ${content.file.path}');
        }
        buffer.writeln('File: ${content.file.absolute.path}');
      } else if (content is BytesContent) {
        final tempFile = await _createTempFile(content);
        buffer.writeln('File: ${tempFile.absolute.path}');
      }
    }

    return buffer.toString().trim();
  }

  Future<File> _createTempFile(BytesContent content) async {
    final tempDir = Directory.systemTemp;
    final fileName = 'codex_temp_${_uuid.v4()}.${content.fileExtension}';
    final tempFile = File(path.join(tempDir.path, fileName));

    await tempFile.writeAsBytes(content.data);
    content.tempFile = tempFile;
    _tempFiles.add(tempFile);

    return tempFile;
  }

  Future<File> _createSchemaTempJsonFile() async {
    final baseDir = options?.cwd != null
        ? Directory(options!.cwd!).absolute
        : Directory.current.absolute;

    final fileName = 'codex_schema_${_uuid.v4()}.json';
    final file = File(path.join(baseDir.path, fileName));
    await file.create(recursive: true);
    _tempFiles.add(file);
    return file;
  }

  Future<void> _resetSchemaTempFile(File file) async {
    await file.writeAsString('{}', flush: true);
  }

  Future<void> _deleteSchemaTempFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore cleanup failures
    } finally {
      _tempFiles.remove(file);
    }
  }

  Future<Map<String, dynamic>> _parseJsonFromTempFile(File file) async {
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      throw JSONDecodeException('JSON file is empty', content);
    }

    try {
      final decoded = jsonDecode(content);
      if (decoded is! Map) {
        throw JSONDecodeException(
          'Expected JSON object at root level',
          content,
        );
      }
      return Map<String, dynamic>.from(decoded);
    } on FormatException catch (error) {
      throw JSONDecodeException(
        'Invalid JSON format: ${error.message}',
        content,
        error,
      );
    }
  }

  String _buildSchemaInstruction({
    required String schemaJsonPretty,
    required String schemaFilePath,
    String? jsonErrorMessage,
    String? currentFileContent,
    SchemaValidationException? validationError,
    String? lastJsonPretty,
  }) {
    final buffer = StringBuffer();

    buffer
      ..writeln('You must produce structured JSON that matches the schema below.')
      ..writeln('Write the JSON object directly into this file (overwrite existing contents):')
      ..writeln(schemaFilePath)
      ..writeln()
      ..writeln('You can run shell commands (e.g. `cat <<\'EOF\' > $schemaFilePath`) or use Codex editing tools to write the file.')
      ..writeln('Do not include the JSON in your assistant reply; only provide a concise summary of your work.')
      ..writeln()
      ..writeln('JSON schema:')
      ..writeln('```json')
      ..writeln(schemaJsonPretty)
      ..writeln('```');

    if (jsonErrorMessage != null) {
      buffer
        ..writeln()
        ..writeln('[Previous attempt produced invalid JSON.]')
        ..writeln('Parser error: $jsonErrorMessage');
      if (currentFileContent != null && currentFileContent.isNotEmpty) {
        buffer
          ..writeln('Current file contents:')
          ..writeln('```json')
          ..writeln(_truncate(currentFileContent))
          ..writeln('```');
      }
      buffer.writeln('Please regenerate the JSON and overwrite the entire file.');
    }

    if (validationError != null) {
      buffer
        ..writeln()
        ..writeln('[Previous attempt failed schema validation.]');
      if (validationError.issues.isNotEmpty) {
        buffer.writeln('Issues detected:');
        for (final issue in validationError.issues) {
          buffer.writeln('- $issue');
        }
      }
      if (lastJsonPretty != null && lastJsonPretty.isNotEmpty) {
        buffer
          ..writeln('Last JSON content:')
          ..writeln('```json')
          ..writeln(_truncate(lastJsonPretty))
          ..writeln('```');
      }
      buffer.writeln('Fix these issues and overwrite the file with a corrected JSON object.');
    }

    buffer
      ..writeln()
      ..writeln('After saving, double-check the file and then respond with a short summary of what was generated.');

    return buffer.toString();
  }

  Map<String, dynamic> _validateSchemaResponse(
    Map<String, dynamic> json,
    SchemaObject schema,
  ) {
    if (schema.type != 'object') {
      throw SchemaValidationException(
        'Root schema type must be an object',
        ['Unsupported schema root type: ${schema.type}'],
      );
    }

    final errors = <String>[];

    late final void Function(
      Map<String, dynamic> value,
      Map<String, SchemaProperty> properties,
      String path,
    ) validateMap;

    late final void Function(
      String propertyPath,
      dynamic value,
      SchemaProperty property,
    ) validateValue;

    validateMap = (value, properties, path) {
      for (final entry in properties.entries) {
        final key = entry.key;
        final property = entry.value;
        final propertyPath = path.isEmpty ? key : '$path.$key';

        if (!value.containsKey(key)) {
          if (!property.nullable) {
            errors.add('Missing required property "$propertyPath"');
          }
          continue;
        }

        final fieldValue = value[key];
        if (fieldValue == null) {
          if (!property.nullable) {
            errors.add('Property "$propertyPath" cannot be null');
          }
          continue;
        }

        validateValue(propertyPath, fieldValue, property);
      }
    };

    validateValue = (propertyPath, value, property) {
      switch (property.type) {
        case 'string':
          if (value is! String) {
            errors.add(
              'Property "$propertyPath" must be a string but received ${value.runtimeType}',
            );
            return;
          }
          if (property.enumValues != null &&
              property.enumValues!.isNotEmpty &&
              !property.enumValues!.contains(value)) {
            errors.add(
              'Property "$propertyPath" must be one of ${property.enumValues} but received "$value"',
            );
          }
          return;
        case 'number':
          if (value is! num) {
            errors.add(
              'Property "$propertyPath" must be a number but received ${value.runtimeType}',
            );
          }
          return;
        case 'integer':
          if (value is int) {
            return;
          }
          if (value is num && value % 1 == 0) {
            return;
          }
          errors.add(
            'Property "$propertyPath" must be an integer but received ${value.runtimeType}',
          );
          return;
        case 'boolean':
          if (value is! bool) {
            errors.add(
              'Property "$propertyPath" must be a boolean but received ${value.runtimeType}',
            );
          }
          return;
        case 'array':
          if (value is! List) {
            errors.add(
              'Property "$propertyPath" must be an array but received ${value.runtimeType}',
            );
            return;
          }
          if (property.items != null) {
            for (var index = 0; index < value.length; index++) {
              final element = value[index];
              if (element == null) {
                errors.add('Array element "$propertyPath[$index]" cannot be null');
                continue;
              }
              validateValue('$propertyPath[$index]', element, property.items!);
            }
          }
          return;
        case 'object':
          if (value is! Map) {
            errors.add(
              'Property "$propertyPath" must be an object but received ${value.runtimeType}',
            );
            return;
          }
          Map<String, dynamic> mapValue;
          try {
            mapValue = Map<String, dynamic>.from(value);
          } catch (_) {
            errors.add(
              'Property "$propertyPath" must be a JSON object with string keys',
            );
            return;
          }
          if (property.properties != null && property.properties!.isNotEmpty) {
            validateMap(mapValue, property.properties!, propertyPath);
          }
          return;
        default:
          return;
      }
    };

    validateMap(json, schema.properties, '');

    if (errors.isNotEmpty) {
      throw SchemaValidationException('Schema validation failed', errors);
    }

    return json;
  }

  List<String> _buildCommandArgs(String message, {bool forStreaming = false}) {
    final args = <String>['exec'];

    if (options != null) {
      final optionArgs = options!.toCliArgs();
      if (forStreaming) {
        optionArgs.removeWhere(
          (arg) => arg == '--quiet' || arg == '--json',
        );
      }
      args.addAll(optionArgs);
    }

    if (_sessionId != null && options?.continueLastSession != true) {
      args.addAll(['--session', _sessionId!]);
    }

    args.add(message);

    return args;
  }

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);
    env['OPENAI_API_KEY'] = apiKey;

    if (options?.environment != null) {
      env.addAll(options!.environment!);
    }

    return env;
  }

  String _parseResponse(String output) {
    if (options?.outputJson == true || options?.quiet == true) {
      try {
        final json = jsonDecode(output);
        if (json is Map<String, dynamic>) {
          return json['response']?.toString() ??
              json['message']?.toString() ??
              json['content']?.toString() ??
              output;
        }
      } catch (_) {
        // Ignore parse errors and fall back to raw output
      }
    }

    return output.trim();
  }

  String? _extractSessionId(String response) {
    final sessionPattern =
        RegExp(r'session[_\\-]?id[:\\s]+([a-f0-9\\-]+)', caseSensitive: false);
    final match = sessionPattern.firstMatch(response);

    if (match != null) {
      return match.group(1);
    }

    return null;
  }

  Future<String> _safeReadFile(File file) async {
    try {
      if (!await file.exists()) {
        return '';
      }
      return await file.readAsString();
    } catch (_) {
      return '';
    }
  }

  String _truncate(String value, [int maxLength = 1500]) {
    if (value.length <= maxLength) {
      return value;
    }
    return '${value.substring(0, maxLength)}...';
  }
}

class _SchemaWorkflowResult {
  final String llmMessage;
  final Map<String, dynamic> structuredSchemaData;

  const _SchemaWorkflowResult({
    required this.llmMessage,
    required this.structuredSchemaData,
  });
}
