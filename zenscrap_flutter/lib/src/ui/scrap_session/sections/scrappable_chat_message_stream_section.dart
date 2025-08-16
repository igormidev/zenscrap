import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';

class ScrappableChatMessageStreamSection extends ConsumerStatefulWidget {
  const ScrappableChatMessageStreamSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableChatMessageStreamSectionState();
}

class _ScrappableChatMessageStreamSectionState
    extends ConsumerState<ScrappableChatMessageStreamSection> {
  @override
  Widget build(BuildContext context) {
    final stream = ref.watch(scrapChatProvider.notifier).chatResponseStream;
    if (stream == null) return SizedBox.shrink();

    return StreamBuilder(
      stream: stream,
      builder: (context, asyncSnapshot) {
        return ListView(
          children: [
            // Todo add the message history
          ],
        );
      },
    );
  }
}
