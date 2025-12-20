/// Repository interface for text translation.
abstract class TranslationRepository {
  /// Translates text from source language to target language.
  /// Returns the translated text.
  /// [text] - The text to translate
  /// [fromLanguage] - Source language code (e.g., "en", "es", "pt")
  /// [toLanguage] - Target language code (e.g., "en", "es", "pt")
  Future<String> translate({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  });
}
