import 'package:serverpod/serverpod.dart';

/// Widget that renders the Payment Success HTML template.
/// This page is shown after a successful Stripe payment and displays
/// a success message with instructions in the user's browser language.
class PaymentSuccessPage extends TemplateWidget {
  PaymentSuccessPage() : super(name: 'payment_success');
}
