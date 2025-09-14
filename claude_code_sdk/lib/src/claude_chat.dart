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
  Future<SchemaResult> sendMessageWithSchema({
    required List<ClaudeSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw ClaudeSDKException('Chat session has been disposed');
    }

    // Build the prompt with schema instructions
    final prompt = await _buildSchemaPrompt(messages, schema);

    // Run the Claude CLI and get response
    final response = await _runClaudeCommand(prompt);

    // First attempt to parse the response
    try {
      return _parseSchemaResponse(response);
    } catch (firstError) {
      // If parsing fails, give the model a second chance with error context
      print('Warning: First schema parsing attempt failed. Retrying with error context...');
      
      try {
        // Build a retry prompt with error context
        final retryPrompt = await _buildRetrySchemaPrompt(
          originalResponse: response,
          error: firstError,
          schema: schema,
        );
        
        // Run the retry command
        final retryResponse = await _runClaudeCommand(retryPrompt);
        
        // Try parsing the retry response
        try {
          return _parseSchemaResponse(retryResponse);
        } catch (secondError) {
          // If it still fails, throw the original error with additional context
          throw JSONDecodeException(
            'Failed to parse schema response after retry. '
            'Original error: ${firstError.toString()}\n'
            'Retry error: ${secondError.toString()}',
            'First response: $response\nRetry response: $retryResponse',
            secondError,
          );
        }
      } catch (e) {
        // If the retry itself fails (not just parsing), throw the original error
        if (e is JSONDecodeException) {
          rethrow;
        }
        throw JSONDecodeException(
          'Failed to retry schema parsing: ${e.toString()}',
          response,
          firstError,
        );
      }
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

  /// Builds a prompt with schema instructions
  Future<String> _buildSchemaPrompt(
      List<ClaudeSdkContent> messages, SchemaObject schema) async {
    final prompt = await _buildPrompt(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''$prompt

Please provide your response in the following JSON schema format:
$schemaJson

Ensure your response strictly follows this schema.
Return only raw json, without anything more (not even md notations like "```" in the begining... just the raw json).''';
  }

  /// Builds a retry prompt when schema parsing fails
  Future<String> _buildRetrySchemaPrompt({
    required String originalResponse,
    required Object error,
    required SchemaObject schema,
  }) async {
    final schemaJson = jsonEncode(schema.toJson());
    
    // Extract error details
    String errorMessage = error.toString();
    String errorDetails = '';
    
    if (error is JSONDecodeException) {
      errorMessage = error.message;
      // Limit the raw content to prevent token overflow
      final rawContent = error.rawContent.length > 500 
          ? '${error.rawContent.substring(0, 500)}...' 
          : error.rawContent;
      errorDetails = 'Your response: $rawContent';
    } else if (error is FormatException) {
      errorMessage = 'JSON format error: ${error.message}';
      errorDetails = 'Invalid JSON at: ${error.source?.toString() ?? 'unknown position'}';
    }

    return '''[CRITICAL ERROR - RETRY REQUIRED]

Your previous response failed to match the required JSON schema format. This is a critical issue that needs immediate correction.

ERROR ENCOUNTERED:
$errorMessage

$errorDetails

WHAT WENT WRONG:
Your response either:
1. Did not contain valid JSON
2. Contained text mixed with JSON (JSON must be standalone)
3. Had syntax errors in the JSON structure
4. Did not match the required schema properties
5. Included markdown code blocks (```) which are not allowed

REQUIRED SCHEMA (YOU MUST FOLLOW THIS EXACTLY):
$schemaJson

INSTRUCTIONS FOR RETRY:
1. Take a deep breath and carefully analyze the schema above
2. Ensure ALL required fields are present with correct types
3. Return ONLY valid JSON - no explanatory text before or after
4. Do NOT wrap JSON in markdown code blocks (no ```)
5. Validate your JSON structure before responding
6. Double-check that property names match exactly (case-sensitive)

CORRECT RESPONSE FORMAT EXAMPLE:
{
  "propertyName": value,
  "anotherProperty": value
}

Please now provide a corrected response that strictly follows the schema. Return ONLY the raw JSON object, nothing else.''';
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
        String errorMessage = 'Claude process exited with code ${result.exitCode}';
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

  /// Parses a schema response and extracts structured data
  SchemaResult _parseSchemaResponse(String response) {
    try {
      // First, try to clean common formatting issues
      String cleanedResponse = response.trim();
      
      // Remove markdown code blocks if present
      if (cleanedResponse.contains('```json')) {
        cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```json\s*'), '');
        cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```\s*'), '');
      } else if (cleanedResponse.contains('```')) {
        cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```\s*'), '');
      }
      
      // Try to extract JSON from the cleaned response
      // First try to parse the entire response as JSON
      try {
        final data = jsonDecode(cleanedResponse) as Map<String, dynamic>;
        return SchemaResult(
          modelMessage: '',
          data: data,
        );
      } catch (_) {
        // If that fails, try to extract JSON using regex
        final jsonMatch = RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}').firstMatch(cleanedResponse);
        
        if (jsonMatch == null) {
          // Try one more time with a more permissive regex
          final permissiveMatch = RegExp(r'\{[\s\S]*\}').firstMatch(cleanedResponse);
          if (permissiveMatch == null) {
            throw JSONDecodeException(
              'No JSON object found in response',
              response,
            );
          }
          
          final jsonStr = permissiveMatch.group(0)!;
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          
          // Extract message if present
          String modelMessage = '';
          final messageIndex = cleanedResponse.indexOf(jsonStr);
          if (messageIndex > 0) {
            modelMessage = cleanedResponse.substring(0, messageIndex).trim();
          }
          
          return SchemaResult(
            modelMessage: modelMessage,
            data: data,
          );
        }
        
        final jsonStr = jsonMatch.group(0)!;
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        
        // Extract message if present
        String modelMessage = '';
        final messageIndex = cleanedResponse.indexOf(jsonStr);
        if (messageIndex > 0) {
          modelMessage = cleanedResponse.substring(0, messageIndex).trim();
        }
        
        return SchemaResult(
          modelMessage: modelMessage,
          data: data,
        );
      }
    } catch (e) {
      if (e is JSONDecodeException) {
        rethrow;
      }
      throw JSONDecodeException(
          'Failed to parse schema response: ${e.toString()}', 
          response,
          e);
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
}
