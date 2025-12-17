import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_curl_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_test_response.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/discard_changes_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_chat_textfield.dart';

class ScrappableEditSessionView extends ConsumerWidget {
  final Scrappable scrappable;
  final DateTime testExpirationDate;
  final List<String>? llmThinkingStream;
  const ScrappableEditSessionView({
    super.key,
    required this.scrappable,
    required this.testExpirationDate,
    required this.llmThinkingStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track edit session view
    final analytics = ref.read(analyticsServiceProvider);
    final isAuthenticated = ref.read(clientProvider).auth.isAuthenticated;

    analytics.trackScrappableEditSessionView(
      scrappableId: scrappable.id ?? 0,
      targetUrl: scrappable.targetRequest?.url ?? '',
      isAuthenticated: isAuthenticated,
    );

    final ScrappableRequest? request = scrappable.targetRequest;
    final ScrappingBeeExtractLogic? extractLogic =
        scrappable.scrappingBeeExtractRules;
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
                      Expanded(
                        child: ScrappableChatMessageStreamSection(
                          llmThinkingStream: llmThinkingStream,
                        ),
                      ),
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
                  scrappingBeeExtractLogic: extractLogic,
                  scrappableRequest: request,
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
