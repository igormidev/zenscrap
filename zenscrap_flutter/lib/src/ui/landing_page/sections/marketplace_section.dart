import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Section highlighting the marketplace feature.
/// Shows that users can leverage pre-built scrapers from the community.
class MarketplaceSection extends StatelessWidget {
  const MarketplaceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.c.secondaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 16,
                  color: context.c.onSecondaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'COMMUNITY',
                  style: context.t.labelSmall?.copyWith(
                    color: context.c.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          const SizedBox(height: 24),
          Text(
            'Don\'t Build What Already Exists',
            style: context.t.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.c.onSurface,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Browse our marketplace of pre-built scrapers for popular websites. Use them instantly or learn from how others solved similar challenges.',
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
          const SizedBox(height: 64),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Row(
              children: [
                Expanded(
                  child: _MarketplaceFeature(
                    icon: Icons.store_rounded,
                    title: 'Pre-Built Scrapers',
                    description:
                        'Amazon, eBay, LinkedIn, news sites—popular websites already have working scrapers ready to use.',
                    delay: 300,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _MarketplaceFeature(
                    icon: Icons.trending_up_rounded,
                    title: 'Usage Statistics',
                    description:
                        'See which scrapers are most popular and reliable based on real community usage data.',
                    delay: 400,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _MarketplaceFeature(
                    icon: Icons.play_arrow_rounded,
                    title: 'Instant Testing',
                    description:
                        'Try any marketplace scraper before using it. Test with your own parameters to verify results.',
                    delay: 500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Categories preview
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _CategoryChip(label: 'E-Commerce', delay: 600),
              _CategoryChip(label: 'News & Media', delay: 650),
              _CategoryChip(label: 'Job Listings', delay: 700),
              _CategoryChip(label: 'Social Media', delay: 750),
              _CategoryChip(label: 'Real Estate', delay: 800),
              _CategoryChip(label: 'Finance', delay: 850),
              _CategoryChip(label: 'Sports', delay: 900),
              _CategoryChip(label: '+ 25 more', delay: 950, isMore: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarketplaceFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;

  const _MarketplaceFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow.withAlpha(200), // Semi-transparent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.c.outline.withAlpha(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.c.secondaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 28,
              color: context.c.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.t.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.c.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final int delay;
  final bool isMore;

  const _CategoryChip({
    required this.label,
    required this.delay,
    this.isMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isMore
            ? context.c.primary.withAlpha(20)
            : context.c.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMore
              ? context.c.primary.withAlpha(60)
              : context.c.outline.withAlpha(30),
        ),
      ),
      child: Text(
        label,
        style: context.t.labelLarge?.copyWith(
          color: isMore ? context.c.primary : context.c.onSurfaceVariant,
          fontWeight: isMore ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
        );
  }
}
