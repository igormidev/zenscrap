import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final String? tooltip;

  const StatCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withAlpha(100),
        ),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: context.t.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: context.t.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        // Change hover time to trigger faster
        waitDuration: const Duration(milliseconds: 900),
        child: card,
      );
    }

    return card;
  }
}
