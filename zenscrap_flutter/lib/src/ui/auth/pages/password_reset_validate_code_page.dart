import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/dialog_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/auth_error_mapper.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/auth_error_dialog.dart';

class PasswordResetValidateCodePage extends ConsumerWidget {
  final EmailAuthController emailAuth;
  final String email;
  final void Function() onSuccessChangePassword;
  const PasswordResetValidateCodePage({
    super.key,
    required this.emailAuth,
    required this.email,
    required this.onSuccessChangePassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    // Track view when the password reset validation form is visible
    analytics.trackAuthPasswordResetValidationViewed(email: email);

    return AuthFormTemplate<bool>(
      items: [
        AuthFormItem(
          hintText: l10n.auth_validation_code_label,
          labelText: l10n.auth_validation_code_label,
          autofillHints: AutofillHints.oneTimeCode,
          validator: FormBuilderValidators.maxLength(8),
        ),
        AuthFormItem(
          hintText: l10n.auth_new_password_hint,
          labelText: l10n.auth_new_password_label,
          autofillHints: AutofillHints.newPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
        AuthFormItem(
          hintText: l10n.auth_new_password_confirm_hint,
          labelText: l10n.auth_confirm_password_label,
          autofillHints: AutofillHints.newPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
      ],
      submitText: l10n.auth_validate_code_button,
      onSubmitSuccess: (data) async {
        await showSuccessDialog(
          context: context,
          title: l10n.auth_password_reset_success_title,
          message: l10n.auth_password_reset_success_message,
          onConfirm: () => onSuccessChangePassword(),
        );
      },
      onSubmit: (List<String> items) async {
        final verificationCode = items[0];
        final newPassword = items[1];

        // Set verification code on the controller
        emailAuth.verificationCodeController.text = verificationCode;

        try {
          // Verify the password reset code
          await emailAuth.verifyPasswordResetCode();

          // Set the new password on the controller
          emailAuth.passwordController.text = newPassword;

          // Complete the password reset
          await emailAuth.finishPasswordReset();

          // Track successful password reset completion
          await analytics.trackAuthPasswordResetComplete(email: email);

          if (context.mounted) {
            return true;
          }
          return null;
        } catch (e) {
          // Track password reset failure
          await analytics.trackAuthPasswordResetFailure(
            email: email,
            errorMessage: e.toString(),
          );

          if (context.mounted) {
            // Map the exception and show beautiful error dialog
            final authError = AuthErrorMapper.mapError(
              e,
              context: AuthContext.passwordReset,
            );
            await showAuthErrorDialog(context: context, error: authError);
          }
          return null;
        }
      },
    );
  }
}
