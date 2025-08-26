import 'dart:io';

// import 'package:gobabel_server/src/web/widgets/flutter_web_page.dart';
import 'package:zenscrap_server/src/web/widgets/flutter_web_page.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(Session session, HttpRequest request) async {
    return FlutterWebPage();
  }
}
