import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web implementation using the Clipboard API
Future<bool> copyImageToClipboard(Uint8List imageBytes) async {
  try {
    // Create a Blob from the image bytes
    final jsArray = imageBytes.toJS;
    final blob = web.Blob(
      [jsArray].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );

    // Create a ClipboardItem with the image
    final clipboardItem = web.ClipboardItem(
      {'image/png': blob}.jsify() as JSObject,
    );

    // Write to clipboard
    await web.window.navigator.clipboard.write([clipboardItem].toJS).toDart;
    return true;
  } catch (e) {
    // Clipboard API might not be available or permission denied
    return false;
  }
}
