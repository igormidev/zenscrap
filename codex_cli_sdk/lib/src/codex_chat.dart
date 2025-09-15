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
  Future<SchemaResult> sendMessageWithSchema({
    required List<CodexSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw CodexSDKException('Chat session has been disposed');
    }

    // Build the schema prompt
    final schemaJson = jsonEncode(schema.toJson());
    final schemaPrompt = '''
Please provide a structured response according to this JSON schema:

```json
$schemaJson
```

IMPORTANT: Your response must include:
1. A brief explanation of what you found/did
2. The structured data matching the schema

Format your response as JSON with these fields:
{
  "modelMessage": "Your explanation here",
  "data": { /* Your structured data matching the schema */ }
}
''';

    // Combine schema prompt with user messages
    final combinedMessages = [
      CodexSdkContent.text(schemaPrompt),
      ...messages,
    ];

    // Note: Codex CLI doesn't support JSON output flags
    // We'll try to extract JSON from the plain text response
    final jsonChat = CodexChat(
      apiKey: apiKey,
      options: options, // Use regular options without JSON flags
    );

    try {
      final response = await jsonChat.sendMessage(combinedMessages);

      // Try to extract JSON from the response
      // Look for JSON blocks in the response
      try {
        // Try to find JSON in code blocks
        final jsonPattern = RegExp(r'```json?\s*\n?([\s\S]*?)\n?```', multiLine: true);
        final match = jsonPattern.firstMatch(response);

        String jsonStr;
        if (match != null) {
          jsonStr = match.group(1)!.trim();
        } else {
          // Try to find raw JSON in the response
          final braceStart = response.indexOf('{');
          final braceEnd = response.lastIndexOf('}');
          if (braceStart >= 0 && braceEnd > braceStart) {
            jsonStr = response.substring(braceStart, braceEnd + 1);
          } else {
            // Last resort: assume entire response is JSON
            jsonStr = response.trim();
          }
        }

        final jsonResponse = jsonDecode(jsonStr);

        // Extract model message and data
        String modelMessage = '';
        Map<String, dynamic> data = {};

        if (jsonResponse is Map<String, dynamic>) {
          modelMessage = jsonResponse['modelMessage']?.toString() ??
                        jsonResponse['message']?.toString() ??
                        jsonResponse['response']?.toString() ?? '';

          data = jsonResponse['data'] as Map<String, dynamic>? ??
                 jsonResponse['result'] as Map<String, dynamic>? ??
                 jsonResponse;
        }

        return SchemaResult(
          modelMessage: modelMessage,
          data: data,
        );
      } catch (e) {
        // If we can't parse JSON, return a simple message structure
        return SchemaResult(
          modelMessage: response,
          data: {
            'responseType': 'message',
            'message': response,
          },
        );
      }
    } finally {
      await jsonChat.dispose();
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
    final sessionPattern = RegExp(r'session[_\-]?id[:\s]+([a-f0-9\-]+)', caseSensitive: false);
    final match = sessionPattern.firstMatch(response);

    if (match != null) {
      return match.group(1);
    }

    // If no session ID found, generate one
    return _uuid.v4();
  }

  /// Annotation for testing visibility
  static const visibleForTesting = _VisibleForTesting();
}

/// Annotation to mark members that are only visible for testing
class _VisibleForTesting {
  const _VisibleForTesting();
}