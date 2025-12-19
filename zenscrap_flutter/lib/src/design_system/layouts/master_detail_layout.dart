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
  final Widget Function(BuildContext context, bool isDetailVisible)
      masterBuilder;

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
  final Widget Function(BuildContext context, bool isDetailVisible)
      masterBuilder;
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
  final Widget Function(BuildContext context, bool isDetailVisible)
      masterBuilder;
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
