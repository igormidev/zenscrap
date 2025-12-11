import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Section showcasing the platform's key features in a grid layout.
/// Highlights technical capabilities without overwhelming users.
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      // Transparent background to show Lottie behind
      child: Column(
        children: [
          Text(
            'Built for the Modern Web',
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Enterprise-grade infrastructure wrapped in a simple interface.',
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
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _FeatureCard(
                  icon: Icons.savings_rounded,
                  title: 'Smart Cost Optimization',
                  description:
                      'AI automatically tests configurations and finds the cheapest option that works. No wasted credits.',
                  delay: 300,
                ),
                _FeatureCard(
                  icon: Icons.shield_rounded,
                  title: 'Anti-Bot Handled',
                  description:
                      'CAPTCHAs, rate limits, fingerprinting—we handle all of it so you don\'t have to.',
                  delay: 400,
                ),
                _FeatureCard(
                  icon: Icons.public_rounded,
                  title: 'Global Geo-Targeting',
                  description:
                      'Access region-locked content with automatic proxy selection based on target location.',
                  delay: 500,
                ),
                _FeatureCard(
                  icon: Icons.play_circle_outline_rounded,
                  title: 'In-Platform Testing',
                  description:
                      'Test any scraper instantly without leaving the platform. No Postman needed.',
                  delay: 600,
                ),
                _FeatureCard(
                  icon: Icons.analytics_outlined,
                  title: 'Deep Analytics',
                  description:
                      'Track every request, identify issues instantly, and monitor usage across time ranges.',
                  delay: 700,
                ),
                _FeatureCard(
                  icon: Icons.javascript_rounded,
                  title: 'JavaScript Rendering',
                  description:
                      'Full headless browser support for SPAs, dynamic content, and infinite scroll pages.',
                  delay: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: context.c.primary,
            ),
          ),
          const SizedBox(width: 16),
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
