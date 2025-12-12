import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/language_provider.dart';

/// A Material 3 styled language selector button.
/// Shows current language as a pill/chip with flag emoji and name.
/// On tap, shows a popup menu with all available languages.
class LanguageSelector extends ConsumerWidget {
  /// Whether to show the full language name or just the flag.
  final bool compact;

  /// Optional callback when language changes.
  final ValueChanged<LanguageOption>? onLanguageChanged;

  const LanguageSelector({
    super.key,
    this.compact = false,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return PopupMenuButton<LanguageOption>(
      tooltip: 'Select language',
      offset: const Offset(0, 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: context.c.surfaceContainerHigh,
      elevation: 8,
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (context) => supportedLanguages.map((language) {
        final isSelected = language.code == currentLanguage.code;
        return PopupMenuItem<LanguageOption>(
          value: language,
          child: _LanguageMenuItem(language: language, isSelected: isSelected),
        );
      }).toList(),
      onSelected: (language) {
        ref.read(languageProvider.notifier).setLanguage(language);
        onLanguageChanged?.call(language);
      },
      child: _LanguagePill(language: currentLanguage, compact: compact),
    );
  }
}

/// The pill/chip button that shows current language.
class _LanguagePill extends StatefulWidget {
  final LanguageOption language;
  final bool compact;

  const _LanguagePill({required this.language, required this.compact});

  @override
  State<_LanguagePill> createState() => _LanguagePillState();
}

class _LanguagePillState extends State<_LanguagePill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: widget.compact ? 10 : 14),
        decoration: BoxDecoration(
          color: _isHovered
              ? context.c.primaryContainer
              : context.c.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? context.c.primary.withAlpha(128)
                : context.c.outline.withAlpha(77),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.language.flagEmoji,
              style: TextStyle(fontSize: widget.compact ? 16 : 18),
            ),
            if (!widget.compact) ...[
              const SizedBox(width: 8),
              Text(
                widget.language.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.c.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: context.c.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single language menu item.
class _LanguageMenuItem extends StatelessWidget {
  final LanguageOption language;
  final bool isSelected;

  const _LanguageMenuItem({required this.language, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(language.flagEmoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                language.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.c.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              Text(
                language.nativeName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Icon(Icons.check_rounded, size: 20, color: context.c.primary),
      ],
    );
  }
}

/// A language selector card for use in settings/account pages.
/// Provides a full-width card with language selection.
class LanguageSelectorCard extends ConsumerWidget {
  const LanguageSelectorCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.c.outline.withAlpha(51), width: 1),
        color: context.c.surfaceContainerLowest.withAlpha(100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.c.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: context.c.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Choose your preferred language',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.c.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _LanguageGrid(currentLanguage: currentLanguage),
        ],
      ),
    );
  }
}

/// Grid of language options for the card selector.
class _LanguageGrid extends ConsumerWidget {
  final LanguageOption currentLanguage;

  const _LanguageGrid({required this.currentLanguage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: supportedLanguages.map((language) {
        final isSelected = language.code == currentLanguage.code;
        return _LanguageChip(
          language: language,
          isSelected: isSelected,
          onTap: () {
            ref.read(languageProvider.notifier).setLanguage(language);
          },
        );
      }).toList(),
    );
  }
}

/// A selectable language chip for the grid.
class _LanguageChip extends StatefulWidget {
  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LanguageChip> createState() => _LanguageChipState();
}

class _LanguageChipState extends State<_LanguageChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? context.c.primaryContainer
                : _isHovered
                ? context.c.surfaceContainerHighest
                : context.c.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? context.c.primary
                  : _isHovered
                  ? context.c.outline.withAlpha(128)
                  : context.c.outline.withAlpha(51),
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.language.flagEmoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                widget.language.name,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: widget.isSelected
                      ? context.c.onPrimaryContainer
                      : context.c.onSurface,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
              if (widget.isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: context.c.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
