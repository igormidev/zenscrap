import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_state.dart';

/// Notifier for managing AI usage state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class AIUsageNotifier extends Notifier<AIUsageState> {
  @override
  AIUsageState build() => const AIUsageState.initial();

  Future<void> loadAiUsage() async {
    state = const AIUsageState.loading();

    final client = ref.read(clientProvider);
    final aiUsageResult =
        await client.privateAiUsage.getAiUsageInfo().toResult;

    state = aiUsageResult.fold(
      (aiUsage) => AIUsageState.loaded(aiUsage: aiUsage),
      (error) => AIUsageState.withError(error),
    );
  }

  Future<void> refresh() async {
    await loadAiUsage();
  }
}

final aiUsageProvider =
    NotifierProvider<AIUsageNotifier, AIUsageState>(AIUsageNotifier.new);
