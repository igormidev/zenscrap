import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_state.dart';

/// Notifier for managing API keys state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class ApiKeysNotifier extends Notifier<ApiKeysState> {
  @override
  ApiKeysState build() => const ApiKeysState.initial();

  Client get _client => ref.read(clientProvider);

  Future<void> loadApiKeys() async {
    try {
      state = const ApiKeysState.loading();

      final language = ref.read(currentLanguageProvider);
      final response = await _client.privateApiUsage.getApiKeysWithStats(language: language);

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
      final language = ref.read(currentLanguageProvider);
      final newKey = await _client.privateApiUsage.createApiKey(name: name, language: language);

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
      final language = ref.read(currentLanguageProvider);
      await _client.privateApiUsage.deactivateApiKey(apiKeyId: keyId, language: language);
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

final apiKeysProvider =
    NotifierProvider<ApiKeysNotifier, ApiKeysState>(ApiKeysNotifier.new);