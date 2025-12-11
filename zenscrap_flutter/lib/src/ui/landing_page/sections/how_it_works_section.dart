import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Section explaining the 3-step process to create a scraper.
/// Emphasizes the simplicity and AI automation.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      child: Column(
        children: [
          Text(
            'Three Steps to Automated Data',
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
              'No code. No configuration. Just describe what you need.',
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
          const SizedBox(height: 80),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StepCard(
                    stepNumber: '1',
                    icon: Icons.link_rounded,
                    title: 'Paste Your URL',
                    description:
                        'Drop the link to the page you want to extract data from. Any website, any complexity.',
                    delay: 300,
                  ),
                ),
                _StepConnector().animate().fadeIn(delay: 400.ms, duration: 400.ms),
                Expanded(
                  child: _StepCard(
                    stepNumber: '2',
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Describe What You Want',
                    description:
                        'Tell our AI in plain language what data you need. Product prices, article content, user profiles—anything.',
                    delay: 500,
                  ),
                ),
                _StepConnector().animate().fadeIn(delay: 600.ms, duration: 400.ms),
                Expanded(
                  child: _StepCard(
                    stepNumber: '3',
                    icon: Icons.auto_fix_high_rounded,
                    title: 'Get Your Self-Healing API',
                    description:
                        'Receive a ready-to-use API endpoint that automatically adapts when the target site changes.',
                    delay: 700,
                    isHighlighted: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: context.c.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.c.primary.withAlpha(40),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: context.c.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI automatically generates name, description, category, and URL patterns',
                  style: context.t.bodyLarge?.copyWith(
                    color: context.c.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 900.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String stepNumber;
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final bool isHighlighted;

  const _StepCard({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.c.primaryContainer.withAlpha(80)
            : context.c.surfaceContainerLow.withAlpha(200), // Semi-transparent
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlighted
              ? context.c.primary.withAlpha(60)
              : context.c.outline.withAlpha(30),
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: context.c.primary.withAlpha(20),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? context.c.primary
                      : context.c.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  stepNumber,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isHighlighted
                        ? context.c.onPrimary
                        : context.c.primary,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                icon,
                size: 32,
                color: isHighlighted
                    ? context.c.primary
                    : context.c.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: context.t.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.c.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.3, end: 0)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}

class _StepConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.arrow_forward_rounded,
            size: 28,
            color: context.c.outline.withAlpha(100),
          ),
        ],
      ),
    );
  }
}
