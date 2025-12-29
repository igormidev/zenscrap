import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/email_typo_detector.dart';

/// Result of the email typo dialog.
enum EmailTypoDialogResult {
  /// User accepted the suggested correction.
  useSuggested,

  /// User wants to keep the original email.
  keepOriginal,

  /// User cancelled the dialog.
  cancel,
}

/// Shows a beautiful Material 3 dialog asking the user to confirm
/// whether they want to use the corrected email or keep the original.
///
/// Returns [EmailTypoDialogResult] indicating the user's choice.
Future<EmailTypoDialogResult?> showEmailTypoDialog({
  required BuildContext context,
  required EmailTypoResult typoResult,
}) async {
  return showDialog<EmailTypoDialogResult>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _EmailTypoDialog(typoResult: typoResult),
  );
}

class _EmailTypoDialog extends StatelessWidget {
  final EmailTypoResult typoResult;

  const _EmailTypoDialog({required this.typoResult});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            _TypoDialogHeader(colorScheme: colorScheme),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question text
                  Text(
                    l10n.email_typo_dialog_title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 300.ms)
                      .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 300.ms),

                  const SizedBox(height: 20),

                  // Email comparison cards
                  _EmailComparisonCards(
                    typoResult: typoResult,
                    colorScheme: colorScheme,
                    theme: theme,
                    l10n: l10n,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Action buttons
            _TypoActionButtons(l10n: l10n),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 200.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 250.ms, curve: Curves.easeOutBack);
  }
}

/// Header section with animated icon and title
class _TypoDialogHeader extends StatelessWidget {
  final ColorScheme colorScheme;

  const _TypoDialogHeader({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Animated icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spellcheck_rounded,
              size: 28,
              color: colorScheme.primary,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.08, 1.08),
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 12),

          // Title
          Text(
            AppLocalizations.of(context)!.email_typo_dialog_header,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
        ],
      ),
    );
  }
}

/// Email comparison cards showing original and suggested emails
class _EmailComparisonCards extends StatelessWidget {
  final EmailTypoResult typoResult;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final AppLocalizations l10n;

  const _EmailComparisonCards({
    required this.typoResult,
    required this.colorScheme,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Original email (with error highlight)
        _EmailCard(
          label: l10n.email_typo_you_typed,
          email: typoResult.originalEmail,
          highlightDomain: typoResult.originalDomain,
          isError: true,
          colorScheme: colorScheme,
          theme: theme,
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 300.ms)
            .slideX(begin: -0.05, end: 0, delay: 300.ms, duration: 300.ms),

        const SizedBox(height: 12),

        // Arrow indicator
        Icon(
          Icons.arrow_downward_rounded,
          color: colorScheme.primary,
          size: 24,
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 200.ms)
            .then()
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(begin: 0, end: 4, duration: 800.ms, curve: Curves.easeInOut),

        const SizedBox(height: 12),

        // Suggested email (with success highlight)
        _EmailCard(
          label: l10n.email_typo_did_you_mean,
          email: typoResult.suggestedEmail,
          highlightDomain: typoResult.suggestedDomain,
          isError: false,
          colorScheme: colorScheme,
          theme: theme,
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 300.ms)
            .slideX(begin: 0.05, end: 0, delay: 500.ms, duration: 300.ms),
      ],
    );
  }
}

/// Action buttons for the typo dialog
class _TypoActionButtons extends StatelessWidget {
  final AppLocalizations l10n;

  const _TypoActionButtons({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primary action: Use suggested email
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(EmailTypoDialogResult.useSuggested),
            icon: const Icon(Icons.check_rounded, size: 20),
            label: Text(l10n.email_typo_use_suggestion),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 600.ms, duration: 300.ms),

          const SizedBox(height: 8),

          // Secondary action: Keep original
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(EmailTypoDialogResult.keepOriginal),
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: Text(l10n.email_typo_keep_original),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 300.ms)
              .slideY(begin: 0.1, end: 0, delay: 700.ms, duration: 300.ms),
        ],
      ),
    );
  }
}

/// Card displaying an email with domain highlighting.
class _EmailCard extends StatelessWidget {
  final String label;
  final String email;
  final String highlightDomain;
  final bool isError;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _EmailCard({
    required this.label,
    required this.email,
    required this.highlightDomain,
    required this.isError,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final atIndex = email.lastIndexOf('@');
    final localPart = atIndex > 0 ? email.substring(0, atIndex + 1) : email;
    final domainPart = atIndex > 0 ? email.substring(atIndex + 1) : '';

    final highlightColor = isError ? colorScheme.error : colorScheme.primary;
    final bgColor = isError
        ? colorScheme.errorContainer.withValues(alpha: 0.3)
        : colorScheme.primaryContainer.withValues(alpha: 0.3);
    final borderColor = isError
        ? colorScheme.error.withValues(alpha: 0.5)
        : colorScheme.primary.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Icon(
                isError ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                size: 16,
                color: highlightColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: highlightColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Email with highlighted domain
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: localPart,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    fontFamily: 'monospace',
                  ),
                ),
                TextSpan(
                  text: domainPart,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: highlightColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    decoration: isError ? TextDecoration.lineThrough : null,
                    decorationColor: highlightColor,
                    decorationThickness: 2,
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
