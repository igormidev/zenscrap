/// Extension on `List<Duration>` to provide utility methods for duration calculations.
extension DurationListExtension on List<Duration> {
  /// Calculates the average duration of all durations in the list.
  ///
  /// Returns [Duration.zero] if the list is empty.
  Duration get average {
    if (isEmpty) return Duration.zero;
    final totalMicroseconds = fold<int>(
      0,
      (sum, duration) => sum + duration.inMicroseconds,
    );
    return Duration(microseconds: totalMicroseconds ~/ length);
  }
}
