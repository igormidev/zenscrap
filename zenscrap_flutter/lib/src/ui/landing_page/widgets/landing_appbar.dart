import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// The navigation items in the landing page appbar.
enum LandingSection {
  createScrappable('Create Scrappable'),
  howItWorks('How It Works'),
  autoFix('Auto-Fix'),
  features('Features'),
  marketplace('Marketplace'),
  pricing('Pricing');

  final String label;
  const LandingSection(this.label);
}

/// Fixed floating appbar with blur effect for the landing page.
/// Contains logo, section navigation with animated pill indicator, and login button.
class LandingAppBar extends StatelessWidget {
  /// Currently active section based on scroll position.
  final LandingSection? activeSection;

  /// Callback when a section navigation item is tapped.
  final void Function(LandingSection section)? onSectionTap;

  /// Whether the appbar should show a solid background (when scrolled).
  final bool isScrolled;

  const LandingAppBar({
    super.key,
    this.activeSection,
    this.onSectionTap,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
          child: Row(
            children: [
              // Logo
              _Logo(),
              const Spacer(),
              // Navigation items with pill indicator
              _NavigationBar(
                activeSection: activeSection,
                onSectionTap: onSectionTap,
              ),
              const Spacer(),
              // Login button
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'ZenScrap',
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

  const _NavigationBar({
    this.activeSection,
    this.onSectionTap,
  });

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
            widget.section.label,
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
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.push('/auth'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text('Sign In'),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}
