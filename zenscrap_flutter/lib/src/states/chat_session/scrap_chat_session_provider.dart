import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

final scrapChatProvider =
    StateNotifierProvider<ScrapChatSessionNotifier, ScrapChatSessionState>(
        ScrapChatSessionNotifier.new);

class ScrapChatSessionNotifier extends StateNotifier<ScrapChatSessionState> {
  final Ref ref;
  ScrapChatSessionNotifier(this.ref) : super(ScrapChatSessionState.initial());

  Future<void> startSession({
    required String targetUrl,
    required String userPrompt,
  }) async {
    state = ScrapChatSessionState.loading();
    final s=  ref
        .read(clientProvider).scrappableChatSession.listenToScrappableRedraftSession(sessionUuid: )
    final result = await ref
        .read(clientProvider)
        .createScrapChatSession(
          targetUrl: targetUrl,
          userPrompt: userPrompt,
        )
        .toResult;

    result.fold(
      (scrappable) {
        state = ScrapChatSessionState.withData(data: scrappable);
      },
      (failure) {
        state = ScrapChatSessionState.withError(error: failure);
      },
    );
  }
}
