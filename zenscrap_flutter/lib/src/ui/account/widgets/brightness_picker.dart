import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final isDark = widget.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BrightnessOption(
              icon: Icons.light_mode_rounded,
              label: 'Light',
              isSelected: !isDark,
              onTap: () => widget.onBrightnessChanged(Brightness.light),
            ),
            const SizedBox(width: 12),
            _BrightnessOption(
              icon: Icons.dark_mode_rounded,
              label: 'Dark',
              isSelected: isDark,
              onTap: () => widget.onBrightnessChanged(Brightness.dark),
              showBetaBadge: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _DarkModeBetaWarning(),
      ],
    );
  }
}

class _BrightnessOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBetaBadge;

  const _BrightnessOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showBetaBadge = false,
  });

  @override
  State<_BrightnessOption> createState() => _BrightnessOptionState();
}

class _BrightnessOptionState extends State<_BrightnessOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
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
                      child: const Text(
                        'BETA',
                        style: TextStyle(
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

class _DarkModeBetaWarning extends StatelessWidget {
  const _DarkModeBetaWarning();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final warningColor = isDark ? Colors.amber.shade400 : Colors.amber.shade700;
    final backgroundColor = isDark
        ? Colors.amber.shade900.withAlpha(40)
        : Colors.amber.shade50;
    final borderColor = isDark
        ? Colors.amber.shade700.withAlpha(60)
        : Colors.amber.shade200;
    final titleColor = isDark ? Colors.amber.shade300 : Colors.amber.shade800;
    final textColor = isDark ? Colors.amber.shade200 : Colors.amber.shade900;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: warningColor.withAlpha(isDark ? 40 : 30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.science_rounded,
              color: warningColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: warningColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BETA',
                        style: TextStyle(
                          color: isDark ? Colors.black87 : Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Some UI elements may not display perfectly. We\'re actively improving it.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textColor,
                        height: 1.4,
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
