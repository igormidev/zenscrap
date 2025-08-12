import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

class PasswordResetPage extends StatelessWidget {
  final void Function(String typedEmail) onChangeToPasswordReset;
  final EmailAuthController emailAuth;
  const PasswordResetPage({
    super.key,
    required this.emailAuth,
    required this.onChangeToPasswordReset,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFormTemplate<String>(
      submitText: 'Send verification code',
      items: [
        AuthFormItem(
          hintText: 'The email you registered with',
          labelText: 'Email',
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
          'A verification code will be sent to your email',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
      ],
      onSubmitSuccess: (email) {
        onChangeToPasswordReset(email);
      },
      onSubmit: (List<String> items) async {
        final String email = items[0];
        final success = await emailAuth.initiatePasswordReset(email);

        if (!success) {
          if (context.mounted) {
            showErrorSnackbar(context);
          }

          return null;
        }

        return email;
      },
    );
  }
}
