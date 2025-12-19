# ZenScrap Flutter Responsive Architecture Guide

**Version**: 1.0.0
**Last Updated**: December 2024
**Author**: Architecture Instance

> This document serves as the foundational guide for implementing responsive UI across ZenScrap Flutter. It will be referenced by all subsequent development instances.

## Table of Contents

1. [Breakpoint System](#section-1-breakpoint-system)
2. [Core Responsive Widgets](#section-2-core-responsive-widgets)
3. [Adaptive Layouts](#section-3-adaptive-layouts)
4. [Folder Structure](#section-4-folder-structure)
5. [Naming Conventions](#section-5-naming-conventions)
6. [Migration Patterns](#section-6-migration-patterns)
7. [Performance Best Practices](#section-7-performance-best-practices)
8. [Testing Requirements](#section-8-testing-requirements)
9. [Translation Requirements](#section-9-translation-requirements)
10. [DRY Principle Enforcement](#section-10-dry-principle-enforcement)

---

## Research Sources

This architecture is based on the following sources:
- [Flutter Adaptive and Responsive Design](https://docs.flutter.dev/ui/adaptive-responsive)
- [Material Design 3 Window Size Classes](https://m3.material.io/foundations/layout/applying-layout/window-size-classes)
- [Best Practices for Adaptive Design](https://docs.flutter.dev/ui/adaptive-responsive/best-practices)
- [MediaQuery Performance Optimization](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
- [Flutter Golden Tests](https://solguruz.com/blog/flutter-golden-tests/)

---

## Section 1: Breakpoint System

### Overview

We follow Material Design 3 window size classes for breakpoints. This ensures consistency with platform conventions and accessibility guidelines.

### Implementation

Create file: `lib/src/design_system/responsive/breakpoints.dart`

```dart
import 'package:flutter/widgets.dart';

/// Material Design 3 Window Size Classes
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
abstract final class Breakpoints {
  /// Compact: 0-599dp (phones in portrait)
  static const double compact = 0;

  /// Medium: 600-839dp (tablets in portrait, foldables)
  static const double medium = 600;

  /// Expanded: 840dp+ (tablets landscape, desktops)
  static const double expanded = 840;

  /// Large: 1200dp+ (large desktops, wide monitors)
  /// Optional extended breakpoint for complex layouts
  static const double large = 1200;

  /// Extra Large: 1600dp+ (ultra-wide monitors)
  /// For maximum content width containers
  static const double extraLarge = 1600;

  /// Private constructor - this class should not be instantiated
  Breakpoints._();
}

/// Represents the current window size classification
/// Based on Material Design 3 guidelines
enum WindowSizeClass {
  /// Width < 600dp - phones, small tablets
  /// Use: Bottom navigation, single column layouts
  compact,

  /// Width 600-839dp - tablets portrait, large phones landscape
  /// Use: Navigation rail, two-column layouts possible
  medium,

  /// Width >= 840dp - tablets landscape, desktops
  /// Use: Navigation drawer/rail, multi-column layouts
  expanded;

  /// Returns true if this size class is at least as large as [other]
  bool operator >=(WindowSizeClass other) => index >= other.index;

  /// Returns true if this size class is larger than [other]
  bool operator >(WindowSizeClass other) => index > other.index;

  /// Returns true if this size class is at most as large as [other]
  bool operator <=(WindowSizeClass other) => index <= other.index;

  /// Returns true if this size class is smaller than [other]
  bool operator <(WindowSizeClass other) => index < other.index;
}

/// Extension on BuildContext to easily access responsive utilities
///
/// Usage:
/// ```dart
/// // Get current window size class
/// final sizeClass = context.windowSizeClass;
///
/// // Check specific size
/// if (context.isCompact) {
///   return MobileLayout();
/// }
///
/// // Get responsive value
/// final padding = context.responsiveValue(
///   compact: 16.0,
///   medium: 24.0,
///   expanded: 32.0,
/// );
/// ```
extension ResponsiveContext on BuildContext {
  /// Get the current screen width using MediaQuery.sizeOf for performance
  /// Note: Using sizeOf instead of .of().size prevents unnecessary rebuilds
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get the current screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Get the current window size class based on width
  WindowSizeClass get windowSizeClass {
    final width = screenWidth;
    if (width < Breakpoints.medium) return WindowSizeClass.compact;
    if (width < Breakpoints.expanded) return WindowSizeClass.medium;
    return WindowSizeClass.expanded;
  }

  /// Returns true if current window is compact (< 600dp)
  bool get isCompact => screenWidth < Breakpoints.medium;

  /// Returns true if current window is medium (600-839dp)
  bool get isMedium =>
      screenWidth >= Breakpoints.medium && screenWidth < Breakpoints.expanded;

  /// Returns true if current window is expanded (>= 840dp)
  bool get isExpanded => screenWidth >= Breakpoints.expanded;

  /// Returns true if current window is large (>= 1200dp)
  bool get isLarge => screenWidth >= Breakpoints.large;

  /// Returns true if current window is extra large (>= 1600dp)
  bool get isExtraLarge => screenWidth >= Breakpoints.extraLarge;

  /// Returns true if we should use mobile-optimized layouts
  /// This includes compact and some medium sizes
  bool get useMobileLayout => isCompact;

  /// Returns true if we should use tablet-optimized layouts
  bool get useTabletLayout => isMedium;

  /// Returns true if we should use desktop-optimized layouts
  bool get useDesktopLayout => isExpanded;

  /// Get a value based on the current window size class
  ///
  /// [compact] - Value for compact screens (required)
  /// [medium] - Value for medium screens (falls back to compact if not provided)
  /// [expanded] - Value for expanded screens (falls back to medium, then compact)
  ///
  /// Example:
  /// ```dart
  /// final columns = context.responsiveValue<int>(
  ///   compact: 1,
  ///   medium: 2,
  ///   expanded: 3,
  /// );
  /// ```
  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) {
    return switch (windowSizeClass) {
      WindowSizeClass.compact => compact,
      WindowSizeClass.medium => medium ?? compact,
      WindowSizeClass.expanded => expanded ?? medium ?? compact,
    };
  }
}

/// Standalone function for responsive values when BuildContext is not available
/// or when you need to use constraints from LayoutBuilder
///
/// Example:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     final columns = responsiveValue(
///       width: constraints.maxWidth,
///       compact: 1,
///       medium: 2,
///       expanded: 3,
///     );
///     return GridView(crossAxisCount: columns);
///   },
/// )
/// ```
T responsiveValue<T>({
  required double width,
  required T compact,
  T? medium,
  T? expanded,
}) {
  if (width < Breakpoints.medium) return compact;
  if (width < Breakpoints.expanded) return medium ?? compact;
  return expanded ?? medium ?? compact;
}

/// Get window size class from width value
WindowSizeClass windowSizeClassFromWidth(double width) {
  if (width < Breakpoints.medium) return WindowSizeClass.compact;
  if (width < Breakpoints.expanded) return WindowSizeClass.medium;
  return WindowSizeClass.expanded;
}
```

### Usage Examples

```dart
// In a widget:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simple check
    if (context.isCompact) {
      return MobileView();
    }
    return DesktopView();

    // Or using responsive value
    final padding = context.responsiveValue(
      compact: EdgeInsets.all(16),
      medium: EdgeInsets.all(24),
      expanded: EdgeInsets.all(32),
    );

    return Padding(padding: padding, child: Content());
  }
}
```

---

## Section 2: Core Responsive Widgets

### 2.1 ResponsiveBuilder

Create file: `lib/src/design_system/responsive/responsive_builder.dart`

```dart
import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// A widget that builds different layouts based on available width constraints.
///
/// Uses [LayoutBuilder] internally for performance - only rebuilds when
/// parent constraints change, not on every MediaQuery change.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   compact: (context, constraints) => MobileLayout(),
///   medium: (context, constraints) => TabletLayout(),
///   expanded: (context, constraints) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for compact screens (< 600dp)
  /// This is required as it's the base layout
  final Widget Function(BuildContext context, BoxConstraints constraints) compact;

  /// Builder for medium screens (600-839dp)
  /// Falls back to [compact] if not provided
  final Widget Function(BuildContext context, BoxConstraints constraints)? medium;

  /// Builder for expanded screens (>= 840dp)
  /// Falls back to [medium], then [compact] if not provided
  final Widget Function(BuildContext context, BoxConstraints constraints)? expanded;

  const ResponsiveBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sizeClass = windowSizeClassFromWidth(width);

        return switch (sizeClass) {
          WindowSizeClass.compact => compact(context, constraints),
          WindowSizeClass.medium => (medium ?? compact)(context, constraints),
          WindowSizeClass.expanded =>
              (expanded ?? medium ?? compact)(context, constraints),
        };
      },
    );
  }
}

/// Simplified ResponsiveBuilder that just takes widgets instead of builders.
/// Useful when you don't need access to constraints.
///
/// Example:
/// ```dart
/// ResponsiveWidget(
///   compact: MobileLayout(),
///   expanded: DesktopLayout(),
/// )
/// ```
class ResponsiveWidget extends StatelessWidget {
  /// Widget for compact screens (< 600dp)
  final Widget compact;

  /// Widget for medium screens (600-839dp)
  final Widget? medium;

  /// Widget for expanded screens (>= 840dp)
  final Widget? expanded;

  const ResponsiveWidget({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (_, __) => compact,
      medium: medium != null ? (_, __) => medium! : null,
      expanded: expanded != null ? (_, __) => expanded! : null,
    );
  }
}
```

### 2.2 ResponsiveVisibility

Create file: `lib/src/design_system/responsive/responsive_visibility.dart`

```dart
import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// A widget that shows or hides content based on screen size.
///
/// Use this for content that should be hidden on certain screen sizes
/// rather than rearranged. For layout changes, use [ResponsiveBuilder].
///
/// Example:
/// ```dart
/// // Only visible on mobile
/// ResponsiveVisibility(
///   visibleOn: {WindowSizeClass.compact},
///   child: MobileOnlyWidget(),
/// )
///
/// // Hidden on mobile (visible on tablet and desktop)
/// ResponsiveVisibility(
///   hiddenOn: {WindowSizeClass.compact},
///   child: TabletAndDesktopWidget(),
/// )
/// ```
class ResponsiveVisibility extends StatelessWidget {
  /// The child widget to conditionally show/hide
  final Widget child;

  /// Set of window size classes where the child should be VISIBLE
  /// If provided, [hiddenOn] is ignored
  final Set<WindowSizeClass>? visibleOn;

  /// Set of window size classes where the child should be HIDDEN
  /// Only used if [visibleOn] is not provided
  final Set<WindowSizeClass>? hiddenOn;

  /// Widget to show when the child is hidden
  /// Defaults to SizedBox.shrink()
  final Widget? replacement;

  /// Whether to maintain state when hidden
  /// If true, uses Offstage instead of conditional rendering
  /// Useful for widgets with expensive state initialization
  final bool maintainState;

  /// Whether to maintain the widget's size when hidden
  /// Only works when [maintainState] is true
  final bool maintainSize;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOn,
    this.hiddenOn,
    this.replacement,
    this.maintainState = false,
    this.maintainSize = false,
  }) : assert(
         visibleOn != null || hiddenOn != null,
         'Either visibleOn or hiddenOn must be provided',
       );

  /// Factory for showing only on compact screens
  factory ResponsiveVisibility.compactOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
    bool maintainState = false,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {WindowSizeClass.compact},
      replacement: replacement,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Factory for showing only on medium screens
  factory ResponsiveVisibility.mediumOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
    bool maintainState = false,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {WindowSizeClass.medium},
      replacement: replacement,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Factory for showing only on expanded screens
  factory ResponsiveVisibility.expandedOnly({
    Key? key,
    required Widget child,
    Widget? replacement,
    bool maintainState = false,
  }) {
    return ResponsiveVisibility(
      key: key,
      visibleOn: const {WindowSizeClass.expanded},
      replacement: replacement,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Factory for hiding on compact screens (mobile)
  factory ResponsiveVisibility.hideOnCompact({
    Key? key,
    required Widget child,
    Widget? replacement,
    bool maintainState = false,
  }) {
    return ResponsiveVisibility(
      key: key,
      hiddenOn: const {WindowSizeClass.compact},
      replacement: replacement,
      maintainState: maintainState,
      child: child,
    );
  }

  /// Factory for hiding on expanded screens (desktop)
  factory ResponsiveVisibility.hideOnExpanded({
    Key? key,
    required Widget child,
    Widget? replacement,
    bool maintainState = false,
  }) {
    return ResponsiveVisibility(
      key: key,
      hiddenOn: const {WindowSizeClass.expanded},
      replacement: replacement,
      maintainState: maintainState,
      child: child,
    );
  }

  bool _isVisible(WindowSizeClass sizeClass) {
    if (visibleOn != null) {
      return visibleOn!.contains(sizeClass);
    }
    if (hiddenOn != null) {
      return !hiddenOn!.contains(sizeClass);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizeClass = windowSizeClassFromWidth(constraints.maxWidth);
        final visible = _isVisible(sizeClass);

        if (maintainState) {
          return Visibility(
            visible: visible,
            maintainState: true,
            maintainSize: maintainSize,
            maintainAnimation: maintainSize,
            maintainInteractivity: false,
            replacement: replacement ?? const SizedBox.shrink(),
            child: child,
          );
        }

        if (visible) {
          return child;
        }

        return replacement ?? const SizedBox.shrink();
      },
    );
  }
}
```

### 2.3 Responsive Spacing

Create file: `lib/src/design_system/responsive/responsive_spacing.dart`

```dart
import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

/// Provides responsive spacing values based on screen size
///
/// Usage:
/// ```dart
/// Padding(
///   padding: ResponsiveSpacing.horizontalPadding(context),
///   child: Content(),
/// )
/// ```
abstract final class ResponsiveSpacing {
  ResponsiveSpacing._();

  /// Standard horizontal page padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: context.responsiveValue(
        compact: 16.0,
        medium: 24.0,
        expanded: 32.0,
      ),
    );
  }

  /// Standard vertical section spacing
  static double sectionSpacing(BuildContext context) {
    return context.responsiveValue(
      compact: 32.0,
      medium: 48.0,
      expanded: 64.0,
    );
  }

  /// Standard card/content padding
  static EdgeInsets contentPadding(BuildContext context) {
    return EdgeInsets.all(
      context.responsiveValue(
        compact: 16.0,
        medium: 20.0,
        expanded: 24.0,
      ),
    );
  }

  /// Gap between grid/list items
  static double itemGap(BuildContext context) {
    return context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 20.0,
    );
  }

  /// Standard border radius
  static double borderRadius(BuildContext context) {
    return context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 20.0,
    );
  }
}

/// A SizedBox with responsive height/width
class ResponsiveGap extends StatelessWidget {
  final double? compactSize;
  final double? mediumSize;
  final double? expandedSize;
  final bool isVertical;

  const ResponsiveGap.vertical({
    super.key,
    this.compactSize = 16,
    this.mediumSize,
    this.expandedSize,
  }) : isVertical = true;

  const ResponsiveGap.horizontal({
    super.key,
    this.compactSize = 16,
    this.mediumSize,
    this.expandedSize,
  }) : isVertical = false;

  @override
  Widget build(BuildContext context) {
    final size = context.responsiveValue(
      compact: compactSize ?? 16,
      medium: mediumSize,
      expanded: expandedSize,
    );

    return SizedBox(
      height: isVertical ? size : null,
      width: isVertical ? null : size,
    );
  }
}
```

### 2.4 Export File

Create file: `lib/src/design_system/responsive/responsive.dart`

```dart
/// Responsive design utilities for ZenScrap Flutter
///
/// This library provides:
/// - [Breakpoints] - Material Design 3 breakpoint constants
/// - [WindowSizeClass] - Enum for size classification
/// - [ResponsiveContext] - BuildContext extension for responsive values
/// - [ResponsiveBuilder] - Widget for layout switching
/// - [ResponsiveVisibility] - Widget for conditional visibility
/// - [ResponsiveSpacing] - Responsive spacing utilities
library;

export 'breakpoints.dart';
export 'responsive_builder.dart';
export 'responsive_visibility.dart';
export 'responsive_spacing.dart';
```

---

## Section 3: Adaptive Layouts

### 3.1 AdaptiveScaffold

Create file: `lib/src/design_system/layouts/adaptive_scaffold.dart`

```dart
import 'package:flutter/material.dart';
import '../responsive/responsive.dart';

/// A navigation destination for the adaptive scaffold
class AdaptiveDestination {
  /// Icon when the destination is not selected
  final IconData icon;

  /// Icon when the destination is selected
  final IconData? selectedIcon;

  /// Text label for the destination
  final String label;

  /// Optional tooltip (defaults to label)
  final String? tooltip;

  /// Optional badge count
  final int? badgeCount;

  const AdaptiveDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.badgeCount,
  });
}

/// An adaptive scaffold that switches navigation based on screen size:
/// - Compact: Bottom navigation bar
/// - Medium: Navigation rail
/// - Expanded: Navigation drawer (collapsible)
///
/// Example:
/// ```dart
/// AdaptiveScaffold(
///   selectedIndex: _currentIndex,
///   onDestinationSelected: (index) => setState(() => _currentIndex = index),
///   destinations: [
///     AdaptiveDestination(icon: Icons.home, label: 'Home'),
///     AdaptiveDestination(icon: Icons.settings, label: 'Settings'),
///   ],
///   body: _pages[_currentIndex],
/// )
/// ```
class AdaptiveScaffold extends StatelessWidget {
  /// The currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// The navigation destinations
  final List<AdaptiveDestination> destinations;

  /// The main body content
  final Widget body;

  /// Optional app bar (for compact mode)
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Location of the FAB
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Whether the drawer should be extended (expanded mode only)
  final bool extendedDrawer;

  /// Optional leading widget for the navigation rail/drawer
  final Widget? navigationLeading;

  /// Optional trailing widget for the navigation rail/drawer
  final Widget? navigationTrailing;

  /// Optional callback for drawer toggle (expanded mode)
  final VoidCallback? onDrawerToggle;

  /// Custom background color for navigation
  final Color? navigationBackgroundColor;

  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendedDrawer = true,
    this.navigationLeading,
    this.navigationTrailing,
    this.onDrawerToggle,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => _CompactLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
      medium: (context, constraints) => _MediumLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationLeading: navigationLeading,
        navigationTrailing: navigationTrailing,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
      expanded: (context, constraints) => _ExpandedLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationLeading: navigationLeading,
        navigationTrailing: navigationTrailing,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
    );
  }
}

/// Compact layout: Bottom navigation bar
class _CompactLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? navigationBackgroundColor;

  const _CompactLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: navigationBackgroundColor,
        destinations: destinations.map((dest) {
          return NavigationDestination(
            icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
            selectedIcon: _BadgeIcon(
              icon: dest.selectedIcon ?? dest.icon,
              badgeCount: dest.badgeCount,
            ),
            label: dest.label,
            tooltip: dest.tooltip ?? dest.label,
          );
        }).toList(),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Medium layout: Navigation rail
class _MediumLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? navigationLeading;
  final Widget? navigationTrailing;
  final Color? navigationBackgroundColor;

  const _MediumLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationLeading,
    this.navigationTrailing,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: navigationBackgroundColor,
            labelType: NavigationRailLabelType.all,
            leading: navigationLeading,
            trailing: navigationTrailing != null
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: navigationTrailing,
                      ),
                    ),
                  )
                : null,
            destinations: destinations.map((dest) {
              return NavigationRailDestination(
                icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
                selectedIcon: _BadgeIcon(
                  icon: dest.selectedIcon ?? dest.icon,
                  badgeCount: dest.badgeCount,
                ),
                label: Text(dest.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Expanded layout: Navigation drawer
class _ExpandedLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? navigationLeading;
  final Widget? navigationTrailing;
  final Color? navigationBackgroundColor;

  const _ExpandedLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationLeading,
    this.navigationTrailing,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: navigationBackgroundColor,
            children: [
              if (navigationLeading != null) ...[
                navigationLeading!,
                const Divider(indent: 16, endIndent: 16),
              ],
              ...destinations.map((dest) {
                return NavigationDrawerDestination(
                  icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
                  selectedIcon: _BadgeIcon(
                    icon: dest.selectedIcon ?? dest.icon,
                    badgeCount: dest.badgeCount,
                  ),
                  label: Text(dest.label),
                );
              }),
              if (navigationTrailing != null) ...[
                const Spacer(),
                const Divider(indent: 16, endIndent: 16),
                navigationTrailing!,
                const SizedBox(height: 16),
              ],
            ],
          ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Icon with optional badge count
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;

  const _BadgeIcon({
    required this.icon,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);

    if (badgeCount == null || badgeCount! <= 0) {
      return iconWidget;
    }

    return Badge.count(
      count: badgeCount!,
      child: iconWidget,
    );
  }
}
```

### 3.2 MasterDetailLayout

Create file: `lib/src/design_system/layouts/master_detail_layout.dart`

```dart
import 'package:flutter/material.dart';
import '../responsive/responsive.dart';

/// A responsive master-detail layout that shows:
/// - Compact: Full-screen master OR detail (with back navigation)
/// - Medium/Expanded: Side-by-side master and detail
///
/// Example:
/// ```dart
/// MasterDetailLayout(
///   masterBuilder: (context, isDetailVisible) => ListView(...),
///   detailBuilder: (context) => DetailView(),
///   hasSelection: _selectedItem != null,
///   onDetailClose: () => setState(() => _selectedItem = null),
/// )
/// ```
class MasterDetailLayout extends StatelessWidget {
  /// Builder for the master (list) view
  /// [isDetailVisible] indicates if the detail is currently shown (compact mode)
  final Widget Function(BuildContext context, bool isDetailVisible) masterBuilder;

  /// Builder for the detail view
  /// Returns null to show empty/placeholder state
  final Widget? Function(BuildContext context) detailBuilder;

  /// Whether an item is currently selected
  final bool hasSelection;

  /// Callback when detail view should be closed (compact mode back button)
  final VoidCallback? onDetailClose;

  /// Placeholder widget when no selection (medium/expanded modes)
  final Widget? emptyDetailPlaceholder;

  /// Flex ratio for master panel (medium/expanded modes)
  /// Defaults to 2 (40% of space with default detail flex of 3)
  final int masterFlex;

  /// Flex ratio for detail panel (medium/expanded modes)
  /// Defaults to 3 (60% of space with default master flex of 2)
  final int detailFlex;

  /// Minimum width for master panel
  final double? masterMinWidth;

  /// Maximum width for master panel
  final double? masterMaxWidth;

  /// Whether to show a divider between panels
  final bool showDivider;

  const MasterDetailLayout({
    super.key,
    required this.masterBuilder,
    required this.detailBuilder,
    this.hasSelection = false,
    this.onDetailClose,
    this.emptyDetailPlaceholder,
    this.masterFlex = 2,
    this.detailFlex = 3,
    this.masterMinWidth,
    this.masterMaxWidth,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => _CompactLayout(
        masterBuilder: masterBuilder,
        detailBuilder: detailBuilder,
        hasSelection: hasSelection,
        onDetailClose: onDetailClose,
      ),
      medium: (context, constraints) => _SplitLayout(
        masterBuilder: masterBuilder,
        detailBuilder: detailBuilder,
        emptyDetailPlaceholder: emptyDetailPlaceholder,
        masterFlex: masterFlex,
        detailFlex: detailFlex,
        masterMinWidth: masterMinWidth,
        masterMaxWidth: masterMaxWidth,
        showDivider: showDivider,
      ),
      expanded: (context, constraints) => _SplitLayout(
        masterBuilder: masterBuilder,
        detailBuilder: detailBuilder,
        emptyDetailPlaceholder: emptyDetailPlaceholder,
        masterFlex: masterFlex,
        detailFlex: detailFlex,
        masterMinWidth: masterMinWidth,
        masterMaxWidth: masterMaxWidth,
        showDivider: showDivider,
      ),
    );
  }
}

/// Compact: Show master OR detail, not both
class _CompactLayout extends StatelessWidget {
  final Widget Function(BuildContext context, bool isDetailVisible) masterBuilder;
  final Widget? Function(BuildContext context) detailBuilder;
  final bool hasSelection;
  final VoidCallback? onDetailClose;

  const _CompactLayout({
    required this.masterBuilder,
    required this.detailBuilder,
    required this.hasSelection,
    this.onDetailClose,
  });

  @override
  Widget build(BuildContext context) {
    if (hasSelection) {
      final detail = detailBuilder(context);
      if (detail != null) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              onDetailClose?.call();
            }
          },
          child: detail,
        );
      }
    }

    return masterBuilder(context, hasSelection);
  }
}

/// Medium/Expanded: Side-by-side layout
class _SplitLayout extends StatelessWidget {
  final Widget Function(BuildContext context, bool isDetailVisible) masterBuilder;
  final Widget? Function(BuildContext context) detailBuilder;
  final Widget? emptyDetailPlaceholder;
  final int masterFlex;
  final int detailFlex;
  final double? masterMinWidth;
  final double? masterMaxWidth;
  final bool showDivider;

  const _SplitLayout({
    required this.masterBuilder,
    required this.detailBuilder,
    this.emptyDetailPlaceholder,
    required this.masterFlex,
    required this.detailFlex,
    this.masterMinWidth,
    this.masterMaxWidth,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final detail = detailBuilder(context);

    Widget masterPanel = masterBuilder(context, false);

    // Apply min/max width constraints if specified
    if (masterMinWidth != null || masterMaxWidth != null) {
      masterPanel = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: masterMinWidth ?? 0,
          maxWidth: masterMaxWidth ?? double.infinity,
        ),
        child: masterPanel,
      );
    }

    return Row(
      children: [
        Flexible(
          flex: masterFlex,
          child: masterPanel,
        ),
        if (showDivider) const VerticalDivider(width: 1, thickness: 1),
        Flexible(
          flex: detailFlex,
          child: detail ??
              emptyDetailPlaceholder ??
              const _DefaultPlaceholder(),
        ),
      ],
    );
  }
}

/// Default placeholder when no item is selected
class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Select an item to view details',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.3 ResponsiveGrid

Create file: `lib/src/design_system/layouts/responsive_grid.dart`

```dart
import 'package:flutter/material.dart';
import '../responsive/responsive.dart';

/// A responsive grid that automatically adjusts columns based on screen size.
///
/// Example:
/// ```dart
/// ResponsiveGrid(
///   compactColumns: 1,
///   mediumColumns: 2,
///   expandedColumns: 3,
///   children: items.map((item) => ItemCard(item: item)).toList(),
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  /// Number of columns on compact screens
  final int compactColumns;

  /// Number of columns on medium screens
  final int? mediumColumns;

  /// Number of columns on expanded screens
  final int? expandedColumns;

  /// Spacing between columns
  final double crossAxisSpacing;

  /// Spacing between rows
  final double mainAxisSpacing;

  /// Aspect ratio for children (width / height)
  /// If null, uses mainAxisExtent instead
  final double? childAspectRatio;

  /// Fixed height for children
  /// Only used if childAspectRatio is null
  final double? mainAxisExtent;

  /// The grid children
  final List<Widget> children;

  /// Whether the grid should shrink-wrap its content
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    this.compactColumns = 1,
    this.mediumColumns,
    this.expandedColumns,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio,
    this.mainAxisExtent,
    required this.children,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  /// Factory for a grid that auto-fits children based on minimum width
  factory ResponsiveGrid.autoFit({
    Key? key,
    required double minChildWidth,
    double crossAxisSpacing = 16,
    double mainAxisSpacing = 16,
    double? childAspectRatio,
    double? mainAxisExtent,
    required List<Widget> children,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) {
    return _AutoFitResponsiveGrid(
      key: key,
      minChildWidth: minChildWidth,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      mainAxisExtent: mainAxisExtent,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = responsiveValue(
          width: constraints.maxWidth,
          compact: compactColumns,
          medium: mediumColumns,
          expanded: expandedColumns,
        );

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio ?? 1.0,
          mainAxisExtent: childAspectRatio == null ? mainAxisExtent : null,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
          children: children,
        );
      },
    );
  }
}

/// Internal: Auto-fit grid implementation
class _AutoFitResponsiveGrid extends StatelessWidget {
  final double minChildWidth;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final List<Widget> children;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const _AutoFitResponsiveGrid({
    super.key,
    required this.minChildWidth,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    this.childAspectRatio,
    this.mainAxisExtent,
    required this.children,
    required this.shrinkWrap,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth -
            (padding != null ? (padding as EdgeInsets).horizontal : 0);
        final columns = (availableWidth / minChildWidth).floor().clamp(1, 12);

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio ?? 1.0,
          mainAxisExtent: childAspectRatio == null ? mainAxisExtent : null,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
          children: children,
        );
      },
    );
  }
}
```

### 3.4 ContentWidthContainer

Create file: `lib/src/design_system/layouts/content_width_container.dart`

```dart
import 'package:flutter/material.dart';
import '../responsive/responsive.dart';

/// A container that constrains its child to a maximum width based on breakpoints.
/// Centers the content horizontally when the screen is wider than the max width.
///
/// Example:
/// ```dart
/// ContentWidthContainer(
///   child: Column(
///     children: [...],
///   ),
/// )
/// ```
class ContentWidthContainer extends StatelessWidget {
  /// The child widget
  final Widget child;

  /// Maximum width on compact screens (defaults to no limit)
  final double? compactMaxWidth;

  /// Maximum width on medium screens
  final double? mediumMaxWidth;

  /// Maximum width on expanded screens
  final double expandedMaxWidth;

  /// Horizontal padding applied inside the container
  final EdgeInsetsGeometry? padding;

  /// Alignment of the child within the container
  final Alignment alignment;

  /// Background color for the container
  final Color? backgroundColor;

  const ContentWidthContainer({
    super.key,
    required this.child,
    this.compactMaxWidth,
    this.mediumMaxWidth,
    this.expandedMaxWidth = 1200,
    this.padding,
    this.alignment = Alignment.topCenter,
    this.backgroundColor,
  });

  /// Factory for article/blog content (narrower max width)
  factory ContentWidthContainer.article({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return ContentWidthContainer(
      key: key,
      expandedMaxWidth: 720,
      mediumMaxWidth: 600,
      padding: padding,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Factory for wide content (dashboard, tables)
  factory ContentWidthContainer.wide({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return ContentWidthContainer(
      key: key,
      expandedMaxWidth: 1400,
      mediumMaxWidth: 900,
      padding: padding,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = responsiveValue(
          width: constraints.maxWidth,
          compact: compactMaxWidth ?? double.infinity,
          medium: mediumMaxWidth,
          expanded: expandedMaxWidth,
        );

        Widget content = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        );

        if (padding != null) {
          content = Padding(padding: padding!, child: content);
        }

        return Container(
          width: double.infinity,
          color: backgroundColor,
          alignment: alignment,
          child: content,
        );
      },
    );
  }
}
```

### 3.5 Export File

Create file: `lib/src/design_system/layouts/layouts.dart`

```dart
/// Adaptive layout widgets for ZenScrap Flutter
///
/// This library provides:
/// - [AdaptiveScaffold] - Navigation switching scaffold
/// - [MasterDetailLayout] - Split view pattern
/// - [ResponsiveGrid] - Auto-adjusting grid
/// - [ContentWidthContainer] - Max-width container
library;

export 'adaptive_scaffold.dart';
export 'master_detail_layout.dart';
export 'responsive_grid.dart';
export 'content_width_container.dart';
```

---

## Section 4: Folder Structure

### Complete Folder Structure

```
lib/
├── l10n/                              # Localization files
│   ├── app_en.arb                     # English (base)
│   ├── app_pt.arb                     # Portuguese
│   ├── app_pt_BR.arb                  # Brazilian Portuguese
│   ├── app_de.arb                     # German
│   ├── app_es.arb                     # Spanish
│   ├── app_fr.arb                     # French
│   └── app_ja.arb                     # Japanese
│
├── src/
│   ├── core/                          # Core utilities, mixins, theme
│   │   ├── mixins/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── web/
│   │
│   ├── design_system/                 # SHARED design system components
│   │   ├── responsive/                # NEW: Responsive utilities
│   │   │   ├── responsive.dart        # Export barrel file
│   │   │   ├── breakpoints.dart       # Breakpoint constants & extensions
│   │   │   ├── responsive_builder.dart
│   │   │   ├── responsive_visibility.dart
│   │   │   └── responsive_spacing.dart
│   │   │
│   │   ├── layouts/                   # NEW: Adaptive layout widgets
│   │   │   ├── layouts.dart           # Export barrel file
│   │   │   ├── adaptive_scaffold.dart
│   │   │   ├── master_detail_layout.dart
│   │   │   ├── responsive_grid.dart
│   │   │   └── content_width_container.dart
│   │   │
│   │   ├── components/                # Reusable UI components
│   │   ├── elements/                  # Basic UI elements
│   │   ├── extensions/                # BuildContext extensions
│   │   └── widgets/                   # Shared widgets
│   │
│   ├── providers/                     # Riverpod providers
│   │
│   ├── states/                        # State management
│   │
│   └── ui/                            # Feature-specific UI
│       └── [feature]/                 # e.g., dashboard, api_usage
│           ├── views/                 # Main view widgets (*_view.dart)
│           ├── pages/                 # Full page widgets (*_page.dart)
│           ├── widgets/               # Feature-specific widgets
│           ├── sections/              # Page sections (*_section.dart)
│           ├── dialogs/               # Dialog widgets (*_dialog.dart)
│           ├── templates/             # Layout templates (*_template.dart)
│           └── layouts/               # Optional: Feature-specific responsive layouts
│
├── main.dart
└── ...
```

### Import Guidelines

```dart
// Responsive utilities - import the barrel file
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

// Layouts - import the barrel file
import 'package:zenscrap_flutter/src/design_system/layouts/layouts.dart';

// Or import specific files if needed
import 'package:zenscrap_flutter/src/design_system/responsive/breakpoints.dart';
```

---

## Section 5: Naming Conventions

### File and Class Naming

| Folder | File Suffix | Class Suffix | Enforced by Lint | Example |
|--------|-------------|--------------|------------------|---------|
| `views/` | `_view.dart` | `View` | Yes | `api_usage_view.dart` -> `ApiUsageView` |
| `pages/` | `_page.dart` | `Page` | Yes | `login_page.dart` -> `LoginPage` |
| `widgets/` | `_widget.dart` | (flexible) | No | `trust_badges_row.dart` -> `TrustBadgesRow` |
| `dialogs/` | `_dialog.dart` | `Dialog` | Yes | `create_api_key_dialog.dart` -> `CreateApiKeyDialog` |
| `sections/` | `_section.dart` | `Section` | Yes | `hero_section.dart` -> `HeroSection` |
| `templates/` | `_template.dart` | `Template` | Yes | `auth_form_template.dart` -> `AuthFormTemplate` |
| `layouts/` | `_layout.dart` | `Layout` | Yes (new) | `mobile_layout.dart` -> `MobileLayout` |

### Widget Naming Patterns

```dart
// View: Main feature view that orchestrates the screen
class ApiUsageView extends ConsumerStatefulWidget { ... }

// Page: A full-screen page, often a route destination
class LoginPage extends StatelessWidget { ... }

// Section: A self-contained portion of a view
class HeroSection extends ConsumerStatefulWidget { ... }

// Dialog: Modal dialog content
class CreateApiKeyDialog extends StatelessWidget { ... }

// Template: Reusable layout structure
class AuthFormTemplate extends StatelessWidget { ... }

// Layout: Responsive layout variant
class MobileLayout extends ConsumerWidget { ... }
class DesktopLayout extends StatelessWidget { ... }

// Widget: General reusable widget (flexible naming)
class TrustBadgesRow extends StatelessWidget { ... }
class CategoryBadge extends StatelessWidget { ... }
```

### Private Widget Naming

Private widgets (prefixed with `_`) can be defined in the same file as their parent widget without separate naming requirements:

```dart
// In api_usage_view.dart
class ApiUsageView extends ConsumerStatefulWidget { ... }

// Private widgets in the same file - allowed
class _LoadingState extends StatelessWidget { ... }
class _ErrorState extends StatelessWidget { ... }
class _ContentState extends StatelessWidget { ... }
```

### Responsive Variant Naming

When creating responsive variants of a view, use clear suffixes:

```dart
// In api_usage_view.dart
class ApiUsageView extends ConsumerStatefulWidget { ... }

// Responsive variants - can be in same file or separate files
class MobileLayout extends ConsumerWidget { ... }
class DesktopLayout extends StatelessWidget { ... }

// Or using private variants in the same file
class _MobileLayout extends ConsumerWidget { ... }
class _DesktopLayout extends StatelessWidget { ... }
```

---

## Section 6: Migration Patterns

### 6.1 Converting Row to Column on Mobile

**Before (Desktop only):**
```dart
Row(
  children: [
    Expanded(child: CreditsOverviewSection(...)),
    SizedBox(width: 24),
    Expanded(child: PurchaseSection()),
  ],
)
```

**After (Responsive):**
```dart
ResponsiveBuilder(
  compact: (context, constraints) => Column(
    children: [
      CreditsOverviewSection(...),
      SizedBox(height: 16),
      PurchaseSection(),
    ],
  ),
  expanded: (context, constraints) => Row(
    children: [
      Expanded(child: CreditsOverviewSection(...)),
      SizedBox(width: 24),
      Expanded(child: PurchaseSection()),
    ],
  ),
)
```

**Or using ResponsiveWidget:**
```dart
ResponsiveWidget(
  compact: _MobileContent(),
  expanded: _DesktopContent(),
)
```

### 6.2 Navigation Switching

**Before (Desktop only):**
```dart
Scaffold(
  body: Row(
    children: [
      DashboardDrawer(...),
      Expanded(child: content),
    ],
  ),
)
```

**After (Responsive with AdaptiveScaffold):**
```dart
AdaptiveScaffold(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) => _handleNavigation(index),
  destinations: [
    AdaptiveDestination(icon: Icons.dashboard, label: 'Dashboard'),
    AdaptiveDestination(icon: Icons.key, label: 'API Keys'),
    AdaptiveDestination(icon: Icons.analytics, label: 'Analytics'),
  ],
  body: _pages[_currentIndex],
)
```

**Or manual implementation:**
```dart
ResponsiveBuilder(
  compact: (context, constraints) => Scaffold(
    appBar: AppBar(...),
    drawer: NavigationDrawer(...),
    bottomNavigationBar: NavigationBar(...),
    body: content,
  ),
  medium: (context, constraints) => Scaffold(
    body: Row(
      children: [
        NavigationRail(...),
        VerticalDivider(width: 1),
        Expanded(child: content),
      ],
    ),
  ),
  expanded: (context, constraints) => Scaffold(
    body: Row(
      children: [
        NavigationDrawer(...),
        Expanded(child: content),
      ],
    ),
  ),
)
```

### 6.3 Grid Column Adjustment

**Before:**
```dart
GridView.count(
  crossAxisCount: 3,
  children: [...],
)
```

**After:**
```dart
ResponsiveGrid(
  compactColumns: 1,
  mediumColumns: 2,
  expandedColumns: 3,
  children: [...],
)
```

**Or using ResponsiveBuilder:**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final columns = responsiveValue(
      width: constraints.maxWidth,
      compact: 1,
      medium: 2,
      expanded: 3,
    );

    return GridView.count(
      crossAxisCount: columns,
      children: [...],
    );
  },
)
```

### 6.4 Padding/Spacing Scaling

**Before:**
```dart
Padding(
  padding: EdgeInsets.all(32),
  child: content,
)
```

**After:**
```dart
Padding(
  padding: ResponsiveSpacing.contentPadding(context),
  child: content,
)

// Or inline:
Padding(
  padding: EdgeInsets.all(
    context.responsiveValue(
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
    ),
  ),
  child: content,
)
```

### 6.5 Conditional Content

**Before (always visible):**
```dart
Row(
  children: [
    SidePanel(),
    MainContent(),
  ],
)
```

**After (hide on mobile):**
```dart
Row(
  children: [
    ResponsiveVisibility.hideOnCompact(
      child: SidePanel(),
    ),
    Expanded(child: MainContent()),
  ],
)

// Or fully rebuild layout:
ResponsiveBuilder(
  compact: (_, __) => MainContent(),
  expanded: (_, __) => Row(
    children: [
      SidePanel(),
      Expanded(child: MainContent()),
    ],
  ),
)
```

### 6.6 Master-Detail Pattern

**Before (separate pages):**
```dart
// List page
class ItemListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemDetailPage(item: items[index])),
        ),
      ),
    );
  }
}
```

**After (responsive master-detail):**
```dart
class ItemsView extends StatefulWidget {
  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  Item? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return MasterDetailLayout(
      hasSelection: _selectedItem != null,
      onDetailClose: () => setState(() => _selectedItem = null),
      masterBuilder: (context, isDetailVisible) => ListView.builder(
        itemBuilder: (context, index) => ListTile(
          selected: items[index] == _selectedItem,
          onTap: () => setState(() => _selectedItem = items[index]),
          title: Text(items[index].title),
        ),
      ),
      detailBuilder: (context) {
        if (_selectedItem == null) return null;
        return ItemDetailView(item: _selectedItem!);
      },
    );
  }
}
```

---

## Section 7: Performance Best Practices

### 7.1 Use LayoutBuilder Over MediaQuery When Possible

**Why**: `LayoutBuilder` only rebuilds when parent constraints change, while `MediaQuery.of(context)` creates a dependency on the entire MediaQuery, causing rebuilds on any media change (keyboard, orientation, etc.).

```dart
// PREFER: LayoutBuilder for local sizing
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    }
    return DesktopLayout();
  },
)

// AVOID: MediaQuery.of for layout decisions
Builder(
  builder: (context) {
    if (MediaQuery.of(context).size.width < 600) {  // Rebuilds on ANY MediaQuery change
      return MobileLayout();
    }
    return DesktopLayout();
  },
)
```

### 7.2 Use MediaQuery.sizeOf() Instead of MediaQuery.of()

**Why**: `MediaQuery.sizeOf(context)` only creates a dependency on the size property, not the entire `MediaQueryData`. This prevents rebuilds when other properties change (like keyboard visibility).

```dart
// PREFER: Specific accessor
final width = MediaQuery.sizeOf(context).width;
final height = MediaQuery.sizeOf(context).height;
final padding = MediaQuery.paddingOf(context);
final orientation = MediaQuery.orientationOf(context);

// AVOID: Full MediaQuery dependency
final width = MediaQuery.of(context).size.width;  // Rebuilds on ANY change
```

### 7.3 Avoid Nested ResponsiveBuilders

**Why**: Each `LayoutBuilder`/`ResponsiveBuilder` adds a rebuild boundary. Nesting them creates unnecessary rebuild cascades.

```dart
// AVOID: Nested responsive builders
ResponsiveBuilder(
  compact: (_, __) => Column(
    children: [
      ResponsiveBuilder(  // UNNECESSARY - parent already determined size class
        compact: (_, __) => SmallHeader(),
        expanded: (_, __) => LargeHeader(),
      ),
      Content(),
    ],
  ),
  expanded: (_, __) => ...,
)

// PREFER: Single responsive builder with composed children
ResponsiveBuilder(
  compact: (context, constraints) => Column(
    children: [
      SmallHeader(),  // Header knows to be "small" because parent chose compact
      Content(),
    ],
  ),
  expanded: (context, constraints) => Row(
    children: [
      LargeHeader(),
      Expanded(child: Content()),
    ],
  ),
)
```

### 7.4 Lazy Layout Building

**Why**: Only build the layout that will be displayed, not all variants.

```dart
// PREFER: Only builds one variant (the one that matches)
ResponsiveBuilder(
  compact: (_, __) => MobileLayout(),
  expanded: (_, __) => DesktopLayout(),
)

// AVOID: Builds all variants, hides unused ones
Stack(
  children: [
    Visibility(
      visible: context.isCompact,
      child: MobileLayout(),  // Built even when not visible
    ),
    Visibility(
      visible: context.isExpanded,
      child: DesktopLayout(),  // Built even when not visible
    ),
  ],
)
```

### 7.5 Use const Constructors

```dart
// PREFER: const for static responsive values
const ResponsiveWidget(
  compact: SizedBox(height: 16),
  expanded: SizedBox(height: 32),
)

// Use const for fixed spacing
ResponsiveGap.vertical(
  compactSize: 16,
  expandedSize: 32,
)
```

### 7.6 Memoize Expensive Computations

When layouts involve expensive computations, create separate widget classes and cache the computed data:

```dart
class MyView extends StatefulWidget {
  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  // Cache expensive computed data, not widgets
  late final ExpensiveData _computedData = _computeExpensiveData();

  ExpensiveData _computeExpensiveData() {
    // Expensive computation that produces data...
    return ExpensiveData();
  }

  @override
  Widget build(BuildContext context) {
    // Pass cached data to widget classes
    return ResponsiveWidget(
      compact: _MobileLayout(data: _computedData),
      expanded: _DesktopLayout(data: _computedData),
    );
  }
}

/// Mobile layout widget
class _MobileLayout extends StatelessWidget {
  final ExpensiveData data;

  const _MobileLayout({required this.data});

  @override
  Widget build(BuildContext context) {
    return MobileLayoutContent(data: data);
  }
}

/// Desktop layout widget
class _DesktopLayout extends StatelessWidget {
  final ExpensiveData data;

  const _DesktopLayout({required this.data});

  @override
  Widget build(BuildContext context) {
    return DesktopLayoutContent(data: data);
  }
}
```

**Key principle**: Cache computed DATA, not widgets. Widgets should always be built fresh to properly respond to theme changes, localization, etc.

---

## Section 8: Testing Requirements

### 8.1 Screen Sizes to Test

| Name | Width | Represents |
|------|-------|------------|
| `smallPhone` | 320 | iPhone SE, small Android |
| `phone` | 375 | iPhone X/11/12/13/14 |
| `largePhone` | 428 | iPhone 14 Pro Max |
| `tabletPortrait` | 600 | Medium breakpoint start |
| `tabletLandscape` | 900 | Large tablet |
| `desktop` | 1200 | Desktop |
| `wideDesktop` | 1600 | Wide monitor |

### 8.2 Test Configuration

Create file: `test/responsive_test_utils.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Standard device sizes for responsive testing
class TestDeviceSizes {
  static const Size smallPhone = Size(320, 568);
  static const Size phone = Size(375, 812);
  static const Size largePhone = Size(428, 926);
  static const Size tabletPortrait = Size(600, 1024);
  static const Size tabletLandscape = Size(900, 600);
  static const Size desktop = Size(1200, 800);
  static const Size wideDesktop = Size(1600, 900);

  static const List<Size> all = [
    smallPhone,
    phone,
    largePhone,
    tabletPortrait,
    tabletLandscape,
    desktop,
    wideDesktop,
  ];

  static const List<Size> breakpointEdges = [
    Size(599, 800),   // Just before medium
    Size(600, 800),   // Medium start
    Size(839, 800),   // Just before expanded
    Size(840, 800),   // Expanded start
  ];
}

/// Extension on WidgetTester for responsive testing
extension ResponsiveTester on WidgetTester {
  /// Sets the test surface size
  Future<void> setScreenSize(Size size) async {
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  }

  /// Tests a widget across multiple screen sizes
  Future<void> pumpWidgetForSizes(
    Widget widget,
    List<Size> sizes,
    Future<void> Function(Size size) testCallback,
  ) async {
    for (final size in sizes) {
      await setScreenSize(size);
      await pumpWidget(widget);
      await testCallback(size);
    }
  }
}

/// Wrapper for testing responsive widgets with proper Material context
Widget responsiveTestWrapper(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}
```

### 8.3 Overflow Detection Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'responsive_test_utils.dart';

void main() {
  group('MyView Responsive Tests', () {
    testWidgets('renders without overflow on all screen sizes', (tester) async {
      // Track overflow errors
      final List<String> overflowErrors = [];
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (details) {
        if (details.toString().contains('overflowed')) {
          overflowErrors.add(details.toString());
        } else {
          originalOnError?.call(details);
        }
      };

      try {
        for (final size in TestDeviceSizes.all) {
          overflowErrors.clear();

          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(MyView()),
          );
          await tester.pumpAndSettle();

          expect(
            overflowErrors,
            isEmpty,
            reason: 'Overflow detected at size $size: ${overflowErrors.join(", ")}',
          );
        }
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}
```

### 8.4 Component Visibility Test Template

```dart
testWidgets('shows correct layout for each breakpoint', (tester) async {
  // Test compact (mobile)
  await tester.setScreenSize(TestDeviceSizes.phone);
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  await tester.pumpAndSettle();

  expect(find.byType(MobileLayout), findsOneWidget);
  expect(find.byType(DesktopLayout), findsNothing);
  expect(find.byType(NavigationBar), findsOneWidget);
  expect(find.byType(NavigationDrawer), findsNothing);

  // Test expanded (desktop)
  await tester.setScreenSize(TestDeviceSizes.desktop);
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  await tester.pumpAndSettle();

  expect(find.byType(MobileLayout), findsNothing);
  expect(find.byType(DesktopLayout), findsOneWidget);
  expect(find.byType(NavigationBar), findsNothing);
  expect(find.byType(NavigationDrawer), findsOneWidget);
});
```

### 8.5 Breakpoint Edge Case Tests

```dart
testWidgets('handles breakpoint edge cases correctly', (tester) async {
  // Just before medium breakpoint (599)
  await tester.setScreenSize(const Size(599, 800));
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  expect(find.byType(MobileLayout), findsOneWidget);

  // Exactly at medium breakpoint (600)
  await tester.setScreenSize(const Size(600, 800));
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  expect(find.byType(TabletLayout), findsOneWidget);

  // Just before expanded breakpoint (839)
  await tester.setScreenSize(const Size(839, 800));
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  expect(find.byType(TabletLayout), findsOneWidget);

  // Exactly at expanded breakpoint (840)
  await tester.setScreenSize(const Size(840, 800));
  await tester.pumpWidget(responsiveTestWrapper(MyView()));
  expect(find.byType(DesktopLayout), findsOneWidget);
});
```

### 8.6 Golden Test Template (Optional)

```dart
testWidgets('golden: MyView renders correctly', (tester) async {
  for (final size in [
    TestDeviceSizes.phone,
    TestDeviceSizes.tabletPortrait,
    TestDeviceSizes.desktop,
  ]) {
    await tester.setScreenSize(size);
    await tester.pumpWidget(responsiveTestWrapper(MyView()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MyView),
      matchesGoldenFile('goldens/my_view_${size.width.toInt()}x${size.height.toInt()}.png'),
    );
  }
});
```

---

## Section 9: Translation Requirements

### 9.1 Key Naming Convention

All localization keys follow this pattern:
```
{feature}_{context}_{description}
```

Examples:
- `landing_hero_title` - Landing page, hero section, title text
- `api_usage_overview` - API usage feature, overview context
- `dashboard_nav_credits_keys` - Dashboard feature, navigation, credits/keys item
- `auth_login_button` - Auth feature, login page, button text

### 9.2 ARB File Structure

There are 7 ARB files that must be updated for any new strings:

| File | Language | Notes |
|------|----------|-------|
| `app_en.arb` | English | **Base file** - add descriptions here |
| `app_pt.arb` | Portuguese | |
| `app_pt_BR.arb` | Brazilian Portuguese | |
| `app_de.arb` | German | |
| `app_es.arb` | Spanish | |
| `app_fr.arb` | French | |
| `app_ja.arb` | Japanese | |

### 9.3 Adding New Strings

1. Add to `app_en.arb` (base file) with description:
```json
{
  "responsive_mobile_nav_label": "Navigation",
  "@responsive_mobile_nav_label": {
    "description": "Label for mobile navigation menu button"
  },
  "responsive_back_button": "Back",
  "@responsive_back_button": {
    "description": "Back button label for mobile detail views"
  }
}
```

2. Add translations to all 6 other ARB files:
```json
// app_pt.arb
{
  "responsive_mobile_nav_label": "Navegacao",
  "responsive_back_button": "Voltar"
}

// app_de.arb
{
  "responsive_mobile_nav_label": "Navigation",
  "responsive_back_button": "Zuruck"
}
// ... etc for es, fr, ja, pt_BR
```

3. Run code generation:
```bash
flutter gen-l10n
```

### 9.4 Using Translations

```dart
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Text(l10n.responsive_mobile_nav_label);
  }
}
```

### 9.5 Responsive-Specific String Patterns

When the same content needs different text for different screen sizes:

```json
{
  "dashboard_title_full": "Dashboard Overview",
  "@dashboard_title_full": {
    "description": "Full dashboard title for desktop"
  },
  "dashboard_title_short": "Dashboard",
  "@dashboard_title_short": {
    "description": "Short dashboard title for mobile"
  }
}
```

```dart
Text(
  context.isCompact
    ? l10n.dashboard_title_short
    : l10n.dashboard_title_full,
)
```

---

## Section 10: DRY Principle Enforcement

### 10.1 When to Create Shared Components

Create a shared component in `design_system/` when:

1. **Used in 3+ places** - If the same pattern appears in 3+ features, extract it
2. **Represents a design pattern** - Navigation, cards, dialogs, forms
3. **Has consistent behavior** - Same props, same behavior everywhere
4. **Is breakpoint-aware** - Responsive components should be centralized

### 10.2 When to Keep Feature-Specific

Keep components in `ui/[feature]/widgets/` when:

1. **Single use** - Only used in one feature
2. **Feature-specific styling** - Has colors/layouts unique to that feature
3. **Tightly coupled to feature state** - Depends on feature-specific providers
4. **In development** - New components that haven't been proven reusable yet

### 10.3 Component Extraction Checklist

Before creating a new widget, ask:

- [ ] Does a similar component exist in `design_system/`?
- [ ] Can an existing component be extended instead of creating new?
- [ ] Will this component be used in multiple features?
- [ ] Does it follow the naming conventions?

### 10.4 Extension Patterns

Use extensions to add responsive utilities without modifying existing classes:

```dart
// In lib/src/design_system/extensions/responsive_extensions.dart

extension ResponsiveTextStyle on TextStyle {
  /// Scale the font size responsively
  TextStyle responsiveSize(BuildContext context, {
    double? compactScale,
    double? mediumScale,
    double? expandedScale,
  }) {
    final scale = context.responsiveValue(
      compact: compactScale ?? 1.0,
      medium: mediumScale,
      expanded: expandedScale,
    );
    return copyWith(fontSize: (fontSize ?? 14) * scale);
  }
}

extension ResponsiveEdgeInsets on EdgeInsets {
  /// Scale all values responsively
  EdgeInsets scaled(BuildContext context, {
    double compactScale = 0.75,
    double? mediumScale,
    double expandedScale = 1.0,
  }) {
    final scale = context.responsiveValue(
      compact: compactScale,
      medium: mediumScale,
      expanded: expandedScale,
    );
    return EdgeInsets.only(
      left: left * scale,
      top: top * scale,
      right: right * scale,
      bottom: bottom * scale,
    );
  }
}
```

### 10.5 Mixin Patterns for Responsive Utilities

**IMPORTANT**: Mixins should only provide helper properties and getters, NOT methods that return Widget. Use ResponsiveBuilder or ResponsiveWidget instead.

```dart
/// Mixin for views that need responsive behavior with common patterns
/// NOTE: Does NOT include methods returning Widget - use ResponsiveBuilder instead
mixin ResponsiveViewMixin<T extends StatefulWidget> on State<T> {
  /// Get the current window size class
  WindowSizeClass get windowSizeClass => context.windowSizeClass;

  /// Whether currently showing compact (mobile) layout
  bool get isCompactLayout => context.isCompact;

  /// Whether currently showing expanded (desktop) layout
  bool get isExpandedLayout => context.isExpanded;

  /// Get responsive padding for the view
  EdgeInsets get viewPadding => ResponsiveSpacing.contentPadding(context);

  /// Get responsive value based on current screen size
  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) => context.responsiveValue(
    compact: compact,
    medium: medium,
    expanded: expanded,
  );
}
```

Usage:

```dart
class MyView extends StatefulWidget {
  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> with ResponsiveViewMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: viewPadding,
      // Use ResponsiveWidget with proper widget classes - NO functions returning Widget
      child: ResponsiveWidget(
        compact: _MobileLayout(),
        expanded: _DesktopLayout(),
      ),
    );
  }
}

// Layout variants are separate widget classes
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(children: [/* mobile content */]);
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(children: [/* desktop content */]);
  }
}
```

### 10.6 Avoiding Duplication in Responsive Layouts

When mobile and desktop layouts share logic, extract the shared parts:

```dart
// AVOID: Duplicating logic in both layouts
class _MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = _loadData();  // Duplicated
    final formatted = _formatData(data);  // Duplicated
    return Column(children: [/* mobile-specific */]);
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = _loadData();  // Duplicated
    final formatted = _formatData(data);  // Duplicated
    return Row(children: [/* desktop-specific */]);
  }
}

// PREFER: Shared data, different presentation
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Shared data loading
    final data = _loadData();
    final formatted = _formatData(data);

    // Responsive presentation
    return ResponsiveBuilder(
      compact: (_, __) => _MobileLayout(data: formatted),
      expanded: (_, __) => _DesktopLayout(data: formatted),
    );
  }
}
```

---

## Quick Reference

### Import Statements

```dart
// All responsive utilities
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

// All layout widgets
import 'package:zenscrap_flutter/src/design_system/layouts/layouts.dart';

// Theme extensions (existing)
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
```

### Common Usage Patterns

```dart
// Check breakpoint
if (context.isCompact) { /* mobile */ }
if (context.isMedium) { /* tablet */ }
if (context.isExpanded) { /* desktop */ }

// Responsive value
final padding = context.responsiveValue(
  compact: 16.0,
  medium: 24.0,
  expanded: 32.0,
);

// Responsive builder
ResponsiveBuilder(
  compact: (context, constraints) => MobileLayout(),
  expanded: (context, constraints) => DesktopLayout(),
)

// Conditional visibility
ResponsiveVisibility.hideOnCompact(child: SidePanel())

// Content container
ContentWidthContainer(
  expandedMaxWidth: 1200,
  child: Content(),
)
```

### Breakpoint Values

| Size Class | Width Range | Constant |
|------------|-------------|----------|
| Compact | 0 - 599 | `Breakpoints.compact` (0) |
| Medium | 600 - 839 | `Breakpoints.medium` (600) |
| Expanded | 840+ | `Breakpoints.expanded` (840) |

---

## Changelog

### 1.0.0 (December 2024)
- Initial architecture document
- Breakpoint system based on Material Design 3
- Core responsive widgets
- Adaptive layout components
- Migration patterns and examples
- Testing requirements
- Translation guidelines
- DRY principle enforcement
