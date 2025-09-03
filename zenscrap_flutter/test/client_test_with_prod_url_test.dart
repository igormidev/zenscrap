// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

void main() {
  // testWidgets('Client connects to production URL', (WidgetTester tester) async {
  test('Client connects to production URL', () async {
    //Arrange
    final client = Client(
      'https://api.zenscrap.com/',
      connectionTimeout: Duration(minutes: 4),
    );

    //Act - Assert
    final Scrappable scrappable = await client.createScrappable(
      referenceLink:
          'https://www.transfermarkt.com.br/cuca/profil/trainer/4732',
    );

    //Assert
    // If there is no error, everything is correct!
    print(scrappable.name);
    print(scrappable.description);
  }, timeout: Timeout(Duration(minutes: 4)));
}
