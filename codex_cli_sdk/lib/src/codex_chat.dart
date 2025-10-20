import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'codex_chat_options.dart';

class CodexChat extends CliChatInterface<CodexChatOptions> {
  CodexChat({
    super.apiKey,
    super.options,
  }) : _sessionId = options?.resumeSessionId;

  bool _didSendFirstMessage = false;
  bool _isDisposed = false;
  String? _sessionId;
  Directory? _codexHomeDir;

  CodexChatOptions get _options => options ?? const CodexChatOptions();

  @override
  bool get didSendFirstMessage => _didSendFirstMessage;

  @override
  String? get sessionId => _sessionId;

  @override
  Directory get baseDir => _options.cwd != null
      ? Directory(_options.cwd!).absolute
      : Directory.current.absolute;

  void changeModel(String model) {
    _ensureNotDisposed();
    options = _options.copyWith(model: model);
    _resetSessionTracking();
  }

  void changeModelWithEffort(String model, String? reasoningEffort) {
    _ensureNotDisposed();
    options = _options.copyWith(model: model, reasoningEffort: reasoningEffort);
    _resetSessionTracking();
  }

  void resetConversation() {
    _resetSessionTracking();
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    await super.dispose();

    // Clean up isolated CODEX_HOME directory
    if (_codexHomeDir != null) {
      try {
        await _codexHomeDir!.parent.delete(recursive: true);
      } catch (_) {
        // Ignore cleanup errors
      }
    }

    _isDisposed = true;
  }

  @override
  Future<Process> createProcess({required String message}) async {
    _ensureNotDisposed();
    filePreffix = '';
    await _ensureBaseDirExists();

    // If API key is provided and we haven't logged in yet, do stdin login
    if (apiKey != null && _codexHomeDir == null) {
      await _loginViaStdin();
    }

    final args = _buildCommandArgs(message);
    final environment = _buildEnvironment();

    // Use script command to create a pseudo-terminal for unbuffered output
    // This works on both macOS and Linux
    final String executable;
    final List<String> processArgs;

    if (Platform.isWindows) {
      // Windows: just run codex directly (no PTY support easily available)
      executable = 'codex';
      processArgs = args;
    } else if (Platform.isMacOS) {
      // macOS: use script with -q flag (quiet mode, no startup/done messages)
      // Format: script -q /dev/null command args...
      executable = 'script';
      processArgs = ['-q', '/dev/null', 'codex', ...args];
    } else {
      // Linux: use script with -q -c flags
      // Format: script -qc "command args..." /dev/null
      final codexCommand = 'codex ${args.join(' ')}';
      executable = 'script';
      processArgs = ['-qec', codexCommand, '/dev/null'];
    }

    final process = await Process.start(
      executable,
      processArgs,
      workingDirectory: baseDir.path,
      environment: environment,
    );

    _didSendFirstMessage = true;
    return process;
  }

  @override
  Future<String> sendMessage(List<PromptContent> contents) async {
    final response = await super.sendMessage(contents);
    _updateSessionIdFromOutput(response);
    return response;
  }

  @override
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) async {
    final result =
        await super.sendMessageWithSchema(messages: messages, schema: schema);
    _updateSessionIdFromOutput(result.llmMessage);
    return result;
  }

  @override
  Stream<String> streamResponse(List<PromptContent> contents) {
    final baseStream = super.streamResponse(contents);
    return _decorateStream(baseStream);
  }

  @override
  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>> structuredSchemaData,
  }) streamResponseWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) {
    final base =
        super.streamResponseWithSchema(messages: messages, schema: schema);
    return (
      llmMessage: _decorateStream(base.llmMessage),
      structuredSchemaData: base.structuredSchemaData,
    );
  }

  List<String> _buildCommandArgs(String message) {
    final args = <String>['exec'];
    args.addAll(_options.toCliArgs());

    final sessionArgument = _sessionArgument();
    if (sessionArgument != null && sessionArgument.isNotEmpty) {
      args.addAll(['--session', sessionArgument]);
    }

    args.add(message);
    return args;
  }

  String? _sessionArgument() {
    if (_options.continueLastSession == true) {
      return null;
    }
    return _sessionId ?? _options.resumeSessionId;
  }

  /// Logs in to Codex CLI using API key via stdin (Codex >= 0.36.0 approach)
  Future<void> _loginViaStdin() async {
    // Create isolated CODEX_HOME directory
    final tempDir = await Directory.systemTemp.createTemp('codex_cli_');
    _codexHomeDir = Directory('${tempDir.path}/.codex')
      ..createSync(recursive: true);

    // Build environment for login
    final loginEnv = {
      ...Platform.environment,
      'CODEX_HOME': _codexHomeDir!.path,
      'HOME': tempDir.path,
      // Disable any parent OPENAI_* vars
      'OPENAI_API_KEY': '',
      'AZURE_OPENAI_API_KEY': '',
    };

    // Run: codex login --with-api-key (and pipe API key to stdin)
    final loginProc = await Process.start(
      'codex',
      ['login', '--with-api-key'],
      environment: loginEnv,
    );

    // Write API key to stdin
    loginProc.stdin
      ..write(apiKey!)
      ..close();

    // Wait for login to complete
    final exitCode = await loginProc.exitCode;
    if (exitCode != 0) {
      final stderr = await loginProc.stderr.transform(utf8.decoder).join();
      throw CliException(
          'Codex login failed with exit code $exitCode: $stderr');
    }
  }

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);

    // If we created an isolated CODEX_HOME, use it
    if (_codexHomeDir != null) {
      env['CODEX_HOME'] = _codexHomeDir!.path;
      env['HOME'] = _codexHomeDir!.parent.path;
      // Disable parent OPENAI_* vars to avoid conflicts
      env['OPENAI_API_KEY'] = '';
      env['AZURE_OPENAI_API_KEY'] = '';
    }

    if (_options.environment != null) {
      env.addAll(_options.environment!);
    }

    if (_options.enableMcp == false) {
      env['CODEX_ENABLE_MCP'] = 'false';
    }

    return env;
  }

  Stream<String> _decorateStream(Stream<String> stream) {
    final buffer = StringBuffer();
    return stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (chunk, sink) {
          buffer.write(chunk);
          sink.add(chunk);
        },
        handleError: (error, stackTrace, sink) {
          sink.addError(error, stackTrace);
        },
        handleDone: (sink) {
          _updateSessionIdFromOutput(buffer.toString());
          sink.close();
        },
      ),
    );
  }

  void _updateSessionIdFromOutput(String output) {
    if (output.isEmpty) return;
    final sessionPattern =
        RegExp(r'session[_\\-]?id[:\\s]+([a-f0-9\\-]+)', caseSensitive: false);
    final match = sessionPattern.firstMatch(output);
    if (match != null) {
      _sessionId = match.group(1);
    }
  }

  Future<void> _ensureBaseDirExists() async {
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }
  }

  void _resetSessionTracking() {
    _sessionId = null;
    _didSendFirstMessage = false;
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw CliException('Chat session has been disposed');
    }
  }
}
