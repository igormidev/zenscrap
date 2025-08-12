import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

class LoginPage extends ConsumerWidget {
  final EmailAuthController emailAuth;
  final void Function(String email) onChangeToConfirmPassword;
  const LoginPage({
    super.key,
    required this.emailAuth,
    required this.onChangeToConfirmPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FormBuilderValidators.email().and(FormBuilderValidators.minLength(8));
    return AuthFormTemplate<UserModel>(
      submitText: 'Log In',
      items: [
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
      ],
      onSubmitSuccess: (data) {
        ref.read(sessionProvider.notifier).state = SessionState.logged(
          user: data,
        );
      },
      onSubmit: (items) async {
        final String email = items[0];
        final String password = items[1];

        final user = await emailAuth.signIn(email, password);
        final userEmail = user?.email;
        final userName = user?.userName;
        if (userEmail == null || userName == null) {
          if (context.mounted) {
            showErrorSnackbar(context);
          }

          return null;
        }

        return UserModel(
          email: email,
          userName: userName,
          imageUrl: user?.imageUrl,
        );
      },
    );
  }
}
