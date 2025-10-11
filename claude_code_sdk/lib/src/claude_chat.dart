import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'claude_chat_options.dart';

class ClaudeChat extends CliChatInterface<ClaudeChatOptions> {
  ClaudeChat({
    String? apiKey,
    ClaudeChatOptions? options,
  })  : _sessionId = options?.resumeSessionId,
        super(options: options, apiKey: apiKey);

  bool _didSendFirstMessage = false;
  bool _isDisposed = false;
  bool _useStreamingFormat = false;
  String? _sessionId;

  ClaudeChatOptions get _options => options ?? const ClaudeChatOptions();

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
    _resetSession();
  }

  void resetConversation() {
    _resetSession();
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
    filePreffix = '@';
    await _ensureBaseDirExists();

    final args = _buildCommandArgs(message, _useStreamingFormat);
    final environment = _buildEnvironment();

    final process = await _spawnClaudeProcess(args, environment);
    _didSendFirstMessage = true;
    return process;
  }

  @override
  Future<String> sendMessage(List<PromptContent> contents) async {
    final raw = await super.sendMessage(contents);
    return _normalizeClaudeOutput(raw);
  }

  @override
  Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})>
      sendMessageWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) async {
    final result =
        await super.sendMessageWithSchema(messages: messages, schema: schema);
    final normalized = _normalizeClaudeOutput(result.llmMessage);
    return (
      llmMessage: normalized,
      structuredSchemaData: result.structuredSchemaData
    );
  }

  @override
  Stream<String> streamResponse(List<PromptContent> contents) {
    _ensureNotDisposed();
    _useStreamingFormat = true;
    Stream<String> base;
    try {
      base = super.streamResponse(contents);
    } finally {
      _useStreamingFormat = false;
    }
    return _transformClaudeStream(base);
  }

  @override
  ({
    Stream<String> llmMessage,
    Completer<Map<String, dynamic>> structuredSchemaData,
  }) streamResponseWithSchema({
    required List<PromptContent> messages,
    required SchemaDefinition schema,
  }) {
    _ensureNotDisposed();
    _useStreamingFormat = true;
    ({
      Stream<String> llmMessage,
      Completer<Map<String, dynamic>> structuredSchemaData
    }) base;
    try {
      base = super.streamResponseWithSchema(messages: messages, schema: schema);
    } finally {
      _useStreamingFormat = false;
    }
    return (
      llmMessage: _transformClaudeStream(base.llmMessage),
      structuredSchemaData: base.structuredSchemaData,
    );
  }

  Map<String, String> _buildEnvironment() {
    final env = Map<String, String>.from(Platform.environment);

    // Only set API key if provided
    if (apiKey != null) {
      env['ANTHROPIC_API_KEY'] = apiKey!;
    }

    if (_options.environment != null) {
      env.addAll(_options.environment!);
    }
    return env;
  }

  List<String> _buildCommandArgs(String message, bool streaming) {
    final args = <String>[];

    final resume = _sessionArgument();
    if (resume != null && resume.isNotEmpty) {
      args.addAll(['--resume', resume]);
    }

    args.addAll(['-p', message]);

    if (streaming) {
      args.addAll(
          ['--output-format', 'stream-json', '--include-partial-messages']);
    } else {
      args.addAll(['--output-format', 'json']);
    }

    args.addAll(_options.toCliArgs());
    return args;
  }

  String? _sessionArgument() {
    if (_sessionId != null && _sessionId!.isNotEmpty) {
      return _sessionId;
    }
    return _options.resumeSessionId;
  }

  Future<Process> _spawnClaudeProcess(
    List<String> args,
    Map<String, String> environment,
  ) async {
    final candidates = ['claude', 'claude-code'];
    for (final executable in candidates) {
      try {
        return await Process.start(
          executable,
          args,
          workingDirectory: baseDir.path,
          environment: environment,
        );
      } catch (_) {
        continue;
      }
    }
    throw CliException(
      'Claude CLI not found. Install it with `npm install -g @anthropic-ai/claude-code`.',
    );
  }

  String _normalizeClaudeOutput(String raw) {
    final events = _parseEvents(raw);
    if (events.isEmpty) {
      return raw.trim();
    }

    final buffer = StringBuffer();
    for (final event in events) {
      _updateSessionFromEvent(event);
      final error = event['error'];
      if (error != null) {
        throw CliException('Claude CLI returned an error: $error');
      }
      final texts = _extractTexts(event);
      for (final text in texts) {
        if (text.isEmpty) continue;
        if (buffer.isNotEmpty) {
          buffer.writeln();
        }
        buffer.write(text);
      }
    }

    return buffer.isEmpty ? raw.trim() : buffer.toString().trim();
  }

  List<Map<String, dynamic>> _parseEvents(String raw) {
    final events = <Map<String, dynamic>>[];
    final lines = const LineSplitter().convert(raw);
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final event = _tryParseEvent(trimmed);
      if (event != null) {
        events.add(event);
      }
    }
    return events;
  }

  Map<String, dynamic>? _tryParseEvent(String line) {
    try {
      final decoded = jsonDecode(line);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  Iterable<String> _extractTexts(Map<String, dynamic> event) sync* {
    final type = event['type'];

    if (type == 'content_block_delta' || type == 'message_delta') {
      final delta = event['delta'];
      if (delta is Map<String, dynamic> && delta['type'] == 'text_delta') {
        final text = delta['text']?.toString();
        if (text != null) {
          yield text;
        }
      }
      return;
    }

    if (type == 'result' && event['result'] != null) {
      yield event['result'].toString();
      return;
    }

    final message = event['message'];
    if (message is Map<String, dynamic>) {
      final messageType = message['type'];
      if (messageType == 'text' && message['text'] != null) {
        yield message['text'].toString();
        return;
      }
    }

    if (event['delta'] is Map<String, dynamic>) {
      final delta = event['delta'] as Map<String, dynamic>;
      if (delta['type'] == 'text_delta' && delta['text'] != null) {
        yield delta['text'].toString();
        return;
      }
    }
  }

  Stream<String> _transformClaudeStream(Stream<String> raw) {
    final controller = StreamController<String>();
    final partial = StringBuffer();

    late final StreamSubscription<String> subscription;
    subscription = raw.listen(
      (chunk) {
        partial.write(chunk);
        var buffered = partial.toString();
        final lines = buffered.split('\n');
        partial.clear();

        if (!buffered.endsWith('\n')) {
          partial.write(lines.removeLast());
        } else if (lines.isNotEmpty && lines.last.isEmpty) {
          lines.removeLast();
        }

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          final event = _tryParseEvent(trimmed);
          if (event != null) {
            _updateSessionFromEvent(event);
            final texts = _extractTexts(event).toList();
            if (texts.isEmpty) continue;
            for (final text in texts) {
              if (text.isNotEmpty) {
                controller.add(text);
              }
            }
          } else {
            controller.add(trimmed);
          }
        }
      },
      onError: controller.addError,
      onDone: () {
        final remaining = partial.toString().trim();
        if (remaining.isNotEmpty) {
          final event = _tryParseEvent(remaining);
          if (event != null) {
            _updateSessionFromEvent(event);
            for (final text in _extractTexts(event)) {
              if (text.isNotEmpty) {
                controller.add(text);
              }
            }
          } else {
            controller.add(remaining);
          }
        }
        controller.close();
      },
      cancelOnError: false,
    );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  void _updateSessionFromEvent(Map<String, dynamic> event) {
    final session = event['session_id'];
    if (session is String && session.isNotEmpty) {
      _sessionId = session;
      return;
    }

    final message = event['message'];
    if (message is Map<String, dynamic>) {
      final messageSession = message['session_id'];
      if (messageSession is String && messageSession.isNotEmpty) {
        _sessionId = messageSession;
      }
    }
  }

  Future<void> _ensureBaseDirExists() async {
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }
  }

  void _resetSession() {
    _sessionId = null;
    _didSendFirstMessage = false;
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw CliException('Chat session has been disposed');
    }
  }
}
