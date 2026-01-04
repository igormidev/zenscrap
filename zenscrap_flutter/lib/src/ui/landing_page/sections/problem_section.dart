import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// Section highlighting the problems with traditional web scraping.
/// Uses the PAS (Problem-Agitation-Solution) framework to create urgency.
/// On mobile, cards take full width; on desktop, they use fixed width with Wrap.
class ProblemSection extends StatelessWidget {
  const ProblemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.responsiveValue(compact: 60.0, expanded: 100.0),
        horizontal: context.responsiveValue(compact: 20.0, expanded: 40.0),
      ),
      child: Column(
        children: [
          Seo.text(
            text: l10n.landing_problem_title,
            style: TextTagStyle.h2,
            child: Text(
              l10n.landing_problem_title,
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
          ),
          const SizedBox(height: 16),
          Seo.text(
            text: l10n.landing_problem_subtitle,
            child: ConstrainedBox(
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
          ),
          SizedBox(height: context.responsiveValue(compact: 40.0, expanded: 64.0)),
          // Responsive problem cards
          ResponsiveBuilder(
            compact: (context, constraints) => _MobileProblemsList(l10n: l10n),
            expanded: (context, constraints) => _DesktopProblemsGrid(l10n: l10n),
          ),
        ],
      ),
    );
  }
}

/// Desktop problems grid with fixed-width cards using Wrap
class _DesktopProblemsGrid extends StatelessWidget {
  final AppLocalizations l10n;

  const _DesktopProblemsGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
    );
  }
}

/// Mobile problems list with full-width cards
class _MobileProblemsList extends StatelessWidget {
  final AppLocalizations l10n;

  const _MobileProblemsList({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProblemCard(
          icon: Icons.code_off_rounded,
          title: l10n.landing_problem_css_title,
          description: l10n.landing_problem_css_description,
          delay: 300,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _ProblemCard(
          icon: Icons.build_circle_outlined,
          title: l10n.landing_problem_maintenance_title,
          description: l10n.landing_problem_maintenance_description,
          delay: 350,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _ProblemCard(
          icon: Icons.shield_outlined,
          title: l10n.landing_problem_antibot_title,
          description: l10n.landing_problem_antibot_description,
          delay: 400,
          isFullWidth: true,
        ),
        const SizedBox(height: 16),
        _ProblemCard(
          icon: Icons.timer_off_outlined,
          title: l10n.landing_problem_productivity_title,
          description: l10n.landing_problem_productivity_description,
          delay: 450,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final bool isFullWidth;

  const _ProblemCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : 220,
      padding: EdgeInsets.all(isFullWidth ? 20 : 24),
      decoration: BoxDecoration(
        color: context.c.errorContainer.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.c.error.withAlpha(40),
          width: 1,
        ),
      ),
      child: isFullWidth
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.c.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: context.c.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Seo.text(
                        text: title,
                        style: TextTagStyle.h3,
                        child: Text(
                          title,
                          style: context.t.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.c.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Seo.text(
                        text: description,
                        child: Text(
                          description,
                          style: context.t.bodyMedium?.copyWith(
                            color: context.c.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
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
                Seo.text(
                  text: title,
                  style: TextTagStyle.h3,
                  child: Text(
                    title,
                    style: context.t.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Seo.text(
                  text: description,
                  child: Text(
                    description,
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.onSurfaceVariant,
                      height: 1.5,
                    ),
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
