import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_state.dart';

/// Notifier for managing API usage state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class ApiUsageNotifier extends Notifier<ApiUsageState> {
  @override
  ApiUsageState build() => const ApiUsageState.initial();

  Future<void> loadApiUsage() async {
    state = const ApiUsageState.loading();

    final client = ref.read(clientProvider);
    final apiUsageResult =
        await client.privateApiUsage.getApiUsageInfo().toResult;

    state = apiUsageResult.fold(
      (apiUsage) => ApiUsageState.loaded(apiUsage: apiUsage),
      (error) => ApiUsageState.withError(error),
    );
  }

  Future<void> refresh() async {
    await loadApiUsage();
  }
}

final apiUsageProvider =
    NotifierProvider<ApiUsageNotifier, ApiUsageState>(ApiUsageNotifier.new);
