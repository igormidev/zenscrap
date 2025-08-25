import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrapapble_analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_state.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/no_selected_scrappable_indicator_page.dart';

class SelectedScrappablePage extends ConsumerStatefulWidget {
  const SelectedScrappablePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedScrappablePageState();
}

class _SelectedScrappablePageState
    extends ConsumerState<SelectedScrappablePage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(selectedScrappableAnalyticsProvider).when(
          none: () => NoSelectedScrappableIndicatorPage(),
          loading: () => SizedBox.shrink(),
          withData: (List<ScrappableAnalytics> result) {
            // Todo(claude-code): impelment this ui
            return Container();
          },
        );
  }
}
