import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/elements/animated_switch.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_edit_visualization.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_test_json_response_viewer.dart';

class ScrappableTestResponse extends StatefulWidget {
  final Scrappable scrappable;
  final ReferenceTestData? testData;
  const ScrappableTestResponse({
    super.key,
    required this.scrappable,
    required this.testData,
  });

  @override
  State<ScrappableTestResponse> createState() => _ScrappableTestResponseState();
}

class _ScrappableTestResponseState extends State<ScrappableTestResponse>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 2, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testData = widget.testData;
    if (testData == null) return SizedBox.fromSize();
    final String? extractedJsonResult =
        testData.scrappableTestResult?.extractJsonResult;
    // testData.scrappableTestResult?.testExtractRule;
    final Map<String, dynamic>? mappedResponse = tryDecode(extractedJsonResult);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        ZenAnimatedSwitch(
          tabController: tabController,
          tabs: [
            AnimatedSwitchItem("Test suite"),
            AnimatedSwitchItem("Scrappable info"),
          ],
        ),
        SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ScrappableTestJsonResponseViewer(
                testResponse: mappedResponse,
                htmlData: testData.byteData?.referenceHtmlPage,
                screenshotData: testData.byteData?.referenceSiteScreenshot,
              ),
              ScrappableEditVisualization(
                scrappable: widget.scrappable,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
