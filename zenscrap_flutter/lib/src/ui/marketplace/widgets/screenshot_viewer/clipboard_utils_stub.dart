import 'package:flutter/foundation.dart';

/// Stub implementation - returns false as image clipboard is not supported
Future<bool> copyImageToClipboard(Uint8List imageBytes) async {
  debugPrint('Clipboard stub called - platform not determined');
  return false;
}
