import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/dialogs/test_endpoint_dialog.dart';

class TestEndpointButton extends StatelessWidget {
  final int scrappableId;
  final ScrappableRequest? scrappableRequest;
  final ReferenceTestData? testData;
  final DateTime targetTime;

  const TestEndpointButton({
    super.key,
    required this.scrappableId,
    required this.scrappableRequest,
    required this.testData,
    required this.targetTime,
  });

  @override
  Widget build(BuildContext context) {
    if (scrappableRequest == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(
        Icons.science,
        size: 18,
        color: context.c.tertiary,
      ),
      tooltip: 'Test endpoint',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => TestEndpointDialog(
            scrappableId: scrappableId,
            scrappableRequest: scrappableRequest!,
            testData: testData,
            targetTime: targetTime,
          ),
        );
      },
    );
  }
}
