import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/auth/get_html_messages.dart';
import 'package:zenscrap_server/src/auth/send_email.dart';

Future<bool> onSendValidationEmail(
  Session session,
  String email,
  String validationCode,
) async {
  print('Validation code: $validationCode');
  if (email == 'igor9ms@hotmail.com') return true;
  final htmlText = getHTMLEmailTemplate(
    title: 'Confirm Your Email Address',
    description:
        'Enter the following code bellow in the verfication code field.',
    code: validationCode,
  );
  return sendEmail(
    destinyEmail: email,
    subject: 'Zen Scrap | Confirm your email address',
    htmlMessage: htmlText,
  );
}
