import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>(
        AnalyticsNotifier.new);

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final Ref ref;
  AnalyticsNotifier(this.ref) : super(AnalyticsState.initial());

  Future<void> getAnalyticsData() async {
    state = AnalyticsState.loading();
    final allData = <ScrappableRequestsAnalyticsItem>[];
    ref
        .read(clientProvider)
        .privateScrappableAnalytics
        .getScrappableAnalyticsOfTheLast12Hours()
        .toResult((item) {
      allData.add(item);
      state = AnalyticsState.withData(allData);
    }, (error) => state = AnalyticsState.withError(error: error));

    if (allData.isEmpty) {
      state = AnalyticsState.emptyData();
    }
  }
}
