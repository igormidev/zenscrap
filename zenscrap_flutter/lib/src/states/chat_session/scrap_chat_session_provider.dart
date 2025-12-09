import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

/// Notifier for managing scrap chat session state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class ScrapChatSessionNotifier extends Notifier<ScrapChatSessionState> {
  StreamSubscription<ChatResponse>? _chatResponseSubscription;
  StreamSubscription<String>? _aiCurrentThinkingSubscription;

  @override
  ScrapChatSessionState build() {
    // Clean up subscriptions when the notifier is disposed
    ref.onDispose(() {
      _chatResponseSubscription?.cancel();
      _aiCurrentThinkingSubscription?.cancel();
    });
    return ScrapChatSessionState.blank();
  }

  void reset() {
    ref.read(chatMessagesProvider.notifier).setMessages(const AsyncValue.data([]));
    state = ScrapChatSessionState.blank();

    _chatResponseSubscription?.cancel();
    _aiCurrentThinkingSubscription?.cancel();
    _chatResponseSubscription = null;
    _aiCurrentThinkingSubscription = null;
  }

  Future<void> createScrappable({
    required String targetUrl,
    required String userPrompt,
  }) async {
    // Initialize the creating state with empty thinking chunks
    state = ScrapChatSessionState.creatingScrappable(
      referenceLink: targetUrl,
      thinkingChunks: [],
      groundingMetadata: null,
    );

    try {
      Scrappable? createdScrappable;
      GroundingMetadataInfo? groundingMetadata;

      await for (final item in ref.read(clientProvider).createScrappable(referenceLink: targetUrl)) {
        if (item is CreateScrappableThinkingChunk) {
          // Update state with new thinking chunk
          state.mapOrNull(creatingScrappable: (current) {
            state = current.copyWith(
              thinkingChunks: [...current.thinkingChunks, item.thinkingText],
            );
          });
        } else if (item is CreateScrappableResult) {
          // Store the final result
          createdScrappable = item.scrappable;
          groundingMetadata = item.grounding;

          // Update state with grounding info before transitioning
          state.mapOrNull(creatingScrappable: (current) {
            state = current.copyWith(
              groundingMetadata: groundingMetadata,
            );
          });
        }
      }

      if (createdScrappable != null) {
        await createSessionWithScrappable(createdScrappable);
        await sendMessage(userPrompt);
      } else {
        state = ScrapChatSessionState.withError(
          error: ZenScrapException(
            title: 'Creation Failed',
            description: 'No scrappable was created. Please try again.',
          ),
        );
      }
    } on ZenScrapException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      state = ScrapChatSessionState.withError(error: e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      state = ScrapChatSessionState.withError(error: defaultException);
    }
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
    reset();
  }

  void onChange(ChatResponse chatResponse) {
    if (chatResponse is UpdatedScrappableRequestResponse) {
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
            data: value.data.copyWith(
              targetRequest: value.data.targetRequest?.copyWith(
                url: chatResponse.url,
                pathParams: chatResponse.pathParams,
                queryParams: chatResponse.queryParams,
              ),
            ),
          );
        },
      );
      return;
    }
    if (chatResponse is TestEndpointCalledSuccessResponse) {
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
            data: value.data.copyWith(
              referenceTestData: chatResponse.referenceTestData,
            ),
          );
        },
      );
      // Don't return here - we want to add the message to the chat
    }
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
    final currentMessages = ref.read(chatMessagesProvider);
    ref.read(chatMessagesProvider.notifier).setMessages(
          currentMessages.maybeMap(
            data: (data) => AsyncValue.data([...data.value, chatResponse]),
            orElse: () => AsyncValue.data([chatResponse]),
          ),
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

  Future<ResultDart<void, ZenScrapException>> commitCurrentChanges() async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return Failure(defaultException);

    return ref
        .read(clientProvider)
        .scrappableChatSession
        .commitCurrentEditState(sessionUuid: sessionUuid)
        .toResult;
  }

  /// Updates the user's OpenAI API key for the current session.
  /// This allows users to bypass platform credit limits by using their own key.
  Future<void> updateUserApiKey(String apiKey) async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    await ref
        .read(clientProvider)
        .scrappableChatSession
        .updateUserApiKey(sessionId: sessionUuid, openAiApiKey: apiKey);
  }
}

final scrapChatProvider =
    NotifierProvider<ScrapChatSessionNotifier, ScrapChatSessionState>(
        ScrapChatSessionNotifier.new);
