import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class PricingBackground extends StatefulWidget {
  final Widget child;
  const PricingBackground({super.key, required this.child});

  @override
  State<PricingBackground> createState() => _PricingBackgroundState();
}

class _PricingBackgroundState extends State<PricingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20), // Default duration of the animation
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              // _controller.duration = Duration(seconds: 10);
              _controller.repeat();
            },
          ),
        ).animate().fadeIn(
          duration: Duration(seconds: 1),
          delay: Duration(milliseconds: 800),
        ),
        // Builder(
        //   builder: (context) {
        //     return Lottie.network(
        //       'https://lottie.host/b70b435a-8472-4e19-ad03-71579dd08074/zOcB4gAPwC.lottie',
        //       decoder: customDecoder,
        //       fit: BoxFit.fitWidth,
        //     );
        //   },
        // ).animate().fadeIn(
        //   duration: Duration(seconds: 1),
        //   delay: Duration(milliseconds: 800),
        // ),
        SizedBox.fromSize(child: widget.child),
      ],
    );
  }
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
