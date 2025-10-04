import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'gemini_chat_options.dart';

class GeminiChat extends CliChatInterface<GeminiChatOptions> {
  GeminiChat({
    required this.apiKey,
    super.options,
  })  : _sessionId = options?.resumeSessionId;

  final String apiKey;
  bool _didSendFirstMessage = false;
  bool _isDisposed = false;
  Process? _activeProcess;
  String? _sessionId;

  GeminiChatOptions get _options => options ?? const GeminiChatOptions();

  bool get isFirstMessage => !_didSendFirstMessage;

  @override
  bool get didSendFirstMessage => _didSendFirstMessage;

  @override
  String? get sessionId => _sessionId;

  @override
  Directory get baseDir => _options.cwd != null && _options.cwd!.isNotEmpty
      ? Directory(_options.cwd!).absolute
      : Directory.current.absolute;

  void changeModel(String model) {
    _ensureNotDisposed();
    options = _options.copyWith(model: model);
    _resetSessionTracking();
  }

  void resetConversation() {
    _resetSessionTracking();
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    if (_activeProcess != null) {
      try {
        _activeProcess!.kill();
      } catch (_) {}
      _activeProcess = null;
    }
    await super.dispose();
  }

  @override
  Future<Process> createProcess({required String message}) async {
    _ensureNotDisposed();
    filePreffix = '@';
    await _ensureBaseDirExists();

    final command = _buildCommand(message: message);
    final environment = _buildEnvironment();

    final process = await Process.start(
      'gemini',
      command.args,
      workingDirectory: baseDir.path,
      environment: environment,
    );

    if (command.writePromptToStdin) {
      process.stdin.write(message);
      await process.stdin.flush();
      await process.stdin.close();
    }

    _didSendFirstMessage = true;
    _activeProcess = process;
    process.exitCode.whenComplete(() => _activeProcess = null);
    return process;
  }

  @override
  Future<String> sendMessage(List<PromptContent> contents) async {
    final adjusted = _prepareContents(contents);
    final raw = await super.sendMessage(adjusted);
    _updateSessionIdFromOutput(raw);
    return _normalizeOutput(raw);
  }

  @override
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) async {
    final adjusted = _prepareContents(messages);
    final result =
        await super.sendMessageWithSchema(messages: adjusted, schema: schema);
    _updateSessionIdFromOutput(result.llmMessage);
    return (
      llmMessage: _normalizeOutput(result.llmMessage),
      structuredSchemaData: result.structuredSchemaData,
    );
  }

  @override
  Stream<String> streamResponse(List<PromptContent> contents) {
    final adjusted = _prepareContents(contents);
    final baseStream = super.streamResponse(adjusted);
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
    final adjusted = _prepareContents(messages);
    final base =
        super.streamResponseWithSchema(messages: adjusted, schema: schema);
    return (
      llmMessage: _decorateStream(base.llmMessage),
      structuredSchemaData: base.structuredSchemaData,
    );
  }

  List<PromptContent> _prepareContents(List<PromptContent> contents) {
    if (_options.repeatSystemPrompt == true &&
        _didSendFirstMessage == true &&
        (_options.systemPrompt?.isNotEmpty ?? false)) {
      final systemPrompt =
          PromptContent.text('''----------- SYSTEM PROMPT [START] -----------
${_options.systemPrompt}
----------- SYSTEM PROMPT [END] -----------''');
      return [systemPrompt, ...contents];
    }
    return contents;
  }

  _GeminiCommand _buildCommand({required String message}) {
    final args = <String>[];
    args.addAll(_options.toCliArgs());

    if (_options.resumeSessionId != null &&
        _options.resumeSessionId!.isNotEmpty) {
      args
        ..add('--session')
        ..add(_options.resumeSessionId!);
    } else if (_sessionId != null && _sessionId!.isNotEmpty) {
      args
        ..add('--session')
        ..add(_sessionId!);
    }

    final requiresStdin = _options.requiresStdin;
    if (!requiresStdin) {
      args.add(message);
    }

    return _GeminiCommand(args: args, writePromptToStdin: requiresStdin);
  }

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);
    env['GEMINI_API_KEY'] = apiKey;

    if (_options.environment != null) {
      env.addAll(_options.environment!);
    }

    return env;
  }

  Stream<String> _decorateStream(Stream<String> stream) {
    final rawBuffer = StringBuffer();
    final controller = StreamController<String>();
    StreamSubscription<String>? subscription;

    subscription = stream.transform(const LineSplitter()).listen(
          (line) {
            rawBuffer.writeln(line);
            final chunks = _extractTextChunks(line);
            for (final chunk in chunks) {
              if (chunk.isNotEmpty) {
                controller.add(chunk);
              }
            }
          },
          onError: controller.addError,
          onDone: () {
            _updateSessionIdFromOutput(rawBuffer.toString());
            controller.close();
          },
        );

    controller.onCancel = () => subscription?.cancel();
    return controller.stream;
  }

  String _normalizeOutput(String raw) {
    if (raw.trim().isEmpty) {
      return raw.trim();
    }

    final lines = const LineSplitter().convert(raw);
    final cleaned = <String>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.startsWith('[') || trimmed.startsWith('session:')) {
        continue;
      }
      cleaned.add(trimmed);
    }

    return cleaned.join('\n').trim();
  }

  Iterable<String> _extractTextChunks(String chunk) sync* {
    final lines = const LineSplitter().convert(chunk);
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      if (trimmed.startsWith('[') || trimmed.startsWith('session:')) {
        _updateSessionIdFromOutput(trimmed);
        continue;
      }
      yield trimmed;
    }
  }

  void _updateSessionIdFromOutput(String output) {
    if (output.isEmpty) return;
    final match = RegExp(r'session:\s*([A-Za-z0-9\-]+)').firstMatch(output);
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
    _sessionId = _options.resumeSessionId;
    _didSendFirstMessage = false;
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw CliException('Chat session has been disposed');
    }
  }
}

class _GeminiCommand {
  const _GeminiCommand({required this.args, this.writePromptToStdin = false});

  final List<String> args;
  final bool writePromptToStdin;
}
