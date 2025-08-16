import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/pages/initial_chat_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';

class InitialChatView extends ConsumerStatefulWidget {
  const InitialChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InitialChatViewState();
}

class _InitialChatViewState extends ConsumerState<InitialChatView> {
  @override
  Widget build(BuildContext context) {
    final ScrapChatSessionState scrapChatState = ref.watch(scrapChatProvider);

    return Scaffold(
      body: scrapChatState.when(
        withError: ZenErrorTab.new,
        creatingSessionState: () => ChatViewPage(),
        blank: () => ChatViewPage(),
        standard: (Scrappable scrappable, String sessionUuid) {
          return ScrappableEditSessionView(
            scrappable: scrappable,
          );
        },
      ),
    );
  }
}
