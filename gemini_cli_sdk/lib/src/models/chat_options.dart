/// Configuration options for a Gemini chat session
class GeminiChatOptions {
  /// The model to use (e.g., 'gemini-2.5-flash', 'gemini-2.5-pro')
  /// Defaults to 'gemini-2.5-flash'
  final String model;

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

  /// Allowed MCP server names
  final List<String>? allowedMcpServerNames;

  /// Permission mode for tool usage ('allow', 'deny', 'acceptEdits')
  final String? permissionMode;

  /// Approval mode for tools ('default', 'auto_edit', 'yolo')
  final String? approvalMode;

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
    this.model = 'gemini-2.5-flash',
    this.systemPrompt,
    this.repeatSystemPrompt = false,
    this.maxTurns,
    this.allowedTools,
    this.allowedMcpServerNames,
    this.permissionMode,
    this.approvalMode,
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
    List<String>? allowedMcpServerNames,
    String? permissionMode,
    String? approvalMode,
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
      allowedMcpServerNames: allowedMcpServerNames ?? this.allowedMcpServerNames,
      permissionMode: permissionMode ?? this.permissionMode,
      approvalMode: approvalMode ?? this.approvalMode,
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

    args.addAll(['-m', model]);

    if (allowedTools != null && allowedTools!.isNotEmpty) {
      for (final tool in allowedTools!) {
        // Quote the tool if it contains special characters
        final quotedTool = tool.contains('*') ? '"$tool"' : tool;
        args.addAll(['--allowed-tools', quotedTool]);
      }
    }

    if (allowedMcpServerNames != null && allowedMcpServerNames!.isNotEmpty) {
      for (final server in allowedMcpServerNames!) {
        args.addAll(['--allowed-mcp-server-names', server]);
      }
    }

    if (approvalMode != null) {
      args.addAll(['--approval-mode', approvalMode!]);
    }

    if (includeDirectories && directories != null) {
      for (final dir in directories!) {
        args.addAll(['--include-directories', dir]);
      }
    }

    return args;
  }
}