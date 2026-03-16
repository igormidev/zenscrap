import 'package:test/test.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';

void main() {
  group('parseStructuredResponseWithValidation', () {
    test('accepts extract_rules as string', () {
      final response = parseStructuredResponseWithValidation({
        'responseType': 'data',
        'resumeActionMessage': 'done',
        'scrappingBeeFetchSettings': {
          'url': 'https://example.com',
          'extract_rules': '{"title":"h1"}',
          'render_js': false,
          'premium_proxy': false,
          'stealth_proxy': false,
        },
      });

      expect(response.validationReason, isNull);
      expect(
        response.response,
        isA<WebScrapperChatAIResponseOnlyExtractRulesModified>(),
      );
    });

    test('accepts extract_rules as object', () {
      final response = parseStructuredResponseWithValidation({
        'responseType': 'data',
        'resumeActionMessage': 'done',
        'scrappingBeeFetchSettings': {
          'url': 'https://example.com',
          'extract_rules': {'title': 'h1'},
          'render_js': false,
          'premium_proxy': false,
          'stealth_proxy': false,
        },
      });

      expect(response.validationReason, isNull);
      final parsed = response.response;
      expect(parsed, isA<WebScrapperChatAIResponseOnlyExtractRulesModified>());
      final onlyRules =
          parsed as WebScrapperChatAIResponseOnlyExtractRulesModified;
      expect(onlyRules.fetchSettings.extract_rules, '{"title":"h1"}');
    });

    test('flags extract_rules array as retryable shape error', () {
      final response = parseStructuredResponseWithValidation({
        'responseType': 'data',
        'resumeActionMessage': 'done',
        'scrappingBeeFetchSettings': {
          'url': 'https://example.com',
          'extract_rules': [
            {'title': 'h1'},
          ],
          'render_js': false,
          'premium_proxy': false,
          'stealth_proxy': false,
        },
      });

      expect(
        response.validationReason,
        StructuredResponseValidationReason.extractRulesTypeInvalid,
      );
      expect(response.isRetryableValidationFailure, isTrue);
      expect(response.response, isA<WebScrapperChatAIResponseErrorMessage>());
    });

    test('defaults nullable scrappableRequest maps and list', () {
      final response = parseStructuredResponseWithValidation({
        'responseType': 'data',
        'resumeActionMessage': 'done',
        'scrappableRequest': {
          'url': 'https://example.com/search',
          'queryParam': null,
          'queryParamsNotRelatedToUrl': null,
          'pathParams': null,
        },
      });

      expect(response.validationReason, isNull);
      final parsed = response.response;
      expect(parsed, isA<WebScrapperChatAIResponseOnlyRequestModified>());

      final onlyRequest =
          parsed as WebScrapperChatAIResponseOnlyRequestModified;
      expect(onlyRequest.scrappableRequest.queryParam, isEmpty);
      expect(onlyRequest.scrappableRequest.queryParamsNotRelatedToUrl, isEmpty);
      expect(onlyRequest.scrappableRequest.pathParams, isEmpty);
    });

    test('flags invalid scrappableRequest shape as retryable error', () {
      final response = parseStructuredResponseWithValidation({
        'responseType': 'data',
        'resumeActionMessage': 'done',
        'scrappableRequest': {
          'url': 'https://example.com/search',
          'queryParam': ['bad'],
          'queryParamsNotRelatedToUrl': {},
          'pathParams': [],
        },
      });

      expect(
        response.validationReason,
        StructuredResponseValidationReason.scrappableRequestInvalid,
      );
      expect(response.isRetryableValidationFailure, isTrue);
    });
  });
}
