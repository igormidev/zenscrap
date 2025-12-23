import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/providers/language_provider.dart';
import 'package:zenscrap_flutter/src/repositories/translation/translation.dart';
import 'package:zenscrap_flutter/src/states/translation/translation_state.dart';

export 'translation_state.dart';

/// Parameters for the translation provider.
/// Uses a record type for efficient hashing as family key.
typedef TranslationParams = ({
  String text,
  String sourceLanguage,
});

/// Provider for the translation repository.
final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return GoogleTranslationRepository();
});

/// Notifier for managing translation state.
/// In Riverpod 3, family notifiers extend Notifier and take the arg via constructor.
class TranslationNotifier extends Notifier<TranslationState> {
  TranslationNotifier(this.arg);
  final TranslationParams arg;

  @override
  TranslationState build() {
    // Check if translation is needed
    final targetLanguage = ref.watch(languageProvider);
    final sourceLanguageCode = _extractLanguageCode(arg.sourceLanguage);
    final targetLanguageCode = targetLanguage.locale.languageCode;

    // Create initial state
    final initialState = TranslationState.initial(
      originalText: arg.text,
      sourceLanguage: arg.sourceLanguage,
    );

    // If same language, no translation needed
    if (sourceLanguageCode == targetLanguageCode) {
      return initialState.copyWith(
        translatedText: arg.text,
        translationAttempted: true,
      );
    }

    // Start translation automatically
    Future.microtask(() => _translate());

    return initialState;
  }

  /// Extracts the 2-letter language code from format like "enUS" or "pt_BR"
  String _extractLanguageCode(String languageCode) {
    if (languageCode.isEmpty) return 'en';

    // Handle formats like "enUS", "ptBR", "en_US", "pt_BR", "en-US", "pt-BR"
    final cleaned = languageCode.replaceAll(RegExp(r'[-_]'), '');

    // Take first 2 characters (language code)
    if (cleaned.length >= 2) {
      return cleaned.substring(0, 2).toLowerCase();
    }

    return languageCode.toLowerCase();
  }

  /// Performs the translation.
  Future<void> _translate() async {
    if (state.isLoading || state.translationAttempted) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(translationRepositoryProvider);
      final targetLanguage = ref.read(languageProvider);

      final sourceCode = _extractLanguageCode(arg.sourceLanguage);
      final targetCode = targetLanguage.locale.languageCode;

      // Skip if same language
      if (sourceCode == targetCode) {
        state = state.copyWith(
          translatedText: arg.text,
          isLoading: false,
          translationAttempted: true,
        );
        return;
      }

      final translatedText = await repository.translate(
        text: arg.text,
        fromLanguage: sourceCode,
        toLanguage: targetCode,
      );

      state = state.copyWith(
        translatedText: translatedText,
        isLoading: false,
        translationAttempted: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        translationAttempted: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// Toggles between showing original and translated text.
  void toggleShowOriginal() {
    state = state.copyWith(showOriginal: !state.showOriginal);
  }

  /// Retries translation if it failed.
  Future<void> retryTranslation() async {
    state = state.copyWith(translationAttempted: false);
    await _translate();
  }
}

/// Provider for translation state.
/// Usage:
/// ```dart
/// final translationState = ref.watch(translationProvider((
///   text: 'Hello world',
///   sourceLanguage: 'enUS',
/// )));
/// ```
final translationProvider = NotifierProvider.family<
    TranslationNotifier, TranslationState, TranslationParams>(
  TranslationNotifier.new,
);

/// Helper extension for creating translation params.
extension TranslationParamsExtension on String {
  TranslationParams toTranslationParams(String sourceLanguage) =>
      (text: this, sourceLanguage: sourceLanguage);
}
