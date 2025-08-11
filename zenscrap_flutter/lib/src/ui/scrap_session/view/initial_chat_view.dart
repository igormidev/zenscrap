import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitialChatView extends ConsumerStatefulWidget {
  const InitialChatView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InitialChatViewState();
}

class _InitialChatViewState extends ConsumerState<InitialChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
