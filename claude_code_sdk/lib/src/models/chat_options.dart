/// Options for configuring a Claude chat session
class ClaudeChatOptions {
  /// System prompt to set the context for Claude
  final String? systemPrompt;

  /// Maximum number of turns in the conversation
  final int? maxTurns;

  /// List of allowed tools that Claude can use
  final List<String>? allowedTools;

  /// List of disallowed tools that Claude cannot use
  final List<String>? disallowedTools;

  /// Permission mode for file operations
  final String? permissionMode;

  /// Working directory for file operations
  final String? cwd;

  /// Model to use (e.g., 'claude-3.5-sonnet')
  final String? model;

  /// Session ID to resume a previous conversation
  final String? resumeSessionId;

  /// Custom environment variables
  final Map<String, String>? environment;

  /// Timeout for the session in milliseconds (default: 60000ms = 60 seconds)
  final int? timeoutMs;

  const ClaudeChatOptions({
    this.systemPrompt,
    this.maxTurns,
    this.allowedTools,
    this.disallowedTools,
    this.permissionMode,
    this.cwd,
    this.model,
    this.resumeSessionId,
    this.environment,
    this.timeoutMs = 60000, // Default 60 second timeout
  });

  /// Converts options to command line arguments
  List<String> toCliArgs() {
    final args = <String>[];

    if (systemPrompt != null) {
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

    if (permissionMode != null) {
      args.addAll(['--permission-mode', permissionMode!]);
    }

    if (cwd != null) {
      args.addAll(['--cwd', cwd!]);
    }

    if (model != null) {
      args.addAll(['--model', model!]);
    }

    // Note: resumeSessionId is handled separately in ClaudeChat
    // since it's added dynamically based on conversation state
    
    return args;
  }

  /// Creates a copy of options with updated values
  ClaudeChatOptions copyWith({
    String? systemPrompt,
    int? maxTurns,
    List<String>? allowedTools,
    List<String>? disallowedTools,
    String? permissionMode,
    String? cwd,
    String? model,
    String? resumeSessionId,
    Map<String, String>? environment,
    int? timeoutMs,
  }) {
    return ClaudeChatOptions(
      systemPrompt: systemPrompt ?? this.systemPrompt,
      maxTurns: maxTurns ?? this.maxTurns,
      allowedTools: allowedTools ?? this.allowedTools,
      disallowedTools: disallowedTools ?? this.disallowedTools,
      permissionMode: permissionMode ?? this.permissionMode,
      cwd: cwd ?? this.cwd,
      model: model ?? this.model,
      resumeSessionId: resumeSessionId ?? this.resumeSessionId,
      environment: environment ?? this.environment,
      timeoutMs: timeoutMs ?? this.timeoutMs,
    );
  }
}