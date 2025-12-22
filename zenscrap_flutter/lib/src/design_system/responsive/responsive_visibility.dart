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
