import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';

const _languageKey = 'selected_language_code';

/// Data class representing a supported language with all display information.
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final Locale locale;
  final SupportedLanguage serverLanguage;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    required this.locale,
    required this.serverLanguage,
  });
}

/// All supported languages in the app.
const List<LanguageOption> supportedLanguages = [
  LanguageOption(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flagEmoji: '\u{1F1FA}\u{1F1F8}', // US flag
    locale: Locale('en'),
    serverLanguage: SupportedLanguage.en,
  ),
  LanguageOption(
    code: 'es',
    name: 'Spanish',
    nativeName: 'Espanol',
    flagEmoji: '\u{1F1EA}\u{1F1F8}', // Spain flag
    locale: Locale('es'),
    serverLanguage: SupportedLanguage.es,
  ),
  LanguageOption(
    code: 'de',
    name: 'German',
    nativeName: 'Deutsch',
    flagEmoji: '\u{1F1E9}\u{1F1EA}', // Germany flag
    locale: Locale('de'),
    serverLanguage: SupportedLanguage.de,
  ),
  LanguageOption(
    code: 'fr',
    name: 'French',
    nativeName: 'Francais',
    flagEmoji: '\u{1F1EB}\u{1F1F7}', // France flag
    locale: Locale('fr'),
    serverLanguage: SupportedLanguage.fr,
  ),
  LanguageOption(
    code: 'pt_BR',
    name: 'Portuguese (Brazil)',
    nativeName: 'Portugues (Brasil)',
    flagEmoji: '\u{1F1E7}\u{1F1F7}', // Brazil flag
    locale: Locale('pt', 'BR'),
    serverLanguage: SupportedLanguage.ptBR,
  ),
  LanguageOption(
    code: 'ja',
    name: 'Japanese',
    nativeName: '\u65E5\u672C\u8A9E',
    flagEmoji: '\u{1F1EF}\u{1F1F5}', // Japan flag
    locale: Locale('ja'),
    serverLanguage: SupportedLanguage.ja,
  ),
];

/// Get a LanguageOption by its code. Returns English if not found.
LanguageOption getLanguageByCode(String code) {
  return supportedLanguages.firstWhere(
    (lang) => lang.code == code,
    orElse: () => supportedLanguages.first, // Default to English
  );
}

/// Get a LanguageOption by Locale. Returns English if not found.
LanguageOption getLanguageByLocale(Locale locale) {
  // First try exact match (including country code)
  for (final lang in supportedLanguages) {
    if (lang.locale.languageCode == locale.languageCode &&
        lang.locale.countryCode == locale.countryCode) {
      return lang;
    }
  }

  // Then try matching just the language code
  for (final lang in supportedLanguages) {
    if (lang.locale.languageCode == locale.languageCode) {
      return lang;
    }
  }

  // Default to English
  return supportedLanguages.first;
}

/// Get the system's preferred locale.
/// Uses PlatformDispatcher for web compatibility.
Locale _getSystemLocale() {
  // PlatformDispatcher.instance.locale works on all platforms including web
  return PlatformDispatcher.instance.locale;
}

/// Check if a locale is supported by the app.
bool _isLocaleSupported(Locale locale) {
  return AppLocalizations.supportedLocales.any(
    (supported) =>
        supported.languageCode == locale.languageCode ||
        (supported.languageCode == locale.languageCode &&
            supported.countryCode == locale.countryCode),
  );
}

/// Notifier for managing language state with persistence.
/// Follows the same pattern as ThemeStateNotifier.
class LanguageNotifier extends Notifier<LanguageOption> {
  @override
  LanguageOption build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedCode = prefs.getString(_languageKey);

    if (savedCode != null) {
      // Use saved language preference
      return getLanguageByCode(savedCode);
    }

    // Detect system locale
    final systemLocale = _getSystemLocale();

    // Check if system locale is supported
    if (_isLocaleSupported(systemLocale)) {
      return getLanguageByLocale(systemLocale);
    }

    // Default to English
    return supportedLanguages.first;
  }

  /// Change the app language and persist the selection.
  void setLanguage(LanguageOption language) {
    state = language;
    ref.read(sharedPreferencesProvider).setString(_languageKey, language.code);
  }

  /// Change the app language by code.
  void setLanguageByCode(String code) {
    final language = getLanguageByCode(code);
    setLanguage(language);
  }
}

/// Provider for the current language selection.
final languageProvider =
    NotifierProvider<LanguageNotifier, LanguageOption>(LanguageNotifier.new);

/// Provider that returns the current Locale for MaterialApp.
final appLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(languageProvider).locale;
});

/// Provider that returns the SupportedLanguage enum for server calls.
/// This can be used to override currentLanguageProvider in serverpod_providers.dart.
final serverLanguageProvider = Provider<SupportedLanguage>((ref) {
  return ref.watch(languageProvider).serverLanguage;
});
