import 'package:flutter/foundation.dart';

/// IO (desktop/mobile) implementation
/// Note: Flutter doesn't have built-in support for copying images to clipboard
/// on non-web platforms. This would require platform-specific implementations.
Future<bool> copyImageToClipboard(Uint8List imageBytes) async {
  debugPrint('Image clipboard is only supported on web platform');
  // On desktop/mobile, image clipboard requires platform-specific implementation
  // Consider using packages like 'pasteboard' for macOS or platform channels
  return false;
}
