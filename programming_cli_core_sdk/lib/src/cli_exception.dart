/// Base exception for all Codex SDK errors
class CliException implements Exception {
  final String message;
  final dynamic originalError;

  const CliException(this.message, [this.originalError]);

  @override
  String toString() => 'CliException: $message';
}
