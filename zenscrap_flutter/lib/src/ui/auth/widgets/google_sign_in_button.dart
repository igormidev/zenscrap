import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/auth_error_mapper.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/auth_error_dialog.dart';

/// Google Sign-In button that handles both login and account creation.
/// If the user has an account, it logs them in. If not, it creates an account.
/// This provides a unified authentication flow with Google.
///
/// Uses Serverpod's GoogleSignInWidget which properly handles:
/// - Native platforms (iOS, Android, macOS): uses GoogleSignInNativeButton
/// - Web platform: uses GoogleSignInWebButton (Google's iframe-based button)
class ZenScrapGoogleSignInButton extends ConsumerStatefulWidget {
  const ZenScrapGoogleSignInButton({super.key});

  @override
  ConsumerState<ZenScrapGoogleSignInButton> createState() =>
      _ZenScrapGoogleSignInButtonState();
}

class _ZenScrapGoogleSignInButtonState
    extends ConsumerState<ZenScrapGoogleSignInButton> {
  GoogleAuthController? _googleAuthController;

  // Server Client ID from Google Cloud Console (Web application credentials)
  // This should match the client_id in google_client_secret.json on the server
  // Configure via environment variable: --dart-define=GOOGLE_SERVER_CLIENT_ID=your-client-id
  // For web, the client ID is also set in web/index.html meta tag
  static const String _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  // Check if Google Sign-In is configured
  // On web, configuration comes from index.html meta tag, so we always show
  // On native, we need the environment variable
  bool get _isConfigured => kIsWeb || _googleServerClientId.isNotEmpty;

  @override
  void dispose() {
    _googleAuthController?.dispose();
    super.dispose();
  }

  Future<void> _handleAuthenticationSuccess() async {
    final client = ref.read(clientProvider);
    final analytics = ref.read(analyticsServiceProvider);

    try {
      // Fetch real user profile from the server
      final userProfileResponse = await client.userProfile
          .getCurrentUserProfile();

      // Track successful Google sign-in with real user info
      await analytics.trackEvent(
        eventName: 'auth_google_success',
        properties: {
          'email': userProfileResponse.email ?? 'unknown',
          'user_name':
              userProfileResponse.userName ??
              userProfileResponse.fullName ??
              'Google User',
        },
      );

      // Update session state with real user profile
      if (mounted) {
        ref
            .read(sessionProvider.notifier)
            .setState(
              SessionState.logged(
                user: UserModel(
                  email: userProfileResponse.email ?? 'google_user@google.com',
                  userName:
                      userProfileResponse.userName ??
                      userProfileResponse.fullName ??
                      'Google User',
                  imageUrl: userProfileResponse.imageUrl,
                ),
              ),
            );
      }
    } catch (e) {
      debugPrint('[GoogleSignIn] Error fetching user profile: $e');
      // Even if profile fetch fails, user is authenticated
      // The session sync provider will handle this
    }
  }

  Future<void> _handleAuthenticationError(Object error) async {
    final analytics = ref.read(analyticsServiceProvider);

    // Track Google sign-in failure
    await analytics.trackEvent(
      eventName: 'auth_google_failure',
      properties: {'error': error.toString()},
    );

    if (mounted) {
      // Map the exception and show beautiful error dialog
      final authError = AuthErrorMapper.mapError(
        error,
        context: AuthContext.googleSignIn,
      );
      await showAuthErrorDialog(context: context, error: authError);
    }
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
    final l10n = AppLocalizations.of(context)!;

    // Initialize controller once
    _googleAuthController ??= GoogleAuthController(
      client: client,
      onAuthenticated: _handleAuthenticationSuccess,
      onError: _handleAuthenticationError,
      // Attempt lightweight sign-in (FedCM on web, One Tap on Android)
      attemptLightweightSignIn: true,
      scopes: const [
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

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
        const SizedBox(height: 10),
        // Google Sign-In Widget from Serverpod
        // This widget properly handles web vs native platforms:
        // - On web: renders Google's iframe-based button (GoogleSignInWebButton)
        // - On native: renders a custom button that calls authenticate()
        // Google Sign-In Widget from Serverpod
        // Uses default wrapper which handles both web (iframe) and native properly
        GoogleSignInWidget(
          controller: _googleAuthController,
          // Button styling
          type: GSIButtonType.standard,
          theme: GSIButtonTheme.outline,
          size: GSIButtonSize.large,
          text: GSIButtonText.continueWith,
          shape: GSIButtonShape.pill,
          logoAlignment: GSIButtonLogoAlignment.left,
          minimumWidth: 280,
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
