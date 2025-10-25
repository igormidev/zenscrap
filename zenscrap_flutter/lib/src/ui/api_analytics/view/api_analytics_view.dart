import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/scrappables_analytics_resume_card_listage_page.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/selected_scrappable_page.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ApiAnalyticsView extends ConsumerStatefulWidget {
  const ApiAnalyticsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApiAnalyticsViewState();
}

class _ApiAnalyticsViewState extends ConsumerState<ApiAnalyticsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(analyticsProvider.notifier).getAnalyticsData());
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsProvider);

    return analyticsState.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loadingMore: (currentData) => _AnalyticsContent(data: currentData),
      emptyData: () => const EmptyScrappableListageIndicatorPage(),
      withData: (data) => _AnalyticsContent(data: data),
      withError: (error) => _AnalyticsErrorView(error: error),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  final PaginatedScrappableRequestsAnalytics data;

  const _AnalyticsContent({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScrappablesAnalyticsResumeCardListagePage(data: data),
        const VerticalDivider(width: 1),
        const Expanded(child: SelectedScrappablePage()),
      ],
    );
  }
}

class _AnalyticsErrorView extends ConsumerWidget {
  final ZenScrapException error;

  const _AnalyticsErrorView({
    required this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.c.error,
          ),
          const SizedBox(height: 16),
          Text(
            error.title,
            style: context.t.headlineSmall?.copyWith(
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(analyticsProvider.notifier).getAnalyticsData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
