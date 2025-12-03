import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_state.dart';

final apiUsageProvider =
    StateNotifierProvider<ApiUsageNotifier, ApiUsageState>((ref) {
  final client = ref.watch(clientProvider);
  return ApiUsageNotifier(client);
});

class ApiUsageNotifier extends StateNotifier<ApiUsageState> {
  final Client _client;

  ApiUsageNotifier(this._client) : super(const ApiUsageState.initial());

  Future<void> loadApiUsage() async {
    state = const ApiUsageState.loading();

    final apiUsageResult =
        await _client.privateApiUsage.getApiUsageInfo().toResult;

    state = apiUsageResult.fold(
      (apiUsage) => ApiUsageState.loaded(apiUsage: apiUsage),
      (error) => ApiUsageState.withError(error),
    );
  }

  Future<void> refresh() async {
    await loadApiUsage();
  }
}
