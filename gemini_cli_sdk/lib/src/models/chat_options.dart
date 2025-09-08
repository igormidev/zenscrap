/// Configuration options for a Gemini chat session
class GeminiChatOptions {
  /// The model to use (e.g., 'gemini-2.5-flash', 'gemini-2.5-pro')
  final String? model;

  /// System prompt to set context for the conversation
  /// This complements (not overrides) Gemini's default system prompt
  final String? systemPrompt;

  /// Whether to repeat the system prompt in every message
  /// If false (default), the system prompt is only included in the first message
  final bool repeatSystemPrompt;

  /// Maximum number of conversation turns
  final int? maxTurns;

  /// Allowed tools for the model to use
  final List<String>? allowedTools;

  /// Permission mode for tool usage ('allow', 'deny', 'acceptEdits')
  final String? permissionMode;

  /// Working directory for file operations
  final String? cwd;

  /// Whether to output JSON format
  final bool outputJson;

  /// Whether to stream JSON responses
  final bool streamJson;

  /// Timeout in milliseconds for commands
  final int? timeoutMs;

  /// Whether to include directory contents in context
  final bool includeDirectories;

  /// List of directories to include in context
  final List<String>? directories;

  /// Whether to run in non-interactive mode
  final bool nonInteractive;

  const GeminiChatOptions({
    this.model,
    this.systemPrompt,
    this.repeatSystemPrompt = false,
    this.maxTurns,
    this.allowedTools,
    this.permissionMode,
    this.cwd,
    this.outputJson = false,
    this.streamJson = false,
    this.timeoutMs,
    this.includeDirectories = false,
    this.directories,
    this.nonInteractive = true,
  });

  /// Creates a copy with some fields replaced
  GeminiChatOptions copyWith({
    String? model,
    String? systemPrompt,
    bool? repeatSystemPrompt,
    int? maxTurns,
    List<String>? allowedTools,
    String? permissionMode,
    String? cwd,
    bool? outputJson,
    bool? streamJson,
    int? timeoutMs,
    bool? includeDirectories,
    List<String>? directories,
    bool? nonInteractive,
  }) {
    return GeminiChatOptions(
      model: model ?? this.model,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      repeatSystemPrompt: repeatSystemPrompt ?? this.repeatSystemPrompt,
      maxTurns: maxTurns ?? this.maxTurns,
      allowedTools: allowedTools ?? this.allowedTools,
      permissionMode: permissionMode ?? this.permissionMode,
      cwd: cwd ?? this.cwd,
      outputJson: outputJson ?? this.outputJson,
      streamJson: streamJson ?? this.streamJson,
      timeoutMs: timeoutMs ?? this.timeoutMs,
      includeDirectories: includeDirectories ?? this.includeDirectories,
      directories: directories ?? this.directories,
      nonInteractive: nonInteractive ?? this.nonInteractive,
    );
  }

  /// Builds command line arguments from options
  List<String> buildArgs() {
    final args = <String>[];

    if (model != null) {
      args.addAll(['-m', model!]);
    }

    if (nonInteractive) {
      args.addAll(['-p']);
    }

    if (includeDirectories && directories != null) {
      for (final dir in directories!) {
        args.addAll(['--include-directories', dir]);
      }
    }

    return args;
  }
}