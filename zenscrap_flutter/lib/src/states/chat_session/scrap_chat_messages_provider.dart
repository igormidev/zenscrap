import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

/// Notifier for managing chat messages state.
class ChatMessagesNotifier extends Notifier<AsyncValue<List<ChatResponse>>> {
  @override
  AsyncValue<List<ChatResponse>> build() => const AsyncValue.loading();

  void setMessages(AsyncValue<List<ChatResponse>> messages) {
    state = messages;
  }

  void addMessage(ChatResponse message) {
    state = state.maybeMap(
      data: (data) => AsyncValue.data([...data.value, message]),
      orElse: () => AsyncValue.data([message]),
    );
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final chatMessagesProvider =
    NotifierProvider<ChatMessagesNotifier, AsyncValue<List<ChatResponse>>>(
        ChatMessagesNotifier.new);
