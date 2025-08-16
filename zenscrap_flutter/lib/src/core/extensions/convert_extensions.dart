import 'dart:convert';

Map<String, dynamic>? tryDecode(String? source) {
  try {
    if (source == null) return null;
    return json.decode(source) as Map<String, dynamic>;
  } catch (_) {
    return null; // or return a default value
  }
}
