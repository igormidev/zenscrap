import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_state.dart';

final aiUsageProvider =
    StateNotifierProvider<AIUsageNotifier, AIUsageState>((ref) {
  final client = ref.watch(clientProvider);
  return AIUsageNotifier(client);
});

class AIUsageNotifier extends StateNotifier<AIUsageState> {
  final Client _client;

  AIUsageNotifier(this._client) : super(const AIUsageState.initial());

  Future<void> loadAiUsage() async {
    state = const AIUsageState.loading();

    final aiUsageResult =
        await _client.privateAiUsage.getAiUsageInfo().toResult;

    state = aiUsageResult.fold(
      (aiUsage) => AIUsageState.loaded(aiUsage: aiUsage),
      (error) => AIUsageState.withError(error),
    );
  }

  Future<void> refresh() async {
    await loadAiUsage();
  }
}
