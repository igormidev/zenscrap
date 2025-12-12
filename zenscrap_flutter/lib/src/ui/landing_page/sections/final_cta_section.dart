import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/legal/terms_of_service_dialog.dart';

/// Final call-to-action section at the bottom of the landing page.
/// Drives urgency and provides a clear path to action.
class FinalCtaSection extends StatelessWidget {
  /// Callback when user wants to scroll to top/hero section
  final VoidCallback? onScrollToTop;

  /// Callback when user clicks "Create Your First Scraper" button
  final VoidCallback? onCreateScraperTap;

  /// Callback when user clicks "Browse Marketplace" button
  final VoidCallback? onBrowseMarketplaceTap;

  const FinalCtaSection({
    super.key,
    this.onScrollToTop,
    this.onCreateScraperTap,
    this.onBrowseMarketplaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      // Transparent background to show Lottie behind
      child: Column(
        children: [
          Text(
            l10n.landing_cta_title,
            style: context.t.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.c.onSurface,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              l10n.landing_cta_subtitle,
              style: context.t.titleMedium?.copyWith(
                color: context.c.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  onCreateScraperTap?.call();
                  onScrollToTop?.call();
                },
                icon: const Icon(Icons.rocket_launch_rounded),
                label: Text(l10n.landing_cta_create_button),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  textStyle: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {
                  onBrowseMarketplaceTap?.call();
                  // Navigate to marketplace - handled by parent
                },
                icon: const Icon(Icons.store_outlined),
                label: Text(l10n.landing_cta_marketplace_button),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  textStyle: context.t.titleMedium,
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 48),
          // Trust indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TrustIndicator(
                icon: Icons.credit_card_off_rounded,
                text: l10n.landing_trust_no_credit_card,
                delay: 400,
              ),
              const SizedBox(width: 32),
              _TrustIndicator(
                icon: Icons.person_off_rounded,
                text: l10n.landing_trust_no_signup,
                delay: 500,
              ),
              const SizedBox(width: 32),
              _TrustIndicator(
                icon: Icons.flash_on_rounded,
                text: l10n.landing_trust_ready_in_minutes,
                delay: 600,
              ),
            ],
          ),
          const SizedBox(height: 80),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: context.c.outline.withAlpha(30),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.landing_app_name,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${l10n.landing_footer_tagline}',
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '•',
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                const TermsOfServiceLink(),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 700.ms),
        ],
      ),
    );
  }
}

class _TrustIndicator extends StatelessWidget {
  final IconData icon;
  final String text;
  final int delay;

  const _TrustIndicator({
    required this.icon,
    required this.text,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: context.c.onSurfaceVariant.withAlpha(180),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: delay.ms);
  }
}
