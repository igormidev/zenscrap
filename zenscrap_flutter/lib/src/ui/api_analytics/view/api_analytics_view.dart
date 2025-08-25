import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';

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
    return Container();
  }
}
