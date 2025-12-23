import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

/// Sends an email using the Resend HTTP API.
///
/// Uses HTTPS (port 443) which is compatible with Serverpod Cloud,
/// unlike SMTP which uses port 465 and is blocked.
///
/// [apiKey] - The Resend API key from Serverpod Cloud secrets
/// [destinyEmail] - The recipient email address
/// [subject] - The email subject
/// [htmlMessage] - The HTML content of the email
///
/// Returns `true` if the email was sent successfully, `false` otherwise.
Future<bool> sendEmail({
  required String apiKey,
  required String destinyEmail,
  required String subject,
  required String htmlMessage,
}) async {
  const endpoint = 'https://api.resend.com/emails';

  const fromEmail = 'Zen Scrap <noreply@zenscrap.com>';

  final body = jsonEncode({
    'from': fromEmail,
    'to': [destinyEmail],
    'subject': subject,
    'html': htmlMessage,
  });

  try {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      final emailId = responseBody['id'];
      developer.log(
        'Email sent successfully. Resend ID: $emailId',
        name: 'sendEmail',
      );
      return true;
    } else {
      developer.log(
        'Failed to send email. Status: ${response.statusCode}, Body: ${response.body}',
        name: 'sendEmail',
      );
      return false;
    }
  } catch (e, stackTrace) {
    developer.log(
      'Exception sending email: $e',
      name: 'sendEmail',
      error: e,
      stackTrace: stackTrace,
    );
    return false;
  }
}
