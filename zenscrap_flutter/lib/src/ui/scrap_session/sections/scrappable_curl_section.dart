import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/deploy_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/remaining_time_indicator.dart';

class ScrappableCurlSection extends ConsumerStatefulWidget {
  final UuidValue scrappableId;
  final DateTime targetTime;
  final ReferenceTestData? testData;
  const ScrappableCurlSection({
    super.key,
    required this.scrappableId,
    required this.targetTime,
    required this.testData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableCurlSectionState();
}

class _ScrappableCurlSectionState extends ConsumerState<ScrappableCurlSection>
    with CurlBuilderMixin {
  late final String code;
  @override
  void initState() {
    super.initState();
    final client = ref.read(clientProvider);
    final baseUrl = client.host.replaceAll('localhost:8080', 'localhost:8082');

    code = buildCurl(
      baseUrl: baseUrl,
      scrappableId: widget.scrappableId,
      testData: widget.testData,
      isProd: false, // This is the test endpoint
    );
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
            code: code,
            leadingWidgets: [RemainingTimeIndicator(widget.targetTime)],
            trailingWidgets: [DeployButton()],
          ),
        ),
      );
    }

    return CodeBlock(
      code: code,
      leadingWidgets: [RemainingTimeIndicator(widget.targetTime)],
      trailingWidgets: [DeployButton()],
    );
  }
}
