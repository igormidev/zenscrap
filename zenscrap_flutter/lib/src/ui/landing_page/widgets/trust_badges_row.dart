import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A row of trust badges displaying key selling points.
/// Reusable component that can be placed below the Lottie animation
/// or anywhere else on the landing page.
class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TrustBadge(
          icon: Icons.credit_card_off_outlined,
          text: 'No credit card required',
        ),
        const SizedBox(width: 32),
        _TrustBadge(
          icon: Icons.person_off_outlined,
          text: 'No signup to test',
        ),
        const SizedBox(width: 32),
        _TrustBadge(
          icon: Icons.bolt_outlined,
          text: 'Ready in under 2 minutes',
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: context.c.outline,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
