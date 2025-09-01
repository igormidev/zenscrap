import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

class SignInPage extends ConsumerWidget {
  final EmailAuthController emailAuth;
  final void Function(String email) onChangeToConfirmPassword;
  const SignInPage({
    super.key,
    required this.emailAuth,
    required this.onChangeToConfirmPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthFormTemplate<String>(
      submitText: 'Sign Up',
      items: [
        AuthFormItem(
          hintText: 'User name (or company name)',
          labelText: 'User display name (Typically the company name)',
          autofillHints: AutofillHints.name,
          keyboardType: TextInputType.name,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(50),
          ]),
        ),
        AuthFormItem(
          hintText: 'Enter your email',
          labelText: 'Email',
          autofillHints: AutofillHints.email,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.email(),
            FormBuilderValidators.minLength(10),
            FormBuilderValidators.maxLength(55),
          ]),
        ),
        AuthFormItem(
          hintText: 'Enter your password',
          labelText: 'Password',
          autofillHints: AutofillHints.password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
        AuthFormItem(
          hintText: 'Type your password again',
          labelText: 'Confirm password',
          autofillHints: AutofillHints.password,
          obscureText: true,
          validatorWithItems: (value, currItensState) {
            return FormBuilderValidators.password(
              maxLength: 64,
            ).and(FormBuilderValidators.equal(currItensState[2]))(value);
          },
        ),
      ],
      onSubmitSuccess: (email) {
        onChangeToConfirmPassword(email);
      },
      onSubmit: (List<String> items) async {
        final String userName = items[0];
        final String email = items[1];
        final String password = items[2];

        final bool success = await emailAuth.createAccountRequest(
          userName,
          email,
          password,
        );

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
