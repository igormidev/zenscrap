import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

final sessionProvider = StateProvider<SessionState>((ref) {
  return SessionState.loading();
});
