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
