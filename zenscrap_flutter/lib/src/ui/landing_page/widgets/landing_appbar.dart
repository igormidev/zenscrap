import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/language_selector.dart';

/// The navigation items in the landing page appbar.
enum LandingSection {
  createScrappable,
  howItWorks,
  autoFix,
  features,
  marketplace,
  pricing;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      LandingSection.createScrappable => l10n.landing_nav_create_scrappable,
      LandingSection.howItWorks => l10n.landing_nav_how_it_works,
      LandingSection.autoFix => l10n.landing_nav_auto_fix,
      LandingSection.features => l10n.landing_nav_features,
      LandingSection.marketplace => l10n.landing_nav_marketplace,
      LandingSection.pricing => l10n.landing_nav_pricing,
    };
  }
}

/// Fixed floating appbar with blur effect for the landing page.
/// Contains logo, section navigation with animated pill indicator, and login button.
/// On mobile, shows a hamburger menu that opens a navigation drawer.
class LandingAppBar extends StatelessWidget {
  /// Currently active section based on scroll position.
  final LandingSection? activeSection;

  /// Callback when a section navigation item is tapped.
  final void Function(LandingSection section)? onSectionTap;

  /// Callback when Sign In button is tapped (for analytics tracking).
  final VoidCallback? onSignInTap;

  /// Callback when hamburger menu is tapped (mobile only).
  final VoidCallback? onMenuTap;

  /// Whether the appbar should show a solid background (when scrolled).
  final bool isScrolled;

  const LandingAppBar({
    super.key,
    this.activeSection,
    this.onSectionTap,
    this.onSignInTap,
    this.onMenuTap,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveValue(
              compact: 16.0,
              medium: 24.0,
              expanded: 32.0,
            ),
            vertical: context.responsiveValue(
              compact: 12.0,
              expanded: 16.0,
            ),
          ),
          decoration: BoxDecoration(
            color: isScrolled
                ? context.c.surface.withAlpha(220)
                : context.c.surface.withAlpha(120),
            border: Border(
              bottom: BorderSide(
                color: context.c.outline.withAlpha(isScrolled ? 40 : 20),
              ),
            ),
          ),
          child: ResponsiveWidget(
            compact: _MobileAppBarContent(
              onMenuTap: onMenuTap,
              onSignInTap: onSignInTap,
            ),
            expanded: _DesktopAppBarContent(
              activeSection: activeSection,
              onSectionTap: onSectionTap,
              onSignInTap: onSignInTap,
            ),
          ),
        ),
      ),
    );
  }
}

/// Desktop layout with full navigation bar
class _DesktopAppBarContent extends StatelessWidget {
  final LandingSection? activeSection;
  final void Function(LandingSection section)? onSectionTap;
  final VoidCallback? onSignInTap;

  const _DesktopAppBarContent({
    this.activeSection,
    this.onSectionTap,
    this.onSignInTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo
        const _Logo(),
        const Spacer(),
        // Navigation items with pill indicator
        _NavigationBar(
          activeSection: activeSection,
          onSectionTap: onSectionTap,
        ),
        const Spacer(),
        // Language selector
        SizedBox(
          height: 34,
          child: const LanguageSelector(),
        ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
        const SizedBox(width: 12),
        // Login button
        _LoginButton(onTap: onSignInTap),
      ],
    );
  }
}

/// Mobile layout with hamburger menu
class _MobileAppBarContent extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSignInTap;

  const _MobileAppBarContent({
    this.onMenuTap,
    this.onSignInTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo
        const _Logo(),
        const Spacer(),
        // Language selector (compact)
        SizedBox(
          height: 34,
          child: const LanguageSelector(),
        ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
        const SizedBox(width: 8),
        // Login button
        _LoginButton(onTap: onSignInTap),
        const SizedBox(width: 8),
        // Hamburger menu button
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu_rounded),
          tooltip: 'Menu',
          style: IconButton.styleFrom(
            foregroundColor: context.c.onSurface,
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.c.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            size: 20,
            color: context.c.onPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          l10n.landing_app_name,
          style: context.t.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.c.onSurface,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _NavigationBar extends StatelessWidget {
  final LandingSection? activeSection;
  final void Function(LandingSection section)? onSectionTap;

  const _NavigationBar({this.activeSection, this.onSectionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHigh.withAlpha(150),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: LandingSection.values.map((section) {
          final isActive = section == activeSection;
          return _NavItem(
            section: section,
            isActive: isActive,
            onTap: () => onSectionTap?.call(section),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }
}

class _NavItem extends StatefulWidget {
  final LandingSection section;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? context.c.primary
                : (_isHovered
                      ? context.c.primary.withAlpha(30)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.section.getLabel(context),
            style: context.t.labelLarge?.copyWith(
              color: widget.isActive
                  ? context.c.onPrimary
                  : (_isHovered
                        ? context.c.primary
                        : context.c.onSurfaceVariant),
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _LoginButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton(
      onPressed: () {
        onTap?.call();
        context.push('/auth');
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(l10n.landing_sign_in),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}
