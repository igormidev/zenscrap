import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_state.freezed.dart';

/// State for managing text translation.
@freezed
abstract class TranslationState with _$TranslationState {
  factory TranslationState({
    /// The original untranslated text
    required String originalText,

    /// The source language code (e.g., "enUS", "esES")
    required String sourceLanguage,

    /// The translated text (null if not yet translated or translation failed)
    String? translatedText,

    /// Whether the translation is currently loading
    @Default(false) bool isLoading,

    /// Whether to show the original text (true) or translated text (false)
    @Default(false) bool showOriginal,

    /// Whether translation has been attempted
    @Default(false) bool translationAttempted,

    /// Error message if translation failed
    String? errorMessage,
  }) = _TranslationState;

  factory TranslationState.initial({
    required String originalText,
    required String sourceLanguage,
  }) =>
      TranslationState(
        originalText: originalText,
        sourceLanguage: sourceLanguage,
      );
}

extension TranslationStateExtensions on TranslationState {
  /// Returns the text to display based on the current state.
  /// Shows original if toggled, translation not available, or still loading.
  String get displayText {
    if (showOriginal || translatedText == null) {
      return originalText;
    }
    return translatedText!;
  }

  /// Whether translation is available and different from original
  bool get hasTranslation =>
      translatedText != null && translatedText != originalText;

  /// Whether the toggle button should be shown
  bool get canToggle => hasTranslation && !isLoading;
}
