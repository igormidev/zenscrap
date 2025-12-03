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

  /// Returns true if loading indicator should be shown.
  ///
  /// The logic is simple: the server explicitly tells us via [expectsFollowUp]
  /// whether more messages are expected. This eliminates brittle heuristics
  /// based on message types and roles.
  bool get willShowLoading {
    if (isEmpty) return false;
    return last.expectsFollowUp;
  }
}
