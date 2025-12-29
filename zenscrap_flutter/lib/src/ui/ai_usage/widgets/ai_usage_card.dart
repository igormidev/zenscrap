import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

// Re-export AiUsageCardHeader for convenience
export 'package:zenscrap_flutter/src/ui/ai_usage/widgets/ai_usage_card_header.dart';

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
