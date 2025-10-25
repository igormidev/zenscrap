import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

final selectedScrappableProvider =
    StateProvider<ScrappableRequestsAnalyticsItem?>((_) => null);
