/// Options for configuring a Codex chat session
class CodexChatOptions {
  /// System prompt to set the context for Codex
  final String? systemPrompt;

  /// Maximum number of turns in the conversation
  final int? maxTurns;

  /// Model to use (e.g., 'gpt-5', 'codex-mini-latest')
  final String? model;

  /// Operation mode ('suggest', 'auto-edit', 'full-auto')
  final String? mode;

  /// Working directory for file operations
  final String? cwd;

  /// Profile to use from config.toml
  final String? profile;

  /// Session ID to resume a previous conversation
  final String? resumeSessionId;

  /// Custom environment variables
  final Map<String, String>? environment;

  /// Timeout for the session in milliseconds (default: 60000ms = 60 seconds)
  final int? timeoutMs;

  /// Whether to output in JSON format
  final bool? outputJson;

  /// Whether to run in quiet mode (non-interactive with JSON output)
  final bool? quiet;

  /// Whether to continue the last session
  final bool? continueLastSession;

  /// Whether to include MCP servers
  final bool? enableMcp;

  /// List of allowed directories for file operations
  final List<String>? allowedDirectories;

  /// Custom configuration file path
  final String? configPath;

  /// Reasoning effort level ('minimal', 'medium', 'high')
  /// Controls the depth of reasoning for the model
  final String? reasoningEffort;

  /// Sandbox mode for controlling access permissions
  /// Options: 'read-only', 'workspace-write', 'danger-full-access'
  /// - 'read-only': Can only read files, no write or network access
  /// - 'workspace-write': Can read/write files in workspace, no network access (default)
  /// - 'danger-full-access': Full access including network, file system, and shell commands
  final String? sandbox;

  const CodexChatOptions({
    this.systemPrompt,
    this.maxTurns,
    this.model,
    this.mode,
    this.cwd,
    this.profile,
    this.resumeSessionId,
    this.environment,
    this.timeoutMs = 60000,
    this.outputJson,
    this.quiet,
    this.continueLastSession,
    this.enableMcp,
    this.allowedDirectories,
    this.configPath,
    this.reasoningEffort,
    this.sandbox,
  });

  /// Converts options to command line arguments
  List<String> toCliArgs() {
    final args = <String>[];

    // Mode selection - only full-auto is supported by Codex CLI
    if (mode != null && mode == 'full-auto') {
      args.add('--full-auto');
    } else {
      // Use provided sandbox mode or default to workspace-write
      final sandboxMode = sandbox ?? 'workspace-write';
      args.addAll(['--sandbox', sandboxMode]);
    }

    if (model != null) {
      args.addAll(['-m', model!]);
    }

    // Note: Codex CLI doesn't support --reasoning-effort flag
    // We can pass it as a config override if needed
    if (reasoningEffort != null) {
      // Use -c flag to override configuration
      args.addAll(['-c', 'reasoning_effort="$reasoningEffort"']);
    }

    if (profile != null) {
      args.addAll(['--profile', profile!]);
    }

    if (cwd != null) {
      // Codex uses -C for working directory
      args.addAll(['-C', cwd!]);
    }

    // Note: Codex exec doesn't support --quiet, --json, --continue, or --resume flags
    // These features would need to be handled differently or removed

    // Note: Codex uses -c for configuration overrides, not file paths
    // The config file is loaded from ~/.codex/config.toml automatically
    if (configPath != null) {
      // This would need special handling - Codex doesn't support custom config paths
      // We'll skip this for now
    }

    if (maxTurns != null) {
      args.addAll(['-c', 'max_turns=$maxTurns']);
    }

    // Note: System prompts can be very long and may cause issues with command line length limits
    // Consider including them in the user message instead
    if (systemPrompt != null && systemPrompt!.length < 500) {
      // Only add short system prompts via -c flag
      final escapedPrompt = systemPrompt!.replaceAll('"', '\\"').replaceAll('\n', '\\n');
      args.addAll(['-c', 'system_prompt="$escapedPrompt"']);
    }

    // Note: Codex exec doesn't support --allow-dir flag
    // Directory permissions would need to be handled through sandbox settings

    return args;
  }

  /// Creates a copy of options with updated values
  CodexChatOptions copyWith({
    String? systemPrompt,
    int? maxTurns,
    String? model,
    String? mode,
    String? cwd,
    String? profile,
    String? resumeSessionId,
    Map<String, String>? environment,
    int? timeoutMs,
    bool? outputJson,
    bool? quiet,
    bool? continueLastSession,
    bool? enableMcp,
    List<String>? allowedDirectories,
    String? configPath,
    String? reasoningEffort,
    String? sandbox,
  }) {
    return CodexChatOptions(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      maxTurns: maxTurns ?? this.maxTurns,
      model: model ?? this.model,
      mode: mode ?? this.mode,
      cwd: cwd ?? this.cwd,
      profile: profile ?? this.profile,
      resumeSessionId: resumeSessionId ?? this.resumeSessionId,
      environment: environment ?? this.environment,
      timeoutMs: timeoutMs ?? this.timeoutMs,
      outputJson: outputJson ?? this.outputJson,
      quiet: quiet ?? this.quiet,
      continueLastSession: continueLastSession ?? this.continueLastSession,
      enableMcp: enableMcp ?? this.enableMcp,
      allowedDirectories: allowedDirectories ?? this.allowedDirectories,
      configPath: configPath ?? this.configPath,
      reasoningEffort: reasoningEffort ?? this.reasoningEffort,
      sandbox: sandbox ?? this.sandbox,
    );
  }
}