import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Generic pagination controls widget for scrappables
/// Supports two modes: Google-style page numbers or simple "Load more" button
class PaginationControls extends StatelessWidget {
  const PaginationControls({
    super.key,
    required this.pagination,
    required this.onPageChanged,
    this.mode = PaginationMode.pageNumbers,
    this.onLoadMoreAnalytics,
    this.onPreviousPageAnalytics,
    this.onNextPageAnalytics,
    this.onPageNumberAnalytics,
  });

  /// Pagination metadata
  final PaginationMetadata pagination;

  /// Callback when page changes
  final ValueChanged<int> onPageChanged;

  /// Display mode for pagination
  final PaginationMode mode;

  /// Analytics callbacks
  final VoidCallback? onLoadMoreAnalytics;
  final VoidCallback? onPreviousPageAnalytics;
  final VoidCallback? onNextPageAnalytics;
  final ValueChanged<int>? onPageNumberAnalytics;

  @override
  Widget build(BuildContext context) {
    if (mode == PaginationMode.loadMore) {
      return _LoadMorePaginationMode(
        pagination: pagination,
        onPageChanged: onPageChanged,
        onLoadMoreAnalytics: onLoadMoreAnalytics,
      );
    }
    return _PageNumbersPaginationMode(
      pagination: pagination,
      onPageChanged: onPageChanged,
      onPreviousPageAnalytics: onPreviousPageAnalytics,
      onNextPageAnalytics: onNextPageAnalytics,
      onPageNumberAnalytics: onPageNumberAnalytics,
    );
  }
}

/// Load more button pagination mode
class _LoadMorePaginationMode extends StatelessWidget {
  const _LoadMorePaginationMode({
    required this.pagination,
    required this.onPageChanged,
    this.onLoadMoreAnalytics,
  });

  final PaginationMetadata pagination;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onLoadMoreAnalytics;

  @override
  Widget build(BuildContext context) {
    if (!pagination.hasNextPage) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: FilledButton.tonal(
        onPressed: () {
          onLoadMoreAnalytics?.call();
          onPageChanged(pagination.currentPage + 1);
        },
        child: Text(
          'Load more (${pagination.currentPage}/${pagination.totalPages})',
        ),
      ),
    );
  }
}

/// Page numbers pagination mode (Google-style)
class _PageNumbersPaginationMode extends StatelessWidget {
  const _PageNumbersPaginationMode({
    required this.pagination,
    required this.onPageChanged,
    this.onPreviousPageAnalytics,
    this.onNextPageAnalytics,
    this.onPageNumberAnalytics,
  });

  final PaginationMetadata pagination;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onPreviousPageAnalytics;
  final VoidCallback? onNextPageAnalytics;
  final ValueChanged<int>? onPageNumberAnalytics;

  @override
  Widget build(BuildContext context) {
    if (pagination.totalPages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(
          top: BorderSide(
            color: context.c.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PreviousPageButton(
            pagination: pagination,
            onPageChanged: onPageChanged,
            onAnalytics: onPreviousPageAnalytics,
          ),
          const SizedBox(width: 16),
          ..._buildPageNumbers(),
          const SizedBox(width: 16),
          _NextPageButton(
            pagination: pagination,
            onPageChanged: onPageChanged,
            onAnalytics: onNextPageAnalytics,
          ),
          const SizedBox(width: 24),
          _PageInfoIndicator(pagination: pagination),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    final currentPage = pagination.currentPage;
    final totalPages = pagination.totalPages;
    final List<Widget> pageButtons = [];

    // Calculate range of pages to show (current page +/- 3)
    int startPage = (currentPage - 3).clamp(1, totalPages);
    int endPage = (currentPage + 3).clamp(1, totalPages);

    // Adjust range to always show 7 pages if possible
    if (endPage - startPage < 6) {
      if (startPage == 1) {
        endPage = (startPage + 6).clamp(1, totalPages);
      } else if (endPage == totalPages) {
        startPage = (endPage - 6).clamp(1, totalPages);
      }
    }

    // Add first page and ellipsis if needed
    if (startPage > 1) {
      pageButtons.add(
        _PageNumberButton(
          key: ValueKey('page_1'),
          pageNumber: 1,
          isActive: currentPage == 1,
          onPageChanged: onPageChanged,
          onAnalytics: onPageNumberAnalytics,
        ),
      );
      if (startPage > 2) {
        pageButtons.add(const _EllipsisIndicator());
      }
    }

    // Add page numbers
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        _PageNumberButton(
          key: ValueKey('page_$i'),
          pageNumber: i,
          isActive: i == currentPage,
          onPageChanged: onPageChanged,
          onAnalytics: onPageNumberAnalytics,
        ),
      );
    }

    // Add ellipsis and last page if needed
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(const _EllipsisIndicator());
      }
      pageButtons.add(
        _PageNumberButton(
          key: ValueKey('page_$totalPages'),
          pageNumber: totalPages,
          isActive: currentPage == totalPages,
          onPageChanged: onPageChanged,
          onAnalytics: onPageNumberAnalytics,
        ),
      );
    }

    return pageButtons;
  }
}

/// Previous page navigation button
class _PreviousPageButton extends StatelessWidget {
  const _PreviousPageButton({
    required this.pagination,
    required this.onPageChanged,
    this.onAnalytics,
  });

  final PaginationMetadata pagination;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onAnalytics;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pagination.hasPreviousPage
          ? () {
              onAnalytics?.call();
              onPageChanged(pagination.currentPage - 1);
            }
          : null,
      icon: Icon(
        Icons.chevron_left_rounded,
        color: pagination.hasPreviousPage
            ? context.c.primary
            : context.c.onSurfaceVariant.withAlpha(77),
      ),
      style: IconButton.styleFrom(
        backgroundColor: pagination.hasPreviousPage
            ? context.c.primary.withAlpha(26)
            : context.c.surfaceContainerHighest.withAlpha(51),
      ),
    );
  }
}

/// Next page navigation button
class _NextPageButton extends StatelessWidget {
  const _NextPageButton({
    required this.pagination,
    required this.onPageChanged,
    this.onAnalytics,
  });

  final PaginationMetadata pagination;
  final ValueChanged<int> onPageChanged;
  final VoidCallback? onAnalytics;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pagination.hasNextPage
          ? () {
              onAnalytics?.call();
              onPageChanged(pagination.currentPage + 1);
            }
          : null,
      icon: Icon(
        Icons.chevron_right_rounded,
        color: pagination.hasNextPage
            ? context.c.primary
            : context.c.onSurfaceVariant.withAlpha(77),
      ),
      style: IconButton.styleFrom(
        backgroundColor: pagination.hasNextPage
            ? context.c.primary.withAlpha(26)
            : context.c.surfaceContainerHighest.withAlpha(51),
      ),
    );
  }
}

/// Individual page number button
class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    super.key,
    required this.pageNumber,
    required this.isActive,
    required this.onPageChanged,
    this.onAnalytics,
  });

  final int pageNumber;
  final bool isActive;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int>? onAnalytics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: isActive
            ? null
            : () {
                onAnalytics?.call(pageNumber);
                onPageChanged(pageNumber);
              },
        style: TextButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(8),
          backgroundColor: isActive
              ? context.c.primary
              : context.c.surfaceContainerHighest.withAlpha(51),
          foregroundColor: isActive ? context.c.onPrimary : context.c.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          pageNumber.toString(),
          style: context.t.bodyMedium?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? context.c.onPrimary : context.c.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Ellipsis indicator for pagination
class _EllipsisIndicator extends StatelessWidget {
  const _EllipsisIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '...',
        style: context.t.bodyMedium?.copyWith(
          color: context.c.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Page information indicator
class _PageInfoIndicator extends StatelessWidget {
  const _PageInfoIndicator({
    required this.pagination,
  });

  final PaginationMetadata pagination;

  @override
  Widget build(BuildContext context) {
    final startItem = ((pagination.currentPage - 1) * pagination.pageSize) + 1;
    final endItem = (pagination.currentPage * pagination.pageSize)
        .clamp(0, pagination.totalCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$startItem-$endItem of ${pagination.totalCount}',
        style: context.t.bodySmall?.copyWith(
          color: context.c.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Pagination display mode
enum PaginationMode {
  /// Shows page numbers like Google search (1, 2, ..., 10)
  pageNumbers,

  /// Shows a simple "Load more" button
  loadMore,
}
