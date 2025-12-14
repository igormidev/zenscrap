import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class BrightnessPicker extends StatefulWidget {
  final Brightness brightness;
  final ValueChanged<Brightness> onBrightnessChanged;

  const BrightnessPicker({
    super.key,
    required this.brightness,
    required this.onBrightnessChanged,
  });

  @override
  State<BrightnessPicker> createState() => _BrightnessPickerState();
}

class _BrightnessPickerState extends State<BrightnessPicker> {
  Future<void> _handleDarkModeSelection() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.science_rounded,
            size: 32,
            color: Colors.amber.shade700,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(dialogContext)!.account_dark_mode_title),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(dialogContext)!.account_beta_badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Text(
            AppLocalizations.of(dialogContext)!.account_dark_mode_beta_warning,
            style: Theme.of(dialogContext).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(MaterialLocalizations.of(dialogContext).okButtonLabel),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onBrightnessChanged(Brightness.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.brightness == Brightness.dark;

    return Row(
      children: [
        _BrightnessOption(
          icon: Icons.light_mode_rounded,
          label: AppLocalizations.of(context)!.account_brightness_light,
          isSelected: !isDark,
          onTap: () => widget.onBrightnessChanged(Brightness.light),
        ),
        const SizedBox(width: 12),
        _BrightnessOption(
          icon: Icons.dark_mode_rounded,
          label: AppLocalizations.of(context)!.account_brightness_dark,
          isSelected: isDark,
          onTap: isDark ? null : _handleDarkModeSelection,
          showBetaBadge: true,
        ),
      ],
    );
  }
}

class _BrightnessOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showBetaBadge;

  const _BrightnessOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.showBetaBadge = false,
  });

  @override
  State<_BrightnessOption> createState() => _BrightnessOptionState();
}

class _BrightnessOptionState extends State<_BrightnessOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.onTap != null;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? context.c.primaryContainer
                  : (_isHovered
                      ? context.c.surfaceContainerHighest
                      : context.c.surfaceContainerLow),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isSelected
                    ? context.c.primary
                    : (_isHovered ? context.c.outline : Colors.transparent),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: context.c.primary.withAlpha(40),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? context.c.primary.withAlpha(30)
                            : context.c.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 24,
                        color: widget.isSelected
                            ? context.c.primary
                            : context.c.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: widget.isSelected
                                ? context.c.primary
                                : context.c.onSurface,
                          ),
                    ),
                  ],
                ),
                if (widget.showBetaBadge)
                  Positioned(
                    top: -8,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade600,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withAlpha(80),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.account_beta_badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
