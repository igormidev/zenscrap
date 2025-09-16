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

  /// Gets the current session ID (null until first message)
  String? get sessionId => _sessionId;

  /// Creates a new CodexChat instance
  CodexChat({
    required this.apiKey,
    this.options,
  });

  /// Sends a message to Codex and returns the response
  Future<String> sendMessage(List<CodexSdkContent> contents) async {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    if (contents.isEmpty) {
      throw CodexSDKException('Cannot send empty message');
    }

    // Prepare the message
    final message = await _prepareMessage(contents);

    // Build command arguments
    final args = _buildCommandArgs(message);

    try {
      // Run the command
      final result = await Process.run(
        'codex',
        args,
        environment: _buildEnvironment(),
        workingDirectory: options?.cwd,
      );

      if (result.exitCode != 0) {
        throw ProcessException(
          'Codex command failed',
          exitCode: result.exitCode,
          stderr: result.stderr.toString(),
        );
      }

      // Parse the response
      final response = _parseResponse(result.stdout.toString());

      // Extract session ID if this is the first message
      if (_sessionId == null && options?.continueLastSession != true) {
        _sessionId = _extractSessionId(response);
      }

      return response;
    } on ProcessException {
      rethrow;
    } catch (e) {
      throw ProcessException(
        'Failed to run Codex command',
        originalError: e,
      );
    }
  }

  /// Sends a message with a schema for structured response
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    // Ensure schema is always an object type
    if (schema.type != 'object') {
      throw CodexSDKException('Schema must be of type "object"');
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

      // Send message to Codex
      final response = await sendMessage([CodexSdkContent.text(filePrompt)]);

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

        await sendMessage([CodexSdkContent.text(retryPrompt)]);

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

        final retryPrompt = await _buildSchemaRetryPrompt(
          originalResponse: structuredData,
          error: firstSchemaError,
          schema: schema,
          tempFile: tempJsonFile,
        );

        await sendMessage([CodexSdkContent.text(retryPrompt)]);

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
      await _cleanupTempFile(tempJsonFile);
    }
  }

  /// Streams the response from Codex
  Stream<String> streamResponse(List<CodexSdkContent> contents) async* {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    if (contents.isEmpty) {
      throw CodexSDKException('Cannot send empty message');
    }

    // Prepare the message
    final message = await _prepareMessage(contents);

    // Build command arguments (without quiet mode for streaming)
    final args = _buildCommandArgs(message, forStreaming: true);

    Process? process;
    StreamSubscription<List<int>>? stdoutSub;
    StreamSubscription<List<int>>? stderrSub;

    try {
      // Start the process
      process = await Process.start(
        'codex',
        args,
        environment: _buildEnvironment(),
        workingDirectory: options?.cwd,
      );

      final completer = Completer<void>();
      final errorBuffer = StringBuffer();
      var hasError = false;

      // Handle stderr
      stderrSub = process.stderr.listen(
        (data) {
          final error = utf8.decode(data);
          errorBuffer.write(error);
          // Print to console for debugging
          if (error.isNotEmpty && !error.contains('[INFO]')) {
            stderr.write(error);
          }
        },
        onError: (e) {
          hasError = true;
          completer.completeError(e);
        },
      );

      // Handle stdout and yield chunks
      stdoutSub = process.stdout.listen(
        (data) {
          final chunk = utf8.decode(data, allowMalformed: true);
          // Yield the chunk to the stream
          if (chunk.isNotEmpty) {
            // ignore: invalid_use_of_visible_for_testing_member
            streamController?.add(chunk);
          }
        },
        onError: (e) {
          hasError = true;
          completer.completeError(e);
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );

      // Wait for process to complete
      final exitCode = await process.exitCode;

      if (exitCode != 0 && !hasError) {
        throw ProcessException(
          'Codex streaming failed',
          exitCode: exitCode,
          stderr: errorBuffer.toString(),
        );
      }

      // Wait for streams to complete
      await completer.future;

      // Extract session ID if this is the first message
      if (_sessionId == null && options?.continueLastSession != true) {
        // Try to extract from the full output
        // Note: This might not work well with streaming
      }
    } finally {
      await stdoutSub?.cancel();
      await stderrSub?.cancel();
      process?.kill();
    }
  }

  /// The stream controller for streaming responses (for testing)
  @visibleForTesting
  StreamController<String>? streamController;

  /// Changes the model for this chat session
  /// This will reset the conversation as Claude Code requires a new session for model changes
  void changeModel(String model) {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    // Update the options with the new model
    options = (options ?? const CodexChatOptions()).copyWith(model: model);

    // Reset the session ID to start a new conversation with the new model
    _sessionId = null;
  }

  /// Changes the model and reasoning effort for this chat session
  /// This will reset the conversation as Codex requires a new session for model changes
  void changeModelWithEffort(String model, String? reasoningEffort) {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    // Update the options with the new model and reasoning effort
    options = (options ?? const CodexChatOptions()).copyWith(
      model: model,
      reasoningEffort: reasoningEffort,
    );

    // Reset the session ID to start a new conversation with the new model
    _sessionId = null;
  }

  /// Resets the conversation, starting a new session
  void resetConversation() {
    _sessionId = null;
  }

  /// Disposes the chat session and cleans up resources
  Future<void> dispose() async {
    if (_isDisposed) return;

    // Clean up temporary files
    for (final file in _tempFiles) {
      try {
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore deletion errors
        print('Warning: Failed to delete temp file ${file.path}: $e');
      }
    }
    _tempFiles.clear();

    _isDisposed = true;
  }

  // Private helper methods

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
        // Create temporary file for bytes content
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

  List<String> _buildCommandArgs(String message, {bool forStreaming = false}) {
    final args = <String>[];

    // Add exec command for non-interactive execution
    args.add('exec');

    // Add options from CodexChatOptions
    if (options != null) {
      // Don't add quiet flag for streaming
      if (!forStreaming) {
        args.addAll(options!.toCliArgs());
      } else {
        // For streaming, filter out quiet and json flags
        final streamingArgs = options!.toCliArgs()
          ..removeWhere((arg) => arg == '--quiet' || arg == '--json');
        args.addAll(streamingArgs);
      }
    }

    // Add resume session if we have a session ID
    if (_sessionId != null && options?.continueLastSession != true) {
      args.addAll(['--session', _sessionId!]);
    }

    // Add the message as the last argument
    args.add(message);

    return args;
  }

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);

    // Add API key
    env['OPENAI_API_KEY'] = apiKey;

    // Add custom environment variables
    if (options?.environment != null) {
      env.addAll(options!.environment!);
    }

    return env;
  }

  String _parseResponse(String output) {
    if (options?.outputJson == true || options?.quiet == true) {
      // In JSON mode, parse and extract the response
      try {
        final json = jsonDecode(output);
        if (json is Map<String, dynamic>) {
          return json['response']?.toString() ??
              json['message']?.toString() ??
              json['content']?.toString() ??
              output;
        }
      } catch (_) {
        // If JSON parsing fails, return raw output
      }
    }

    return output.trim();
  }

  String? _extractSessionId(String response) {
    // Try to extract session ID from response
    // This might be in logs or metadata

    // Look for session ID patterns in the response
    final sessionPattern =
        RegExp(r'session[_\-]?id[:\s]+([a-f0-9\-]+)', caseSensitive: false);
    final match = sessionPattern.firstMatch(response);

    if (match != null) {
      return match.group(1);
    }

    // If no session ID found, generate one
    return _uuid.v4();
  }

  /// Annotation for testing visibility
  static const visibleForTesting = _VisibleForTesting();

  // New helper methods for file-based schema handling

  /// Creates a temporary JSON file for schema output
  Future<File> _createSchemaOutputFile() async {
    final tempDir = Directory.systemTemp;
    final fileName = 'codex_schema_${_uuid.v4()}.json';
    final tempFile = File(path.join(tempDir.path, fileName));

    // Create empty JSON object as initial content
    await tempFile.writeAsString('{}');
    _tempFiles.add(tempFile);

    return tempFile;
  }

  /// Builds the prompt for file-based schema output
  Future<String> _buildSchemaFilePrompt({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
    required File tempFile,
  }) async {
    final userPrompt = await _prepareMessage(messages);
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
    if (!file.existsSync()) {
      throw CodexSDKException(
          'Schema output file does not exist: ${file.path}');
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      throw CodexSDKException('Schema output file is empty');
    }

    try {
      final parsed = jsonDecode(content);
      if (parsed is! Map<String, dynamic>) {
        throw CodexSDKException('JSON content is not an object');
      }
      return parsed;
    } catch (e) {
      if (e is CodexSDKException) rethrow;
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
  Future<String> _buildSchemaRetryPrompt({
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
        throw CodexSDKException('Required field "$field" is missing or null');
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
          throw CodexSDKException(
              'Field "$fieldName" must be a string, got ${value.runtimeType}');
        }
        if (property.enumValues != null &&
            !property.enumValues!.contains(value)) {
          throw CodexSDKException(
              'Field "$fieldName" must be one of ${property.enumValues}');
        }
        break;
      case 'number':
        if (value is! num) {
          throw CodexSDKException(
              'Field "$fieldName" must be a number, got ${value.runtimeType}');
        }
        break;
      case 'boolean':
        if (value is! bool) {
          throw CodexSDKException(
              'Field "$fieldName" must be a boolean, got ${value.runtimeType}');
        }
        break;
      case 'array':
        if (value is! List) {
          throw CodexSDKException(
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
          throw CodexSDKException(
              'Field "$fieldName" must be an object, got ${value.runtimeType}');
        }
        if (property.properties != null) {
          property.properties!.forEach((subKey, subProperty) {
            if (value.containsKey(subKey) && value[subKey] != null) {
              _validateFieldType(
                  '$fieldName.$subKey', value[subKey], subProperty);
            } else if (!subProperty.nullable) {
              throw CodexSDKException(
                  'Required field "$fieldName.$subKey" is missing');
            }
          });
        }
        break;
    }
  }

  /// Cleans up a temporary file safely
  Future<void> _cleanupTempFile(File file) async {
    try {
      if (file.existsSync()) {
        await file.delete();
        _tempFiles.remove(file);
      }
    } catch (e) {
      // Log but don't throw - cleanup errors shouldn't break the flow
      print('Warning: Failed to delete temp file ${file.path}: $e');
    }
  }
}

/// Annotation to mark members that are only visible for testing
class _VisibleForTesting {
  const _VisibleForTesting();
}
