import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';

class StripeWebhookRoute extends Route {
  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    // Read the request body (Stripe sends JSON)
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body);

    // Handle subscription events
    if (data['type'] == 'customer.subscription.created') {
      // Handle subscription created
    } else if (data['type'] == 'customer.subscription.updated') {
      // Handle subscription updated
    } else if (data['type'] == 'customer.subscription.deleted') {
      // Handle subscription deleted
    }

    // Respond with 200 OK to acknowledge receipt
    request.response.statusCode = HttpStatus.ok;
    await request.response.close();
    return true;
  }
}
