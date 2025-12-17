import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/get_html_messages.dart';
import 'package:zenscrap_server/src/auth/send_email.dart';

/// Callback for sending password reset verification code emails
/// Used by EmailIdpConfig in Serverpod 3.1 IDP system
Future<void> onSendPasswordResetVerificationCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  session.log('Password reset verification code for $email: $verificationCode');

  final htmlText = getHTMLEmailTemplate(
    title: 'Reset password code',
    description:
        'Enter the following code below in the verification code field.',
    code: verificationCode,
  );

  await sendEmail(
    destinyEmail: email,
    subject: 'Zen Scrap | Reset your password',
    htmlMessage: htmlText,
  );
}
