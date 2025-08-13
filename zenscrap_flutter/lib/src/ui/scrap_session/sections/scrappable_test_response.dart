import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/scrappable_test_json_response_viewer.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/test_link_card.dart';

class ScrappableTestResponse extends StatelessWidget {
  final String testLink;
  final Map<String, dynamic> testJsonResponse;
  const ScrappableTestResponse({
    super.key,
    required this.testLink,
    required this.testJsonResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Scrapper test response'),
        SizedBox(height: 8),
        TestLinkCard(testLink: testLink),
        SizedBox(height: 8),
        ScrappableTestJsonResponseViewer(
          testResponse: testJsonResponse,
        ),
      ],
    );
  }
}
