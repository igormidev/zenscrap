import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

/// Notifier for managing user session state.
/// Replaces StateProvider with the new Riverpod 3.0 Notifier pattern.
class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => SessionState.loading();

  void setState(SessionState newState) {
    state = newState;
  }
}

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
