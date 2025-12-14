import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CloneSuccessDialog extends StatelessWidget {
  final Scrappable clonedScrappable;

  const CloneSuccessDialog({
    super.key,
    required this.clonedScrappable,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withAlpha(26),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: Colors.green.shade600,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              AppLocalizations.of(context)!.marketplace_clone_success_title,
              style: context.t.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              AppLocalizations.of(context)!.marketplace_clone_success_message(clonedScrappable.name),
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.primary.withAlpha(51),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.marketplace_clone_private_notice,
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/endpoints');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.folder_open_rounded),
                    label: Text(AppLocalizations.of(context)!.marketplace_go_to_endpoints),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/scrappable-form?id=${clonedScrappable.id.toString()}');
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.edit_rounded),
                    label: Text(AppLocalizations.of(context)!.marketplace_edit_scrappable),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.marketplace_close,
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}