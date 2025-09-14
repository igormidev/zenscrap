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
  });

  /// Converts options to command line arguments
  List<String> toCliArgs() {
    final args = <String>[];

    // Mode selection
    if (mode != null) {
      switch (mode) {
        case 'suggest':
          args.add('--suggest');
          break;
        case 'auto-edit':
          args.add('--auto-edit');
          break;
        case 'full-auto':
          args.add('--full-auto');
          break;
      }
    }

    if (model != null) {
      args.addAll(['--model', model!]);
    }

    if (profile != null) {
      args.addAll(['--profile', profile!]);
    }

    if (cwd != null) {
      args.addAll(['--cwd', cwd!]);
    }

    if (quiet == true) {
      args.add('--quiet');
    }

    if (outputJson == true || quiet == true) {
      args.add('--json');
    }

    if (continueLastSession == true) {
      args.add('--continue');
    }

    if (resumeSessionId != null && continueLastSession != true) {
      args.add('--resume');
      // Note: The session ID selection might be interactive,
      // so we might need to handle this differently
    }

    if (configPath != null) {
      args.addAll(['--config', configPath!]);
    }

    if (maxTurns != null) {
      args.addAll(['-c', 'max_turns=$maxTurns']);
    }

    if (systemPrompt != null) {
      // Using the -c flag to override config temporarily
      args.addAll(['-c', 'system_prompt="${systemPrompt!}"']);
    }

    if (allowedDirectories != null && allowedDirectories!.isNotEmpty) {
      // This might need to be handled differently depending on Codex's actual syntax
      for (final dir in allowedDirectories!) {
        args.addAll(['--allow-dir', dir]);
      }
    }

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
    );
  }
}