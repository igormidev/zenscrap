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
  Future<SchemaResult> sendMessageWithSchema({
    required List<GeminiSdkContent> messages,
    required SchemaObject schema,
  }) async {
    if (_isDisposed) {
      throw GeminiSDKException('Chat session has been disposed');
    }

    // Build the prompt with schema instructions
    final prompt = await _buildSchemaPrompt(messages, schema);

    // Run the Gemini CLI and get response
    final response = await _runGeminiCommand(prompt);

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
        final retryResponse = await _runGeminiCommand(retryPrompt);
        
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

  /// Builds a prompt with schema instructions
  Future<String> _buildSchemaPrompt(
      List<GeminiSdkContent> messages, SchemaObject schema) async {
    // The system prompt is already included in _buildPrompt if needed
    final prompt = await _buildPrompt(messages);
    final schemaJson = jsonEncode(schema.toJson());

    return '''$prompt

Please provide your response in the following JSON schema format:
$schemaJson

Ensure your response strictly follows this schema and return only valid JSON.
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

  /// Runs the Gemini CLI command and returns the response
  Future<String> _runGeminiCommand(String prompt) async {
    // Build command arguments
    final args = <String>[];

    // Add base command
    args.add('gemini');

    // Add options
    args.addAll(options.buildArgs());

    // Add prompt
    args.add(prompt);

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

      // Run the actual command
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs(args.join(' ')),
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

    // Add prompt
    args.add(prompt);

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
        e,
      );
    }
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
