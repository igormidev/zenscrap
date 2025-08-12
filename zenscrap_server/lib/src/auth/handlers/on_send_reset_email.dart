import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:zenscrap_server/src/auth/get_html_messages.dart';
import 'package:zenscrap_server/src/auth/send_email.dart';

Future<bool> onSendResetEmail(
  Session session,
  UserInfo userInfo,
  String validationCode,
) async {
  print('Validation code: $validationCode');
  final email = userInfo.email;
  if (email == null) {
    print('Email not found for ${userInfo.id}');
    return false;
  }
  final htmlText = getHTMLEmailTemplate(
    title: 'Reset password code',
    description:
        'Enter the following code bellow in the verfication code field.',
    code: validationCode,
  );
  return sendEmail(
    destinyEmail: email,
    subject: 'GO BABEL | Reset your password',
    htmlMessage: htmlText,
  );
}
