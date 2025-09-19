/// Base exception for all Codex SDK errors
class CodexSDKException implements Exception {
  final String message;
  final dynamic originalError;

  const CodexSDKException(this.message, [this.originalError]);

  @override
  String toString() => 'CodexSDKException: $message';
}

/// Exception thrown when Codex CLI is not found
class CLINotFoundException extends CodexSDKException {
  const CLINotFoundException()
      : super(
            'Codex CLI not found. Please install it using npm install -g @openai/codex');
}

/// Exception thrown when there's a connection error with Codex CLI
class CLIConnectionException extends CodexSDKException {
  const CLIConnectionException(super.message, [super.originalError]);
}

/// Exception thrown when the Codex process fails
class ProcessException extends CodexSDKException {
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
class JSONDecodeException extends CodexSDKException {
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
class SchemaValidationException extends CodexSDKException {
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
