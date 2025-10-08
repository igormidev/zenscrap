abstract class CliChatOptions {
  /// Max Timeout to run the cli
  final Duration timeout = const Duration(minutes: 30);

  /// System prompt to set the context for Codex
  final String? systemPrompt;

  /// Model to use (e.g., 'gpt-5', 'codex-mini-latest')
  final String? model;

  /// Working directory for file operations
  final String? cwd;

  const CliChatOptions({this.systemPrompt, this.model, this.cwd});
}
