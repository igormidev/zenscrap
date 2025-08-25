import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>(
        AnalyticsNotifier.new);

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final Ref ref;
  AnalyticsNotifier(this.ref) : super(AnalyticsState.initial());

  Future<void> getAnalyticsData() async {}
}
