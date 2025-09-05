import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
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
    try {
      state = const ApiUsageState.loading();

      final apiUsage = await _client.privateApiUsage.getApiUsageInfo();

      state = ApiUsageState.loaded(apiUsage: apiUsage);
    } on ZenScrapException catch (e) {
      state = ApiUsageState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading API usage',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = ApiUsageState.withError(
        ZenScrapException(
          title: 'Error loading API usage',
          description: 'An unexpected error occurred:\n$error',
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadApiUsage();
  }
}