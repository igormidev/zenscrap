import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seo/seo.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/language_selector.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/landing_appbar.dart';

/// Mobile navigation drawer for the landing page.
/// Contains all navigation items, language selector, and sign in button.
class LandingMobileDrawer extends StatelessWidget {
  /// Currently active section based on scroll position.
  final LandingSection? activeSection;

  /// Callback when a section navigation item is tapped.
  final void Function(LandingSection section)? onSectionTap;

  /// Callback when Sign In button is tapped (for analytics tracking).
  final VoidCallback? onSignInTap;

  const LandingMobileDrawer({
    super.key,
    this.activeSection,
    this.onSectionTap,
    this.onSignInTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header with logo
            const _DrawerHeader(),
            const Divider(height: 1),
            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: LandingSection.values.map((section) {
                  final isActive = section == activeSection;
                  return _DrawerNavItem(
                    section: section,
                    isActive: isActive,
                    onTap: () {
                      Navigator.of(context).pop(); // Close drawer
                      onSectionTap?.call(section);
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),
            // Footer with language selector and sign in
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Language selector
                  Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 20,
                        color: context.c.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Seo.text(
                          text: l10n.landing_drawer_language,
                          child: Text(
                            l10n.landing_drawer_language,
                            style: context.t.bodyMedium?.copyWith(
                              color: context.c.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        height: 34,
                        child: LanguageSelector(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close drawer
                        onSignInTap?.call();
                        context.push('/auth');
                      },
                      icon: const Icon(Icons.login_rounded),
                      label: Text(l10n.landing_sign_in),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drawer header with logo
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
          Seo.text(
            text: l10n.landing_app_name,
            child: Text(
              l10n.landing_app_name,
              style: context.t.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Navigation item in the drawer
class _DrawerNavItem extends StatelessWidget {
  final LandingSection section;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  IconData get _icon {
    return switch (section) {
      LandingSection.createScrappable => Icons.add_circle_outline_rounded,
      LandingSection.howItWorks => Icons.help_outline_rounded,
      LandingSection.autoFix => Icons.auto_fix_high_rounded,
      LandingSection.features => Icons.star_outline_rounded,
      LandingSection.marketplace => Icons.store_outlined,
      LandingSection.pricing => Icons.payments_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _icon,
        color: isActive ? context.c.primary : context.c.onSurfaceVariant,
      ),
      title: Seo.text(
        text: section.getLabel(context),
        child: Text(
          section.getLabel(context),
          style: context.t.bodyLarge?.copyWith(
            color: isActive ? context.c.primary : context.c.onSurface,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
      selected: isActive,
      selectedTileColor: context.c.primaryContainer.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
    );
  }
}
