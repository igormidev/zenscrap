import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  StreamSubscription<String>? _aiCurrentThinkingSubscription;
  ScrapChatSessionNotifier(this.ref) : super(ScrapChatSessionState.blank());

  @override
  void dispose() {
    _chatResponseSubscription?.cancel();
    _aiCurrentThinkingSubscription?.cancel();
    super.dispose();
  }

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
          .last
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

    await ref
        .read(clientProvider)
        .scrappableChatSession
        .sendPromptMessage(sessionId: sessionUuid, userPrompt: userPrompt)
        .toRawResult(
      (Stream<String> llmThinkingStream) {
        debugPrint('stream set');
        _aiCurrentThinkingSubscription = llmThinkingStream.listen(
            (thinking) {
              state.mapOrNull(standard: (value) {
                final currentStream = value.llmThinkingStream ?? [];
                state = value.copyWith(
                  llmThinkingStream: [...currentStream, thinking],
                );
              });
            },
            onDone: () {
              _aiCurrentThinkingSubscription?.cancel();
              state.mapOrNull(standard: (value) {
                Clipboard.setData(ClipboardData(
                    text: value.llmThinkingStream?.join('\n') ?? ''));
                state = value.copyWith(llmThinkingStream: null);
              });
            },
            cancelOnError: true,
            onError: (error) {
              if (error is ZenScrapException) {
                state = ScrapChatSessionState.withError(error: error);
              } else {
                state =
                    ScrapChatSessionState.withError(error: defaultException);
              }
            });
      },
      (failure) => state = ScrapChatSessionState.withError(error: failure),
    );
  }

  Future<void> endSession() async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    await ref
        .read(clientProvider)
        .scrappableChatSession
        .disposeSession(sessionId: sessionUuid);
  }

  void onChange(ChatResponse chatResponse) {
    if (chatResponse is NewExtractRuleResponse) {
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
            data: value.data.copyWith(
              referenceTestData: chatResponse.referenceTestData,
              scrappingBeeExtractRules: chatResponse.scrappingBeeExtractLogic,
              targetRequest: chatResponse.scrapperRequest,
            ),
          );
        },
      );
    }
    ref.read(chatMessagesProvider.notifier).state =
        ref.read(chatMessagesProvider).maybeMap(
              data: (data) => AsyncValue.data([...data.value, chatResponse]),
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

  Future<void> createSessionWithScrappableId(int scrappableId) async {
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
        .createSession(scrappableId: scrappable.id!)
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
          llmThinkingStream: null,
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
