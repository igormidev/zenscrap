import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
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
    final language = ref.read(currentLanguageProvider);
    final aiUsageResult =
        await client.privateAiUsage.getAiUsageInfo(language: language).toResult;

    state = aiUsageResult.fold(
      (aiUsage) => AIUsageState.loaded(aiUsage: aiUsage),
      (error) => AIUsageState.withError(error),
    );
  }

  Future<void> refresh() async {
    await loadAiUsage();
  }

  /// Updates the user's OpenAI API key.
  /// Pass null or empty string to remove the API key.
  /// Returns a Result with the updated AccountAIUsage or a ZenScrapException.
  Future<ResultDart<AccountAIUsage, ZenScrapException>> updateOpenAiApiKey(
      String? apiKey) async {
    final client = ref.read(clientProvider);
    final language = ref.read(currentLanguageProvider);

    final result = await client.privateAiUsage
        .updateOpenAiApiKey(apiKey: apiKey, language: language)
        .toResult;

    result.onSuccess((updatedAiUsage) {
      state = AIUsageState.loaded(aiUsage: updatedAiUsage);
    });

    return result;
  }
}

final aiUsageProvider =
    NotifierProvider<AIUsageNotifier, AIUsageState>(AIUsageNotifier.new);
