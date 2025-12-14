import 'package:serverpod/serverpod.dart';
import '../widgets/privacy_policy_page.dart';

/// Route that serves the Privacy Policy page at /privacy-policy
class PrivacyPolicyRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return PrivacyPolicyPage();
  }
}
