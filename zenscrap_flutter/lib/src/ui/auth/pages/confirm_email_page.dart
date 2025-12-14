import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
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
        final user = await emailAuth.validateAccount(email, verificationCode);

        final userEmail = user?.email;
        final userName = user?.userName;
        if (userEmail == null || userName == null) {
          if (context.mounted) {
            showErrorSnackbar(context);
          }

          return null;
        }

        // Track successful email confirmation
        await analytics.trackAuthEmailConfirmationSuccess(email: email);

        return true;
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
