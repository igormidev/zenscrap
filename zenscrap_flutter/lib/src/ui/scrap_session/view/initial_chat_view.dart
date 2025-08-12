import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/pages/initial_chat_page.dart';

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
        initial: () => ChatViewPage(),
        loading: () => ChatViewPage(),
        withData: (Scrappable scrappable) {
          final decoded = jsonDecode(scrappable.scrappingRules) as Map;
          final json = JsonEncoder.withIndent('  ').convert(decoded);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(scrappable.name, style: context.t.displayMedium),
                SizedBox(height: 16),
                Text(scrappable.description, style: context.t.bodyLarge),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: context.c.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(json, style: context.t.bodyLarge),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
