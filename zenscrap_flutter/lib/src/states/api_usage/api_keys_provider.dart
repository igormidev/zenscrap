import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_state.dart';

final apiKeysProvider =
    StateNotifierProvider<ApiKeysNotifier, ApiKeysState>((ref) {
  final client = ref.watch(clientProvider);
  return ApiKeysNotifier(client);
});

class ApiKeysNotifier extends StateNotifier<ApiKeysState> {
  final Client _client;

  ApiKeysNotifier(this._client) : super(const ApiKeysState.initial());

  Future<void> loadApiKeys() async {
    try {
      state = const ApiKeysState.loading();

      final response = await _client.privateApiUsage.getApiKeysWithStats();

      state = ApiKeysState.loaded(
        apiKeys: response.apiKeys,
        usageStats: response.usageStats,
      );
    } on ZenScrapException catch (e) {
      state = ApiKeysState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading API keys',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = ApiKeysState.withError(
        ZenScrapException(
          title: 'Error loading API keys',
          description: 'An unexpected error occurred:\n$error',
        ),
      );
    }
  }

  Future<AccountApiKey?> createApiKey(BuildContext context, String name) async {
    try {
      final newKey = await _client.privateApiUsage.createApiKey(name: name);

      // Reload data to get updated stats
      await loadApiKeys();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('API key created successfully'),
            backgroundColor: context.c.primary,
          ),
        );
      }

      return newKey;
    } on ZenScrapException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create API key: ${e.description}'),
            backgroundColor: context.c.error,
          ),
        );
      }
      return null;
    } catch (error) {
      talker.log(
        'Error creating API key',
        exception: error,
        logLevel: LogLevel.error,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create API key: $error'),
            backgroundColor: context.c.error,
          ),
        );
      }
      return null;
    }
  }

  Future<bool> deactivateApiKey(BuildContext context, int keyId) async {
    try {
      await _client.privateApiUsage.deactivateApiKey(apiKeyId: keyId);
      await loadApiKeys();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('API key deactivated successfully'),
            backgroundColor: context.c.primary,
          ),
        );
      }
      return true;
    } on ZenScrapException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to deactivate API key: ${e.description}'),
            backgroundColor: context.c.error,
          ),
        );
      }
      return false;
    } catch (error) {
      talker.log(
        'Error deactivating API key',
        exception: error,
        logLevel: LogLevel.error,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to deactivate API key: $error'),
            backgroundColor: context.c.error,
          ),
        );
      }
      return false;
    }
  }

  Future<void> refresh() async {
    await loadApiKeys();
  }
}