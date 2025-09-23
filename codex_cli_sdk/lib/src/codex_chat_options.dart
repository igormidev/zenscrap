import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

/// Options for configuring a Codex chat session.
///
/// Only Codex specific flags that need to be passed to the CLI are handled here.
class CodexChatOptions extends CliChatOptions {
  /// Maximum number of turns in the conversation.
  final int? maxTurns;

  /// Operation mode ('suggest', 'auto-edit', 'full-auto').
  final String? mode;

  /// Profile to use from config.toml.
  final String? profile;

  /// Session ID to resume a previous conversation.
  final String? resumeSessionId;

  /// Custom environment variables.
  final Map<String, String>? environment;

  /// Whether to output in JSON format.
  final bool? outputJson;

  /// Whether to run in quiet mode (non-interactive with JSON output).
  final bool? quiet;

  /// Whether to continue the last session.
  final bool? continueLastSession;

  /// Whether to include MCP servers.
  final bool? enableMcp;

  /// Sandbox mode to run Codex under (e.g. 'workspace-write', 'danger-full-access').
  final String? sandboxMode;

  /// Approval policy for Codex actions (e.g. 'never', 'on-request').
  final String? approvalPolicy;

  /// List of allowed directories for file operations.
  final List<String>? allowedDirectories;

  /// Custom configuration file path.
  final String? configPath;

  /// Additional command line arguments passed verbatim to Codex CLI.
  final List<String>? additionalArgs;

  /// Reasoning effort level ('minimal', 'medium', 'high').
  /// Controls the depth of reasoning for the model.
  final String? reasoningEffort;

  const CodexChatOptions({
    this.maxTurns,
    this.mode,
    this.profile,
    this.resumeSessionId,
    this.environment,
    this.outputJson,
    this.quiet,
    this.continueLastSession,
    this.enableMcp,
    this.sandboxMode,
    this.approvalPolicy,
    this.allowedDirectories,
    this.configPath,
    this.additionalArgs,
    this.reasoningEffort,
    super.systemPrompt,
    super.model,
    super.cwd,
  });

  /// Converts the options into command line arguments that are handed to the Codex CLI.
  List<String> toCliArgs() {
    final args = <String>[];

    if (mode != null && mode?.toLowerCase() == 'full-auto') {
      args.add('--full-auto');
    }

    if (model != null && model!.isNotEmpty) {
      args.addAll(['--model', model!]);
    }

    if (reasoningEffort != null && reasoningEffort!.isNotEmpty) {
      args.addAll(['-c', 'reasoning_effort="${reasoningEffort!}"']);
    }

    if (profile != null && profile!.isNotEmpty) {
      args.addAll(['--profile', profile!]);
    }

    if (cwd != null && cwd!.isNotEmpty) {
      // Codex uses --cd instead of --cwd
      args.addAll(['--cd', cwd!]);
    }

    if (configPath != null && configPath!.isNotEmpty) {
      args.addAll(['--config', configPath!]);
    }

    if (maxTurns != null) {
      args.addAll(['-c', 'max_turns=$maxTurns']);
    }

    if (sandboxMode != null && sandboxMode!.isNotEmpty) {
      args.addAll(['--sandbox', sandboxMode!]);
    }

    if (approvalPolicy != null && approvalPolicy!.isNotEmpty) {
      args.addAll(['-c', 'approval_policy="${approvalPolicy!}"']);
    }

    if (allowedDirectories != null && allowedDirectories!.isNotEmpty) {
      for (final directory in allowedDirectories!) {
        if (directory.isEmpty) continue;
        args.addAll(['--allow-dir', directory]);
      }
    }

    if (additionalArgs != null && additionalArgs!.isNotEmpty) {
      args.addAll(additionalArgs!);
    }

    if (quiet == true) {
      args.add('--quiet');
    }

    if (outputJson == true) {
      args.add('--json');
    }

    return args;
  }

  /// Creates a copy of options with updated values.
  CodexChatOptions copyWith({
    int? maxTurns,
    String? mode,
    String? profile,
    String? resumeSessionId,
    Map<String, String>? environment,
    bool? outputJson,
    bool? quiet,
    bool? continueLastSession,
    bool? enableMcp,
    String? sandboxMode,
    String? approvalPolicy,
    List<String>? allowedDirectories,
    String? configPath,
    List<String>? additionalArgs,
    String? reasoningEffort,
    String? systemPrompt,
    String? model,
    String? cwd,
  }) {
    return CodexChatOptions(
      maxTurns: maxTurns ?? this.maxTurns,
      mode: mode ?? this.mode,
      profile: profile ?? this.profile,
      resumeSessionId: resumeSessionId ?? this.resumeSessionId,
      environment: environment ?? this.environment,
      outputJson: outputJson ?? this.outputJson,
      quiet: quiet ?? this.quiet,
      continueLastSession: continueLastSession ?? this.continueLastSession,
      enableMcp: enableMcp ?? this.enableMcp,
      sandboxMode: sandboxMode ?? this.sandboxMode,
      approvalPolicy: approvalPolicy ?? this.approvalPolicy,
      allowedDirectories: allowedDirectories ?? this.allowedDirectories,
      configPath: configPath ?? this.configPath,
      additionalArgs: additionalArgs ?? this.additionalArgs,
      reasoningEffort: reasoningEffort ?? this.reasoningEffort,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      model: model ?? this.model,
      cwd: cwd ?? this.cwd,
    );
  }
}
