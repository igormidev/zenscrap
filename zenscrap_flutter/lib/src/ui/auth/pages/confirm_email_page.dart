import 'package:babel_text/babel_text.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
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
    return AuthFormTemplate<bool>(
      submitText: 'Confirm your email',
      items: [
        AuthFormItem(
          hintText: 'Check your email for the validation code',
          labelText: 'Validation code',
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

        return true;
      },
      children: [
        BabelText(
          'Check your <i><b>"$email"<b><i>',
          style: context.t.bodyMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
