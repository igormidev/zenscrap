import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

class PasswordResetPage extends ConsumerWidget {
  final void Function(String typedEmail) onChangeToPasswordReset;
  final EmailAuthController emailAuth;
  const PasswordResetPage({
    super.key,
    required this.emailAuth,
    required this.onChangeToPasswordReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    // Track view when the password reset form is visible
    analytics.trackAuthPasswordResetViewed();

    return AuthFormTemplate<String>(
      submitText: l10n.auth_send_verification_code,
      items: [
        AuthFormItem(
          hintText: l10n.auth_email_registered_hint,
          labelText: l10n.auth_email_label,
          autofillHints: AutofillHints.email,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.email(),
            FormBuilderValidators.minLength(10),
            FormBuilderValidators.maxLength(55),
          ]),
        ),
      ],
      children: [
        Text(
          l10n.auth_verification_code_info,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
      ],
      onSubmitSuccess: (email) {
        onChangeToPasswordReset(email);
      },
      onSubmit: (List<String> items) async {
        final String email = items[0];

        // Track password reset initiation
        await analytics.trackAuthPasswordResetInitiate(email: email);

        final success = await emailAuth.initiatePasswordReset(email);

        if (!success) {
          // Track password reset failure
          await analytics.trackAuthPasswordResetFailure(
            email: email,
            errorMessage: 'Failed to send verification code',
          );

          if (context.mounted) {
            showErrorSnackbar(context);
          }

          return null;
        }

        // Track successful code sent
        await analytics.trackAuthPasswordResetCodeSent(email: email);

        return email;
      },
    );
  }
}
