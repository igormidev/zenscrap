import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/language_provider.dart';

final clientProvider = Provider<Client>((ref) {
  return throw UnimplementedError();
});

/// Provider for accessing the FlutterAuthSessionManager from the client.
final sessionManagerProvider = Provider<FlutterAuthSessionManager>((ref) {
  final client = ref.watch(clientProvider);
  return client.authSessionManager;
});

/// Provider for the current supported language for server calls.
/// Derives from the language provider which handles persistence and system locale detection.
final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  return ref.watch(serverLanguageProvider);
});
