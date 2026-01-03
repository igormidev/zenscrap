import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A header widget for card sections with icon and title
class AiUsageCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Widget? trailing;

  const AiUsageCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? context.c.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: context.t.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
