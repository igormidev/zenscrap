import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

/// Notifier for managing scrap chat session state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class ScrapChatSessionNotifier extends Notifier<ScrapChatSessionState> {
  StreamSubscription<ChatResponse>? _chatResponseSubscription;
  StreamSubscription<String>? _aiCurrentThinkingSubscription;

  /// Tracks whether we've received a successful extract rule in this session.
  /// Used to determine if errors occur before the first successful result.
  bool _hasReceivedExtractRule = false;
  String? _lastChatErrorReasonCode;

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
    ref
        .read(chatMessagesProvider.notifier)
        .setMessages(const AsyncValue.data([]));
    state = ScrapChatSessionState.blank();

    _chatResponseSubscription?.cancel();
    _aiCurrentThinkingSubscription?.cancel();
    _chatResponseSubscription = null;
    _aiCurrentThinkingSubscription = null;
    _hasReceivedExtractRule = false;
    _lastChatErrorReasonCode = null;
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

      final language = ref.read(currentLanguageProvider);
      await for (final item
          in ref
              .read(clientProvider)
              .createScrappable(referenceLink: targetUrl, language: language)) {
        if (item is CreateScrappableThinkingChunk) {
          // Update state with new thinking chunk
          state.mapOrNull(
            creatingScrappable: (current) {
              state = current.copyWith(
                thinkingChunks: [...current.thinkingChunks, item.thinkingText],
              );
            },
          );
        } else if (item is CreateScrappableResult) {
          // Store the final result
          createdScrappable = item.scrappable;
          groundingMetadata = item.grounding;

          // Update state with grounding info before transitioning
          state.mapOrNull(
            creatingScrappable: (current) {
              state = current.copyWith(groundingMetadata: groundingMetadata);
            },
          );
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

    final language = ref.read(currentLanguageProvider);
    await ref
        .read(clientProvider)
        .scrappableChatSession
        .sendPromptMessage(
          sessionId: sessionUuid,
          userPrompt: userPrompt,
          language: language,
        )
        .toRawResult(
          (Stream<String> llmThinkingStream) {
            _aiCurrentThinkingSubscription = llmThinkingStream.listen(
              (thinking) {
                state.mapOrNull(
                  standard: (value) {
                    final currentStream = value.llmThinkingStream ?? [];
                    state = value.copyWith(
                      llmThinkingStream: [...currentStream, thinking],
                    );
                  },
                );
              },
              onDone: () {
                _aiCurrentThinkingSubscription?.cancel();
                state.mapOrNull(
                  standard: (value) {
                    if (kDebugMode) {
                      Clipboard.setData(
                        ClipboardData(
                          text: value.llmThinkingStream?.join('\n') ?? '',
                        ),
                      );
                    }
                    state = value.copyWith(llmThinkingStream: null);
                  },
                );
              },
              cancelOnError: true,
              onError: (error, stackTrace) {
                logError(error, stackTrace);

                // If we already received a successful result, ignore late errors
                // (e.g., WebSocket closing after success)
                if (_hasReceivedExtractRule) return;

                if (error is ZenScrapException) {
                  state = ScrapChatSessionState.withError(error: error);
                } else {
                  final errorStringLower = error.toString().toLowerCase();
                  final isConnectionError =
                      errorStringLower.contains('connection') ||
                      errorStringLower.contains('websocket') ||
                      errorStringLower.contains('closed') ||
                      errorStringLower.contains('socket');
                  state = ScrapChatSessionState.withError(
                    error: isConnectionError
                        ? connectionClosedException
                        : defaultException,
                  );
                }
              },
            );
          },
          (failure) {
            logError(failure);
            state = ScrapChatSessionState.withError(error: failure);
          },
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
    final rawResponse = chatResponse;

    // Get scrappable ID and message count for analytics
    final scrappableId = state.mapOrNull(standard: (value) => value.data.id);
    final currentMessages = ref.read(chatMessagesProvider);
    final messageCount = currentMessages.maybeWhen(
      data: (messages) => messages.length,
      orElse: () => 0,
    );

    // Track the response for analytics
    _trackChatResponse(rawResponse, scrappableId, messageCount);

    // Improve technical parser errors into actionable user-facing messages.
    final displayResponse = rawResponse is ErrorTextResponse
        ? _toUserFriendlyErrorResponse(rawResponse)
        : rawResponse;

    if (displayResponse is UpdatedScrappableRequestResponse) {
      state.mapOrNull(
        standard: (value) {
          // Use the full ScrappableRequest if available (from AI-driven updates),
          // otherwise fall back to individual fields (for manual endpoint updates)
          final updatedRequest =
              displayResponse.scrappableRequest ??
              value.data.targetRequest?.copyWith(
                url: displayResponse.url,
                pathParams: displayResponse.pathParams,
                queryParams: displayResponse.queryParams,
              );
          state = value.copyWith(
            data: value.data.copyWith(targetRequest: updatedRequest),
          );
        },
      );
      return;
    }
    if (displayResponse is TestEndpointCalledSuccessResponse) {
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
            data: value.data.copyWith(
              referenceTestData: displayResponse.referenceTestData,
            ),
          );
        },
      );
      // Don't return here - we want to add the message to the chat
    }
    if (displayResponse is NewExtractRuleResponse) {
      _lastChatErrorReasonCode = null;
      state.mapOrNull(
        standard: (value) {
          state = value.copyWith(
            data: value.data.copyWith(
              referenceTestData: displayResponse.referenceTestData,
              scrappingBeeExtractRules:
                  displayResponse.scrappingBeeExtractLogic,
              targetRequest: displayResponse.scrapperRequest,
            ),
          );
        },
      );
    }
    ref
        .read(chatMessagesProvider.notifier)
        .setMessages(
          currentMessages.maybeMap(
            data: (data) => AsyncValue.data([...data.value, displayResponse]),
            orElse: () => AsyncValue.data([displayResponse]),
          ),
        );
  }

  /// Tracks chat response for analytics.
  /// Identifies error types and tracks first extract rule success/failure.
  void _trackChatResponse(
    ChatResponse chatResponse,
    int? scrappableId,
    int messageCount,
  ) {
    if (scrappableId == null) return;

    final analytics = ref.read(analyticsServiceProvider);
    final responseType = _getResponseType(chatResponse);
    final isFirstResponse = messageCount == 0;
    final attemptNumber = messageCount + 1;

    // Track every response received
    analytics.trackChatResponseReceived(
      scrappableId: scrappableId,
      responseType: responseType,
      messageCount: messageCount,
      hasReceivedExtractRule: _hasReceivedExtractRule,
    );

    // Check if this is an error response
    if (_isErrorResponse(chatResponse)) {
      _trackErrorResponse(
        chatResponse,
        scrappableId,
        messageCount,
        attemptNumber,
        isFirstResponse,
        analytics,
      );
      return;
    }

    // Track first successful extract rule
    if (chatResponse is NewExtractRuleResponse && !_hasReceivedExtractRule) {
      _hasReceivedExtractRule = true;
      _lastChatErrorReasonCode = null;
      analytics.trackChatFirstExtractRuleSuccess(
        scrappableId: scrappableId,
        messageCount: messageCount,
      );
    }
  }

  /// Returns the response type string for analytics tracking.
  String _getResponseType(ChatResponse response) {
    // All ChatResponse subtypes are covered - switch is exhaustive
    return switch (response) {
      MessageTextResponse() => 'message_text',
      NewExtractRuleResponse() => 'new_extract_rule',
      TestEndpointCalledSuccessResponse() => 'test_endpoint_success',
      TestEndpointCalledErrorResponse() => 'test_endpoint_error',
      UpdatedScrappableRequestResponse() => 'updated_request',
      CandidateExtractLogicUpdate() => 'candidate_extract_logic',
      ApiKeyUpdatedResponse() => 'api_key_updated',
      ErrorTextResponse() => 'error_text',
      CreditLimitReachedResponse() => 'credit_limit_reached',
      IpLimitReachedResponse() => 'ip_limit_reached',
      UserApiKeyQuotaExceededResponse() => 'user_api_key_quota_exceeded',
      SuspiciousIpResponse() => 'suspicious_ip',
      HeartbeatResponse() => 'heartbeat', // Keep-alive, not tracked
    };
  }

  /// Checks if the response is an error type.
  bool _isErrorResponse(ChatResponse response) {
    return response is ErrorTextResponse ||
        response is TestEndpointCalledErrorResponse ||
        response is CreditLimitReachedResponse ||
        response is IpLimitReachedResponse ||
        response is UserApiKeyQuotaExceededResponse ||
        response is SuspiciousIpResponse;
  }

  /// Tracks error responses with detailed information.
  void _trackErrorResponse(
    ChatResponse chatResponse,
    int scrappableId,
    int messageCount,
    int attemptNumber,
    bool isFirstResponse,
    AnalyticsService analytics,
  ) {
    final errorType = _getResponseType(chatResponse);
    String? errorMessage;
    String? errorTitle;
    String? errorDescription;

    // Extract error details based on type
    if (chatResponse is ErrorTextResponse) {
      errorMessage = chatResponse.errorMessage;
    } else if (chatResponse is TestEndpointCalledErrorResponse) {
      errorTitle = chatResponse.errorTitle;
      errorDescription = chatResponse.errorDescription;
    } else if (chatResponse is CreditLimitReachedResponse) {
      errorTitle = 'Credit Limit Reached';
    } else if (chatResponse is IpLimitReachedResponse) {
      errorTitle = 'IP Limit Reached';
    } else if (chatResponse is UserApiKeyQuotaExceededResponse) {
      errorTitle = 'User API Key Quota Exceeded';
    }

    final errorReasonCode = _normalizeErrorReasonCode(
      errorType: errorType,
      errorMessage: errorMessage,
      errorTitle: errorTitle,
      errorDescription: errorDescription,
    );
    _lastChatErrorReasonCode = errorReasonCode;

    // Track the error
    analytics.trackChatResponseError(
      scrappableId: scrappableId,
      errorType: errorType,
      messageCount: messageCount,
      attemptNumber: attemptNumber,
      isFirstResponse: isFirstResponse,
      hasReceivedExtractRule: _hasReceivedExtractRule,
      errorReasonCode: errorReasonCode,
      errorMessage: errorMessage,
      errorTitle: errorTitle,
      errorDescription: errorDescription,
    );

    // If no extract rule has been received yet, this is a critical "first response error"
    if (!_hasReceivedExtractRule) {
      analytics.trackChatFirstExtractRuleError(
        scrappableId: scrappableId,
        errorType: errorType,
        messageCount: messageCount,
        attemptNumber: attemptNumber,
        hasReceivedExtractRule: _hasReceivedExtractRule,
        errorReasonCode: errorReasonCode,
        errorMessage: errorMessage,
        errorTitle: errorTitle,
        errorDescription: errorDescription,
      );
    }
  }

  Future<void> retryIncompleteSetup() async {
    if (state.mapOrNull(standard: (value) => value.sessionUuid) == null) {
      return;
    }

    final data = state.mapOrNull(standard: (value) => value.data);
    if (data == null) return;
    if (data.scrappingBeeExtractRules != null) return;

    final reasonCode = _lastChatErrorReasonCode ?? 'unknown';
    final analytics = ref.read(analyticsServiceProvider);
    analytics.trackApiAnalyticsErrorRetryClick(errorType: reasonCode);

    final guidedRecoveryPrompt =
        '''
Recovery mode: continue from the existing context and fix the setup response format.
Last error reason code: $reasonCode.

Hard requirements:
- Return schema-valid JSON.
- `extract_rules` must be a JSON object (or stringified JSON object), never an array.
- If `scrappableRequest` is present: `queryParam` and `queryParamsNotRelatedToUrl` must be objects (`{}` when empty), and `pathParams` must be an array (`[]` when empty). Never use null for these containers.

Do not ask me to restate context unless absolutely required.
''';

    await sendMessage(guidedRecoveryPrompt);
  }

  ErrorTextResponse _toUserFriendlyErrorResponse(ErrorTextResponse response) {
    final reasonCode = _normalizeErrorReasonCode(
      errorType: 'error_text',
      errorMessage: response.errorMessage,
      errorTitle: null,
      errorDescription: null,
    );

    final friendlyMessage = switch (reasonCode) {
      'extract_rules_type_invalid' =>
        'Setup failed because the AI returned an invalid extract-rules format. '
            'Use "Retry setup" to automatically regenerate it.',
      'scrappable_request_invalid' =>
        'Setup failed because request parameters came in an invalid format. '
            'Use "Retry setup" to regenerate the configuration.',
      'missing_required_data' =>
        'Setup could not be completed because required configuration fields were missing. '
            'Use "Retry setup" to continue from the current context.',
      _ => response.errorMessage,
    };

    return ErrorTextResponse(
      role: response.role,
      expectsFollowUp: response.expectsFollowUp,
      errorMessage: friendlyMessage,
    );
  }

  String _normalizeErrorReasonCode({
    required String errorType,
    required String? errorMessage,
    required String? errorTitle,
    required String? errorDescription,
  }) {
    final details = [
      errorType,
      errorMessage ?? '',
      errorTitle ?? '',
      errorDescription ?? '',
    ].join(' ').toLowerCase();

    if (details.contains('extract_rules must be a string or object') ||
        details.contains('extract_rules_type_invalid')) {
      return 'extract_rules_type_invalid';
    }
    if (details.contains('could not parse scrappablerequest') ||
        details.contains('scrappablerequest.queryparam') ||
        details.contains('scrappablerequest.pathparams') ||
        details.contains('scrappable_request_invalid')) {
      return 'scrappable_request_invalid';
    }
    if (details.contains('missing responsetype') ||
        details.contains('missing resumeactionmessage') ||
        details.contains('must include either scrappingbeefetchsettings') ||
        details.contains('missing_required_data')) {
      return 'missing_required_data';
    }
    if (details.contains('context_length_exceeded') ||
        (details.contains('context') && details.contains('length'))) {
      return 'context_length_exceeded';
    }
    if (details.contains('timeout')) {
      return 'timeout';
    }
    if (details.contains('network error') ||
        details.contains('socket') ||
        details.contains('connection')) {
      return 'network_error';
    }
    if (details.contains('credit_limit_reached')) {
      return 'credit_limit_reached';
    }
    if (details.contains('ip_limit_reached')) {
      return 'ip_limit_reached';
    }
    if (details.contains('user_api_key_quota_exceeded')) {
      return 'user_api_key_quota_exceeded';
    }

    return 'unknown';
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
    final language = ref.read(currentLanguageProvider);
    final scrappableResult = await ref
        .read(clientProvider)
        .privateUserScrappables
        .getScrappableById(scrappableId, language: language)
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
    final language = ref.read(currentLanguageProvider);

    final sessionResult = await ref
        .read(clientProvider)
        .scrappableChatSession
        .createSession(scrappableId: scrappable.id!, language: language)
        .toResult;

    await sessionResult.fold(
      (createdSessionResponse) async {
        try {
          _chatResponseSubscription = ref
              .read(clientProvider)
              .scrappableChatSession
              .listenToScrappableRedraftSession(
                sessionUuid: createdSessionResponse.sessionId,
                language: language,
              )
              .listen(
                (response) {
                  // Ignore heartbeat responses - they keep the connection alive
                  // during long AI processing (infrastructure has ~60s idle timeout)
                  if (response is HeartbeatResponse) return;

                  onChange(response);
                },
                onError: (error, stackTrace) {
                  logError(error, stackTrace);

                  // If we already received a successful result, ignore late errors
                  // (e.g., WebSocket closing after success)
                  if (_hasReceivedExtractRule) return;

                  if (error is ZenScrapException) {
                    state = ScrapChatSessionState.withError(error: error);
                  } else {
                    final errorStringLower = error.toString().toLowerCase();
                    final isConnectionError =
                        errorStringLower.contains('connection') ||
                        errorStringLower.contains('websocket') ||
                        errorStringLower.contains('closed') ||
                        errorStringLower.contains('socket') ||
                        errorStringLower.contains('upgrade');
                    state = ScrapChatSessionState.withError(
                      error: isConnectionError
                          ? connectionClosedException
                          : defaultException,
                    );
                  }
                },
                cancelOnError: false,
              );

          final Duration timeUntilExpire = createdSessionResponse.expiresIn;
          final DateTime expirationDate = DateTime.now().add(timeUntilExpire);

          state = ScrapChatSessionState.standard(
            data: scrappable,
            sessionUuid: createdSessionResponse.sessionId,
            testExpirationDate: expirationDate,
            llmThinkingStream: null,
          );
        } catch (error, stackTrace) {
          logError(error, stackTrace);
          state = ScrapChatSessionState.withError(error: defaultException);
        }
      },
      (failure) async {
        state = ScrapChatSessionState.withError(error: failure);
      },
    );
  }

  Future<ResultDart<void, ZenScrapException>> commitCurrentChanges() async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return Failure(defaultException);

    final language = ref.read(currentLanguageProvider);
    return ref
        .read(clientProvider)
        .scrappableChatSession
        .commitCurrentEditState(sessionUuid: sessionUuid, language: language)
        .toResult;
  }

  /// Updates the user's OpenAI API key for the current session.
  /// This allows users to bypass platform credit limits by using their own key.
  Future<void> updateUserApiKey(String apiKey) async {
    final sessionUuid = state.mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    final language = ref.read(currentLanguageProvider);
    await ref
        .read(clientProvider)
        .scrappableChatSession
        .updateUserApiKey(
          sessionId: sessionUuid,
          openAiApiKey: apiKey,
          language: language,
        );
  }
}

final scrapChatProvider =
    NotifierProvider<ScrapChatSessionNotifier, ScrapChatSessionState>(
      ScrapChatSessionNotifier.new,
    );
