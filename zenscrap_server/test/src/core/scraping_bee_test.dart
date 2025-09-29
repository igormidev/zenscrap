import 'package:test/test.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable/scrapping_bee_extract_logic.dart';

void main() {
  test('scraping bee with screenshot...', () async {
    final scrappingBee = ScrapingBee();
    final ExtractFullDataByRule result =
        await scrappingBee.fetchHtmlAndScreenshotWithLogic(
      targetUrl: 'https://www.transfermarkt.com.br/cuca/profil/trainer/4732',
      scrappingBeeExtractLogic: ScrappingBeeExtractLogic(
        extractRules:
            '{  "coach_name": "h1.data-header__headline-wrapper",  "current_club_name": ".data-header__club a",  "current_club_image": "div.data-header__box--big img@src"}',
        jsScenario: null,
        renderJs: false,
        wait: 3000,
        waitFor: null,
        waitBrowser: null,
        premiumProxy: false,
        stealthProxy: false,
        countryCode: null,
        sessionId: null,
        customGoogle: false,
      ),
    );

    expect(result.errorMessage, isNull);
  });

  test('scraping bee default...', () async {
    final scrappingBee = ScrapingBee();
    final ExtractDataByRule result = await scrappingBee.extractByRulesWithLogic(
      targetUrl: 'https://www.transfermarkt.com.br/cuca/profil/trainer/4732',
      scrappingBeeExtractLogic: ScrappingBeeExtractLogic(
        extractRules:
            '{  "coach_name": "h1.data-header__headline-wrapper",  "current_club_name": ".data-header__club a",  "current_club_image": "div.data-header__box--big img@src"}',
        jsScenario: null,
        renderJs: false,
        wait: 3000,
        waitFor: null,
        waitBrowser: null,
        premiumProxy: false,
        stealthProxy: false,
        countryCode: null,
        sessionId: null,
        customGoogle: false,
      ),
    );

    expect(result.errorMessage, isNull);
  });
}
