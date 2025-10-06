import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

/// Options for configuring a Gemini CLI chat session.
class GeminiChatOptions extends CliChatOptions {
  const GeminiChatOptions({
    this.allowedTools,
    this.allowedMcpServerNames,
    this.approvalMode,
    this.permissionMode,
    this.maxTurns,
    this.repeatSystemPrompt,
    this.includeDirectories,
    this.directories,
    this.outputJson,
    this.streamJson,
    this.timeoutMs,
    this.environment,
    this.additionalArgs,
    this.resumeSessionId,
    super.systemPrompt,
    super.model,
    super.cwd,
    super.runType,
  });

  /// Explicit list of tools Gemini is allowed to call.
  final List<String>? allowedTools;

  /// Explicit list of MCP server names Gemini can interact with.
  final List<String>? allowedMcpServerNames;

  /// When set, Gemini requests tool approvals using this policy.
  final String? approvalMode;

  /// Controls the permission mode for tool usage.
  final String? permissionMode;

  /// Maximum number of conversation turns to keep in the session.
  final int? maxTurns;

  /// Whether the system prompt should be repeated on every turn.
  final bool? repeatSystemPrompt;

  /// When `true`, include the provided [directories] in context.
  final bool? includeDirectories;

  /// Directories that should be included in the Gemini CLI context.
  final List<String>? directories;

  /// Whether Gemini should emit JSON output (`--output json`).
  final bool? outputJson;

  /// Whether Gemini should emit streaming JSON output (`--stream json`).
  final bool? streamJson;

  /// Override the CLI timeout (in milliseconds).
  final int? timeoutMs;

  /// Custom environment variables injected into the Gemini CLI process.
  final Map<String, String>? environment;

  /// Additional CLI arguments passed verbatim to Gemini.
  final List<String>? additionalArgs;

  /// Session identifier to resume a previous conversation.
  final String? resumeSessionId;

  /// Whether the current configuration requires streaming the prompt via stdin.
  bool get requiresStdin =>
      (allowedTools?.isNotEmpty ?? false) ||
      (allowedMcpServerNames?.isNotEmpty ?? false) ||
      streamJson == true;

  /// Converts the options into command line arguments for Gemini CLI.
  List<String> toCliArgs() {
    final args = <String>[];

    if (model != null && model!.isNotEmpty) {
      args
        ..add('-m')
        ..add(model!);
    }

    if (maxTurns != null) {
      args
        ..add('--max-turns')
        ..add(maxTurns!.toString());
    }

    if (permissionMode != null && permissionMode!.isNotEmpty) {
      args
        ..add('--permission-mode')
        ..add(permissionMode!);
    }

    if (approvalMode != null && approvalMode!.isNotEmpty) {
      args
        ..add('--approval-mode')
        ..add(approvalMode!);
    }

    if (allowedTools != null && allowedTools!.isNotEmpty) {
      for (final tool in allowedTools!) {
        final value = tool.contains('*') ? '"$tool"' : tool;
        args
          ..add('--allowed-tools')
          ..add(value);
      }
    }

    if (allowedMcpServerNames != null && allowedMcpServerNames!.isNotEmpty) {
      for (final server in allowedMcpServerNames!) {
        args
          ..add('--allowed-mcp-server-names')
          ..add(server);
      }
    }

    if (includeDirectories == true && directories != null) {
      for (final directory in directories!) {
        if (directory.isEmpty) continue;
        args
          ..add('--include-directories')
          ..add(directory);
      }
    }

    if (outputJson == true) {
      args
        ..add('--output')
        ..add('json');
    }

    if (streamJson == true) {
      args
        ..add('--stream')
        ..add('json');
    }

    if (timeoutMs != null && timeoutMs! > 0) {
      args
        ..add('--timeout-ms')
        ..add(timeoutMs!.toString());
    }

    if (additionalArgs != null && additionalArgs!.isNotEmpty) {
      args.addAll(additionalArgs!);
    }

    return args;
  }

  /// Creates a copy of the options with updated values.
  GeminiChatOptions copyWith({
    List<String>? allowedTools,
    List<String>? allowedMcpServerNames,
    String? approvalMode,
    String? permissionMode,
    int? maxTurns,
    bool? repeatSystemPrompt,
    bool? includeDirectories,
    List<String>? directories,
    bool? outputJson,
    bool? streamJson,
    int? timeoutMs,
    Map<String, String>? environment,
    List<String>? additionalArgs,
    String? resumeSessionId,
    String? systemPrompt,
    String? model,
    String? cwd,
    RunType? runType,
  }) {
    return GeminiChatOptions(
      allowedTools: allowedTools ?? this.allowedTools,
      allowedMcpServerNames:
          allowedMcpServerNames ?? this.allowedMcpServerNames,
      approvalMode: approvalMode ?? this.approvalMode,
      permissionMode: permissionMode ?? this.permissionMode,
      maxTurns: maxTurns ?? this.maxTurns,
      repeatSystemPrompt: repeatSystemPrompt ?? this.repeatSystemPrompt,
      includeDirectories: includeDirectories ?? this.includeDirectories,
      directories: directories ?? this.directories,
      outputJson: outputJson ?? this.outputJson,
      streamJson: streamJson ?? this.streamJson,
      timeoutMs: timeoutMs ?? this.timeoutMs,
      environment: environment ?? this.environment,
      additionalArgs: additionalArgs ?? this.additionalArgs,
      resumeSessionId: resumeSessionId ?? this.resumeSessionId,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      model: model ?? this.model,
      cwd: cwd ?? this.cwd,
      runType: runType ?? this.runType,
    );
  }
}
