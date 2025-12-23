import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/language_provider.dart';
import 'package:zenscrap_flutter/src/states/translation/translation_provider.dart';

/// A widget that displays text with automatic translation support.
/// Shows a toggle button to switch between original and translated text.
class TranslatableText extends ConsumerWidget {
  /// The original text to display/translate.
  final String text;

  /// The source language code (e.g., "enUS", "ptBR").
  /// If null, no translation will be attempted.
  final String? sourceLanguage;

  /// The text style to apply.
  final TextStyle? style;

  /// Maximum number of lines to display.
  final int? maxLines;

  /// How to handle text overflow.
  final TextOverflow? overflow;

  /// Whether this is a title (larger text, bolder styling).
  final bool isTitle;

  /// Whether to show the translation toggle icon.
  /// If false, translation will still happen but no toggle will be shown.
  final bool showToggle;

  const TranslatableText({
    super.key,
    required this.text,
    this.sourceLanguage,
    this.style,
    this.maxLines,
    this.overflow,
    this.isTitle = false,
    this.showToggle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no source language provided, just show the original text
    if (sourceLanguage == null || sourceLanguage!.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Check if translation is needed
    final currentLanguage = ref.watch(languageProvider);
    final sourceCode = _extractLanguageCode(sourceLanguage!);
    final targetCode = currentLanguage.locale.languageCode;

    // If same language, no translation needed
    if (sourceCode == targetCode) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Watch the translation state
    final translationState = ref.watch(
      translationProvider((text: text, sourceLanguage: sourceLanguage!)),
    );

    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            translationState.displayText,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
        if (showToggle) ...[
          const SizedBox(width: 4),
          _TranslationToggleButton(
            state: translationState,
            l10n: l10n,
            onToggle: () {
              ref
                  .read(translationProvider(
                          (text: text, sourceLanguage: sourceLanguage!))
                      .notifier)
                  .toggleShowOriginal();
            },
          ),
        ],
      ],
    );
  }

  /// Extracts the 2-letter language code from format like "enUS" or "pt_BR"
  String _extractLanguageCode(String languageCode) {
    if (languageCode.isEmpty) return 'en';

    // Handle formats like "enUS", "ptBR", "en_US", "pt_BR", "en-US", "pt-BR"
    final cleaned = languageCode.replaceAll(RegExp(r'[-_]'), '');

    // Take first 2 characters (language code)
    if (cleaned.length >= 2) {
      return cleaned.substring(0, 2).toLowerCase();
    }

    return languageCode.toLowerCase();
  }
}

/// A small button to toggle between original and translated text.
class _TranslationToggleButton extends StatelessWidget {
  final TranslationState state;
  final AppLocalizations l10n;
  final VoidCallback onToggle;

  const _TranslationToggleButton({
    required this.state,
    required this.l10n,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while translating
    if (state.isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.c.primary,
        ),
      );
    }

    // Don't show toggle if translation is not available
    if (!state.canToggle) {
      return const SizedBox.shrink();
    }

    final tooltip = state.showOriginal
        ? l10n.common_show_translated
        : l10n.common_show_original;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(
            state.showOriginal ? Icons.translate : Icons.text_fields,
            size: 16,
            color: context.c.primary.withAlpha(state.showOriginal ? 180 : 255),
          ),
        ),
      ),
    );
  }
}

/// A widget for displaying a title with translation support.
/// Similar to TranslatableText but optimized for title display in cards/dialogs.
class TranslatableTitle extends ConsumerWidget {
  final String text;
  final String? sourceLanguage;
  final TextStyle? style;
  final int maxLines;

  const TranslatableTitle({
    super.key,
    required this.text,
    this.sourceLanguage,
    this.style,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TranslatableText(
      text: text,
      sourceLanguage: sourceLanguage,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      isTitle: true,
      showToggle: true,
    );
  }
}

/// A widget for displaying a description with translation support.
/// Similar to TranslatableText but optimized for multi-line description display.
class TranslatableDescription extends ConsumerWidget {
  final String text;
  final String? sourceLanguage;
  final TextStyle? style;
  final int maxLines;

  const TranslatableDescription({
    super.key,
    required this.text,
    this.sourceLanguage,
    this.style,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TranslatableText(
      text: text,
      sourceLanguage: sourceLanguage,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      isTitle: false,
      showToggle: true,
    );
  }
}
