import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';

class MarketplacePaginationControls extends ConsumerWidget {
  const MarketplacePaginationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplaceState = ref.watch(marketplaceProvider);
    
    return marketplaceState.maybeWhen(
      loaded: (response, searchQuery, selectedCategories) {
        final pagination = response.pagination;

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
              _buildPreviousButton(context, ref, pagination),
              const SizedBox(width: 16),
              ..._buildPageNumbers(context, ref, pagination),
              const SizedBox(width: 16),
              _buildNextButton(context, ref, pagination),
              const SizedBox(width: 24),
              _buildPageInfo(context, pagination),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildPreviousButton(
    BuildContext context,
    WidgetRef ref,
    PaginationMetadata pagination,
  ) {
    return IconButton(
      onPressed: pagination.hasPreviousPage
          ? () {
              // Track previous page click
              ref.read(analyticsServiceProvider).trackMarketplacePaginationPrevious(
                fromPage: pagination.currentPage,
                toPage: pagination.currentPage - 1,
              );

              ref
                  .read(marketplaceProvider.notifier)
                  .changePage(pagination.currentPage - 1);
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

  Widget _buildNextButton(
    BuildContext context,
    WidgetRef ref,
    PaginationMetadata pagination,
  ) {
    return IconButton(
      onPressed: pagination.hasNextPage
          ? () {
              // Track next page click
              ref.read(analyticsServiceProvider).trackMarketplacePaginationNext(
                fromPage: pagination.currentPage,
                toPage: pagination.currentPage + 1,
              );

              ref
                  .read(marketplaceProvider.notifier)
                  .changePage(pagination.currentPage + 1);
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

  List<Widget> _buildPageNumbers(
    BuildContext context,
    WidgetRef ref,
    PaginationMetadata pagination,
  ) {
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
      pageButtons.add(_buildPageButton(context, ref, 1, currentPage));
      if (startPage > 2) {
        pageButtons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
    }
    
    // Add page numbers
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(context, ref, i, currentPage));
    }
    
    // Add ellipsis and last page if needed
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
      pageButtons.add(
        _buildPageButton(context, ref, totalPages, currentPage),
      );
    }
    
    return pageButtons;
  }

  Widget _buildPageButton(
    BuildContext context,
    WidgetRef ref,
    int pageNumber,
    int currentPage,
  ) {
    final isActive = pageNumber == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: isActive
            ? null
            : () {
                // Track page number click
                ref.read(analyticsServiceProvider).trackMarketplacePaginationPage(
                  fromPage: currentPage,
                  toPage: pageNumber,
                );

                ref.read(marketplaceProvider.notifier).changePage(pageNumber);
              },
        style: TextButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(8),
          backgroundColor: isActive
              ? context.c.primary
              : context.c.surfaceContainerHighest.withAlpha(51),
          foregroundColor: isActive
              ? context.c.onPrimary
              : context.c.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          pageNumber.toString(),
          style: context.t.bodyMedium?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPageInfo(BuildContext context, PaginationMetadata pagination) {
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