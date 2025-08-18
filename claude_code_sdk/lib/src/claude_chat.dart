import 'dart:convert';
import 'dart:io';

import 'exceptions/claude_exceptions.dart';
import 'models/chat_options.dart';
import 'models/claude_sdk_content.dart';
import 'models/schema_models.dart';

/// Represents a chat session with Claude
class ClaudeChat {
  final String apiKey;
  final ClaudeChatOptions options;
  
  /// The session ID from Claude CLI, used for conversation continuity
  String? _sessionId;
  
  /// Whether this is the first message in the conversation
  bool _isFirstMessage = true;
  
  /// Whether the chat session has been disposed
  bool _isDisposed = false;

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
    final prompt = _buildPrompt(contents);
    
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
    final prompt = _buildSchemaPrompt(messages, schema);
    
    // Run the Claude CLI and get response
    final response = await _runClaudeCommand(prompt);
    
    // Parse the response for schema data
    return _parseSchemaResponse(response);
  }

  /// Gets the current session ID (if available)
  String? get sessionId => _sessionId;
  
  /// Resets the conversation, starting a new session
  void resetConversation() {
    _sessionId = null;
    _isFirstMessage = true;
  }

  /// Builds a prompt from the provided contents
  String _buildPrompt(List<ClaudeSdkContent> contents) {
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
      }
    }

    return promptParts.join('\n\n');
  }

  /// Builds a prompt with schema instructions
  String _buildSchemaPrompt(
      List<ClaudeSdkContent> messages, SchemaObject schema) {
    final prompt = _buildPrompt(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''$prompt

Please provide your response in the following JSON schema format:
$schemaJson

Ensure your response strictly follows this schema.''';
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
        throw ProcessException(
          'Claude process exited with code ${result.exitCode}',
          exitCode: result.exitCode,
          stderr: result.stderr.toString(),
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
            'Failed to parse Claude response: ${e.toString()}', e);
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
      Map<String, dynamic> data = {};
      
      // Check if response contains JSON wrapped in markdown code blocks
      if (response.contains('```json')) {
        // Extract JSON from markdown code blocks
        final jsonMatch = RegExp(r'```json\s*(.*?)\s*```', dotAll: true)
            .firstMatch(response);
        if (jsonMatch != null) {
          final jsonContent = jsonMatch.group(1) ?? '';
          try {
            final parsedJson = jsonDecode(jsonContent);
            if (parsedJson is Map<String, dynamic>) {
              data = parsedJson;
            }
          } catch (_) {
            // If parsing fails, use the whole response
            data = {'response': response};
          }
        } else {
          data = {'response': response};
        }
      } else {
        // Try to parse the response as JSON directly
        try {
          final resultJson = jsonDecode(response);
          if (resultJson is Map<String, dynamic>) {
            data = resultJson;
          } else {
            data = {'response': response};
          }
        } catch (_) {
          // If not JSON, create a simple data structure
          data = {'response': response};
        }
      }
      
      return SchemaResult(
        modelMessage: response,
        data: data,
      );
    } catch (e) {
      throw JSONDecodeException(
          'Failed to parse schema response: ${e.toString()}', e);
    }
  }

  /// Disposes of the chat session
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    // No processes to clean up since we use Process.run
  }

  /// Whether the chat session is disposed
  bool get isDisposed => _isDisposed;
}
