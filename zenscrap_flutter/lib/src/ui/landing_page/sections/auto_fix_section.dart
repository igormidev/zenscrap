import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

/// Section highlighting the unique auto-fix feature.
/// This is the primary differentiator - no competitor has this.
/// On mobile, uses Column layout; on desktop, uses Row with arrows.
class AutoFixSection extends StatelessWidget {
  const AutoFixSection({super.key});

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
          // "New" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.c.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: context.c.onTertiary,
                ),
                const SizedBox(width: 6),
                Seo.text(
                  text: l10n.landing_autofix_badge,
                  child: Text(
                    l10n.landing_autofix_badge,
                    style: context.t.labelSmall?.copyWith(
                      color: context.c.onTertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          const SizedBox(height: 24),
          Seo.text(
            text: l10n.landing_autofix_title,
            style: TextTagStyle.h2,
            child: Text(
              l10n.landing_autofix_title,
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
            text: l10n.landing_autofix_subtitle,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Text(
                l10n.landing_autofix_subtitle,
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
          // Responsive steps layout
          ResponsiveWidget(
            compact: _MobileAutoFixSteps(l10n: l10n),
            expanded: _DesktopAutoFixSteps(l10n: l10n),
          ),
          SizedBox(height: context.responsiveValue(compact: 40.0, expanded: 64.0)),
          // Notifications card
          _NotificationsCard(l10n: l10n),
          SizedBox(height: context.responsiveValue(compact: 32.0, expanded: 48.0)),
          // Comparison section - responsive
          ResponsiveWidget(
            compact: _MobileComparisonLayout(l10n: l10n),
            expanded: _DesktopComparisonLayout(l10n: l10n),
          ),
        ],
      ),
    );
  }
}

/// Desktop layout for auto-fix steps with Row and arrows
class _DesktopAutoFixSteps extends StatelessWidget {
  final AppLocalizations l10n;

  const _DesktopAutoFixSteps({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Row(
        children: [
          Expanded(
            child: _AutoFixStep(
              icon: Icons.warning_amber_rounded,
              iconColor: context.c.error,
              title: l10n.landing_autofix_step1_title,
              description: l10n.landing_autofix_step1_description,
              delay: 300,
            ),
          ),
          const _AnimatedArrow(delay: 400),
          Expanded(
            child: _AutoFixStep(
              icon: Icons.psychology_rounded,
              iconColor: context.c.tertiary,
              title: l10n.landing_autofix_step2_title,
              description: l10n.landing_autofix_step2_description,
              delay: 500,
            ),
          ),
          const _AnimatedArrow(delay: 600),
          Expanded(
            child: _AutoFixStep(
              icon: Icons.check_circle_rounded,
              iconColor: Colors.green,
              title: l10n.landing_autofix_step3_title,
              description: l10n.landing_autofix_step3_description,
              delay: 700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile layout for auto-fix steps with Column (no arrows)
class _MobileAutoFixSteps extends StatelessWidget {
  final AppLocalizations l10n;

  const _MobileAutoFixSteps({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AutoFixStep(
          icon: Icons.warning_amber_rounded,
          iconColor: context.c.error,
          title: l10n.landing_autofix_step1_title,
          description: l10n.landing_autofix_step1_description,
          delay: 300,
        ),
        const SizedBox(height: 24),
        _AutoFixStep(
          icon: Icons.psychology_rounded,
          iconColor: context.c.tertiary,
          title: l10n.landing_autofix_step2_title,
          description: l10n.landing_autofix_step2_description,
          delay: 400,
        ),
        const SizedBox(height: 24),
        _AutoFixStep(
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          title: l10n.landing_autofix_step3_title,
          description: l10n.landing_autofix_step3_description,
          delay: 500,
        ),
      ],
    );
  }
}

/// Notifications card widget
class _NotificationsCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _NotificationsCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(compact: 20.0, expanded: 32.0),
      ),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow.withAlpha(200),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.c.outline.withAlpha(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(
              context.responsiveValue(compact: 12.0, expanded: 16.0),
            ),
            decoration: BoxDecoration(
              color: context.c.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.email_outlined,
              size: context.responsiveValue(compact: 24.0, expanded: 32.0),
              color: context.c.primary,
            ),
          ),
          SizedBox(width: context.responsiveValue(compact: 16.0, expanded: 24.0)),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Seo.text(
                  text: l10n.landing_autofix_notifications_title,
                  style: TextTagStyle.h3,
                  child: Text(
                    l10n.landing_autofix_notifications_title,
                    style: context.t.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Seo.text(
                  text: l10n.landing_autofix_notifications_description,
                  child: Text(
                    l10n.landing_autofix_notifications_description,
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
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

/// Desktop comparison layout with Row
class _DesktopComparisonLayout extends StatelessWidget {
  final AppLocalizations l10n;

  const _DesktopComparisonLayout({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: Row(
        children: [
          Expanded(
            child: _ComparisonColumn(
              title: l10n.landing_autofix_without_title,
              isNegative: true,
              items: [
                l10n.landing_autofix_without_item1,
                l10n.landing_autofix_without_item2,
                l10n.landing_autofix_without_item3,
                l10n.landing_autofix_without_item4,
              ],
              delay: 1000,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _ComparisonColumn(
              title: l10n.landing_autofix_with_title,
              isNegative: false,
              items: [
                l10n.landing_autofix_with_item1,
                l10n.landing_autofix_with_item2,
                l10n.landing_autofix_with_item3,
                l10n.landing_autofix_with_item4,
              ],
              delay: 1100,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile comparison layout with Column
class _MobileComparisonLayout extends StatelessWidget {
  final AppLocalizations l10n;

  const _MobileComparisonLayout({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ComparisonColumn(
          title: l10n.landing_autofix_without_title,
          isNegative: true,
          items: [
            l10n.landing_autofix_without_item1,
            l10n.landing_autofix_without_item2,
            l10n.landing_autofix_without_item3,
            l10n.landing_autofix_without_item4,
          ],
          delay: 600,
        ),
        const SizedBox(height: 16),
        _ComparisonColumn(
          title: l10n.landing_autofix_with_title,
          isNegative: false,
          items: [
            l10n.landing_autofix_with_item1,
            l10n.landing_autofix_with_item2,
            l10n.landing_autofix_with_item3,
            l10n.landing_autofix_with_item4,
          ],
          delay: 700,
        ),
      ],
    );
  }
}

class _AutoFixStep extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final int delay;

  const _AutoFixStep({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 32,
            color: iconColor,
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
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Seo.text(
          text: description,
          child: Text(
            description,
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

class _AnimatedArrow extends StatelessWidget {
  final int delay;

  const _AnimatedArrow({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 24,
        color: context.c.outline.withAlpha(80),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: delay.ms).slideX(begin: -0.5, end: 0);
  }
}

class _ComparisonColumn extends StatelessWidget {
  final String title;
  final bool isNegative;
  final List<String> items;
  final int delay;

  const _ComparisonColumn({
    required this.title,
    required this.isNegative,
    required this.items,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final color = isNegative ? context.c.error : Colors.green;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withAlpha(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isNegative ? Icons.close_rounded : Icons.check_rounded,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Seo.text(
                text: title,
                style: TextTagStyle.h3,
                child: Text(
                  title,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isNegative
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      size: 18,
                      color: color.withAlpha(150),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Seo.text(
                        text: item,
                        child: Text(
                          item,
                          style: context.t.bodyMedium?.copyWith(
                            color: context.c.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideX(begin: isNegative ? -0.2 : 0.2, end: 0);
  }
}
