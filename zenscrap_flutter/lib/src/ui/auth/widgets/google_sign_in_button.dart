import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart' show localhost;
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';

/// Google Sign-In button that handles both login and account creation.
/// If the user has an account, it logs them in. If not, it creates an account.
/// This provides a unified authentication flow with Google.
class ZenScrapGoogleSignInButton extends ConsumerStatefulWidget {
  const ZenScrapGoogleSignInButton({super.key});

  @override
  ConsumerState<ZenScrapGoogleSignInButton> createState() =>
      _ZenScrapGoogleSignInButtonState();
}

class _ZenScrapGoogleSignInButtonState
    extends ConsumerState<ZenScrapGoogleSignInButton> {
  bool _isLoading = false;

  // Server Client ID from Google Cloud Console (Web application credentials)
  // This should match the client_id in google_client_secret.json on the server
  // Configure via environment variable: --dart-define=GOOGLE_SERVER_CLIENT_ID=your-client-id
  static const String _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  // Check if Google Sign-In is configured
  bool get _isConfigured => _googleServerClientId.isNotEmpty;

  // Redirect URI for web - must be registered in Google Cloud Console
  Uri get _redirectUri {
    if (kDebugMode) {
      return Uri.parse('http://$localhost:8082/googlesignin');
    }
    return Uri.parse('https://api.zenscrap.com/googlesignin');
  }

  @override
  Widget build(BuildContext context) {
    // Don't show if not configured
    if (!_isConfigured) {
      // In debug mode, show a hint about configuration
      if (kDebugMode) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Google Sign-In not configured. Set GOOGLE_SERVER_CLIENT_ID environment variable.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        );
      }
      return const SizedBox.shrink();
    }

    final client = ref.watch(clientProvider);
    final analytics = ref.read(analyticsServiceProvider);

    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        // Google Sign-In Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    try {
                      // Track Google sign-in attempt
                      await analytics.trackEvent(
                        eventName: 'auth_google_attempt',
                      );

                      // Use the signInWithGoogle function from serverpod_auth_google_flutter
                      final sessionManager = ref.read(sessionManagerProvider);
                      final userInfo = await signInWithGoogle(
                        client.modules.auth,
                        serverClientId: _googleServerClientId,
                        redirectUri: _redirectUri,
                      );

                      if (userInfo != null) {
                        // Track successful Google sign-in
                        await analytics.trackEvent(
                          eventName: 'auth_google_success',
                          properties: {
                            'email': userInfo.email ?? 'unknown',
                            'user_name': userInfo.userName ?? 'unknown',
                          },
                        );

                        // Refresh session manager to get the new session
                        await sessionManager.initialize();

                        // Update session state
                        if (context.mounted) {
                          ref.read(sessionProvider.notifier).setState(
                                SessionState.logged(
                                  user: UserModel(
                                    email: userInfo.email ?? '',
                                    userName: userInfo.userName ?? 'User',
                                    imageUrl: userInfo.imageUrl,
                                  ),
                                ),
                              );
                        }
                      } else {
                        // Track cancelled/failed Google sign-in
                        await analytics.trackEvent(
                          eventName: 'auth_google_cancelled',
                        );
                      }
                    } catch (e) {
                      // Track Google sign-in failure
                      await analytics.trackEvent(
                        eventName: 'auth_google_failure',
                        properties: {'error': e.toString()},
                      );

                      if (context.mounted) {
                        showErrorSnackbar(
                          context,
                          'Google sign-in failed. Please try again or use email.',
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Image.network(
                    'https://www.google.com/favicon.ico',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.g_mobiledata, size: 20),
                  ),
            label: Text(_isLoading ? 'Signing in...' : 'Continue with Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in or create an account with Google',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
