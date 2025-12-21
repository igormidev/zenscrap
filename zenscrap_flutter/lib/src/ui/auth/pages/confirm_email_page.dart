import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
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
  const ConfirmEmailPage({
    super.key,
    required this.emailAuth,
    required this.email,
    required this.onSuccessChangePassword,
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
          if (password != null) {
            emailAuth.passwordController.text = password;
          }

          // Complete the registration
          // Note: finishRegistration() in Serverpod 3.x automatically authenticates
          // the user after successful registration.
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
      children: [
        Text(
          l10n.auth_check_email(email),
          style: context.t.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
