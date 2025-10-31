import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

class ClaudeChatOptions extends CliChatOptions {
  final int? maxTurns;
  final List<String>? allowedTools;
  final List<String>? disallowedTools;
  final String? permissionMode;
  final String? resumeSessionId;
  final Map<String, String>? environment;
  final List<String>? additionalArgs;

  /// Enable MCP (Model Context Protocol) support.
  /// When true and an API key is provided, the chat will use the global
  /// CLAUDE_HOME configuration instead of creating an isolated one.
  /// This allows access to globally configured MCP servers.
  final bool? enableMcp;

  const ClaudeChatOptions({
    this.maxTurns,
    this.allowedTools,
    this.disallowedTools,
    this.permissionMode,
    this.resumeSessionId,
    this.environment,
    this.additionalArgs,
    this.enableMcp,
    super.systemPrompt,
    super.model,
    super.cwd,
  });

  List<String> toCliArgs() {
    final args = <String>[];

    if (systemPrompt != null && systemPrompt!.isNotEmpty) {
      args.addAll(['--append-system-prompt', systemPrompt!]);
    }

    if (maxTurns != null) {
      args.addAll(['--max-turns', maxTurns.toString()]);
    }

    if (allowedTools != null && allowedTools!.isNotEmpty) {
      args.addAll(['--allowedTools', allowedTools!.join(',')]);
    }

    if (disallowedTools != null && disallowedTools!.isNotEmpty) {
      args.addAll(['--disallowedTools', disallowedTools!.join(',')]);
    }

    if (permissionMode != null && permissionMode!.isNotEmpty) {
      args.addAll(['--permission-mode', permissionMode!]);
    }

    if (model != null && model!.isNotEmpty) {
      args.addAll(['--model', model!]);
    }

    if (additionalArgs != null && additionalArgs!.isNotEmpty) {
      args.addAll(additionalArgs!);
    }

    return args;
  }

  ClaudeChatOptions copyWith({
    int? maxTurns,
    List<String>? allowedTools,
    List<String>? disallowedTools,
    String? permissionMode,
    String? resumeSessionId,
    Map<String, String>? environment,
    List<String>? additionalArgs,
    bool? enableMcp,
    String? systemPrompt,
    String? model,
    String? cwd,
  }) {
    return ClaudeChatOptions(
      maxTurns: maxTurns ?? this.maxTurns,
      allowedTools: allowedTools ?? this.allowedTools,
      disallowedTools: disallowedTools ?? this.disallowedTools,
      permissionMode: permissionMode ?? this.permissionMode,
      resumeSessionId: resumeSessionId ?? this.resumeSessionId,
      environment: environment ?? this.environment,
      additionalArgs: additionalArgs ?? this.additionalArgs,
      enableMcp: enableMcp ?? this.enableMcp,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      model: model ?? this.model,
      cwd: cwd ?? this.cwd,
    );
  }
}
