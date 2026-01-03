import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/deploy_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/edit_scrappable_request_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/remaining_time_indicator.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/test_endpoint_button.dart';

class ScrappableCurlSection extends ConsumerStatefulWidget {
  final int scrappableId;
  final DateTime targetTime;
  final ReferenceTestData? testData;
  final ScrappingBeeExtractLogic? scrappingBeeExtractLogic;
  final ScrappableRequest? scrappableRequest;
  const ScrappableCurlSection({
    super.key,
    required this.scrappableId,
    required this.targetTime,
    required this.testData,
    required this.scrappingBeeExtractLogic,
    required this.scrappableRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableCurlSectionState();
}

class _ScrappableCurlSectionState extends ConsumerState<ScrappableCurlSection>
    with CurlBuilderMixin {
  late final String displayCurlCommand;
  late final String copiableCurlCommand;
  @override
  void initState() {
    super.initState();
    final client = ref.read(clientProvider);
    final baseUrl = client.host.replaceAll('localhost:8080/', 'localhost:8082');

    // Handle test data and extract payload
    if (widget.testData == null) {
      displayCurlCommand = 'No test data available';
    } else {
      final examplePayload = tryDecode(
        widget.testData!.referenceQueryParametersJson,
      );

      displayCurlCommand = buildSimpleCurl(
        isDisplayCurl: true,
        baseUrl: baseUrl,
        scrappableId: widget.scrappableId,
        isProd: false, // This is the test endpoint
        examplePayload: examplePayload,
      );
      copiableCurlCommand = buildSimpleCurl(
        isDisplayCurl: false,
        baseUrl: baseUrl,
        scrappableId: widget.scrappableId,
        isProd: false, // This is the test endpoint
        examplePayload: examplePayload,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChatLoading = ref.watch(isChatLoadingProvider);
    if (isChatLoading) {
      return Tooltip(
        message: 'Chat is loading...',
        child: Opacity(
          opacity: 0.6,
          child: CodeBlock(
            code: displayCurlCommand,
            leadingWidgets: [
              EditScrappableRequestButton(
                scrappableRequest: widget.scrappableRequest,
                scrappableId: widget.scrappableId,
                isChatLoading: true,
                targetTime: widget.targetTime,
              ),
              TestEndpointButton(
                scrappableId: widget.scrappableId,
                scrappableRequest: widget.scrappableRequest,
                testData: widget.testData,
                targetTime: widget.targetTime,
                isChatLoading: true,
              ),
              RemainingTimeIndicator(widget.targetTime),
            ],
            trailingWidgets: [
              DeployButton(
                scrappableId: widget.scrappableId,
                testData: widget.testData,
                scrappingBeeExtractLogic: widget.scrappingBeeExtractLogic,
                scrappableRequest: widget.scrappableRequest,
              ),
            ],
          ),
        ),
      );
    }

    return CodeBlock(
      copyTooltipMessage: 'Copy the test cURL command',
      code: displayCurlCommand,
      copyCode: copiableCurlCommand,
      leadingWidgets: [
        RemainingTimeIndicator(widget.targetTime),
        EditScrappableRequestButton(
          scrappableRequest: widget.scrappableRequest,
          scrappableId: widget.scrappableId,
          targetTime: widget.targetTime,
        ),
        TestEndpointButton(
          scrappableId: widget.scrappableId,
          scrappableRequest: widget.scrappableRequest,
          testData: widget.testData,
          targetTime: widget.targetTime,
        ),
      ],
      trailingWidgets: [
        DeployButton(
          scrappableId: widget.scrappableId,
          testData: widget.testData,
          scrappingBeeExtractLogic: widget.scrappingBeeExtractLogic,
          scrappableRequest: widget.scrappableRequest,
        ),
      ],
    );
  }
}
