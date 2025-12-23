import 'package:flutter_test/flutter_test.dart';
import 'package:zenscrap_flutter/src/repositories/translation/translation_repository.dart';
import 'package:zenscrap_flutter/src/states/translation/translation_provider.dart';

/// Mock implementation of TranslationRepository for testing.
class MockTranslationRepository implements TranslationRepository {
  final Map<String, String> translations;
  final bool shouldFail;
  final Duration delay;
  int callCount = 0;

  MockTranslationRepository({
    this.translations = const {},
    this.shouldFail = false,
    this.delay = Duration.zero,
  });

  @override
  Future<String> translate({
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    callCount++;
    if (delay != Duration.zero) {
      await Future.delayed(delay);
    }
    if (shouldFail) {
      throw Exception('Translation failed');
    }
    return translations[text] ?? text;
  }
}

void main() {
  group('TranslationState', () {
    test('initial state has correct values', () {
      final state = TranslationState.initial(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
      );

      expect(state.originalText, 'Hello');
      expect(state.sourceLanguage, 'enUS');
      expect(state.translatedText, isNull);
      expect(state.isLoading, isFalse);
      expect(state.showOriginal, isFalse);
      expect(state.translationAttempted, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('displayText returns original when translation not available', () {
      final state = TranslationState.initial(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
      );

      expect(state.displayText, 'Hello');
    });

    test('displayText returns translated when available and not showing original', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
        showOriginal: false,
      );

      expect(state.displayText, 'Hola');
    });

    test('displayText returns original when showOriginal is true', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
        showOriginal: true,
      );

      expect(state.displayText, 'Hello');
    });

    test('hasTranslation is true when translation differs from original', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
      );

      expect(state.hasTranslation, isTrue);
    });

    test('hasTranslation is false when translation equals original', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hello',
      );

      expect(state.hasTranslation, isFalse);
    });

    test('hasTranslation is false when translation is null', () {
      final state = TranslationState.initial(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
      );

      expect(state.hasTranslation, isFalse);
    });

    test('canToggle is true when translation available and not loading', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
        isLoading: false,
      );

      expect(state.canToggle, isTrue);
    });

    test('canToggle is false when loading', () {
      final state = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
        isLoading: true,
      );

      expect(state.canToggle, isFalse);
    });

    test('canToggle is false when no translation available', () {
      final state = TranslationState.initial(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
      );

      expect(state.canToggle, isFalse);
    });
  });

  group('TranslationParamsExtension', () {
    test('toTranslationParams creates correct record', () {
      final params = 'Hello'.toTranslationParams('enUS');

      expect(params.text, 'Hello');
      expect(params.sourceLanguage, 'enUS');
    });
  });

  group('Language code extraction', () {
    // Test helper function for language code extraction logic
    String extractLanguageCode(String languageCode) {
      if (languageCode.isEmpty) return 'en';
      final cleaned = languageCode.replaceAll(RegExp(r'[-_]'), '');
      if (cleaned.length >= 2) {
        return cleaned.substring(0, 2).toLowerCase();
      }
      return languageCode.toLowerCase();
    }

    test('extracts from enUS format', () {
      expect(extractLanguageCode('enUS'), 'en');
    });

    test('extracts from ptBR format', () {
      expect(extractLanguageCode('ptBR'), 'pt');
    });

    test('extracts from en_US format', () {
      expect(extractLanguageCode('en_US'), 'en');
    });

    test('extracts from pt-BR format', () {
      expect(extractLanguageCode('pt-BR'), 'pt');
    });

    test('handles simple two letter code', () {
      expect(extractLanguageCode('en'), 'en');
    });

    test('handles empty string', () {
      expect(extractLanguageCode(''), 'en');
    });

    test('handles single character', () {
      expect(extractLanguageCode('e'), 'e');
    });
  });

  group('TranslationState copyWith', () {
    test('copyWith creates new state with updated values', () {
      final original = TranslationState.initial(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
      );

      final updated = original.copyWith(
        translatedText: 'Hola',
        isLoading: false,
        translationAttempted: true,
      );

      expect(updated.originalText, 'Hello');
      expect(updated.sourceLanguage, 'enUS');
      expect(updated.translatedText, 'Hola');
      expect(updated.isLoading, isFalse);
      expect(updated.translationAttempted, isTrue);
    });

    test('copyWith preserves unchanged values', () {
      final original = TranslationState(
        originalText: 'Hello',
        sourceLanguage: 'enUS',
        translatedText: 'Hola',
        isLoading: false,
        showOriginal: true,
        translationAttempted: true,
        errorMessage: 'Some error',
      );

      final updated = original.copyWith(
        showOriginal: false,
      );

      expect(updated.originalText, 'Hello');
      expect(updated.sourceLanguage, 'enUS');
      expect(updated.translatedText, 'Hola');
      expect(updated.isLoading, isFalse);
      expect(updated.showOriginal, isFalse);
      expect(updated.translationAttempted, isTrue);
      expect(updated.errorMessage, 'Some error');
    });
  });

  group('MockTranslationRepository', () {
    test('returns translated text from map', () async {
      final repo = MockTranslationRepository(
        translations: {'Hello': 'Hola'},
      );

      final result = await repo.translate(
        text: 'Hello',
        fromLanguage: 'en',
        toLanguage: 'es',
      );

      expect(result, 'Hola');
      expect(repo.callCount, 1);
    });

    test('returns original text when not in map', () async {
      final repo = MockTranslationRepository();

      final result = await repo.translate(
        text: 'Hello',
        fromLanguage: 'en',
        toLanguage: 'es',
      );

      expect(result, 'Hello');
    });

    test('throws exception when shouldFail is true', () async {
      final repo = MockTranslationRepository(shouldFail: true);

      expect(
        () => repo.translate(
          text: 'Hello',
          fromLanguage: 'en',
          toLanguage: 'es',
        ),
        throwsException,
      );
    });

    test('respects delay', () async {
      final repo = MockTranslationRepository(
        translations: {'Hello': 'Hola'},
        delay: const Duration(milliseconds: 100),
      );

      final stopwatch = Stopwatch()..start();
      await repo.translate(
        text: 'Hello',
        fromLanguage: 'en',
        toLanguage: 'es',
      );
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
    });
  });
}
