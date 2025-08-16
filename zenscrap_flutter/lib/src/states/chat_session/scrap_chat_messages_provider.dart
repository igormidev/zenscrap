import 'package:riverpod/riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

final chatMessagesProvider = StateProvider<AsyncValue<List<ChatResponse>>>(
  (ref) {
    return const AsyncValue.loading();
  },
);
