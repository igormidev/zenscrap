import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Custom Riverpod observer that logs provider lifecycle events using Talker.
///
/// In Riverpod 3.0, ProviderObserver methods receive a single [ProviderObserverContext]
/// instead of separate container/provider parameters.
base class CustomTalkerRiverpodObserver extends ProviderObserver {
  final Talker talker;
  final int maxStateLength;

  CustomTalkerRiverpodObserver({
    required this.talker,
    this.maxStateLength = 500,
  });

  String _truncateState(Object? state) {
    final stateStr = state.toString();
    if (stateStr.length <= maxStateLength) {
      return stateStr;
    }
    return '${stateStr.substring(0, maxStateLength)}... (truncated)';
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    talker.debug(
      'Provider added: ${context.provider.name ?? context.provider.runtimeType}\n'
      'Value: ${_truncateState(value)}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    talker.debug(
      'Provider updated: ${context.provider.name ?? context.provider.runtimeType}\n'
      'Old: ${_truncateState(previousValue)}\n'
      'New: ${_truncateState(newValue)}',
    );
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    talker.debug(
      'Provider disposed: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    talker.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}\n'
      'Error: $error',
      error,
      stackTrace,
    );
  }
}