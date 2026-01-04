import 'package:serverpod/serverpod.dart';
import '../widgets/payment_success_page.dart';

/// Route that serves the Payment Success page at /success
/// This page is displayed after a successful Stripe checkout session.
class PaymentSuccessRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return PaymentSuccessPage();
  }
}
