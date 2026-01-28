import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A warning card displayed when a user tries to sign up/login with an
/// incomplete scrappable (one that doesn't have extract rules defined yet).
///
/// This warns the user that the scrappable shown below will NOT be attached
/// to their account because it's not ready for use.
class IncompleteScrappableWarningCard extends StatelessWidget {
  const IncompleteScrappableWarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.auth_incomplete_scrappable_warning_title,
                  style: context.t.labelMedium?.copyWith(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.auth_incomplete_scrappable_warning_message,
                  style: context.t.bodySmall?.copyWith(
                    color: Colors.amber.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
