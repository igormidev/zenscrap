import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
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

    try {
      // Build the prompt with direct JSON response instructions
      final directPrompt = await _buildDirectSchemaPrompt(
        messages: messages,
        schema: schema,
      );

      // Send message to Codex
      final response = await sendMessage([CodexSdkContent.text(directPrompt)]);

      // Parse JSON directly from the response with retries
      Map<String, dynamic> structuredData;
      try {
        structuredData = _parseJsonFromResponse(response);
      } catch (firstJsonError) {
        // Retry with error feedback
        print(
            'Warning: First JSON parsing attempt failed. Retrying with error context...');
        print('[DEBUG] First parse error: $firstJsonError');

        final retryPrompt = _buildDirectJsonRetryPrompt(
          originalResponse: response,
          originalError: firstJsonError,
        );

        final retryResponse = await sendMessage([CodexSdkContent.text(retryPrompt)]);

        // Try parsing again
        try {
          structuredData = _parseJsonFromResponse(retryResponse);
        } catch (secondJsonError) {
          // If JSON parsing still fails, try schema validation retry
          throw JSONDecodeException(
            'Failed to parse JSON after retry',
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

        final retryPrompt = _buildDirectSchemaRetryPrompt(
          originalResponse: structuredData,
          error: firstSchemaError,
          schema: schema,
        );

        final retryResponse = await sendMessage([CodexSdkContent.text(retryPrompt)]);

        // Try parsing and validating again
        try {
          structuredData = _parseJsonFromResponse(retryResponse);
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
    } catch (e) {
      // Re-throw the exception
      rethrow;
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

    // Note: Codex exec doesn't support sessions - each execution is independent
    // Sessions are only available in interactive mode, not exec mode

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

  // Helper methods for direct schema handling

  /// Builds the prompt for direct JSON schema output
  Future<String> _buildDirectSchemaPrompt({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
  }) async {
    final userPrompt = await _prepareMessage(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''[STRUCTURED OUTPUT REQUEST]

IMPORTANT: You must respond with valid JSON that matches the schema below.

==== JSON SCHEMA SPECIFICATION ====
$schemaJson
==== END OF SCHEMA ====

==== OUTPUT FORMAT ====
Your response MUST contain a valid JSON object somewhere in your response.
The JSON should be properly formatted and complete.
You can include explanatory text before or after the JSON, but the JSON itself must be valid and complete.

Example format:
Here is the structured response:
```json
{
  "field1": "value1",
  "field2": "value2"
}
```
==== END OF FORMAT ====

==== USER REQUEST ====
$userPrompt
==== END OF REQUEST ====

Process this request and provide the structured JSON response.''';
  }


  /// Parses JSON directly from response text
  Map<String, dynamic> _parseJsonFromResponse(String response) {
    // Codex response format:
    // [timestamp] OpenAI Codex version...
    // --------
    // metadata...
    // --------
    // [timestamp] User instructions:
    // ... user prompt ...
    // [timestamp] thinking (optional)
    // ... thinking content ...
    // [timestamp] codex
    // ... actual AI response with JSON ...
    // [timestamp] tokens used: ...

    // Find where the actual AI response starts
    // Look for the last occurrence of a line like "[timestamp] codex"
    // The content after this is the actual response

    final lines = response.split('\n');
    int responseStartIndex = -1;

    // Find all "[timestamp] codex" lines
    final codexLineIndices = <int>[];
    for (int i = 0; i < lines.length; i++) {
      if (RegExp(r'^\[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\]\s+codex\s*$').hasMatch(lines[i])) {
        codexLineIndices.add(i);
      }
    }

    // Try to find the last codex block that contains actual content
    for (int idx = codexLineIndices.length - 1; idx >= 0; idx--) {
      int codexLineIdx = codexLineIndices[idx];

      // Look for content after this codex line
      for (int j = codexLineIdx + 1; j < lines.length; j++) {
        final line = lines[j].trim();

        // Stop at the next timestamp or "tokens used"
        if (line.startsWith('[') && line.contains(']')) break;
        if (line.contains('tokens used:')) break;

        // Skip empty lines and reasoning blocks
        if (line.isEmpty) continue;
        if (line.startsWith('**') && line.endsWith('**')) continue;

        // Found actual content
        responseStartIndex = j;
        break;
      }

      if (responseStartIndex >= 0) break;
    }

    String cleanedResponse;
    if (responseStartIndex >= 0) {
      // Extract from the response start to the end or until "tokens used"
      final responseLines = <String>[];
      for (int i = responseStartIndex; i < lines.length; i++) {
        // Stop at "tokens used" line
        if (lines[i].contains('tokens used:')) {
          break;
        }
        responseLines.add(lines[i]);
      }
      cleanedResponse = responseLines.join('\n').trim();
    } else {
      // Fallback: try to find JSON in the entire response
      cleanedResponse = response;
    }


    // Try multiple strategies to find JSON

    String? jsonStr;

    // Strategy 1: Look for markdown-wrapped JSON
    final markdownJsonPattern = RegExp(r'```(?:json)?\s*\n?([\s\S]*?)\n?```');
    final markdownMatches = markdownJsonPattern.allMatches(cleanedResponse);

    for (final match in markdownMatches) {
      final candidateJson = match.group(1)?.trim();
      if (candidateJson != null && candidateJson.startsWith('{')) {
        jsonStr = candidateJson;
        break;
      }
    }

    // Strategy 2: Look for raw JSON object
    if (jsonStr == null || jsonStr.isEmpty) {
      // Find all potential JSON start positions
      final jsonStarts = <int>[];
      for (int i = 0; i < cleanedResponse.length; i++) {
        if (cleanedResponse[i] == '{') {
          jsonStarts.add(i);
        }
      }

      // Try each potential start position
      for (final startIdx in jsonStarts) {
        int braceCount = 0;
        for (int i = startIdx; i < cleanedResponse.length; i++) {
          if (cleanedResponse[i] == '{') braceCount++;
          if (cleanedResponse[i] == '}') braceCount--;

          if (braceCount == 0 && i > startIdx) {
            final candidate = cleanedResponse.substring(startIdx, i + 1);
            // Try to parse it to verify it's valid JSON
            try {
              final test = jsonDecode(candidate);
              if (test is Map<String, dynamic>) {
                jsonStr = candidate;
                break;
              }
            } catch (_) {
              // Not valid JSON, try next candidate
              continue;
            }
          }
        }
        if (jsonStr != null) break;
      }
    }

    if (jsonStr == null || jsonStr.isEmpty) {
      throw JSONDecodeException(
        'No JSON found in response',
        'Could not find JSON in cleaned response. Response start: ${cleanedResponse.substring(0, math.min(500, cleanedResponse.length))}...',
        null,
      );
    }

    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map<String, dynamic>) {
        throw JSONDecodeException(
          'JSON is not an object',
          'Expected JSON object, got ${decoded.runtimeType}',
          null,
        );
      }
      return decoded;
    } catch (e) {
      throw JSONDecodeException(
        'Failed to parse JSON',
        'JSON parsing error: $e\nJSON string: ${jsonStr.substring(0, math.min(500, jsonStr.length))}...',
        e,
      );
    }
  }

  /// Builds a retry prompt for direct JSON parsing errors
  String _buildDirectJsonRetryPrompt({
    required String originalResponse,
    required dynamic originalError,
  }) {
    return '''[JSON PARSING ERROR - CORRECTION REQUIRED]

Your previous response could not be parsed as valid JSON.

ERROR: ${originalError.toString()}

YOUR RESPONSE:
${originalResponse.substring(0, math.min(500, originalResponse.length))}...

COMMON JSON ISSUES TO FIX:
1. Missing or extra commas
2. Unescaped quotes in strings (use ")
3. Trailing commas before closing brackets
4. Missing closing brackets or braces
5. Invalid escape sequences

Please provide a corrected response with VALID JSON that can be parsed.''';
  }

  /// Builds a retry prompt for direct schema validation errors
  String _buildDirectSchemaRetryPrompt({
    required Map<String, dynamic> originalResponse,
    required dynamic error,
    required SchemaObject schema,
  }) {
    final schemaJson = jsonEncode(schema.toJson());
    final responseJson = jsonEncode(originalResponse);

    return '''[SCHEMA VALIDATION ERROR - CORRECTION REQUIRED]

Your JSON does not match the required schema.

ERROR: ${error.toString()}

YOUR JSON:
$responseJson

REQUIRED SCHEMA:
$schemaJson

Please provide corrected JSON that matches the schema exactly.''';
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
        // Validate array items if items schema is provided
        if (property.items != null) {
          for (var i = 0; i < value.length; i++) {
            _validateFieldType('$fieldName[$i]', value[i], property.items!);
          }
        }
        break;
      case 'object':
        if (value is! Map<String, dynamic>) {
          throw CodexSDKException(
              'Field "$fieldName" must be an object, got ${value.runtimeType}');
        }
        // Validate nested object properties if provided
        if (property.properties != null) {
          _validateSchemaResponse(value, SchemaObject(
            properties: property.properties!,
            description: property.description,
          ));
        }
        break;
    }
  }

}

/// Annotation class for visible for testing
class _VisibleForTesting {
  const _VisibleForTesting();
}
