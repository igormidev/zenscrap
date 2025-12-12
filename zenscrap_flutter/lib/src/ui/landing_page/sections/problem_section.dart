import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Section highlighting the problems with traditional web scraping.
/// Uses the PAS (Problem-Agitation-Solution) framework to create urgency.
class ProblemSection extends StatelessWidget {
  const ProblemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      child: Column(
        children: [
          Text(
            l10n.landing_problem_title,
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
              l10n.landing_problem_subtitle,
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
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Wrap(
              spacing: 32,
              runSpacing: 32,
              alignment: WrapAlignment.center,
              children: [
                _ProblemCard(
                  icon: Icons.code_off_rounded,
                  title: l10n.landing_problem_css_title,
                  description: l10n.landing_problem_css_description,
                  delay: 300,
                ),
                _ProblemCard(
                  icon: Icons.build_circle_outlined,
                  title: l10n.landing_problem_maintenance_title,
                  description: l10n.landing_problem_maintenance_description,
                  delay: 400,
                ),
                _ProblemCard(
                  icon: Icons.shield_outlined,
                  title: l10n.landing_problem_antibot_title,
                  description: l10n.landing_problem_antibot_description,
                  delay: 500,
                ),
                _ProblemCard(
                  icon: Icons.timer_off_outlined,
                  title: l10n.landing_problem_productivity_title,
                  description: l10n.landing_problem_productivity_description,
                  delay: 600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;

  const _ProblemCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.c.errorContainer.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.c.error.withAlpha(40),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.error.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.t.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.c.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
              height: 1.5,
            ),
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
