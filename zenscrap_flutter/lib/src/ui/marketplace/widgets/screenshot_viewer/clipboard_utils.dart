import 'package:flutter/foundation.dart';
import 'clipboard_utils_stub.dart'
    if (dart.library.html) 'clipboard_utils_web.dart'
    if (dart.library.io) 'clipboard_utils_io.dart' as platform;

/// Copies an image to the system clipboard.
/// Returns true if successful, false otherwise.
Future<bool> copyImageToClipboard(Uint8List imageBytes) async {
  try {
    return await platform.copyImageToClipboard(imageBytes);
  } catch (e) {
    debugPrint('Error copying image to clipboard: $e');
    return false;
  }
}
