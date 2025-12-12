import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

final sessionManagerProvider = Provider<SessionManager>((ref) {
  return throw UnimplementedError();
});
final clientProvider = Provider<Client>((ref) {
  return throw UnimplementedError();
});

/// Provider for the current supported language.
/// Currently defaults to English as the app locale is hardcoded.
/// Can be expanded to map from Flutter's locale when multi-language support is added.
final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  return SupportedLanguage.en;
});
