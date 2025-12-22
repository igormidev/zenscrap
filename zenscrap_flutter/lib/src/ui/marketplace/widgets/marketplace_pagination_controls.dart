import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 20.0,
            ),
            vertical: context.responsiveValue(
              compact: 12.0,
              medium: 16.0,
              expanded: 16.0,
            ),
          ),
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
              _PreviousButton(pagination: pagination),
              const SizedBox(width: 16),
              ..._PageNumbers(pagination: pagination).buildPageButtons(context, ref),
              const SizedBox(width: 16),
              _NextButton(pagination: pagination),
              const SizedBox(width: 24),
              _PageInfo(pagination: pagination),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PreviousButton extends ConsumerWidget {
  final PaginationMetadata pagination;

  const _PreviousButton({required this.pagination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: pagination.hasPreviousPage
          ? () {
              ref.read(analyticsServiceProvider).trackMarketplacePaginationPrevious(
                fromPage: pagination.currentPage,
                toPage: pagination.currentPage - 1,
              );
              ref.read(marketplaceProvider.notifier).changePage(pagination.currentPage - 1);
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

class _NextButton extends ConsumerWidget {
  final PaginationMetadata pagination;

  const _NextButton({required this.pagination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: pagination.hasNextPage
          ? () {
              ref.read(analyticsServiceProvider).trackMarketplacePaginationNext(
                fromPage: pagination.currentPage,
                toPage: pagination.currentPage + 1,
              );
              ref.read(marketplaceProvider.notifier).changePage(pagination.currentPage + 1);
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

class _PageNumbers {
  final PaginationMetadata pagination;

  const _PageNumbers({required this.pagination});

  List<Widget> buildPageButtons(BuildContext context, WidgetRef ref) {
    final currentPage = pagination.currentPage;
    final totalPages = pagination.totalPages;
    final List<Widget> pageButtons = [];

    int startPage = (currentPage - 3).clamp(1, totalPages);
    int endPage = (currentPage + 3).clamp(1, totalPages);

    if (endPage - startPage < 6) {
      if (startPage == 1) {
        endPage = (startPage + 6).clamp(1, totalPages);
      } else if (endPage == totalPages) {
        startPage = (endPage - 6).clamp(1, totalPages);
      }
    }

    if (startPage > 1) {
      pageButtons.add(_PageButton(pageNumber: 1, currentPage: currentPage));
      if (startPage > 2) {
        pageButtons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Builder(
              builder: (context) => Text(
                '...',
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_PageButton(pageNumber: i, currentPage: currentPage));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Builder(
              builder: (context) => Text(
                '...',
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }
      pageButtons.add(_PageButton(pageNumber: totalPages, currentPage: currentPage));
    }

    return pageButtons;
  }
}

class _PageButton extends ConsumerWidget {
  final int pageNumber;
  final int currentPage;

  const _PageButton({
    required this.pageNumber,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = pageNumber == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: isActive
            ? null
            : () {
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
}

class _PageInfo extends StatelessWidget {
  final PaginationMetadata pagination;

  const _PageInfo({required this.pagination});

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
        AppLocalizations.of(context)!.marketplace_pagination_range(startItem, endItem, pagination.totalCount),
        style: context.t.bodySmall?.copyWith(
          color: context.c.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}