import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

class ChatViewPage extends ConsumerStatefulWidget {
  const ChatViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends ConsumerState<ChatViewPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Lottie.network(
            'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
            decoder: customDecoder,
            fit: BoxFit.fitWidth,
            controller: _controller,
            onLoaded: (composition) {
              _controller.repeat();
            },
          ),
        ).animate().fadeIn(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 800),
            ),
        LayoutBuilder(builder: (context, constraints) {
          // final double screenWidth = MediaQuery.sizeOf(context).width;
          final double screenWidth = constraints.maxWidth;
          final bool isCompactSize = screenWidth < 1060.0;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isCompactSize ? 600 : 1700),
            ),
          );
        })
      ],
    );
  }
}
