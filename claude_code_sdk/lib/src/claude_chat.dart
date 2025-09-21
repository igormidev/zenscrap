import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nanoid2/nanoid2.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import 'exceptions/claude_exceptions.dart';
import 'models/chat_options.dart';
import 'models/claude_sdk_content.dart';
import 'models/schema_models.dart';

/// Represents a chat session with Claude
class ClaudeChat {
  final String apiKey;
  ClaudeChatOptions options;

  /// The session ID from Claude CLI, used for conversation continuity
  String? _sessionId;

  /// Whether this is the first message in the conversation
  bool _isFirstMessage = true;

  /// Whether the chat session has been disposed
  bool _isDisposed = false;

  /// List of temporary files created during this session
  final List<File> _temporaryFiles = [];

  ClaudeChat({
    required this.apiKey,
    ClaudeChatOptions? options,
  }) : options = options ?? const ClaudeChatOptions();

  /// Sends a message to Claude and returns the response
  Future<String> sendMessage(List<ClaudeSdkContent> contents) async {
    if (_isDisposed) {
      throw ClaudeSDKException('Chat session has been disposed');
    }

    // Build the prompt from contents
    final prompt = await _buildPrompt(contents);

    // Run the Claude CLI and get response
    final result = await _runClaudeCommand(prompt);

    return result;
  }

  /// Sends a message with a schema and returns structured data
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<ClaudeSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw ClaudeSDKException('Chat session has been disposed');
    }

    final result = await _runSchemaWorkflow(
      messages: messages,
      schema: schema,
    );

    return (
      llmMessage: result.llmMessage.trim(),
      structuredSchemaData: result.structuredSchemaData,
    );
  }

  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>> structuredSchemaData
  }) streamResponseWithSchema({
    required List<ClaudeSdkContent> messages,
    required SchemaObject schema,
  }) {
    if (_isDisposed) {
      throw ClaudeSDKException('Chat session has been disposed');
    }

    final controller = StreamController<String>.broadcast();
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

  /// Gets the current session ID (if available)
  String? get sessionId => _sessionId;

  /// Resets the conversation, starting a new session
  void resetConversation() {
    _sessionId = null;
    _isFirstMessage = true;
  }

  /// Builds a prompt from the provided contents
  Future<String> _buildPrompt(List<ClaudeSdkContent> contents) async {
    final promptParts = <String>[];

    for (final content in contents) {
      if (content is TextContent) {
        promptParts.add(content.toCliString());
      } else if (content is FileContent) {
        if (!content.exists) {
          throw ClaudeSDKException('File does not exist: ${content.file.path}');
        }
        // Clone file to working directory
        await _cloneFileToWorkingDirectory(content);
        // Use the CLI string representation
        promptParts.add(content.toCliString());
      } else if (content is BytesContent) {
        // Create temporary file from bytes
        await _createTempFileFromBytes(content);
        // Use the CLI string representation
        promptParts.add(content.toCliString());
      }
    }

    return promptParts.join('\n\n');
  }

  Directory get baseDir => options.cwd != null
      ? Directory(options.cwd!).absolute
      : Directory.current.absolute;

  /// Creates a temporary file from bytes content
  Future<void> _createTempFileFromBytes(BytesContent content) async {
    try {
      // Generate unique filename with nanoid
      final nanoId = nanoid(length: 3);
      final fileName = '${content.fileName}_$nanoId.${content.fileExtension}';
      final filePath = path.join(baseDir.path, fileName);

      // Create and write to file
      final tempFile = File(filePath);
      await tempFile.writeAsBytes(content.data);

      // Track this temporary file for cleanup
      _temporaryFiles.add(tempFile);

      // Store reference in the BytesContent object
      content.tempFile = tempFile;
    } catch (e) {
      throw ClaudeSDKException(
          'Failed to create temporary file: ${e.toString()}', e);
    }
  }

  /// Clones a file to the working directory with a unique name
  Future<void> _cloneFileToWorkingDirectory(FileContent content) async {
    try {
      // Read the original file
      final originalData = await content.file.readAsBytes();

      // Generate unique filename with nanoid
      final nanoId = nanoid(length: 3);
      final originalName = content.fileName;
      final extension = path.extension(originalName);
      final baseName = path.basenameWithoutExtension(originalName);
      final newFileName = '${baseName}_$nanoId$extension';
      final filePath = path.join(baseDir.path, newFileName);

      // Create and write to file
      final tempFile = File(filePath);
      await tempFile.writeAsBytes(originalData);

      // Track this temporary file for cleanup
      _temporaryFiles.add(tempFile);

      // Store reference in the FileContent object
      content.tempFile = tempFile;
    } catch (e) {
      throw ClaudeSDKException(
          'Failed to clone file to working directory: ${e.toString()}', e);
    }
  }

  Future<String> _runClaudeCommand(
    String prompt, {
    StreamSink<String>? streamSink,
  }) async {
    final args = <String>[];

    if (_sessionId != null && !_isFirstMessage) {
      args.addAll(['--resume', _sessionId!]);
    }

    args.addAll(['-p', prompt]);

    if (streamSink != null) {
      args.addAll(
          ['--output-format', 'stream-json', '--include-partial-messages']);
    } else {
      args.addAll(['--output-format', 'json']);
    }

    args.addAll(options.toCliArgs());

    final environment = Map<String, String>.from(Platform.environment);
    environment['ANTHROPIC_API_KEY'] = apiKey;
    if (options.environment != null) {
      environment.addAll(options.environment!);
    }

    final timeout = Duration(milliseconds: options.timeoutMs ?? 60000);

    if (streamSink != null) {
      return _runClaudeStreamCommand(
        args: args,
        environment: environment,
        timeout: timeout,
        streamSink: streamSink,
      );
    }

    return _runClaudeBlockingCommand(
      args: args,
      environment: environment,
      timeout: timeout,
    );
  }

  Future<String> _runClaudeBlockingCommand({
    required List<String> args,
    required Map<String, String> environment,
    required Duration timeout,
  }) async {
    try {
      ProcessResult result;
      try {
        result = await Process.run(
          'claude',
          args,
          environment: environment,
          workingDirectory: options.cwd,
        ).timeout(
          timeout,
          onTimeout: () => throw ClaudeSDKException(
            'Request timed out after ${timeout.inMilliseconds}ms',
          ),
        );
      } catch (error) {
        if (error is ClaudeSDKException) rethrow;
        try {
          result = await Process.run(
            'claude-code',
            args,
            environment: environment,
            workingDirectory: options.cwd,
          ).timeout(
            timeout,
            onTimeout: () => throw ClaudeSDKException(
              'Request timed out after ${timeout.inMilliseconds}ms',
            ),
          );
        } catch (_) {
          throw const CLINotFoundException();
        }
      }

      if (result.exitCode != 0) {
        final stderr = result.stderr.toString();
        final stdout = result.stdout.toString();
        var errorMessage = 'Claude process exited with code ${result.exitCode}';
        try {
          if (stdout.isNotEmpty) {
            final json = jsonDecode(stdout) as Map<String, dynamic>;
            if (json['is_error'] == true && json['result'] != null) {
              errorMessage = json['result'].toString();
            }
          }
        } catch (_) {}
        throw ProcessException(
          errorMessage,
          exitCode: result.exitCode,
          stderr: stderr,
        );
      }

      final output = result.stdout.toString();
      if (output.isEmpty) {
        throw ClaudeSDKException('Empty response from Claude CLI');
      }

      try {
        final json = jsonDecode(output) as Map<String, dynamic>;

        if (_isFirstMessage && json['session_id'] != null) {
          _sessionId = json['session_id'] as String;
          _isFirstMessage = false;
        }

        if (json['type'] == 'result') {
          return json['result']?.toString() ?? '';
        }

        if (json['error'] != null) {
          throw ClaudeSDKException(
            'Claude returned an error: ${json['error']}',
          );
        }

        throw ClaudeSDKException(
          'Unexpected response format: ${json['type']}',
        );
      } catch (error) {
        if (error is ClaudeSDKException) rethrow;
        throw JSONDecodeException(
          'Failed to parse Claude response: ${error.toString()}',
          output,
          error,
        );
      }
    } catch (error) {
      if (error is ClaudeSDKException ||
          error is CLINotFoundException ||
          error is ProcessException ||
          error is JSONDecodeException) {
        rethrow;
      }
      throw ClaudeSDKException(
        'Failed to execute Claude command: ${error.toString()}',
        error,
      );
    }
  }

  Future<String> _runClaudeStreamCommand({
    required List<String> args,
    required Map<String, String> environment,
    required Duration timeout,
    required StreamSink<String> streamSink,
  }) async {
    Process process;
    try {
      process = await Process.start(
        'claude',
        args,
        environment: environment,
        workingDirectory: options.cwd,
      );
    } catch (_) {
      try {
        process = await Process.start(
          'claude-code',
          args,
          environment: environment,
          workingDirectory: options.cwd,
        );
      } catch (_) {
        throw const CLINotFoundException();
      }
    }

    final stdoutLines = <String>[];
    final llmBuffer = StringBuffer();
    final stderrBuffer = StringBuffer();
    final stdoutDone = Completer<void>();
    final stderrDone = Completer<void>();

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
      (line) {
        if (line.trim().isEmpty) {
          return;
        }
        stdoutLines.add(line);
        _handleClaudeStreamLine(line, streamSink, llmBuffer);
      },
      onError: (error, stackTrace) {
        if (!stdoutDone.isCompleted) {
          stdoutDone.completeError(error, stackTrace);
        }
      },
      onDone: () {
        if (!stdoutDone.isCompleted) {
          stdoutDone.complete();
        }
      },
    );

    process.stderr.transform(utf8.decoder).listen(
      (data) => stderrBuffer.write(data),
      onError: (error, stackTrace) {
        if (!stderrDone.isCompleted) {
          stderrDone.completeError(error, stackTrace);
        }
      },
      onDone: () {
        if (!stderrDone.isCompleted) {
          stderrDone.complete();
        }
      },
    );

    final exitCode = await process.exitCode.timeout(
      timeout,
      onTimeout: () {
        process.kill();
        throw ClaudeSDKException(
          'Request timed out after ${timeout.inMilliseconds}ms',
        );
      },
    );

    await stdoutDone.future;
    await stderrDone.future;

    if (exitCode != 0) {
      throw ProcessException(
        'Claude process exited with code $exitCode',
        exitCode: exitCode,
        stderr: stderrBuffer.toString(),
      );
    }

    _tryUpdateSessionFromStream(stdoutLines);
    if (_isFirstMessage) {
      _isFirstMessage = false;
    }

    if (llmBuffer.isEmpty) {
      final extracted = _extractResultFromStream(stdoutLines);
      if (extracted != null) {
        streamSink.add(extracted);
        llmBuffer.write(extracted);
      }
    }

    return llmBuffer.toString();
  }

  void _handleClaudeStreamLine(
    String line,
    StreamSink<String> streamSink,
    StringBuffer llmBuffer,
  ) {
    try {
      final event = jsonDecode(line);
      if (event is! Map<String, dynamic>) {
        streamSink.add('$line\n');
        llmBuffer.write('$line\n');
        return;
      }

      final type = event['type'];
      if (type == 'content_block_delta') {
        final delta = event['delta'];
        if (delta is Map<String, dynamic> && delta['type'] == 'text_delta') {
          final text = delta['text']?.toString() ?? '';
          if (text.isNotEmpty) {
            streamSink.add(text);
            llmBuffer.write(text);
          }
        }
        return;
      }

      if (type == 'message_delta') {
        final delta = event['delta'];
        if (delta is Map<String, dynamic> && delta['type'] == 'text_delta') {
          final text = delta['text']?.toString() ?? '';
          if (text.isNotEmpty) {
            streamSink.add(text);
            llmBuffer.write(text);
          }
        }
        return;
      }

      if (type == 'result' && event['result'] != null) {
        final text = event['result'].toString();
        if (text.isNotEmpty) {
          streamSink.add(text);
          llmBuffer.write(text);
        }
        return;
      }

      if (type == 'message' && event['message'] is Map<String, dynamic>) {
        final message = event['message'] as Map<String, dynamic>;
        if (message['type'] == 'text' && message['text'] != null) {
          final text = message['text'].toString();
          if (text.isNotEmpty) {
            streamSink.add(text);
            llmBuffer.write(text);
          }
          return;
        }
      }

      streamSink.add('$line\n');
      llmBuffer.write('$line\n');
    } catch (_) {
      streamSink.add('$line\n');
      llmBuffer.write('$line\n');
    }
  }

  void _tryUpdateSessionFromStream(List<String> lines) {
    if (!_isFirstMessage) {
      return;
    }

    for (final line in lines.reversed) {
      try {
        final event = jsonDecode(line);
        if (event is! Map<String, dynamic>) {
          continue;
        }

        if (event['session_id'] is String) {
          _sessionId = event['session_id'] as String;
          _isFirstMessage = false;
          return;
        }

        final message = event['message'];
        if (message is Map<String, dynamic> &&
            message['session_id'] is String) {
          _sessionId = message['session_id'] as String;
          _isFirstMessage = false;
          return;
        }
      } catch (_) {
        continue;
      }
    }
  }

  String? _extractResultFromStream(List<String> lines) {
    for (final line in lines.reversed) {
      try {
        final event = jsonDecode(line);
        if (event is! Map<String, dynamic>) {
          continue;
        }

        if (event['type'] == 'result' && event['result'] != null) {
          return event['result'].toString();
        }

        final message = event['message'];
        if (message is Map<String, dynamic> && message['type'] == 'text') {
          return message['text']?.toString();
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<_SchemaWorkflowResult> _runSchemaWorkflow({
    required List<ClaudeSdkContent> messages,
    required SchemaObject schema,
    StreamSink<String>? streamSink,
  }) async {
    if (messages.isEmpty) {
      throw ClaudeSDKException('Cannot send empty message');
    }

    final schemaFile = await _createSchemaTempFile();
    final schemaJsonPretty = const JsonEncoder.withIndent('  ').convert(
      schema.toJson(),
    );
    final fileReference = '@${schemaFile.absolute.path}/';

    String instruction = _buildSchemaInstruction(
      schemaJsonPretty: schemaJsonPretty,
      fileReference: fileReference,
    );

    Future<String> buildPrompt() {
      final combined = <ClaudeSdkContent>[
        ...messages,
        ClaudeSdkContent.text(instruction),
      ];
      return _buildPrompt(combined);
    }

    String prompt = await buildPrompt();

    var jsonAttempts = 0;
    var schemaAttempts = 0;
    String llmMessage = '';

    try {
      while (true) {
        jsonAttempts += 1;
        await _resetSchemaTempFile(schemaFile);

        final rawOutput = await _runClaudeCommand(
          prompt,
          streamSink: streamSink,
        );
        llmMessage = rawOutput.trim();

        Map<String, dynamic> parsedJson;
        try {
          parsedJson = await _parseJsonFromTempFile(schemaFile);
        } on JSONDecodeException catch (jsonError) {
          if (jsonAttempts >= 2) {
            throw JSONDecodeException(
              'Failed to parse Claude JSON output after retry: ${jsonError.message}',
              jsonError.rawContent,
              jsonError,
            );
          }

          final currentContent = await _safeReadFile(schemaFile);
          instruction = _buildSchemaInstruction(
            schemaJsonPretty: schemaJsonPretty,
            fileReference: fileReference,
            jsonErrorMessage: jsonError.message,
            currentFileContent: currentContent,
          );
          prompt = await buildPrompt();
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
          final prettyJson =
              const JsonEncoder.withIndent('  ').convert(parsedJson);
          instruction = _buildSchemaInstruction(
            schemaJsonPretty: schemaJsonPretty,
            fileReference: fileReference,
            validationError: validationError,
            lastJsonPretty: prettyJson,
          );
          prompt = await buildPrompt();
        }
      }
    } finally {
      await _deleteSchemaTempFile(schemaFile);
    }
  }

  Future<File> _createSchemaTempFile() async {
    final fileName = 'claude_schema_${const Uuid().v4()}.json';
    final file = File(path.join(baseDir.path, fileName));
    await file.create(recursive: true);
    _temporaryFiles.add(file);
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
      // Ignore cleanup errors
    } finally {
      _temporaryFiles.remove(file);
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
    required String fileReference,
    String? jsonErrorMessage,
    String? currentFileContent,
    SchemaValidationException? validationError,
    String? lastJsonPretty,
  }) {
    final buffer = StringBuffer();

    buffer
      ..writeln('You must produce structured JSON matching the schema below.')
      ..writeln(
          'Open the file reference $fileReference and overwrite its contents with the JSON object.')
      ..writeln(
          'Do not include the JSON in your assistant reply; only share a concise summary of your actions.')
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
      buffer.writeln('Regenerate valid JSON and overwrite the file reference.');
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
      buffer.writeln(
          'Fix these issues and overwrite the file with the corrected JSON.');
    }

    buffer
      ..writeln()
      ..writeln(
          'After saving, verify the file and respond with a brief summary of the generated data.');

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
                errors.add(
                    'Array element "$propertyPath[$index]" cannot be null');
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
    return value.substring(0, maxLength) + '...';
  }

  /// Changes the model for this chat session
  /// This will reset the conversation as Claude Code requires a new session for model changes
  void changeModel(String model) {
    if (_isDisposed) {
      throw ClaudeSDKException('Chat session has been disposed');
    }

    // Update the options with the new model
    options = options.copyWith(model: model);

    // Reset the session ID to start a new conversation with the new model
    _sessionId = null;
    _isFirstMessage = true;
  }

  /// Disposes of the chat session
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    // Clean up temporary files - guarantee cleanup
    try {
      for (final tempFile in _temporaryFiles) {
        try {
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (e) {
          // Log but don't throw - cleanup is best effort
          print('Warning: Failed to delete temp file ${tempFile.path}: $e');
        }
      }
    } catch (e) {
      // Log but don't throw - cleanup must complete
      print('Warning: Failed during cleanup: $e');
    } finally {
      _temporaryFiles.clear();
    }
  }

  /// Whether the chat session is disposed
  bool get isDisposed => _isDisposed;
}

class _SchemaWorkflowResult {
  final String llmMessage;
  final Map<String, dynamic> structuredSchemaData;

  const _SchemaWorkflowResult({
    required this.llmMessage,
    required this.structuredSchemaData,
  });
}
