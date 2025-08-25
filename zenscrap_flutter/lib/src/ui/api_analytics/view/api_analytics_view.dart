import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/scrappables_analytics_resume_card_listage_page.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/selected_scrappable_page.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';

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
    return ref.watch(analyticsProvider).when(
          initial: () => SizedBox.shrink(),
          withError: (_) => SizedBox.fromSize(),
          loading: () => SizedBox.fromSize(),
          emptyData: () => EmptyScrappableListageIndicatorPage(),
          withData: (items) {
            return Row(
              children: [
                ScrappablesAnalyticsResumeCardListagePage(items: items),
                VerticalDivider(),
                Expanded(child: SelectedScrappablePage()),
              ],
            );
          },
        );
  }
}
