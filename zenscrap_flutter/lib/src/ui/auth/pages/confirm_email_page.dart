import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/auth/pages/sign_in_page.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

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
          final userName = PendingRegistrationData.userName;
          if (password != null) {
            emailAuth.passwordController.text = password;
          }

          // Complete the registration
          // Note: Do NOT check client.auth.isAuthenticated immediately after this call.
          // The auth state update is asynchronous and the onAuthenticated callback
          // will be triggered when authentication is complete.
          await emailAuth.finishRegistration();

          // Clear the pending data
          PendingRegistrationData.clear();

          // If finishRegistration() completes without throwing, registration succeeded.
          // The EmailAuthController's onAuthenticated callback will handle the auth state.
          // Update session state using the data we collected from the form.
          ref.read(sessionProvider.notifier).setState(
                SessionState.logged(
                  user: UserModel(
                    email: email,
                    userName: userName ?? 'User',
                    imageUrl: null,
                  ),
                ),
              );

          // Track successful email confirmation
          await analytics.trackAuthEmailConfirmationSuccess(email: email);

          return true;
        } catch (e) {
          // Clear pending data on failure
          PendingRegistrationData.clear();

          if (context.mounted) {
            showErrorSnackbar(context);
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
