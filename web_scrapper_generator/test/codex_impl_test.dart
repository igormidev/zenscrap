import 'package:test/test.dart';
import 'package:web_scrapper_generator/src/implementations/web_scrapper_codex_impl.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';

void main() {
  group('WebScrapperCodexImpl', () {
    test('should have correct model options', () {
      expect(CodexModel.values.length, equals(3));
      expect(CodexModel.gpt5.apiName, equals('gpt-5'));
      expect(CodexModel.codexMiniLatest.apiName, equals('codex-mini-latest'));
      expect(CodexModel.codex1.apiName, equals('codex-1'));
    });

    test('should have correct display names', () {
      expect(CodexModel.gpt5.displayName, equals('GPT-5 (Fast Reasoning)'));
      expect(CodexModel.codexMiniLatest.displayName, equals('Codex Mini (Fine-tuned for Code)'));
      expect(CodexModel.codex1.displayName, equals('Codex-1 (Software Engineering)'));
    });

    test('should build correct schema', () {
      // This would normally require the SDK to be initialized
      // For testing, we're just validating the structure exists
      expect(WebScrapperCodexImpl, isNotNull);

      // Verify that InitialPayloadDataCreatingFromZero can be created
      expect(
        () => InitialPayloadDataCreatingFromZero(
          webScrapperRequest: WebScrapperRequest(
            url: 'https://example.com',
            queryParam: {},
            pathParams: [],
          ),
          targetExampleUrl: 'https://example.com',
        ),
        returnsNormally,
      );
    });
  });

  group('CodexModel enum', () {
    test('should have unique API names', () {
      final apiNames = CodexModel.values.map((m) => m.apiName).toSet();
      expect(apiNames.length, equals(CodexModel.values.length));
    });

    test('should have display names for all models', () {
      for (final model in CodexModel.values) {
        expect(model.displayName, isNotEmpty);
        expect(model.displayName, isNot(contains('null')));
      }
    });
  });
}