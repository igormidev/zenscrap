import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:zenscrap_flutter/src/design_system/dialog_message.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/ui/auth/templates/auth_form_template.dart';

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
    return AuthFormTemplate<bool>(
      items: [
        AuthFormItem(
          hintText: 'Validation code',
          labelText: 'New password',
          autofillHints: AutofillHints.oneTimeCode,
          validator: FormBuilderValidators.maxLength(8),
        ),
        AuthFormItem(
          hintText: 'Define your new password',
          labelText: 'New password',
          autofillHints: AutofillHints.newPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
        AuthFormItem(
          hintText: 'Type again your new password',
          labelText: 'Confirm password',
          autofillHints: AutofillHints.newPassword,
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.password(maxLength: 64),
        ),
      ],
      submitText: 'Validate the code sent to email',
      onSubmitSuccess: (data) async {
        await showSuccessDialog(
          context: context,
          title: 'Password reseted with success!',
          message: 'Now you can log in with the new password',
          onConfirm: () => onSuccessChangePassword(),
        );
      },
      onSubmit: (List<String> items) async {
        final verificationCode = items[0];
        final newPassword = items[1];

        final success = await emailAuth.resetPassword(
          email,
          verificationCode,
          newPassword,
        );

        if (!success) {
          if (context.mounted) {
            showErrorSnackbar(context);
          }
          return null;
        }

        if (context.mounted) {
          return true;
        }
        return null;
      },
    );
  }
}
