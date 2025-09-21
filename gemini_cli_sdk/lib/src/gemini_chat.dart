import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import 'exceptions/gemini_exceptions.dart';
import 'models/chat_options.dart';
import 'models/gemini_sdk_content.dart';
import 'models/schema_models.dart';

/// Represents a chat session with Gemini
class GeminiChat {
  final String apiKey;
  GeminiChatOptions options;

  /// The session ID for conversation continuity
  String? _sessionId;

  /// Whether this is the first message in the conversation
  bool isFirstMessage = true;

  /// Whether the chat session has been disposed
  bool _isDisposed = false;

  /// List of temporary files created during this session
  final List<File> _temporaryFiles = [];

  /// Active process for streaming
  Process? _activeProcess;

  GeminiChat({
    required this.apiKey,
    GeminiChatOptions? options,
  }) : options = options ?? const GeminiChatOptions();

  /// Gets the current model being used
  String get currentModel => options.model;

  /// Changes the model for future interactions
  /// Common models include:
  /// - 'gemini-2.5-flash' (fast, efficient for most tasks)
  /// - 'gemini-2.5-pro' (balanced performance)
  /// - 'gemini-2.5-ultra' (highest capability for complex tasks)
  void changeModel(String model) {
    options = options.copyWith(model: model);
  }

  /// Sends a message to Gemini and returns the response
  Future<String> sendMessage(List<GeminiSdkContent> contents) async {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
    }

    // Build the prompt from contents
    final prompt = await _buildPrompt(contents);

    // Run the Gemini CLI and get response
    final result = await _runGeminiCommand(prompt);

    return result;
  }

  /// Sends a message with a schema and returns structured data
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<GeminiSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
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
    required List<GeminiSdkContent> messages,
    required SchemaObject schema,
  }) {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
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

  /// Streams a response from Gemini
  Stream<String> streamResponse(List<GeminiSdkContent> contents) async* {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
    }

    // Build the prompt from contents
    final prompt = await _buildPrompt(contents);

    // Run the Gemini CLI in streaming mode
    yield* _streamGeminiCommand(prompt);
  }

  /// Gets the current session ID (if available)
  String? get sessionId => _sessionId;

  /// Resets the conversation, starting a new session
  void resetConversation() {
    _sessionId = null;
    isFirstMessage = true;
  }

  /// Builds a prompt from the provided contents
  Future<String> _buildPrompt(List<GeminiSdkContent> contents) async {
    final promptParts = <String>[];

    // Include system prompt if it's set
    // This complements (not overrides) Gemini's default system prompt
    if (options.systemPrompt != null && options.systemPrompt!.isNotEmpty) {
      // Include system prompt either in first message only or in every message
      if (isFirstMessage || options.repeatSystemPrompt) {
        // Add system prompt as context
        promptParts.add('''[Additional Context/Instructions]
${options.systemPrompt}
[End of Additional Context]''');
      }
    }

    for (final content in contents) {
      if (content is TextContent) {
        promptParts.add(content.text);
      } else if (content is FileContent) {
        if (!content.exists) {
          throw GeminiSDKException('File does not exist: ${content.file.path}');
        }
        // Include file reference in the prompt
        promptParts
            .add('Please analyze the file at: ${content.file.absolute.path}');
      } else if (content is BytesContent) {
        // Create temporary file from bytes
        final tempFile = await _createTempFileFromBytes(content);
        // Include file reference in the prompt
        promptParts
            .add('Please analyze the file at: ${tempFile.absolute.path}');
      }
    }

    return promptParts.join('\n\n');
  }

  /// Creates a temporary file from bytes content
  Future<File> _createTempFileFromBytes(BytesContent content) async {
    try {
      // Get system temp directory
      final tempDir = Directory.systemTemp;

      // Generate unique filename
      const uuid = Uuid();
      final fileName = 'gemini_temp_${uuid.v4()}.${content.fileExtension}';
      final filePath = path.join(tempDir.path, fileName);

      // Create and write to file
      final tempFile = File(filePath);
      await tempFile.writeAsBytes(content.data);

      // Track this temporary file for cleanup
      _temporaryFiles.add(tempFile);

      // Store reference in the BytesContent object
      content.tempFile = tempFile;

      return tempFile;
    } catch (e) {
      throw GeminiSDKException(
          'Failed to create temporary file: ${e.toString()}', e);
    }
  }

  Future<_SchemaWorkflowResult> _runSchemaWorkflow({
    required List<GeminiSdkContent> messages,
    required SchemaObject schema,
    StreamSink<String>? streamSink,
  }) async {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
    }

    if (messages.isEmpty) {
      throw GeminiSDKException('Cannot send empty message');
    }

    final schemaFile = await _createSchemaTempFile();
    final schemaJsonPretty = const JsonEncoder.withIndent('  ').convert(
      schema.toJson(),
    );
    final schemaFilePath = schemaFile.absolute.path;

    String instruction = _buildSchemaInstruction(
      schemaJsonPretty: schemaJsonPretty,
      schemaFilePath: schemaFilePath,
    );

    Future<String> buildPrompt() async {
      final combined = <GeminiSdkContent>[
        ...messages,
        GeminiSdkContent.text(instruction),
      ];
      return _buildPrompt(combined);
    }

    Future<String> executePrompt(String prompt) async {
      if (streamSink == null) {
        return await _runGeminiCommand(prompt);
      }

      final buffer = StringBuffer();
      try {
        await for (final chunk in _streamGeminiCommand(prompt)) {
          if (chunk.isEmpty) {
            continue;
          }
          buffer.write(chunk);
          streamSink.add(chunk);
        }
      } catch (error) {
        if (error is GeminiSDKException) rethrow;
        throw GeminiSDKException('Failed to stream Gemini response', error);
      }
      return buffer.toString();
    }

    String prompt = await buildPrompt();

    var jsonAttempts = 0;
    var schemaAttempts = 0;
    String llmMessage = '';

    try {
      while (true) {
        jsonAttempts += 1;
        await _resetSchemaTempFile(schemaFile);

        final rawOutput = await executePrompt(prompt);
        llmMessage = rawOutput.trim();

        Map<String, dynamic> parsedJson;
        try {
          parsedJson = await _parseJsonFromTempFile(schemaFile);
        } on JSONDecodeException catch (jsonError) {
          if (jsonAttempts >= 2) {
            throw JSONDecodeException(
              'Failed to parse Gemini JSON output after retry: ${jsonError.message}',
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
            schemaFilePath: schemaFilePath,
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
    final baseDir = options.cwd != null
        ? Directory(options.cwd!).absolute
        : Directory.current.absolute;
    final fileName = 'gemini_schema_${const Uuid().v4()}.json';
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
    required String schemaFilePath,
    String? jsonErrorMessage,
    String? currentFileContent,
    SchemaValidationException? validationError,
    String? lastJsonPretty,
  }) {
    final buffer = StringBuffer();

    buffer
      ..writeln('Generate structured JSON that matches the schema below.')
      ..writeln('Use the `write_file` tool to overwrite the file at:')
      ..writeln(schemaFilePath)
      ..writeln()
      ..writeln(
          'When calling `write_file`, provide the JSON object as the `content` value and ensure the file is overwritten in a single call.')
      ..writeln(
          'Do not print the JSON in your assistant message; respond with a brief summary instead.')
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
      buffer.writeln(
          'Regenerate valid JSON and call `write_file` again with the corrected content.');
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
          'After writing the file, double-check the contents and respond with a concise summary of what was generated.');

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
    return '${value.substring(0, maxLength)}...';
  }

  /// Runs the Gemini CLI command and returns the response
  Future<String> _runGeminiCommand(String prompt) async {
    // Build command arguments
    final args = <String>[];

    // Add base command
    args.add('gemini');

    // Add options
    args.addAll(options.buildArgs());

    // Check if we need to use stdin for prompt (when MCP servers are allowed)
    final usesStdin = (options.allowedMcpServerNames != null &&
            options.allowedMcpServerNames!.isNotEmpty) ||
        (options.allowedTools != null && options.allowedTools!.isNotEmpty);

    if (!usesStdin) {
      // Add escaped prompt as positional argument
      args.add(_escapeForShell(prompt));
    }

    // Set up environment with API key
    final environment = Map<String, String>.from(Platform.environment);
    environment['GEMINI_API_KEY'] = apiKey;

    try {
      // Check if Gemini CLI exists
      final checkResult = await Process.run(
        _getShellCommand(),
        _getShellArgs('gemini --version'),
        environment: environment,
      );

      if (checkResult.exitCode != 0) {
        throw CLINotFoundException();
      }

      // Build the command
      final command = args.join(' ');

      if (usesStdin) {
        // Use Process.start and write to stdin
        final process = await Process.start(
          _getShellCommand(),
          _getShellArgs(command),
          environment: environment,
        );

        // Write prompt to stdin with proper encoding
        process.stdin.write(prompt);
        await process.stdin.close();

        // Collect output
        final stdout = await process.stdout.transform(utf8.decoder).join();
        final stderr = await process.stderr.transform(utf8.decoder).join();
        final exitCode = await process.exitCode;

        if (exitCode != 0) {
          throw ProcessException(
            'Gemini command failed',
            exitCode: exitCode,
            stderr: stderr,
          );
        }

        final output = stdout;

        // Extract session ID if present
        if (isFirstMessage && output.contains('session:')) {
          final sessionMatch =
              RegExp(r'session:\s*([a-zA-Z0-9-]+)').firstMatch(output);
          if (sessionMatch != null) {
            _sessionId = sessionMatch.group(1);
            isFirstMessage = false;
          }
        }

        return _extractResponse(output);
      } else {
        // Run the actual command with positional argument
        final result = await Process.run(
          _getShellCommand(),
          _getShellArgs(command),
          environment: environment,
        );

        if (result.exitCode != 0) {
          throw ProcessException(
            'Gemini command failed',
            exitCode: result.exitCode,
            stderr: result.stderr.toString(),
          );
        }

        final output = result.stdout.toString();

        // Extract session ID if present
        if (isFirstMessage && output.contains('session:')) {
          final sessionMatch =
              RegExp(r'session:\s*([a-zA-Z0-9-]+)').firstMatch(output);
          if (sessionMatch != null) {
            _sessionId = sessionMatch.group(1);
            isFirstMessage = false;
          }
        }

        return _extractResponse(output);
      }
    } catch (e) {
      if (e is GeminiSDKException) {
        rethrow;
      }
      throw ProcessException(
        'Failed to run Gemini command: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Streams the Gemini CLI command output
  Stream<String> _streamGeminiCommand(String prompt) async* {
    // Build command arguments
    final args = <String>[];

    // Add base command
    args.add('gemini');

    // Add options
    args.addAll(options.buildArgs());

    // Check if we need to use stdin for prompt (when MCP servers are allowed)
    final usesStdin = (options.allowedMcpServerNames != null &&
            options.allowedMcpServerNames!.isNotEmpty) ||
        (options.allowedTools != null && options.allowedTools!.isNotEmpty);

    if (!usesStdin) {
      // Add escaped prompt as positional argument
      args.add(_escapeForShell(prompt));
    }

    // Set up environment with API key
    final environment = Map<String, String>.from(Platform.environment);
    environment['GEMINI_API_KEY'] = apiKey;

    try {
      // Start the process
      _activeProcess = await Process.start(
        _getShellCommand(),
        _getShellArgs(args.join(' ')),
        environment: environment,
      );

      final process = _activeProcess!;

      // If using stdin, write the prompt
      if (usesStdin) {
        process.stdin.write(prompt);
        await process.stdin.close();
      }

      // Stream stdout
      final stdoutController = StreamController<String>();
      final stderrBuffer = StringBuffer();

      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          // Extract session ID if present
          if (isFirstMessage && line.contains('session:')) {
            final sessionMatch =
                RegExp(r'session:\s*([a-zA-Z0-9-]+)').firstMatch(line);
            if (sessionMatch != null) {
              _sessionId = sessionMatch.group(1);
              isFirstMessage = false;
            }
          }

          // Process and yield the line
          final processed = _processStreamLine(line);
          if (processed.isNotEmpty) {
            stdoutController.add(processed);
          }
        },
        onDone: () => stdoutController.close(),
        onError: (e) => stdoutController.addError(e),
      );

      process.stderr
          .transform(utf8.decoder)
          .listen((data) => stderrBuffer.write(data));

      // Yield from the stream
      yield* stdoutController.stream;

      // Wait for process to complete
      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        throw ProcessException(
          'Gemini streaming command failed',
          exitCode: exitCode,
          stderr: stderrBuffer.toString(),
        );
      }
    } catch (e) {
      if (e is GeminiSDKException) {
        rethrow;
      }
      throw ProcessException(
        'Failed to stream Gemini response: ${e.toString()}',
        originalError: e,
      );
    } finally {
      _activeProcess = null;
    }
  }

  /// Processes a line from the stream output
  String _processStreamLine(String line) {
    // Remove any CLI metadata or formatting
    if (line.startsWith('[') || line.startsWith('session:')) {
      return '';
    }

    // Return the cleaned line
    return line;
  }

  /// Extracts the response from the CLI output
  String _extractResponse(String output) {
    // Handle empty responses gracefully when MCP is involved
    if (output.trim().isEmpty) {
      return '';
    }

    // Remove any CLI metadata and return clean response
    final lines = output.split('\n');
    final responseLines = <String>[];

    for (final line in lines) {
      // Skip metadata lines
      if (line.startsWith('[') ||
          line.startsWith('session:') ||
          line.trim().isEmpty) {
        continue;
      }
      responseLines.add(line);
    }

    return responseLines.join('\n').trim();
  }

  /// Parses the schema response
  /// Gets the appropriate shell command for the platform
  String _getShellCommand() {
    if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return 'sh';
  }

  /// Gets the appropriate shell arguments for the platform
  List<String> _getShellArgs(String command) {
    if (Platform.isWindows) {
      return ['/c', command];
    }
    return ['-c', command];
  }

  /// Escapes a string for safe shell execution
  String _escapeForShell(String input) {
    if (Platform.isWindows) {
      // For Windows, escape double quotes and wrap in double quotes
      return '"${input.replaceAll('"', '\\"')}"';
    } else {
      // For Unix-like systems, escape single quotes and wrap in single quotes
      return "'${input.replaceAll("'", "'\\''")}'";
    }
  }

  /// Cleans up temporary files
  Future<void> _cleanupTempFiles() async {
    for (final file in _temporaryFiles) {
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
        print('Warning: Failed to delete temp file ${file.path}: $e');
      }
    }
    _temporaryFiles.clear();
  }

  /// Disposes the chat session and cleans up resources
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    // Kill any active process
    if (_activeProcess != null) {
      _activeProcess!.kill();
      _activeProcess = null;
    }

    // Clean up temporary files
    await _cleanupTempFiles();

    // Clear session
    _sessionId = null;
    isFirstMessage = true;
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
