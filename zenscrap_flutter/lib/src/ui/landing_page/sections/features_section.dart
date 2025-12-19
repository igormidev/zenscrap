import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// Section showcasing the platform's key features in a grid layout.
/// Highlights technical capabilities without overwhelming users.
/// On mobile, cards take full width; on desktop, they use fixed width with Wrap.
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

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
            l10n.landing_features_title,
            style: context.responsiveValue(
              compact: context.t.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
              expanded: context.t.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              l10n.landing_features_subtitle,
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
          SizedBox(height: context.responsiveValue(compact: 40.0, expanded: 64.0)),
          // Responsive feature cards
          ResponsiveBuilder(
            compact: (context, constraints) => _MobileFeaturesList(l10n: l10n),
            expanded: (context, constraints) => _DesktopFeaturesGrid(l10n: l10n),
          ),
        ],
      ),
    );
  }
}

/// Desktop features grid with fixed-width cards using Wrap
class _DesktopFeaturesGrid extends StatelessWidget {
  final AppLocalizations l10n;

  const _DesktopFeaturesGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: [
          _FeatureCard(
            icon: Icons.savings_rounded,
            title: l10n.landing_features_cost_title,
            description: l10n.landing_features_cost_description,
            delay: 300,
          ),
          _FeatureCard(
            icon: Icons.shield_rounded,
            title: l10n.landing_features_antibot_title,
            description: l10n.landing_features_antibot_description,
            delay: 400,
          ),
          _FeatureCard(
            icon: Icons.public_rounded,
            title: l10n.landing_features_geo_title,
            description: l10n.landing_features_geo_description,
            delay: 500,
          ),
          _FeatureCard(
            icon: Icons.play_circle_outline_rounded,
            title: l10n.landing_features_testing_title,
            description: l10n.landing_features_testing_description,
            delay: 600,
          ),
          _FeatureCard(
            icon: Icons.analytics_outlined,
            title: l10n.landing_features_analytics_title,
            description: l10n.landing_features_analytics_description,
            delay: 700,
          ),
          _FeatureCard(
            icon: Icons.javascript_rounded,
            title: l10n.landing_features_js_title,
            description: l10n.landing_features_js_description,
            delay: 800,
          ),
        ],
      ),
    );
  }
}

/// Mobile features list with full-width cards
class _MobileFeaturesList extends StatelessWidget {
  final AppLocalizations l10n;

  const _MobileFeaturesList({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeatureCard(
          icon: Icons.savings_rounded,
          title: l10n.landing_features_cost_title,
          description: l10n.landing_features_cost_description,
          delay: 300,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.shield_rounded,
          title: l10n.landing_features_antibot_title,
          description: l10n.landing_features_antibot_description,
          delay: 350,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.public_rounded,
          title: l10n.landing_features_geo_title,
          description: l10n.landing_features_geo_description,
          delay: 400,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.play_circle_outline_rounded,
          title: l10n.landing_features_testing_title,
          description: l10n.landing_features_testing_description,
          delay: 450,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.analytics_outlined,
          title: l10n.landing_features_analytics_title,
          description: l10n.landing_features_analytics_description,
          delay: 500,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.javascript_rounded,
          title: l10n.landing_features_js_title,
          description: l10n.landing_features_js_description,
          delay: 550,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final bool isFullWidth;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : 340,
      padding: EdgeInsets.all(isFullWidth ? 20 : 24),
      decoration: BoxDecoration(
        color: context.c.surface.withAlpha(200), // Semi-transparent for Lottie
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.c.outline.withAlpha(30),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isFullWidth ? 10 : 12),
            decoration: BoxDecoration(
              color: context.c.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: isFullWidth ? 20 : 24,
              color: context.c.primary,
            ),
          ),
          SizedBox(width: isFullWidth ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
