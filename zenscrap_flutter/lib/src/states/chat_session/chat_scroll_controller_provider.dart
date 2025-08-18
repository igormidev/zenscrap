import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatScrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final chatScrollHelperProvider = Provider<ChatScrollHelper>((ref) {
  final controller = ref.watch(chatScrollControllerProvider);
  return ChatScrollHelper(controller);
});

class ChatScrollHelper {
  final ScrollController _controller;

  ChatScrollHelper(this._controller);

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}