/// Base exception class for Gemini SDK errors
class GeminiSDKException implements Exception {
  final String message;
  final Object? originalError;

  GeminiSDKException(this.message, [this.originalError]);

  @override
  String toString() {
    if (originalError != null) {
      return 'GeminiSDKException: $message\nOriginal error: $originalError';
    }
    return 'GeminiSDKException: $message';
  }
}

/// Exception thrown when Gemini CLI is not found
class CLINotFoundException extends GeminiSDKException {
  CLINotFoundException([String? message])
      : super(
          message ??
              'Gemini CLI not found. Please install it using:\n'
                  'npm install -g @google/gemini-cli\n'
                  'or\n'
                  'brew install gemini-cli',
        );
}

/// Exception thrown when there's a connection issue with the CLI
class CLIConnectionException extends GeminiSDKException {
  CLIConnectionException(super.message, [super.originalError]);
}

/// Exception thrown when a process execution fails
class ProcessException extends GeminiSDKException {
  final int? exitCode;
  final String? stderr;

  ProcessException(
    String message, {
    this.exitCode,
    this.stderr,
    Object? originalError,
  }) : super(message, originalError);

  @override
  String toString() {
    final buffer = StringBuffer('ProcessException: $message');
    if (exitCode != null) {
      buffer.write('\nExit code: $exitCode');
    }
    if (stderr != null && stderr!.isNotEmpty) {
      buffer.write('\nStderr: $stderr');
    }
    if (originalError != null) {
      buffer.write('\nOriginal error: $originalError');
    }
    return buffer.toString();
  }
}

/// Exception thrown when JSON decoding fails
class JSONDecodeException extends GeminiSDKException {
  final String rawContent;

  JSONDecodeException(String message, this.rawContent, [Object? originalError])
      : super(message, originalError);

  @override
  String toString() {
    return 'JSONDecodeException: $message\n'
        'Raw content: ${rawContent.length > 200 ? '${rawContent.substring(0, 200)}...' : rawContent}\n'
        '${originalError != null ? 'Original error: $originalError' : ''}';
  }
}

/// Exception thrown when JSON content fails schema validation
class SchemaValidationException extends GeminiSDKException {
  final List<String> issues;

  SchemaValidationException(
    String message,
    this.issues, [
    Object? originalError,
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
