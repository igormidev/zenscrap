import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';

final isChatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatMessagesProvider.select((value) => value.maybeMap(
        data: (data) => !data.value.willHideLoading,
        orElse: () => false,
      )));
});

extension MessagesExt on List<ChatResponse> {
  bool get willHideLoading {
    if (isEmpty) return false;
    final ChatResponse lastItem = last;
    final bool hasOnlyUserMessage = length == 1;
    final bool willHideLoading = !hasOnlyUserMessage &&
        (lastItem.role == PromptRole.user ||
            lastItem is ErrorTextResponse ||
            lastItem is NewExtractRuleResponse ||
            (lastItem is MessageTextResponse &&
                lastItem.role == PromptRole.model));

    return willHideLoading;
  }
}
