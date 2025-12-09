import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';

/// Notifier for managing global loading state.
/// Replaces StateProvider with the new Riverpod 3.0 Notifier pattern.
class IsGlobalLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

final isGlobalLoadingProvider =
    NotifierProvider<IsGlobalLoadingNotifier, bool>(IsGlobalLoadingNotifier.new);

typedef GlobalLoadingFunction<T> = Future<T> Function(
    Future<T> Function() future);

extension GlobalLoadingWidgetRefExt on WidgetRef {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).setLoading(true);
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).setLoading(false);
    }
  }
}

extension GlobalLoadingProviderContainerExt on ProviderContainer {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).setLoading(true);
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).setLoading(false);
    }
  }
}

extension GlobalLoadingRefExt on Ref {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).setLoading(true);
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).setLoading(false);
    }
  }
}
