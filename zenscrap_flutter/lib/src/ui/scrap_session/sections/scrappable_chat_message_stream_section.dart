import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return ListView(
      children: [
        // Todo add the message history
      ],
    );
  }
}
