import 'package:serverpod/serverpod.dart';
import '../widgets/terms_of_service_page.dart';

/// Route that serves the Terms of Service page at /terms-of-service
class TermsOfServiceRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TermsOfServicePage();
  }
}
