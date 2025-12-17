/// Extension on Duration to provide formatting utilities.
extension DurationExtension on Duration {
  /// Formats the duration in a human-readable format.
  ///
  /// Examples:
  /// - 1.2s for durations >= 1 second
  /// - 450ms for durations < 1 second
  /// - 1m 30s for durations >= 1 minute
  String get formatted {
    if (inMinutes >= 1) {
      final minutes = inMinutes;
      final seconds = inSeconds.remainder(60);
      return '${minutes}m ${seconds}s';
    }
    if (inSeconds >= 1) {
      return '${(inMilliseconds / 1000).toStringAsFixed(1)}s';
    }
    return '${inMilliseconds}ms';
  }

  /// Short format for compact display (e.g., in badges).
  ///
  /// Examples:
  /// - 450ms for durations < 1 second
  /// - 1.2s for durations 1-59 seconds
  /// - 1m 30s for durations >= 1 minute
  /// - 1h 5m for durations >= 1 hour
  String get shortFormat {
    if (inHours >= 1) {
      final hours = inHours;
      final minutes = inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    }
    if (inMinutes >= 1) {
      final minutes = inMinutes;
      final seconds = inSeconds.remainder(60);
      return '${minutes}m ${seconds}s';
    }
    if (inSeconds >= 1) {
      return '${(inMilliseconds / 1000).toStringAsFixed(1)}s';
    }
    return '${inMilliseconds}ms';
  }
}
