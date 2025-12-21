import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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
  GoogleAuthController? _googleAuthController;

  // Server Client ID from Google Cloud Console (Web application credentials)
  // This should match the client_id in google_client_secret.json on the server
  // Configure via environment variable: --dart-define=GOOGLE_SERVER_CLIENT_ID=your-client-id
  static const String _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  // Check if Google Sign-In is configured
  bool get _isConfigured => _googleServerClientId.isNotEmpty;

  @override
  void dispose() {
    _googleAuthController?.dispose();
    super.dispose();
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.auth_or_divider,
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
          // Minimum 48px height for mobile touch target
          height: context.responsiveValue(
            compact: 52.0,
            expanded: 48.0,
          ),
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

                      // Create GoogleAuthController for the new IDP system
                      _googleAuthController?.dispose();
                      _googleAuthController = GoogleAuthController(
                        client: client,
                        onAuthenticated: () {
                          // Authentication successful - handle in the callback
                        },
                        onError: (error) {
                          // Error handled below
                        },
                        attemptLightweightSignIn: true,
                        scopes: const [
                          'https://www.googleapis.com/auth/userinfo.email',
                          'https://www.googleapis.com/auth/userinfo.profile',
                        ],
                      );

                      // Attempt Google sign-in
                      await _googleAuthController!.signIn();

                      // Small delay to allow the async state update to propagate
                      // The GoogleAuthController updates state asynchronously after signIn()
                      await Future.delayed(const Duration(milliseconds: 50));

                      // Check the controller's isAuthenticated property (not client.auth.isAuthenticated)
                      // This is updated by the GoogleAuthController after signIn() completes
                      final isAuthenticated = _googleAuthController!.isAuthenticated;

                      if (!isAuthenticated) {
                        // Check if there was an error or if user cancelled
                        final errorMsg = _googleAuthController!.errorMessage;
                        if (errorMsg != null) {
                          // Track Google sign-in failure with error message
                          await analytics.trackEvent(
                            eventName: 'auth_google_failure',
                            properties: {'error': errorMsg},
                          );

                          if (context.mounted) {
                            showErrorSnackbar(
                              context,
                              l10n.auth_google_sign_in_failed,
                            );
                          }
                        } else {
                          // User likely cancelled the sign-in flow
                          await analytics.trackEvent(
                            eventName: 'auth_google_cancelled',
                          );
                        }
                        return;
                      }

                      // Fetch real user profile from the server
                      final userProfileResponse =
                          await client.userProfile.getCurrentUserProfile();

                      // Track successful Google sign-in with real user info
                      await analytics.trackEvent(
                        eventName: 'auth_google_success',
                        properties: {
                          'email': userProfileResponse.email ?? 'unknown',
                          'user_name': userProfileResponse.userName ??
                              userProfileResponse.fullName ??
                              'Google User',
                        },
                      );

                      // Update session state with real user profile
                      if (context.mounted) {
                        ref.read(sessionProvider.notifier).setState(
                              SessionState.logged(
                                user: UserModel(
                                  email: userProfileResponse.email ??
                                      'google_user@google.com',
                                  userName: userProfileResponse.userName ??
                                      userProfileResponse.fullName ??
                                      'Google User',
                                  imageUrl: userProfileResponse.imageUrl,
                                ),
                              ),
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
                          l10n.auth_google_sign_in_failed,
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
            label: Text(
              _isLoading ? l10n.auth_signing_in : l10n.auth_continue_with_google,
              style: context.responsiveValue(
                compact: Theme.of(context).textTheme.titleSmall,
                expanded: null, // Use default
              ),
            ),
            style: OutlinedButton.styleFrom(
              // Responsive padding for proper touch target
              padding: context.responsiveValue(
                compact: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                expanded: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.auth_google_sign_in_description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
