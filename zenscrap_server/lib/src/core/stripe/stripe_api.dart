import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class StripeApi {
  static const String baseUrl = 'https://api.stripe.com/v1';

  static Future<Map<String, dynamic>> createCheckoutSession({
    required String secretKey,
    required String priceId,
    required String customerEmail,
    required String successUrl,
    required String cancelUrl,
    required int accountInfoId,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse('$baseUrl/checkout/sessions'));
      
      // Set headers
      request.headers.set('Authorization', 'Bearer $secretKey');
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      
      // Build form data
      final formData = {
        'mode': 'subscription',
        'line_items[0][price]': priceId,
        'line_items[0][quantity]': '1',
        'customer_email': customerEmail,
        'success_url': successUrl,
        'cancel_url': cancelUrl,
        'client_reference_id': accountInfoId.toString(),
        'metadata[account_info_id]': accountInfoId.toString(),
        'metadata[customer_email]': customerEmail,
        'subscription_data[metadata][account_info_id]': accountInfoId.toString(),
      };
      
      final body = formData.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      
      request.write(body);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to create checkout session: $responseBody');
      }
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> retrieveSubscription({
    required String secretKey,
    required String subscriptionId,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('$baseUrl/subscriptions/$subscriptionId'));
      
      request.headers.set('Authorization', 'Bearer $secretKey');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to retrieve subscription: $responseBody');
      }
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> cancelSubscription({
    required String secretKey,
    required String subscriptionId,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.deleteUrl(Uri.parse('$baseUrl/subscriptions/$subscriptionId'));
      
      request.headers.set('Authorization', 'Bearer $secretKey');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to cancel subscription: $responseBody');
      }
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> createCustomerPortalSession({
    required String secretKey,
    required String customerId,
    required String returnUrl,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse('$baseUrl/billing_portal/sessions'));
      
      // Set headers
      request.headers.set('Authorization', 'Bearer $secretKey');
      request.headers.set('Content-Type', 'application/x-www-form-urlencoded');
      
      // Build form data
      final formData = {
        'customer': customerId,
        'return_url': returnUrl,
      };
      
      final body = formData.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      
      request.write(body);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to create customer portal session: $responseBody');
      }
    } finally {
      client.close();
    }
  }

  static bool verifyWebhookSignature({
    required String payload,
    required String signature,
    required String secret,
  }) {
    // Extract timestamp and signatures from header
    final parts = signature.split(',');
    String? timestamp;
    String? receivedSignature;
    
    for (final part in parts) {
      final keyValue = part.split('=');
      if (keyValue.length == 2) {
        if (keyValue[0] == 't') {
          timestamp = keyValue[1];
        } else if (keyValue[0] == 'v1') {
          receivedSignature = keyValue[1];
        }
      }
    }
    
    if (timestamp == null || receivedSignature == null) {
      return false;
    }
    
    // Compute expected signature
    final signedPayload = '$timestamp.$payload';
    final key = utf8.encode(secret);
    final bytes = utf8.encode(signedPayload);
    
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    final expectedSignature = digest.toString();
    
    // Compare signatures
    return expectedSignature == receivedSignature;
  }
}