import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/scrappable_test_json_response_viewer.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/test_link_card.dart';

class ScrappableTestResponse extends StatelessWidget {
  final ReferenceTestData? testData;
  const ScrappableTestResponse({
    super.key,
    required this.testData,
  });

  @override
  Widget build(BuildContext context) {
    final testData = this.testData;
    if (testData == null) return SizedBox.fromSize();
    final String? extractedJsonResult =
        testData.scrappableTestResult?.extractJsonResult;
    final Map<String, dynamic>? mappedResponse = tryDecode(extractedJsonResult);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        TestLinkCard(testLink: testData.referenceLinkUsed),
        SizedBox(height: 8),
        Expanded(
          child: ScrappableTestJsonResponseViewer(
            testResponse: mappedResponse,
            htmlData: testData.referenceHtmlPage,
            screenshotData: testData.referenceSiteScreenshot,
          ),
        ),
      ],
    );
  }
}
