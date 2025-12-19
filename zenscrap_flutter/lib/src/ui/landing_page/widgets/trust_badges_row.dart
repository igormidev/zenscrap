import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// A row of trust badges displaying key selling points.
/// Reusable component that can be placed below the Lottie animation
/// or anywhere else on the landing page.
/// Uses Wrap on mobile to handle narrow screens gracefully.
class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final badges = [
      _TrustBadge(
        icon: Icons.credit_card_off_outlined,
        text: l10n.landing_trust_no_credit_card,
      ),
      _TrustBadge(
        icon: Icons.person_off_outlined,
        text: l10n.landing_trust_no_signup,
      ),
      _TrustBadge(
        icon: Icons.bolt_outlined,
        text: l10n.landing_trust_ready_in_minutes,
      ),
    ];

    // Use Wrap which automatically handles wrapping on narrow screens
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: context.responsiveValue(
        compact: 16.0,
        expanded: 32.0,
      ),
      runSpacing: 12.0,
      children: badges,
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
        Flexible(
          child: Text(
            text,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
