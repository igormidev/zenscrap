import 'package:zenscrap_server/src/web/widgets/flutter_web_page.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return FlutterWebPage();
  }
}
