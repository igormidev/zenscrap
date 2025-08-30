import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

final scrapChatProvider =
    StateNotifierProvider<ScrapChatSessionNotifier, ScrapChatSessionState>(
        ScrapChatSessionNotifier.new);

class ScrapChatSessionNotifier extends StateNotifier<ScrapChatSessionState> {
  final Ref ref;
  StreamSubscription<ChatResponse>? _chatResponseSubscription;
  ScrapChatSessionNotifier(this.ref) : super(ScrapChatSessionState.blank());

  void reset() {
    ref.read(chatMessagesProvider.notifier).state = const AsyncValue.data([]);
    state = ScrapChatSessionState.blank();
  }

  Future<void> createScrappable({
    required String targetUrl,
    required String userPrompt,
  }) async {
    await ref.globalLoadingSetter(() async {
      final result = await ref
          .read(clientProvider)
          .createScrappable(referenceLink: targetUrl)
          .toResult;

      await result.fold(
        (Scrappable scrappable) async {
          await createSessionWithScrappable(scrappable);
          await sendMessage(userPrompt);
        },
        (failure) {
          state = ScrapChatSessionState.withError(error: failure);
        },
      );
    });
  }

  Future<void> sendMessage(String userPrompt) async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    final sessionResult = await ref
        .read(clientProvider)
        .scrappableChatSession
        .sendPromptMessage(sessionId: sessionUuid, userPrompt: userPrompt)
        .toResult;

    sessionResult.onFailure((failure) {
      state = ScrapChatSessionState.withError(error: failure);
    });
  }

  @override
  void dispose() {
    _chatResponseSubscription?.cancel();
    super.dispose();
  }

  void onChange(ChatResponse chatResponse) {
    if (chatResponse is NewExtractRuleResponse) {
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
              data: value.data
                  .copyWith(referenceTestData: chatResponse.referenceTestData));
        },
      );
    }
    ref.read(chatMessagesProvider.notifier).state =
        ref.read(chatMessagesProvider).maybeMap(
              data: (data) => AsyncValue.data(
                [...data.value, chatResponse],
              ),
              orElse: () => AsyncValue.data([chatResponse]),
            );
  }

  void updateScrappableDetails({
    required String name,
    required String description,
    required ScraperCategory category,
  }) {
    state.mapOrNull(
      standard: (value) {
        state = value.copyWith(
          data: value.data.copyWith(
            name: name,
            description: description,
            category: category,
          ),
        );
      },
    );
  }

  Future<void> createSessionWithScrappableId(String scrappableId) async {
    // First fetch the scrappable by ID
    final scrappableResult = await ref
        .read(clientProvider)
        .privateUserScrappables
        .getScrappableById(scrappableId)
        .toResult;

    await scrappableResult.fold(
      (Scrappable scrappable) async {
        await createSessionWithScrappable(scrappable);
      },
      (failure) {
        state = ScrapChatSessionState.withError(error: failure);
      },
    );
  }

  Future<void> createSessionWithScrappable(Scrappable scrappable) async {
    final sessionResult = await ref
        .read(clientProvider)
        .scrappableChatSession
        .createSession(scrappableId: scrappable.id.toString())
        .toResult;

    await sessionResult.fold((createdSessionResponse) async {
      try {
        _chatResponseSubscription = ref
            .read(clientProvider)
            .scrappableChatSession
            .listenToScrappableRedraftSession(
                sessionUuid: createdSessionResponse.sessionId)
            .listen(onChange);

        final Duration timeUntilExpire = createdSessionResponse.expiresIn;
        final DateTime expirationDate = DateTime.now().add(timeUntilExpire);

        state = ScrapChatSessionState.standard(
          data: scrappable,
          sessionUuid: createdSessionResponse.sessionId,
          testExpirationDate: expirationDate,
        );
      } catch (error, stackTrace) {
        talker.error(
          'Error while creating session with scrappable',
          error,
          stackTrace,
        );
        state = ScrapChatSessionState.withError(error: defaultException);
      }
    },
        (failure) async =>
            state = ScrapChatSessionState.withError(error: failure));
  }
}
