import 'dart:developer' as developer;

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<bool> sendEmail({
  required String destinyEmail,
  required String subject,
  required String htmlMessage,
}) async {
  // Note that using a username and password for gmail only works if
  // you have two-factor authentication enabled and created an App password.
  // Search for "gmail app password 2fa"
  // The alternative is to use oauth.

  // TODO: Create admin@zenscrap.com email account with Hostinger and update credentials
  // Temporarily using gobabel.io until Zen Scrap email is set up
  String username = 'admin@gobabel.io';
  String password = '5HLF7UXvE^fjD*S*4m#K';

  // final smtpServer = gmail(username, password);
  // Configure SMTP server for Hostinger
  final smtpServer = SmtpServer(
    'smtp.hostinger.com',
    port: 465,
    username: username, // Your Hostinger email
    password: password, // Your Hostinger email password
    ssl: true, // Enable SSL for port 465
  );
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Zen Scrap')
    ..recipients.add(destinyEmail)
    ..subject = subject
    ..html = htmlMessage;

  try {
    final sendReport = await send(message, smtpServer);
    developer.log('Message sent: $sendReport', name: 'sendEmail');
    return true;
  } on MailerException catch (e) {
    developer.log('Message not sent.\n$e', name: 'sendEmail');
    for (var p in e.problems) {
      developer.log('Problem: ${p.code}: ${p.msg}', name: 'sendEmail');
    }
    return false;
  }
}
