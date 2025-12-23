import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

/// Provider that syncs Serverpod's auth state with the app's session provider.
///
/// This provider listens to `client.auth.authInfoListenable` for reactive auth
/// state updates. When auth state changes (e.g., token expiration or sign-out
/// from another device), it automatically updates the [sessionProvider].
///
/// The provider should be initialized early in the app lifecycle by watching
/// it in a top-level widget (e.g., [MyApp]).
final authStateSyncProvider = Provider<AuthStateSync>((ref) {
  final client = ref.watch(clientProvider);
  final authInfoListenable = client.auth.authInfoListenable;

  // Create the sync instance
  final authStateSync = AuthStateSync(
    authInfoListenable: authInfoListenable,
    onAuthStateChanged: (isAuthenticated) {
      // Only handle sign-out events - sign-in is handled by login pages
      // to preserve user profile information from the login flow
      if (!isAuthenticated) {
        final currentState = ref.read(sessionProvider);

        // Only update if we were previously logged in
        // This prevents unnecessary state changes during app initialization
        currentState.mapOrNull(
          logged: (_) {
            talker.info('Auth state sync: User signed out externally');
            ref.read(sessionProvider.notifier).setState(
                  SessionState.notSignedIn(),
                );
          },
        );
      }
    },
  );

  // Clean up when the provider is disposed
  ref.onDispose(() {
    authStateSync.dispose();
  });

  return authStateSync;
});

/// Manages synchronization between Serverpod's auth state and the app's session.
///
/// This class listens to a [ValueListenable] for auth info changes and
/// invokes the [onAuthStateChanged] callback when authentication status changes.
class AuthStateSync {
  AuthStateSync({
    required this.authInfoListenable,
    required this.onAuthStateChanged,
  }) {
    // Add listener to track auth state changes
    authInfoListenable.addListener(_onAuthInfoChanged);
    talker.info('AuthStateSync: Started listening to auth state changes');
  }

  /// The Serverpod auth info listenable to monitor.
  final ValueListenable<dynamic> authInfoListenable;

  /// Callback invoked when auth state changes.
  /// [isAuthenticated] is true if the user is authenticated, false otherwise.
  final void Function(bool isAuthenticated) onAuthStateChanged;

  /// Tracks the last known authentication state to detect changes.
  bool? _lastAuthState;

  void _onAuthInfoChanged() {
    // authInfoListenable.value is AuthSuccess? - non-null means authenticated
    final isAuthenticated = authInfoListenable.value != null;

    // Only trigger callback if the auth state actually changed
    if (_lastAuthState != isAuthenticated) {
      talker.info(
        'AuthStateSync: Auth state changed from $_lastAuthState to $isAuthenticated',
      );
      _lastAuthState = isAuthenticated;
      onAuthStateChanged(isAuthenticated);
    }
  }

  /// Cleans up the listener when no longer needed.
  void dispose() {
    authInfoListenable.removeListener(_onAuthInfoChanged);
    talker.info('AuthStateSync: Stopped listening to auth state changes');
  }
}
