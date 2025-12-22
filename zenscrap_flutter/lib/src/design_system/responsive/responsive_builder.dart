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
  final Widget Function(BuildContext context, BoxConstraints constraints)
      compact;

  /// Builder for medium screens (600-839dp)
  /// Falls back to [compact] if not provided
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      medium;

  /// Builder for expanded screens (>= 840dp)
  /// Falls back to [medium], then [compact] if not provided
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      expanded;

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
      compact: (_, constraints) => compact,
      medium: medium != null ? (_, constraints) => medium! : null,
      expanded: expanded != null ? (_, constraints) => expanded! : null,
    );
  }
}
