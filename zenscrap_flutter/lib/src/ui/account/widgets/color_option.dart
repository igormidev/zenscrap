import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

class ColorOption extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  factory ColorOption.fromColor(
    Color color, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ColorOption(
      color: color,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  @override
  State<ColorOption> createState() => _ColorOptionState();
}

class _ColorOptionState extends State<ColorOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = widget.color.computeLuminance() > 0.5;
    final checkColor = isLight ? Colors.black87 : Colors.white;

    final size = context.responsiveValue(
      compact: 38.0,
      medium: 40.0,
      expanded: 42.0,
    );

    final iconSize = context.responsiveValue(
      compact: 20.0,
      medium: 21.0,
      expanded: 22.0,
    );

    final borderWidth = context.responsiveValue(
      compact: 2.0,
      medium: 2.5,
      expanded: 3.0,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isSelected
                    ? context.c.primary
                    : (_isHovered ? context.c.outline : Colors.transparent),
                width: widget.isSelected ? borderWidth : borderWidth - 1,
              ),
              boxShadow: [
                if (widget.isSelected || _isHovered)
                  BoxShadow(
                    color: widget.color.withAlpha(100),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: widget.isSelected ? 1.0 : 0.0,
              child: Icon(
                Icons.check_rounded,
                color: checkColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
