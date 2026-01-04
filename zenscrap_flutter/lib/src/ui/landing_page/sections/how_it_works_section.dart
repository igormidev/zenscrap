import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// Section explaining the 3-step process to create a scraper.
/// Emphasizes the simplicity and AI automation.
/// On mobile, steps are shown in a Column; on desktop, in a Row with connectors.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

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
            text: l10n.landing_how_title,
            style: TextTagStyle.h2,
            child: Text(
              l10n.landing_how_title,
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
            text: l10n.landing_how_subtitle,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                l10n.landing_how_subtitle,
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
          SizedBox(height: context.responsiveValue(compact: 40.0, expanded: 80.0)),
          // Responsive steps layout
          ResponsiveWidget(
            compact: _MobileStepsLayout(l10n: l10n),
            expanded: _DesktopStepsLayout(l10n: l10n),
          ),
          SizedBox(height: context.responsiveValue(compact: 40.0, expanded: 64.0)),
          const _AiNoteWidget(),
        ],
      ),
    );
  }
}

/// Desktop layout with Row and connectors
class _DesktopStepsLayout extends StatelessWidget {
  final AppLocalizations l10n;

  const _DesktopStepsLayout({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _StepCard(
              stepNumber: '1',
              icon: Icons.link_rounded,
              title: l10n.landing_how_step1_title,
              description: l10n.landing_how_step1_description,
              delay: 300,
            ),
          ),
          const _StepConnector(delay: 400),
          Expanded(
            child: _StepCard(
              stepNumber: '2',
              icon: Icons.chat_bubble_outline_rounded,
              title: l10n.landing_how_step2_title,
              description: l10n.landing_how_step2_description,
              delay: 500,
            ),
          ),
          const _StepConnector(delay: 600),
          Expanded(
            child: _StepCard(
              stepNumber: '3',
              icon: Icons.auto_fix_high_rounded,
              title: l10n.landing_how_step3_title,
              description: l10n.landing_how_step3_description,
              delay: 700,
              isHighlighted: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile layout with Column (no connectors)
class _MobileStepsLayout extends StatelessWidget {
  final AppLocalizations l10n;

  const _MobileStepsLayout({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepCard(
          stepNumber: '1',
          icon: Icons.link_rounded,
          title: l10n.landing_how_step1_title,
          description: l10n.landing_how_step1_description,
          delay: 300,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: '2',
          icon: Icons.chat_bubble_outline_rounded,
          title: l10n.landing_how_step2_title,
          description: l10n.landing_how_step2_description,
          delay: 400,
        ),
        const SizedBox(height: 16),
        _StepCard(
          stepNumber: '3',
          icon: Icons.auto_fix_high_rounded,
          title: l10n.landing_how_step3_title,
          description: l10n.landing_how_step3_description,
          delay: 500,
          isHighlighted: true,
        ),
      ],
    );
  }
}

/// AI Note widget at the bottom
class _AiNoteWidget extends StatelessWidget {
  const _AiNoteWidget();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(compact: 16.0, expanded: 24.0),
        vertical: 16,
      ),
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
            size: context.responsiveValue(compact: 20.0, expanded: 24.0),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Seo.text(
              text: l10n.landing_how_ai_note,
              child: Text(
                l10n.landing_how_ai_note,
                style: context.t.bodyLarge?.copyWith(
                  color: context.c.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms)
        .slideY(begin: 0.2, end: 0);
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
          Seo.text(
            text: title,
            style: TextTagStyle.h3,
            child: Text(
              title,
              style: context.t.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Seo.text(
            text: description,
            child: Text(
              description,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
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

class _StepConnector extends StatelessWidget {
  final int delay;

  const _StepConnector({required this.delay});

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
    ).animate().fadeIn(delay: delay.ms, duration: 400.ms);
  }
}
