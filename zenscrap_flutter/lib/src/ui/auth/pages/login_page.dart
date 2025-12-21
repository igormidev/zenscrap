import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/states/session/user_model.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/auth_error_mapper.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/auth_error_dialog.dart';
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
        ref
            .read(sessionProvider.notifier)
            .setState(SessionState.logged(user: data));
      },
      onSubmit: (items) async {
        final String email = items[0];
        final String password = items[1];

        // Track login attempt
        await analytics.trackAuthLoginAttempt(email: email);

        // Set email and password on the controller
        emailAuth.emailController.text = email;
        emailAuth.passwordController.text = password;

        // DEBUG: Log login attempt info
        debugPrint(
          '[DEBUG] Login attempt - email: $email, password length: ${password.length}',
        );
        debugPrint(
          '[DEBUG] passwordController.text length: ${emailAuth.passwordController.text.length}',
        );

        try {
          // Attempt login using the new IDP system
          // Note: login() catches exceptions internally via _guarded().
          // It sets state to EmailAuthState.error on failure and
          // EmailAuthState.authenticated on success.
          await emailAuth.login();

          // DEBUG: Log authentication state immediately after login()
          debugPrint(
            '[DEBUG] After login() - state: ${emailAuth.state}, '
            'isAuthenticated: ${emailAuth.isAuthenticated}, '
            'errorMessage: ${emailAuth.errorMessage}',
          );

          // Check the state directly - this is more reliable than isAuthenticated
          // because isAuthenticated reads from client.auth.isAuthenticated which
          // may have timing issues, while state is updated synchronously by _guarded()
          final state = emailAuth.state;
          final isSuccess = state == EmailAuthState.authenticated;
          final isError = state == EmailAuthState.error;

          if (isError || !isSuccess) {
            // Track login failure - use errorMessage if available
            final errorMsg = emailAuth.errorMessage ?? 'Invalid credentials';
            await analytics.trackAuthLoginFailure(
              email: email,
              errorMessage: errorMsg,
            );

            if (context.mounted) {
              // Map the error and show beautiful error dialog
              // Use the actual error from the controller if available
              final error = emailAuth.error;
              final authError = error != null
                  ? AuthErrorMapper.mapError(error, context: AuthContext.login)
                  : (emailAuth.errorMessage != null
                      ? AuthErrorMapper.mapControllerError(
                          emailAuth.errorMessage,
                          context: AuthContext.login,
                        )
                      : AuthErrorMapper.loginFailed());
              showAuthErrorDialog(context: context, error: authError);
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

          return UserModel(email: email, userName: userName, imageUrl: null);
        } catch (e) {
          // Track login failure
          await analytics.trackAuthLoginFailure(
            email: email,
            errorMessage: e.toString(),
          );

          if (context.mounted) {
            // Map the exception and show beautiful error dialog
            final authError = AuthErrorMapper.mapError(
              e,
              context: AuthContext.login,
            );
            await showAuthErrorDialog(context: context, error: authError);
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
