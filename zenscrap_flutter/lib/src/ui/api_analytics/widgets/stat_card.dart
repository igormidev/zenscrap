import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 12.0,
          medium: 14.0,
          expanded: 14.0,
        ),
        vertical: context.responsiveValue(
          compact: 8.0,
          medium: 10.0,
          expanded: 10.0,
        ),
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 16.0,
          ),
        ),
        border: Border.all(
          color: color.withAlpha(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: context.t.titleMedium?.copyWith(
              color: color.withAlpha(230),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: context.t.bodySmall?.copyWith(
              color: color.withAlpha(200),
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
