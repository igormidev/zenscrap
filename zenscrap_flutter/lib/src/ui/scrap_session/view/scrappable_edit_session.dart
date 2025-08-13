import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_curl_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_test_response.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_chat_textfield.dart';

class ScrappableEditSessionView extends StatelessWidget {
  final String testLink;
  final Map<String, dynamic> testJsonResponse;
  final Scrappable? request;
  const ScrappableEditSessionView({
    super.key,
    this.request,
    required this.testLink,
    required this.testJsonResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(child: ScrappableChatMessageStreamSection()),
              ZenChatTextfield(),
            ],
          ),
        ),
        Expanded(
          child: Column(children: [
            ScrappableCurlSection(request: request!.targetRequest!),
            SizedBox(height: 20),
            Expanded(
              child: ScrappableTestResponse(
                testLink: testLink,
                testJsonResponse: testJsonResponse,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
