// ignore: avoid_web_libraries_in_flutter
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Configures the URL strategy for web to use path-based URLs
/// instead of hash-based URLs (removes the # from URLs).
void configureUrlStrategy() {
  setUrlStrategy(PathUrlStrategy());
}