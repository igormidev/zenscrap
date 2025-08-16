import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

final scrapChatProvider =
    StateNotifierProvider<ScrapChatSessionNotifier, ScrapChatSessionState>(
        ScrapChatSessionNotifier.new);

class ScrapChatSessionNotifier extends StateNotifier<ScrapChatSessionState> {
  final Ref ref;
  Stream<ChatResponse>? chatResponseStream;
  StreamSubscription<ChatResponse>? chatResponseSubscription;
  ScrapChatSessionNotifier(this.ref) : super(ScrapChatSessionState.blank());

  Future<void> createScrappable({
    required String targetUrl,
    required String userPrompt,
  }) async {
    final result = await ref
        .read(clientProvider)
        .createScrappable(referenceLink: targetUrl)
        .toResult;

    await result.fold(
      (scrappable) async {
        final sessionResult = await ref
            .read(clientProvider)
            .scrappableChatSession
            .createSession(scrappable: scrappable)
            .toResult;

        await sessionResult.fold((sessionUuid) async {
          chatResponseStream = ref
              .read(clientProvider)
              .scrappableChatSession
              .listenToScrappableRedraftSession(sessionUuid: sessionUuid);

          chatResponseSubscription = chatResponseStream!.listen(onChange);
          state = ScrapChatSessionState.standard(
            data: scrappable,
            sessionUuid: sessionUuid,
          );

          await sendMessage(userPrompt);
        },
            (failure) async =>
                state = ScrapChatSessionState.withError(error: failure));
      },
      (failure) {
        state = ScrapChatSessionState.withError(error: failure);
      },
    );
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
    chatResponseSubscription?.cancel();
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
  }
}
