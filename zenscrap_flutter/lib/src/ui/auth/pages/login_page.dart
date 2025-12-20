import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/google_sign_in_button.dart';

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
    final analytics = ref.read(analyticsServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    // Track view when the login form is visible
    analytics.trackAuthLoginViewed();

    FormBuilderValidators.email().and(FormBuilderValidators.minLength(8));
    return AuthFormTemplate<UserModel>(
      submitText: l10n.auth_log_in_button,
      items: [
        AuthFormItem(
          hintText: l10n.auth_email_hint,
          labelText: l10n.auth_email_label,
          autofillHints: AutofillHints.email,
          keyboardType: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.email(),
            FormBuilderValidators.minLength(10),
            FormBuilderValidators.maxLength(55),
          ]),
        ),
        AuthFormItem(
          hintText: l10n.auth_password_hint,
          labelText: l10n.auth_password_label,
          autofillHints: AutofillHints.password,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
      ],
      onSubmitSuccess: (data) {
        ref.read(sessionProvider.notifier).setState(SessionState.logged(
          user: data,
        ));
      },
      onSubmit: (items) async {
        final String email = items[0];
        final String password = items[1];

        // Track login attempt
        await analytics.trackAuthLoginAttempt(email: email);

        // Set email and password on the controller
        emailAuth.emailController.text = email;
        emailAuth.passwordController.text = password;

        try {
          // Attempt login using the new IDP system
          // Note: login() does NOT throw on invalid credentials.
          // Instead, it triggers onError callback and sets errorMessage.
          await emailAuth.login();

          // Small delay to allow the async state update to propagate
          // The EmailAuthController updates state asynchronously after login()
          await Future.delayed(const Duration(milliseconds: 50));

          // Check the controller's isAuthenticated property (not client.auth.isAuthenticated)
          // This is updated by the EmailAuthController after login() completes
          final isAuthenticated = emailAuth.isAuthenticated;

          if (!isAuthenticated) {
            // Track login failure - use errorMessage if available
            final errorMsg = emailAuth.errorMessage ?? 'Invalid credentials';
            await analytics.trackAuthLoginFailure(
              email: email,
              errorMessage: errorMsg,
            );

            if (context.mounted) {
              showErrorSnackbar(context);
            }

            return null;
          }

          // Login succeeded.
          // The EmailAuthController's onAuthenticated callback handles auth state.
          const userName = 'User';

          // Track successful login
          await analytics.trackAuthLoginSuccess(
            email: email,
            userName: userName,
          );

          return UserModel(
            email: email,
            userName: userName,
            imageUrl: null,
          );
        } catch (e) {
          // Track login failure
          await analytics.trackAuthLoginFailure(
            email: email,
            errorMessage: e.toString(),
          );

          if (context.mounted) {
            showErrorSnackbar(context);
          }

          return null;
        }
      },
      children: const [
        SizedBox(height: 8),
        ZenScrapGoogleSignInButton(),
        SizedBox(height: 16),
      ],
    );
  }
}
