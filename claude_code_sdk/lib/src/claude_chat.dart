import 'dart:convert';
import 'dart:io';

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

    // Ensure schema is always an object type
    if (schema.type != 'object') {
      throw ClaudeSDKException('Schema must be of type "object"');
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

      // Send message to Claude
      final response = await sendMessage([ClaudeSdkContent.text(filePrompt)]);

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

        await sendMessage([ClaudeSdkContent.text(retryPrompt)]);

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

        await sendMessage([ClaudeSdkContent.text(retryPrompt)]);

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
        promptParts.add(content.text);
      } else if (content is FileContent) {
        if (!content.exists) {
          throw ClaudeSDKException('File does not exist: ${content.file.path}');
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
      // Get system temp directory using dart:io
      final tempDir = Directory.systemTemp;

      // Generate unique filename
      const uuid = Uuid();
      final fileName = 'claude_temp_${uuid.v4()}.${content.fileExtension}';
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
      throw ClaudeSDKException(
          'Failed to create temporary file: ${e.toString()}', e);
    }
  }

  /// Runs the Claude CLI command and returns the response
  Future<String> _runClaudeCommand(String prompt) async {
    // Build command arguments
    final args = <String>[];

    // If we have a session ID, use --resume to continue the conversation
    if (_sessionId != null && !_isFirstMessage) {
      args.addAll(['--resume', _sessionId!]);
    }

    // Add the prompt with -p flag
    args.addAll(['-p', prompt]);

    // Always use JSON output for consistent parsing
    args.addAll(['--output-format', 'json']);

    // Add any additional options
    args.addAll(options.toCliArgs());

    // Set up environment
    final environment = Map<String, String>.from(Platform.environment);
    environment['ANTHROPIC_API_KEY'] = apiKey;
    if (options.environment != null) {
      environment.addAll(options.environment!);
    }

    try {
      // Try to run claude command first
      ProcessResult result;
      try {
        result = await Process.run(
          'claude',
          args,
          environment: environment,
          workingDirectory: options.cwd,
        ).timeout(
          Duration(milliseconds: options.timeoutMs ?? 60000),
          onTimeout: () => throw ClaudeSDKException(
              'Request timed out after ${options.timeoutMs ?? 60000}ms'),
        );
      } catch (e) {
        if (e is ClaudeSDKException) rethrow;

        // Try claude-code as fallback
        try {
          result = await Process.run(
            'claude-code',
            args,
            environment: environment,
            workingDirectory: options.cwd,
          ).timeout(
            Duration(milliseconds: options.timeoutMs ?? 60000),
            onTimeout: () => throw ClaudeSDKException(
                'Request timed out after ${options.timeoutMs ?? 60000}ms'),
          );
        } catch (e2) {
          if (e2 is ClaudeSDKException) rethrow;
          throw const CLINotFoundException();
        }
      }

      // Check exit code
      if (result.exitCode != 0) {
        final stderr = result.stderr.toString();
        final stdout = result.stdout.toString();
        // Try to parse error from stdout if it's JSON
        String errorMessage =
            'Claude process exited with code ${result.exitCode}';
        try {
          if (stdout.isNotEmpty) {
            final json = jsonDecode(stdout) as Map<String, dynamic>;
            if (json['is_error'] == true && json['result'] != null) {
              errorMessage = json['result'].toString();
            }
          }
        } catch (_) {
          // If parsing fails, use the original error message
        }
        throw ProcessException(
          errorMessage,
          exitCode: result.exitCode,
          stderr: stderr,
        );
      }

      // Parse the JSON response
      final output = result.stdout.toString();
      if (output.isEmpty) {
        throw ClaudeSDKException('Empty response from Claude CLI');
      }

      try {
        final json = jsonDecode(output) as Map<String, dynamic>;

        // Extract session ID from the response (for first message)
        if (_isFirstMessage && json['session_id'] != null) {
          _sessionId = json['session_id'] as String;
          _isFirstMessage = false;
        }

        // Extract the actual result
        if (json['type'] == 'result') {
          return json['result']?.toString() ?? '';
        } else if (json['error'] != null) {
          throw ClaudeSDKException(
              'Claude returned an error: ${json['error']}');
        } else {
          throw ClaudeSDKException(
              'Unexpected response format: ${json['type']}');
        }
      } catch (e) {
        if (e is ClaudeSDKException) rethrow;
        throw JSONDecodeException(
            'Failed to parse Claude response: ${e.toString()}', output, e);
      }
    } catch (e) {
      if (e is ClaudeSDKException ||
          e is CLINotFoundException ||
          e is ProcessException ||
          e is JSONDecodeException) {
        rethrow;
      }
      throw ClaudeSDKException(
          'Failed to execute Claude command: ${e.toString()}', e);
    }
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

    // Clean up temporary files
    for (final tempFile in _temporaryFiles) {
      try {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (e) {
        // Silently ignore cleanup errors
        // Files will be cleaned up by the OS eventually
      }
    }
    _temporaryFiles.clear();
  }

  /// Whether the chat session is disposed
  bool get isDisposed => _isDisposed;

  // New helper methods for file-based schema handling

  /// Creates a temporary JSON file for schema output
  Future<File> _createSchemaOutputFile() async {
    final tempDir = Directory.systemTemp;
    const uuid = Uuid();
    final fileName = 'claude_schema_${uuid.v4()}.json';
    final tempFile = File(path.join(tempDir.path, fileName));

    // Create empty JSON object as initial content
    await tempFile.writeAsString('{}');
    _temporaryFiles.add(tempFile);

    return tempFile;
  }

  /// Builds the prompt for file-based schema output
  Future<String> _buildSchemaFilePrompt({
    required List<ClaudeSdkContent> messages,
    required SchemaObject schema,
    required File tempFile,
  }) async {
    final userPrompt = await _buildPrompt(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''[STRUCTURED OUTPUT REQUEST]

IMPORTANT INSTRUCTIONS:
1. You must write your structured response to the file: @${tempFile.absolute.path}/
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
1. Write the structured JSON data to: @${tempFile.absolute.path}/
2. Provide a summary of your findings in your text response

Remember: The JSON goes in the file, so WRITE IT IN the file, NOT in your response text.''';
  }

  /// Parses JSON content from a file
  Future<Map<String, dynamic>> _parseJsonFileContent(File file) async {
    if (!await file.exists()) {
      throw ClaudeSDKException(
          'Schema output file does not exist: ${file.path}');
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      throw ClaudeSDKException('Schema output file is empty');
    }

    try {
      final parsed = jsonDecode(content);
      if (parsed is! Map<String, dynamic>) {
        throw ClaudeSDKException('JSON content is not an object');
      }
      return parsed;
    } catch (e) {
      if (e is ClaudeSDKException) rethrow;
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

Please fix the JSON syntax in the file: @${tempFile.absolute.path}/

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

Please correct the JSON in the file: @${tempFile.absolute.path}/

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
        throw ClaudeSDKException('Required field "$field" is missing or null');
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
          throw ClaudeSDKException(
              'Field "$fieldName" must be a string, got ${value.runtimeType}');
        }
        if (property.enumValues != null &&
            !property.enumValues!.contains(value)) {
          throw ClaudeSDKException(
              'Field "$fieldName" must be one of ${property.enumValues}');
        }
        break;
      case 'number':
        if (value is! num) {
          throw ClaudeSDKException(
              'Field "$fieldName" must be a number, got ${value.runtimeType}');
        }
        break;
      case 'boolean':
        if (value is! bool) {
          throw ClaudeSDKException(
              'Field "$fieldName" must be a boolean, got ${value.runtimeType}');
        }
        break;
      case 'array':
        if (value is! List) {
          throw ClaudeSDKException(
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
          throw ClaudeSDKException(
              'Field "$fieldName" must be an object, got ${value.runtimeType}');
        }
        if (property.properties != null) {
          property.properties!.forEach((subKey, subProperty) {
            if (value.containsKey(subKey) && value[subKey] != null) {
              _validateFieldType(
                  '$fieldName.$subKey', value[subKey], subProperty);
            } else if (!subProperty.nullable) {
              throw ClaudeSDKException(
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
