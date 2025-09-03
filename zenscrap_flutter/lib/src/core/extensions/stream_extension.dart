extension LastValueFutureExtension<T> on Stream<T> {
  /// Waits for the stream to close and returns its last emitted value.
  /// If the stream has no events, this completes with a [StateError]
  /// (same behavior as `stream.last`).
  Future<T> toLastFuture() => last;

  /// Like [toLastFuture], but returns `null` if the stream emits nothing.
  Future<T?> toLastFutureOrNull() async {
    T? result;
    await for (final value in this) {
      result = value;
    }
    return result;
  }

  /// Like [toLastFuture], but lets you provide a default value if empty.
  Future<T> toLastFutureOr(T defaultValue) async {
    var hasValue = false;
    late T lastValue;
    await for (final value in this) {
      lastValue = value;
      hasValue = true;
    }
    return hasValue ? lastValue : defaultValue;
  }
}
