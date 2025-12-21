import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/sign_in_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/auth_error_mapper.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/auth_error_dialog.dart';

class ConfirmEmailPage extends ConsumerWidget {
  final EmailAuthController emailAuth;
  final String email;
  final Future<void> Function() onSuccessChangePassword;
  final VoidCallback? onGoBack;
  const ConfirmEmailPage({
    super.key,
    required this.emailAuth,
    required this.email,
    required this.onSuccessChangePassword,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    // Track view when the email confirmation form is visible
    analytics.trackAuthEmailConfirmationViewed(email: email);

    return AuthFormTemplate<bool>(
      submitText: l10n.auth_confirm_email_button,
      items: [
        AuthFormItem(
          hintText: l10n.auth_validation_code_hint,
          labelText: l10n.auth_validation_code_label,
          validator: FormBuilderValidators.maxLength(8),
        ),
      ],
      onSubmitSuccess: (_) async {
        await onSuccessChangePassword();
      },
      onSubmit: (items) async {
        final verificationCode = items[0];

        // Set verification code on the controller
        emailAuth.verificationCodeController.text = verificationCode;

        try {
          // Verify the registration code
          await emailAuth.verifyRegistrationCode();

          // Set the password from the stored pending data
          final password = PendingRegistrationData.password;
          // DEBUG: Log password info for troubleshooting
          debugPrint(
            '[DEBUG] PendingRegistrationData.password is ${password == null ? "null" : "set (length: ${password.length})"}',
          );
          if (password != null) {
            emailAuth.passwordController.text = password;
            debugPrint(
              '[DEBUG] passwordController.text set to password with length: ${password.length}',
            );
          } else {
            debugPrint(
              '[DEBUG] WARNING: PendingRegistrationData.password is null! '
              'passwordController.text will be: "${emailAuth.passwordController.text}"',
            );
          }

          // Complete the registration
          // Note: finishRegistration() in Serverpod 3.x automatically authenticates
          // the user after successful registration.
          debugPrint(
            '[DEBUG] About to call finishRegistration() with password length: ${emailAuth.passwordController.text.length}',
          );
          await emailAuth.finishRegistration();

          // Clear the pending data
          PendingRegistrationData.clear();

          // Registration succeeded. However, we want the user to manually log in
          // with their new credentials rather than being auto-logged in.
          // Sign out immediately so the user can log in manually.
          // This provides a cleaner UX where the user confirms their credentials work.
          //
          // Note: We wrap signOutDevice() in its own try-catch because:
          // 1. The registration has already succeeded at this point
          // 2. signOutDevice() may throw if the session wasn't fully established yet
          //    (race condition between finishRegistration completing and session sync)
          // 3. We don't want a sign-out failure to show an error when registration worked
          final client = ref.read(clientProvider);
          try {
            await client.auth.signOutDevice();
          } catch (e) {
            // Ignore sign-out errors - registration already succeeded
            // The user will just be logged in, which is also fine
          }

          // IMPORTANT: Reset the EmailAuthController's screen state to login.
          // After finishRegistration(), the controller's currentScreen is in a
          // post-registration state. Even though signOutDevice() sets isAuthenticated
          // to false, the currentScreen is not automatically reset. This causes
          // subsequent login() calls to fail silently because the controller is
          // not in the expected login state.
          emailAuth.navigateTo(EmailFlowScreen.login);

          // Track successful email confirmation
          await analytics.trackAuthEmailConfirmationSuccess(email: email);

          // Return true to trigger onSubmitSuccess, which calls onSuccessConfirmEmail()
          // This will show a success dialog and switch to the Login tab.
          return true;
        } catch (e) {
          // Clear pending data on failure
          PendingRegistrationData.clear();

          if (context.mounted) {
            // Map the exception and show beautiful error dialog
            final authError = AuthErrorMapper.mapError(
              e,
              context: AuthContext.verification,
            );
            showAuthErrorDialog(context: context, error: authError);
          }
          return null;
        }
      },
      aboveChildren: [
        Text(
          l10n.auth_check_email(email),
          style: context.t.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onGoBack != null) ...[
          const SizedBox(height: 8),
          _ChangeEmailButton(onPressed: onGoBack!, l10n: l10n),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

/// A stylized button to go back and change email address.
class _ChangeEmailButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AppLocalizations l10n;

  const _ChangeEmailButton({
    required this.onPressed,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back_rounded,
        size: 18,
        color: colorScheme.primary,
      ),
      label: Text(
        l10n.auth_change_email,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: 200.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms, delay: 200.ms);
  }
}
