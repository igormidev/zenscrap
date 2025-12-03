import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedThinkingDots extends StatefulWidget {
  final Color color;
  final double size;
  final double spacing;

  const AnimatedThinkingDots({
    super.key,
    required this.color,
    this.size = 6,
    this.spacing = 2,
  });

  @override
  State<AnimatedThinkingDots> createState() => _AnimatedThinkingDotsState();
}

class _AnimatedThinkingDotsState extends State<AnimatedThinkingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Create a wave effect with phase shift for each dot
            final phase = (index * 0.35) + _controller.value * 2 * math.pi;
            // Use sine wave for smooth up and down motion
            final offset = math.sin(phase) * 6;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing),
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color.withAlpha(179),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}