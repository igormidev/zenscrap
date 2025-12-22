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
