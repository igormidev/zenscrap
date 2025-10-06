/// Determines how the CLI should authenticate
enum RunType {
  /// Use logged-in account credentials (from CLI login)
  withLoggedInAccountCredits,

  /// Use API key provided programmatically
  withApiKey,
}

abstract class CliChatOptions {
  /// Max Timeout to run the cli
  final Duration timeout = const Duration(minutes: 30);

  /// System prompt to set the context for Codex
  final String? systemPrompt;

  /// Model to use (e.g., 'gpt-5', 'codex-mini-latest')
  final String? model;

  /// Working directory for file operations
  final String? cwd;

  /// How the CLI should authenticate. If null, will default based on whether API key was provided.
  /// If API key was provided in constructor, defaults to withApiKey.
  /// If no API key was provided, defaults to withLoggedInAccountCredits.
  final RunType? runType;

  const CliChatOptions({
    this.systemPrompt,
    this.model,
    this.cwd,
    this.runType,
  });
}
