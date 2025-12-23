import 'package:executor/executor.dart';
import 'package:translator/translator.dart';
import 'translation_repository.dart';

/// Google Translate implementation of the translation repository.
///
/// This implementation uses the Google Translate API via the translator package
/// and limits concurrent requests to prevent overwhelming the API.
class GoogleTranslationRepository implements TranslationRepository {
  final _translator = GoogleTranslator();

  /// Limit to 2 concurrent requests to avoid overwhelming Google API.
  static final _executor = Executor(concurrency: 2);

  /// Extracts the 2-letter language code from formats like "enUS", "pt_BR", "en-US", etc.
  ///
  /// Examples:
  /// - "enUS" -> "en"
  /// - "pt_BR" -> "pt"
  /// - "en-US" -> "en"
  /// - "en" -> "en"
  String _extractLanguageCode(String languageCode) {
    // Handle common separators (underscore, hyphen)
    if (languageCode.contains('_')) {
      return languageCode.split('_').first.toLowerCase();
    }
    if (languageCode.contains('-')) {
      return languageCode.split('-').first.toLowerCase();
    }

    // If no separator found, take first 2 characters
    if (languageCode.length >= 2) {
      return languageCode.substring(0, 2).toLowerCase();
    }

    // Return as-is if less than 2 characters (edge case)
    return languageCode.toLowerCase();
  }

  @override
  Future<String> translate({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    // Handle empty text
    if (text.trim().isEmpty) {
      return text;
    }

    // Extract 2-letter language codes
    final from = _extractLanguageCode(fromLanguage);
    final to = _extractLanguageCode(toLanguage);

    // No translation needed if languages are the same
    if (from == to) {
      return text;
    }

    try {
      // Use executor to limit concurrent requests
      final translatedText = await _executor.scheduleTask(() async {
        final translation = await _translator.translate(
          text,
          from: from,
          to: to,
        );
        return translation.text;
      });

      return translatedText;
    } catch (e) {
      // Log error in production, you might want to use a logger here
      // For now, gracefully return original text on any error
      return text;
    }
  }
}
