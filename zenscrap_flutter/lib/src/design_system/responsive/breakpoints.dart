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
