import 'dart:convert';

import 'package:test/scaffolding.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';

void main() {
  test('scraping bee ...', () async {
    final String scrapingBeeApiKey =
        '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K';
    ScrapingBee.initialize(scrapingBeeApiKey);
//     final extractRules = {
//   "coach_name": "h1.data-header__headline-wrapper strong",
//   "current_club_name": "span.data-header__club a",
//   "current_club_image_url": {
//     "selector": ".data-header__box--big a > img",
//     "type": "attribute",
//     "attribute": "src"
//   }
// };
    final extractRules = {
      "coach_name": "h1.data-header__headline-wrapper",
      "current_club_name": ".data-header__club a",
      "current_club_image_url": ".data-header__club img@src"
    };

    final scrappingBee = await ScrapingBee().extractByRules(
      targetUrl: 'https://www.transfermarkt.com.br/cuca/profil/trainer/4732',
      extractRules: jsonEncode(extractRules),
    );
    print(scrappingBee);
  });
}
