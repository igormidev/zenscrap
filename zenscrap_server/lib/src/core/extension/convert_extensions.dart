import 'dart:convert';

Map<String, dynamic>? tryDecode(Object? source) {
  if (source == null) return null;
  try {
    if (source is String) {
      return json.decode(source) as Map<String, dynamic>;
    } else if (source is Map) {
      return source.cast<String, dynamic>();
    }
    return null;
  } catch (_) {
    return null; // or return a default value
  }
}
