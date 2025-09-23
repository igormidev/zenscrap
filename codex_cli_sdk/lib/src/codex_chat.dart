import 'dart:async';
import 'dart:io';

import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'codex_chat_options.dart';

class CodexChat extends CliChatInterface<CodexChatOptions> {
  CodexChat({
    required this.apiKey,
    super.options,
  }) : _sessionId = options?.resumeSessionId;

  final String apiKey;
  bool _didSendFirstMessage = false;
  bool _isDisposed = false;
  String? _sessionId;

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
    _isDisposed = true;
  }

  @override
  Future<Process> createProcess({required String message}) async {
    _ensureNotDisposed();
    filePreffix = '';
    await _ensureBaseDirExists();

    final args = _buildCommandArgs(message);
    final environment = _buildEnvironment();

    final process = await Process.start(
      'codex',
      args,
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
    required SchemaObject schema,
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
    required SchemaObject schema,
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

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);
    env['OPENAI_API_KEY'] = apiKey;

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
