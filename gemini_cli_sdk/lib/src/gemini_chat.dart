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

    // Ensure schema is always an object type
    if (schema.type != 'object') {
      throw GeminiSDKException('Schema must be of type "object"');
    }

    // Create temporary JSON file for schema output
    final tempJsonFile = await _createSchemaOutputFile();

    try {
      // Build the prompt with file-based instructions
      final filePrompt = await _buildSchemaFilePrompt(
        messages: messages,
        schema: schema,
        tempFile: tempJsonFile,
      );

      // Send message to Gemini
      final response = await sendMessage([GeminiSdkContent.text(filePrompt)]);

      // Read and parse the JSON file content with retries
      Map<String, dynamic> structuredData;
      try {
        structuredData = await _parseJsonFileContent(tempJsonFile);
      } catch (firstJsonError) {
        // Retry with error feedback
        print(
            'Warning: First JSON parsing attempt failed. Retrying with error context...');

        final retryPrompt = await _buildJsonRetryPrompt(
          originalError: firstJsonError,
          tempFile: tempJsonFile,
        );

        await sendMessage([GeminiSdkContent.text(retryPrompt)]);

        // Try parsing again
        try {
          structuredData = await _parseJsonFileContent(tempJsonFile);
        } catch (secondJsonError) {
          // If JSON parsing still fails, try schema validation retry
          throw JSONDecodeException(
            'Failed to parse JSON file after retry',
            'JSON parsing errors: $firstJsonError, $secondJsonError',
            secondJsonError,
          );
        }
      }

      // Validate against schema with retries
      try {
        _validateSchemaResponse(structuredData, schema);
      } catch (firstSchemaError) {
        // Retry with schema validation feedback
        print(
            'Warning: Schema validation failed. Retrying with error context...');

        final retryPrompt = await _buildSchemaValidationRetryPrompt(
          originalResponse: structuredData,
          error: firstSchemaError,
          schema: schema,
          tempFile: tempJsonFile,
        );

        await sendMessage([GeminiSdkContent.text(retryPrompt)]);

        // Try parsing and validating again
        try {
          structuredData = await _parseJsonFileContent(tempJsonFile);
          _validateSchemaResponse(structuredData, schema);
        } catch (secondSchemaError) {
          throw JSONDecodeException(
            'Failed to validate schema after retry',
            'Schema validation errors: $firstSchemaError, $secondSchemaError',
            secondSchemaError,
          );
        }
      }

      // Return the structured response as a record
      return (
        llmMessage: response,
        structuredSchemaData: structuredData,
      );
    } finally {
      // Clean up temporary file
      await _cleanupSchemaFile(tempJsonFile);
    }
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

  // New helper methods for file-based schema handling

  /// Creates a temporary JSON file for schema output
  Future<File> _createSchemaOutputFile() async {
    final tempDir = Directory.systemTemp;
    const uuid = Uuid();
    final fileName = 'gemini_schema_${uuid.v4()}.json';
    final tempFile = File(path.join(tempDir.path, fileName));

    // Create empty JSON object as initial content
    await tempFile.writeAsString('{}');
    _temporaryFiles.add(tempFile);

    return tempFile;
  }

  /// Builds the prompt for file-based schema output
  Future<String> _buildSchemaFilePrompt({
    required List<GeminiSdkContent> messages,
    required SchemaObject schema,
    required File tempFile,
  }) async {
    final userPrompt = await _buildPrompt(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''[STRUCTURED OUTPUT REQUEST]

IMPORTANT INSTRUCTIONS:
1. You must write your structured response to the file: ${tempFile.absolute.path}
2. The file must contain ONLY valid JSON matching the schema below
3. Do NOT include the JSON in your text response
4. Your text response should summarize what you did and found

==== JSON SCHEMA SPECIFICATION ====
$schemaJson
==== END OF SCHEMA ====

==== FILE OUTPUT RULES ====
- Write ONLY valid JSON to the file (no markdown, no comments, no extra text)
- Ensure all required fields are present with correct types
- Use null for optional fields that have no value
- Arrays must contain items of the specified type
- Property names must match exactly (case-sensitive)
==== END OF RULES ====

==== USER REQUEST ====
$userPrompt
==== END OF REQUEST ====

Now process the request and:
1. Write the structured JSON data to: ${tempFile.absolute.path}
2. Provide a summary of your findings in your text response

Remember: The JSON goes in the file, so WRITE IT IN the file, NOT in your response text.''';
  }

  /// Parses JSON content from a file
  Future<Map<String, dynamic>> _parseJsonFileContent(File file) async {
    if (!await file.exists()) {
      throw GeminiSDKException(
          'Schema output file does not exist: ${file.path}');
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      throw GeminiSDKException('Schema output file is empty');
    }

    try {
      final parsed = jsonDecode(content);
      if (parsed is! Map<String, dynamic>) {
        throw GeminiSDKException('JSON content is not an object');
      }
      return parsed;
    } catch (e) {
      if (e is GeminiSDKException) rethrow;
      throw JSONDecodeException(
        'Failed to parse JSON from file',
        content,
        e,
      );
    }
  }

  /// Builds a retry prompt for JSON parsing errors
  Future<String> _buildJsonRetryPrompt({
    required dynamic originalError,
    required File tempFile,
  }) async {
    String errorDetails = originalError.toString();
    String fileContent = '';

    try {
      fileContent = await tempFile.readAsString();
    } catch (_) {
      fileContent = '<unable to read file>';
    }

    return '''[JSON PARSING ERROR - CORRECTION REQUIRED]

The JSON file you created has syntax errors and cannot be parsed.

ERROR: $errorDetails

FILE CONTENT:
$fileContent

COMMON JSON ERRORS TO CHECK:
1. Missing or extra commas
2. Unclosed brackets or braces
3. Unquoted property names
4. Single quotes instead of double quotes
5. Trailing commas in arrays or objects
6. Invalid escape sequences in strings

Please fix the JSON syntax in the file: ${tempFile.absolute.path}

Write ONLY valid JSON to the file. Do not include any markdown formatting or comments.''';
  }

  /// Builds a retry prompt for schema validation errors
  Future<String> _buildSchemaValidationRetryPrompt({
    required Map<String, dynamic> originalResponse,
    required dynamic error,
    required SchemaObject schema,
    required File tempFile,
  }) async {
    final schemaJson = jsonEncode(schema.toJson());
    final responseJson = jsonEncode(originalResponse);

    return '''[SCHEMA VALIDATION ERROR - CORRECTION REQUIRED]

Your JSON structure does not match the required schema.

ERROR: ${error.toString()}

YOUR JSON:
$responseJson

REQUIRED SCHEMA:
$schemaJson

VALIDATION ISSUES TO FIX:
1. Check that all required fields are present
2. Verify field types match the schema (string, number, boolean, etc.)
3. Ensure property names match exactly (case-sensitive)
4. Arrays must contain items of the correct type
5. Nested objects must match their schema definitions

Please correct the JSON in the file: ${tempFile.absolute.path}

Make sure the JSON structure exactly matches the schema requirements.''';
  }

  /// Validates that the response matches the schema
  void _validateSchemaResponse(Map<String, dynamic> data, SchemaObject schema) {
    // Get required fields from schema
    final requiredFields = <String>[];
    schema.properties.forEach((key, property) {
      if (!property.nullable) {
        requiredFields.add(key);
      }
    });

    // Check for required fields
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw GeminiSDKException('Required field "$field" is missing or null');
      }
    }

    // Validate field types
    schema.properties.forEach((key, property) {
      if (data.containsKey(key) && data[key] != null) {
        _validateFieldType(key, data[key], property);
      }
    });
  }

  /// Validates a field matches its schema type
  void _validateFieldType(
      String fieldName, dynamic value, SchemaProperty property) {
    switch (property.type) {
      case 'string':
        if (value is! String) {
          throw GeminiSDKException(
              'Field "$fieldName" must be a string, got ${value.runtimeType}');
        }
        if (property.enumValues != null &&
            !property.enumValues!.contains(value)) {
          throw GeminiSDKException(
              'Field "$fieldName" must be one of ${property.enumValues}');
        }
        break;
      case 'number':
        if (value is! num) {
          throw GeminiSDKException(
              'Field "$fieldName" must be a number, got ${value.runtimeType}');
        }
        break;
      case 'boolean':
        if (value is! bool) {
          throw GeminiSDKException(
              'Field "$fieldName" must be a boolean, got ${value.runtimeType}');
        }
        break;
      case 'array':
        if (value is! List) {
          throw GeminiSDKException(
              'Field "$fieldName" must be an array, got ${value.runtimeType}');
        }
        if (property.items != null) {
          for (int i = 0; i < value.length; i++) {
            _validateFieldType('$fieldName[$i]', value[i], property.items!);
          }
        }
        break;
      case 'object':
        if (value is! Map<String, dynamic>) {
          throw GeminiSDKException(
              'Field "$fieldName" must be an object, got ${value.runtimeType}');
        }
        if (property.properties != null) {
          property.properties!.forEach((subKey, subProperty) {
            if (value.containsKey(subKey) && value[subKey] != null) {
              _validateFieldType(
                  '$fieldName.$subKey', value[subKey], subProperty);
            } else if (!subProperty.nullable) {
              throw GeminiSDKException(
                  'Required field "$fieldName.$subKey" is missing');
            }
          });
        }
        break;
    }
  }

  /// Cleans up a temporary schema file safely
  Future<void> _cleanupSchemaFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _temporaryFiles.remove(file);
      }
    } catch (e) {
      // Log but don't throw - cleanup errors shouldn't break the flow
      print('Warning: Failed to delete schema file ${file.path}: $e');
    }
  }
}
