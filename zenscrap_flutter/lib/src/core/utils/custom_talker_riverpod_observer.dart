import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CustomTalkerRiverpodObserver extends ProviderObserver {
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
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    talker.debug(
      'Provider added: ${provider.name ?? provider.runtimeType}\n'
      'Value: ${_truncateState(value)}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    talker.debug(
      'Provider updated: ${provider.name ?? provider.runtimeType}\n'
      'Old: ${_truncateState(previousValue)}\n'
      'New: ${_truncateState(newValue)}',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    talker.debug(
      'Provider disposed: ${provider.name ?? provider.runtimeType}',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    talker.error(
      'Provider failed: ${provider.name ?? provider.runtimeType}\n'
      'Error: $error',
      error,
      stackTrace,
    );
  }
}