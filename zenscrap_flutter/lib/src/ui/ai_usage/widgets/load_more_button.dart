import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A styled "Load More" button for paginated lists.
class LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String? label;

  const LoadMoreButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? AppLocalizations.of(context)!.ai_usage_load_more;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: context.c.outline.withAlpha(100),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.c.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.expand_more, size: 20),
                  const SizedBox(width: 8),
                  Text(displayLabel),
                ],
              ),
      ),
    );
  }
}
