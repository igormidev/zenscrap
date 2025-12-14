import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scrappable_requests_analytics_card.dart';

class ScrappablesAnalyticsResumeCardListagePage extends ConsumerStatefulWidget {
  final PaginatedScrappableRequestsAnalytics data;

  const ScrappablesAnalyticsResumeCardListagePage({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ScrappablesAnalyticsResumeCardListagePage> createState() =>
      _ScrappablesAnalyticsResumeCardListagePageState();
}

class _ScrappablesAnalyticsResumeCardListagePageState
    extends ConsumerState<ScrappablesAnalyticsResumeCardListagePage> {
  final ScrollController _scrollController = ScrollController();
  Scrappable? _selectedScrappable;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      // User is near the bottom, but don't auto-load
      // We'll show a load more button instead
    }
  }

  void _selectScrappable(Scrappable scrappable) {
    setState(() {
      _selectedScrappable = scrappable;
    });
    ref.read(selectedScrappableAnalyticsProvider.notifier)
        .selectScrappable(scrappable);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(
          right: BorderSide(
            color: context.c.outline.withAlpha(50),
          ),
        ),
      ),
      child: Column(
        children: [
          _AnalyticsListHeader(data: widget.data),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.data.items.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.data.items.length) {
                  return _AnalyticsLoadMoreButton(data: widget.data);
                }

                final item = widget.data.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ScrappableRequestsAnalyticsCard(
                    item: item,
                    isSelected: _selectedScrappable?.id == item.scrappable.id,
                    onTap: () => _selectScrappable(item.scrappable),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsListHeader extends StatelessWidget {
  final PaginatedScrappableRequestsAnalytics data;

  const _AnalyticsListHeader({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(
          bottom: BorderSide(
            color: context.c.outline.withAlpha(50),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: context.c.primary,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.api_analytics_title,
            style: context.t.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            l10n.api_analytics_items_count(data.items.length, data.totalCount),
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsLoadMoreButton extends ConsumerWidget {
  final PaginatedScrappableRequestsAnalytics data;

  const _AnalyticsLoadMoreButton({
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (!data.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            l10n.api_analytics_no_more_to_load,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ),
      );
    }

    final analyticsState = ref.watch(analyticsProvider);
    bool isLoadingMore = false;
    analyticsState.when(
      initial: () => isLoadingMore = false,
      loading: () => isLoadingMore = false,
      loadingMore: (_) => isLoadingMore = true,
      emptyData: () => isLoadingMore = false,
      withData: (_) => isLoadingMore = false,
      withError: (_) => isLoadingMore = false,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoadingMore
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: () {
                  ref.read(analyticsProvider.notifier).loadMoreAnalytics();
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.api_analytics_load_more),
              ),
      ),
    );
  }
}
