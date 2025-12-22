import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/auth_error_mapper.dart';

/// Shows a beautiful authentication error dialog.
///
/// This function displays a polished dialog with:
/// - An appropriate icon based on error type
/// - A clear title and description
/// - A styled action button
///
/// Use this instead of snackbars for auth errors to provide
/// better user experience and clearer error communication.
Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError error,
  VoidCallback? onDismiss,
}) async {
  final l10n = AppLocalizations.of(context)!;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AuthErrorDialog(
        error: error,
        l10n: l10n,
        onDismiss: () {
          Navigator.of(dialogContext).pop();
          onDismiss?.call();
        },
      );
    },
  );
}

/// A beautiful error dialog widget for authentication errors.
///
/// Features:
/// - Contextual icons based on error type
/// - Smooth animations
/// - Theme-aware colors
/// - Responsive sizing
/// - Clear, actionable messaging
class AuthErrorDialog extends StatelessWidget {
  final AuthError error;
  final AppLocalizations l10n;
  final VoidCallback onDismiss;

  const AuthErrorDialog({
    super.key,
    required this.error,
    required this.l10n,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Responsive sizing
    final dialogWidth = context.responsiveValue(
      compact: MediaQuery.of(context).size.width * 0.85,
      medium: 400.0,
      expanded: 420.0,
    );

    final iconSize = context.responsiveValue(
      compact: 56.0,
      expanded: 64.0,
    );

    final padding = context.responsiveValue(
      compact: 20.0,
      expanded: 28.0,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          minWidth: 280,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top section with icon
            _buildIconSection(context, colorScheme, iconSize, padding),

            // Content section
            _buildContentSection(context, colorScheme, padding),

            // Button section
            _buildButtonSection(context, colorScheme, padding),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSection(
    BuildContext context,
    ColorScheme colorScheme,
    double iconSize,
    double padding,
  ) {
    final iconData = _getIconForError(error.type);
    final iconColor = _getColorForError(error.type, colorScheme);
    final backgroundColor = iconColor.withValues(alpha: 0.12);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: padding + 8,
        left: padding,
        right: padding,
        bottom: padding / 2,
      ),
      child: Column(
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: iconSize + 24,
              height: iconSize + 24,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  iconData,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    ColorScheme colorScheme,
    double padding,
  ) {
    final title = error.getTitle(l10n);
    final description = error.getDescription(l10n);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding / 2,
      ),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: context.t.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: context.t.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    ColorScheme colorScheme,
    double padding,
  ) {
    final buttonText = error.getButtonText(l10n);
    final buttonColor = _getButtonColor(error.type, colorScheme);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: double.infinity,
        height: context.responsiveValue(
          compact: 52.0,
          expanded: 48.0,
        ),
        child: FilledButton(
          onPressed: onDismiss,
          style: FilledButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            buttonText,
            style: context.t.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForError(AuthErrorType type) {
    switch (type) {
      // Login/credential errors
      case AuthErrorType.invalidCredentials:
      case AuthErrorType.accountNotFound:
        return Icons.lock_outline_rounded;
      case AuthErrorType.accountDisabled:
      case AuthErrorType.accountLocked:
        return Icons.block_rounded;

      // Registration errors
      case AuthErrorType.emailAlreadyExists:
        return Icons.email_outlined;
      case AuthErrorType.invalidVerificationCode:
      case AuthErrorType.passwordResetCodeInvalid:
        return Icons.pin_outlined;
      case AuthErrorType.expiredVerificationCode:
      case AuthErrorType.passwordResetCodeExpired:
        return Icons.timer_off_outlined;
      case AuthErrorType.weakPassword:
        return Icons.password_rounded;
      case AuthErrorType.invalidEmailFormat:
        return Icons.alternate_email_rounded;

      // Rate limiting
      case AuthErrorType.tooManyAttempts:
      case AuthErrorType.loginRateLimited:
      case AuthErrorType.verificationRateLimited:
      case AuthErrorType.passwordResetRateLimited:
        return Icons.hourglass_top_rounded;

      // Google Sign-In errors
      case AuthErrorType.googleSignInCancelled:
        return Icons.cancel_outlined;
      case AuthErrorType.googleSignInFailed:
        return Icons.g_mobiledata_rounded;
      case AuthErrorType.googleAccountNotVerified:
        return Icons.verified_user_outlined;
      case AuthErrorType.googleAccountDomainRestricted:
        return Icons.domain_disabled_rounded;

      // Network/server errors
      case AuthErrorType.networkError:
      case AuthErrorType.connectionRefused:
        return Icons.wifi_off_rounded;
      case AuthErrorType.serverError:
        return Icons.cloud_off_rounded;
      case AuthErrorType.timeout:
        return Icons.schedule_rounded;

      // Unknown
      case AuthErrorType.unknown:
        return Icons.error_outline_rounded;
    }
  }

  Color _getColorForError(AuthErrorType type, ColorScheme colorScheme) {
    switch (type) {
      // User-correctable errors - use warning/error color
      case AuthErrorType.invalidCredentials:
      case AuthErrorType.accountNotFound:
      case AuthErrorType.invalidVerificationCode:
      case AuthErrorType.passwordResetCodeInvalid:
      case AuthErrorType.weakPassword:
      case AuthErrorType.invalidEmailFormat:
        return colorScheme.error;

      // Account issues - more serious, use error
      case AuthErrorType.accountDisabled:
      case AuthErrorType.accountLocked:
      case AuthErrorType.emailAlreadyExists:
        return colorScheme.error;

      // Time-related issues - use orange/amber
      case AuthErrorType.expiredVerificationCode:
      case AuthErrorType.passwordResetCodeExpired:
      case AuthErrorType.timeout:
        return Colors.orange.shade700;

      // Rate limiting - use amber to indicate temporary
      case AuthErrorType.tooManyAttempts:
      case AuthErrorType.loginRateLimited:
      case AuthErrorType.verificationRateLimited:
      case AuthErrorType.passwordResetRateLimited:
        return Colors.amber.shade700;

      // Google-specific - use Google's colors or neutral
      case AuthErrorType.googleSignInCancelled:
        return colorScheme.outline;
      case AuthErrorType.googleSignInFailed:
      case AuthErrorType.googleAccountNotVerified:
      case AuthErrorType.googleAccountDomainRestricted:
        return colorScheme.error;

      // Network/server - use a distinct color
      case AuthErrorType.networkError:
      case AuthErrorType.connectionRefused:
      case AuthErrorType.serverError:
        return Colors.blueGrey.shade600;

      // Unknown - neutral error color
      case AuthErrorType.unknown:
        return colorScheme.error;
    }
  }

  Color _getButtonColor(AuthErrorType type, ColorScheme colorScheme) {
    // For cancelled actions, use a less prominent color
    if (type == AuthErrorType.googleSignInCancelled) {
      return colorScheme.primary;
    }

    // For server/network errors, use primary color (not user's fault)
    if (type == AuthErrorType.networkError ||
        type == AuthErrorType.connectionRefused ||
        type == AuthErrorType.serverError ||
        type == AuthErrorType.timeout) {
      return colorScheme.primary;
    }

    // For user-correctable errors, use primary
    return colorScheme.primary;
  }
}

/// Extension to easily show auth error dialogs from anywhere.
extension AuthErrorDialogExtension on BuildContext {
  /// Shows an auth error dialog for the given error.
  Future<void> showAuthError(AuthError error, {VoidCallback? onDismiss}) {
    return showAuthErrorDialog(
      context: this,
      error: error,
      onDismiss: onDismiss,
    );
  }

  /// Shows an auth error dialog by mapping a raw error.
  Future<void> showMappedAuthError(
    dynamic error, {
    AuthContext? authContext,
    VoidCallback? onDismiss,
  }) {
    final mappedError = AuthErrorMapper.mapError(error, context: authContext);
    return showAuthError(mappedError, onDismiss: onDismiss);
  }
}
