/// Base exception for all Claude SDK errors
class ClaudeSDKException implements Exception {
  final String message;
  final dynamic originalError;

  const ClaudeSDKException(this.message, [this.originalError]);

  @override
  String toString() => 'ClaudeSDKException: $message';
}

/// Exception thrown when Claude Code CLI is not found
class CLINotFoundException extends ClaudeSDKException {
  const CLINotFoundException()
      : super(
            'Claude Code CLI not found. Please install it using npm install -g @anthropic-ai/claude-code');
}

/// Exception thrown when there's a connection error with Claude Code CLI
class CLIConnectionException extends ClaudeSDKException {
  const CLIConnectionException(super.message, [super.originalError]);
}

/// Exception thrown when the Claude Code process fails
class ProcessException extends ClaudeSDKException {
  final int? exitCode;
  final String? stderr;

  const ProcessException(String message,
      {this.exitCode, this.stderr, dynamic originalError})
      : super(message, originalError);

  @override
  String toString() {
    final buffer = StringBuffer('ProcessException: $message');
    if (exitCode != null) buffer.write(' (exit code: $exitCode)');
    if (stderr != null && stderr!.isNotEmpty) {
      buffer.write('\nStderr: $stderr');
    }
    return buffer.toString();
  }
}

/// Exception thrown when JSON parsing fails
class JSONDecodeException extends ClaudeSDKException {
  final String rawContent;

  const JSONDecodeException(String message, this.rawContent, [dynamic originalError])
      : super(message, originalError);

  @override
  String toString() {
    return 'JSONDecodeException: $message\n'
        'Raw content: ${rawContent.length > 200 ? '${rawContent.substring(0, 200)}...' : rawContent}\n'
        '${originalError != null ? 'Original error: $originalError' : ''}';
  }
}

/// Exception thrown when JSON content fails schema validation
class SchemaValidationException extends ClaudeSDKException {
  final List<String> issues;

  const SchemaValidationException(
    String message,
    this.issues, [
    dynamic originalError,
  ]) : super(message, originalError);

  @override
  String toString() {
    final issuesDescription = issues.isEmpty
        ? ''
        : issues.map((issue) => '- $issue').join('\n');
    if (issuesDescription.isEmpty && originalError == null) {
      return 'SchemaValidationException: $message';
    }

    final buffer = StringBuffer('SchemaValidationException: $message');
    if (issuesDescription.isNotEmpty) {
      buffer.write('\n$issuesDescription');
    }
    if (originalError != null) {
      buffer.write('\nOriginal error: ${originalError.toString()}');
    }
    return buffer.toString();
  }
}
