import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_curl_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_test_response.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/discard_changes_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_chat_textfield.dart';

class ScrappableEditSessionView extends StatelessWidget {
  final Scrappable scrappable;
  final DateTime testExpirationDate;
  const ScrappableEditSessionView({
    super.key,
    required this.scrappable,
    required this.testExpirationDate,
  });

  @override
  Widget build(BuildContext context) {
    final ScrappableRequest? request = scrappable.targetRequest;
    final ReferenceTestData? testData = scrappable.referenceTestData;
    if (request == null) return SizedBox.fromSize();

    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20),
                  child: Column(
                    children: [
                      Expanded(child: ScrappableChatMessageStreamSection()),
                      ZenChatTextfield(
                        targetTime: testExpirationDate,
                      ),
                    ],
                  ),
                ),
              ),
              DiscardChangesButton(),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScrappableCurlSection(
                  targetTime: testExpirationDate,
                  scrappableId: scrappable.id!,
                  testData: testData,
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ScrappableTestResponse(
                    scrappable: scrappable,
                    testData: testData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
