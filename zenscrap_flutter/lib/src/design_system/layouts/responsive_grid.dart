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

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio ?? 1.0,
            mainAxisExtent: childAspectRatio == null ? mainAxisExtent : null,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
        );
      },
    );
  }
}

/// Internal: Auto-fit grid implementation
class _AutoFitResponsiveGrid extends ResponsiveGrid {
  final double minChildWidth;

  const _AutoFitResponsiveGrid({
    super.key,
    required this.minChildWidth,
    required super.crossAxisSpacing,
    required super.mainAxisSpacing,
    super.childAspectRatio,
    super.mainAxisExtent,
    required super.children,
    required super.shrinkWrap,
    super.physics,
    super.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth -
            (padding != null ? (padding! as EdgeInsets).horizontal : 0);
        final columns = (availableWidth / minChildWidth).floor().clamp(1, 12);

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio ?? 1.0,
            mainAxisExtent: childAspectRatio == null ? mainAxisExtent : null,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
        );
      },
    );
  }
}
