import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';

final isChatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatMessagesProvider.select((value) => value.maybeMap(
        data: (data) => data.value.willShowLoading,
        orElse: () => false,
      )));
});

extension MessagesExt on List<ChatResponse> {
  bool get willHideLoading {
    return !willShowLoading;
  }

  bool get willShowLoading {
    if (isEmpty) return false;

    final ChatResponse lastItem = last;

    if (lastItem.role == PromptRole.user) {
      return true;
    } else if (lastItem.role == PromptRole.model) {
      if (lastItem is MessageTextResponse) return false;
      if (lastItem is ErrorTextResponse) return false;
      return true;
    } else {
      // lastItem.role == PromptRole.system
      if (lastItem is MessageTextResponse) return false;
      if (lastItem is ErrorTextResponse) return false;
      return true;
    }
  }
}
