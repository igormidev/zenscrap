import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';

final isGlobalLoadingProvider = StateProvider<bool>((ref) => false);

typedef GlobalLoadingFunction<T> = Future<T> Function(
    Future<T> Function() future);

extension GlobalLoadingWidgetRefExt on WidgetRef {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).state = true;
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).state = false;
    }
  }
}

extension GlobalLoadingProviderContainerExt on ProviderContainer {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).state = true;
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).state = false;
    }
  }
}

extension GlobalLoadingRefExt on Ref {
  Future<T> globalLoadingSetter<T>(Future<T> Function() future) async {
    read(isGlobalLoadingProvider.notifier).state = true;
    try {
      return await future();
    } catch (e, s) {
      logError(e, s);
      rethrow;
    } finally {
      read(isGlobalLoadingProvider.notifier).state = false;
    }
  }
}
