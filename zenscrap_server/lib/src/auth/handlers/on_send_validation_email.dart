import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/get_html_messages.dart';
import 'package:zenscrap_server/src/auth/send_email.dart';

/// Callback for sending registration verification code emails
/// Used by EmailIdpConfig in Serverpod 3.1 IDP system
Future<void> onSendRegistrationVerificationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) async {
  session.log('Registration verification code for $email: $verificationCode');

  // Skip email for test account - ONLY in development or test mode
  // This bypass is disabled in production and staging for security
  final runMode = session.serverpod.runMode;
  final isNonProductionMode = runMode == ServerpodRunMode.development ||
      runMode == ServerpodRunMode.test;
  if (isNonProductionMode && email == 'igor9ms@hotmail.com') {
    session.log('Skipping email for test account in $runMode mode');
    return;
  }

  final htmlText = getHTMLEmailTemplate(
    title: 'Confirm Your Email Address',
    description:
        'Enter the following code below in the verification code field.',
    code: verificationCode,
  );

  await sendEmail(
    apiKey: session.passwords['resendApiKey']!,
    destinyEmail: email,
    subject: 'Zen Scrap | Confirm your email address',
    htmlMessage: htmlText,
  );
}
