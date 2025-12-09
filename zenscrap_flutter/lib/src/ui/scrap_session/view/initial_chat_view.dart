import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/ip_limit_error_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/fullscreen_loading_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/pages/initial_chat_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/ai_thinking_stream_view.dart';

class InitialChatView extends ConsumerStatefulWidget {
  final int? scrappableId;
  const InitialChatView({
    super.key,
    required this.scrappableId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InitialChatViewState();
}

class _InitialChatViewState extends ConsumerState<InitialChatView> {
  final Completer<void> _initializationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.scrappableId != null) {
      unawaited(ref.read(scrapChatProvider.notifier).endSession());
      Future.delayed(const Duration(seconds: 3), () async {
        await ref
            .read(scrapChatProvider.notifier)
            .createSessionWithScrappableId(widget.scrappableId!);
        _initializationCompleter.complete();
      });
    } else {
      _initializationCompleter.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrapChatSessionState scrapChatState = ref.watch(scrapChatProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FutureBuilder(
          future: _initializationCompleter.future,
          builder: (context, asyncSnapshot) {
            final isLoading =
                asyncSnapshot.connectionState == ConnectionState.waiting;
            if (isLoading) {
              return FullpageLoadingPage(
                loadingMessage: 'Creating session...',
              );
            }

            return scrapChatState.when(
              withError: (exception) {
                // Check if this is an IP limit error
                if (exception.title == 'Usage Limit Reached') {
                  return IpLimitErrorView(exception: exception);
                }
                // Default error handling for other errors
                return ZenErrorTab(exception);
              },
              creatingSessionState: () => InitialChatPage(),
              blank: () => InitialChatPage(),
              creatingScrappable: (
                String referenceLink,
                List<String> thinkingChunks,
                GroundingMetadataInfo? groundingMetadata,
              ) {
                return AiThinkingStreamView(
                  referenceLink: referenceLink,
                  thinkingChunks: thinkingChunks,
                  groundingMetadata: groundingMetadata,
                );
              },
              standard: (
                Scrappable scrappable,
                DateTime testExpirationDate,
                String sessionUuid,
                List<String>? llmThinkingStream,
              ) {
                return ScrappableEditSessionView(
                  testExpirationDate: testExpirationDate,
                  scrappable: scrappable,
                  llmThinkingStream: llmThinkingStream,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
