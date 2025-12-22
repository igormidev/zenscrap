import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// A styled card container matching the AuthView design.
/// Features:
/// - White/onPrimary background
/// - Rounded corners (20px)
/// - Subtle box shadow
class AiUsageCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AiUsageCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    final borderRadiusValue = context.responsiveValue(
      compact: 16.0,
      medium: 18.0,
      expanded: 20.0,
    );

    return Container(
      padding: padding ?? EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: context.c.onPrimary,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

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
