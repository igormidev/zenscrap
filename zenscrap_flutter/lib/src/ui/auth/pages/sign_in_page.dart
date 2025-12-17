import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/google_sign_in_button.dart';

/// Stores pending registration data between startRegistration and finishRegistration.
/// This is needed because the new IDP system splits registration into multiple steps.
class PendingRegistrationData {
  static String? userName;
  static String? password;

  static void clear() {
    userName = null;
    password = null;
  }
}

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
    final analytics = ref.read(analyticsServiceProvider);
    final l10n = AppLocalizations.of(context)!;

    // Track view when the sign up form is visible
    analytics.trackAuthSignUpViewed();

    return AuthFormTemplate<String>(
      submitText: l10n.auth_sign_up_button,
      items: [
        AuthFormItem(
          hintText: l10n.auth_user_name_hint,
          labelText: l10n.auth_user_name_label,
          autofillHints: AutofillHints.name,
          keyboardType: TextInputType.name,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(4),
            FormBuilderValidators.maxLength(50),
          ]),
        ),
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
        AuthFormItem(
          hintText: l10n.auth_confirm_password_hint,
          labelText: l10n.auth_confirm_password_label,
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

        // Track sign up attempt
        await analytics.trackAuthSignUpAttempt(
          email: email,
          userName: userName,
        );

        // Store the user name and password for later use in finishRegistration
        PendingRegistrationData.userName = userName;
        PendingRegistrationData.password = password;

        // Set email on the controller
        emailAuth.emailController.text = email;

        try {
          // Start registration - this sends a verification code to the email
          await emailAuth.startRegistration();

          // Track successful sign up initiation
          await analytics.trackAuthSignUpSuccess(
            email: email,
            userName: userName,
          );

          return email;
        } catch (e) {
          // Track sign up failure
          await analytics.trackAuthSignUpFailure(
            email: email,
            errorMessage: e.toString(),
          );

          PendingRegistrationData.clear();

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
