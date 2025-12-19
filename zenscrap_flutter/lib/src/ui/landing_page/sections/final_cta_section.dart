import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/legal/terms_of_service_dialog.dart';
import 'package:zenscrap_flutter/src/ui/legal/privacy_policy_dialog.dart';

/// Final call-to-action section at the bottom of the landing page.
/// Drives urgency and provides a clear path to action.
/// On mobile, buttons and footer items are stacked vertically.
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
      padding: EdgeInsets.symmetric(
        vertical: context.responsiveValue(compact: 60.0, expanded: 100.0),
        horizontal: context.responsiveValue(compact: 20.0, expanded: 40.0),
      ),
      // Transparent background to show Lottie behind
      child: Column(
        children: [
          Text(
            l10n.landing_cta_title,
            style: context.responsiveValue(
              compact: context.t.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
                height: 1.2,
              ),
              expanded: context.t.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
                height: 1.2,
              ),
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
          SizedBox(height: context.responsiveValue(compact: 32.0, expanded: 48.0)),
          // Responsive CTA buttons
          _CtaButtons(
            onCreateScraperTap: onCreateScraperTap,
            onScrollToTop: onScrollToTop,
            onBrowseMarketplaceTap: onBrowseMarketplaceTap,
          ),
          SizedBox(height: context.responsiveValue(compact: 32.0, expanded: 48.0)),
          // Trust indicators - using Wrap for responsiveness
          const _TrustIndicators(),
          SizedBox(height: context.responsiveValue(compact: 48.0, expanded: 80.0)),
          // Footer - responsive
          const _Footer(),
        ],
      ),
    );
  }
}

/// CTA buttons widget - responsive layout
class _CtaButtons extends StatelessWidget {
  final VoidCallback? onCreateScraperTap;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onBrowseMarketplaceTap;

  const _CtaButtons({
    this.onCreateScraperTap,
    this.onScrollToTop,
    this.onBrowseMarketplaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ResponsiveWidget(
      compact: _MobileCtaButtons(
        l10n: l10n,
        onCreateScraperTap: onCreateScraperTap,
        onScrollToTop: onScrollToTop,
        onBrowseMarketplaceTap: onBrowseMarketplaceTap,
      ),
      expanded: _DesktopCtaButtons(
        l10n: l10n,
        onCreateScraperTap: onCreateScraperTap,
        onScrollToTop: onScrollToTop,
        onBrowseMarketplaceTap: onBrowseMarketplaceTap,
      ),
    );
  }
}

/// Desktop CTA buttons in a Row
class _DesktopCtaButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback? onCreateScraperTap;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onBrowseMarketplaceTap;

  const _DesktopCtaButtons({
    required this.l10n,
    this.onCreateScraperTap,
    this.onScrollToTop,
    this.onBrowseMarketplaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        .slideY(begin: 0.2, end: 0);
  }
}

/// Mobile CTA buttons in a Column
class _MobileCtaButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback? onCreateScraperTap;
  final VoidCallback? onScrollToTop;
  final VoidCallback? onBrowseMarketplaceTap;

  const _MobileCtaButtons({
    required this.l10n,
    this.onCreateScraperTap,
    this.onScrollToTop,
    this.onBrowseMarketplaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  onCreateScraperTap?.call();
                  onScrollToTop?.call();
                },
                icon: const Icon(Icons.rocket_launch_rounded),
                label: Text(l10n.landing_cta_create_button),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  onBrowseMarketplaceTap?.call();
                },
                icon: const Icon(Icons.store_outlined),
                label: Text(l10n.landing_cta_marketplace_button),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: context.t.titleMedium,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

/// Trust indicators - uses Wrap for responsiveness
class _TrustIndicators extends StatelessWidget {
  const _TrustIndicators();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: context.responsiveValue(compact: 16.0, expanded: 32.0),
      runSpacing: 12.0,
      children: [
        _TrustIndicator(
          icon: Icons.credit_card_off_rounded,
          text: l10n.landing_trust_no_credit_card,
          delay: 400,
        ),
        _TrustIndicator(
          icon: Icons.person_off_rounded,
          text: l10n.landing_trust_no_signup,
          delay: 500,
        ),
        _TrustIndicator(
          icon: Icons.flash_on_rounded,
          text: l10n.landing_trust_ready_in_minutes,
          delay: 600,
        ),
      ],
    );
  }
}

/// Footer widget - responsive layout
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.c.outline.withAlpha(30),
          ),
        ),
      ),
      child: ResponsiveWidget(
        compact: const _MobileFooter(),
        expanded: const _DesktopFooter(),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms);
  }
}

/// Desktop footer in a Row
class _DesktopFooter extends StatelessWidget {
  const _DesktopFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
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
        const SizedBox(width: 16),
        Text(
          '|',
          style: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        const PrivacyPolicyLink(),
      ],
    );
  }
}

/// Mobile footer in a Column
class _MobileFooter extends StatelessWidget {
  const _MobileFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.landing_app_name,
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.landing_footer_tagline,
          style: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TermsOfServiceLink(),
            const SizedBox(width: 16),
            Text(
              '|',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            const PrivacyPolicyLink(),
          ],
        ),
      ],
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
