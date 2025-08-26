import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/fullscreen_loading_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/pages/initial_chat_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';

class InitialChatView extends ConsumerStatefulWidget {
  final String? scrappableId;
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

    return Scaffold(
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
              withError: ZenErrorTab.new,
              creatingSessionState: () => ChatViewPage(),
              blank: () => ChatViewPage(),
              standard: (Scrappable scrappable, DateTime testExpirationDate,
                  String sessionUuid) {
                return ScrappableEditSessionView(
                  testExpirationDate: testExpirationDate,
                  scrappable: scrappable,
                );
              },
            );
          }),
    );
  }
}
