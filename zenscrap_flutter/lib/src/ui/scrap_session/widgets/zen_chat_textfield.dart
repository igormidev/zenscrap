import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/chat_scroll_controller_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/change_ai_model_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_textfield.dart';

class ZenChatTextfield extends ConsumerStatefulWidget {
  final DateTime targetTime;
  const ZenChatTextfield({
    super.key,
    required this.targetTime,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ZenChatTextfieldState();
}

class _ZenChatTextfieldState extends ConsumerState<ZenChatTextfield> {
  bool isEndpointTimeExpired = false;
  final TextEditingController _promptEC = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isSendingMessage = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Use targetTime
    final Duration whenWillEnd = widget.targetTime.difference(DateTime.now());
    _timer = Timer.periodic(whenWillEnd, (timer) {
      if (mounted) {
        setState(() {
          isEndpointTimeExpired = true;
        });
      }
    });
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _promptEC.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      ref.read(chatScrollHelperProvider).scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSendingMessage)
      return;

    final message = _promptEC.text.trim();
    final analytics = ref.read(analyticsServiceProvider);

    setState(() {
      _isSendingMessage = true;
    });

    _promptEC.clear();
    _formKey.currentState?.reset();
    ref.read(chatScrollHelperProvider).scrollToBottom();

    try {
      // Track message send before sending
      final scrappable = ref.read(scrapChatProvider).mapOrNull(
            standard: (value) => value.data,
          );

      if (scrappable != null && scrappable.id != null) {
        await analytics.trackScrappableChatMessageSend(
          scrappableId: scrappable.id!,
          messageLength: message.length,
          messageCount: 0, // Count not available in state
        );
      }

      await ref.read(scrapChatProvider.notifier).sendMessage(message);
      // The thinking message will be automatically removed by onChange when the response arrives
      ref.read(chatScrollHelperProvider).scrollToBottom();
    } catch (error, stackTrace) {
      talker.error('Failed to send message', error, stackTrace);
      ref.read(chatScrollHelperProvider).scrollToBottom();
    } finally {
      setState(() {
        _isSendingMessage = false;
      });
    }
  }

  /// Checks if credits are exhausted and not yet resolved.
  /// Returns true if:
  /// - CreditLimitReachedResponse exists without a subsequent ApiKeyUpdatedResponse
  /// - UserApiKeyQuotaExceededResponse exists (user must add credits on OpenAI)
  bool _areCreditsExhausted(List<ChatResponse> messages) {
    if (messages.isEmpty) return false;

    // Find the last credit-related response
    CreditLimitReachedResponse? lastCreditLimitReached;
    ApiKeyUpdatedResponse? lastApiKeyUpdated;
    UserApiKeyQuotaExceededResponse? lastQuotaExceeded;

    for (final message in messages) {
      if (message is CreditLimitReachedResponse) {
        lastCreditLimitReached = message;
      } else if (message is ApiKeyUpdatedResponse) {
        lastApiKeyUpdated = message;
      } else if (message is UserApiKeyQuotaExceededResponse) {
        lastQuotaExceeded = message;
      }
    }

    // If user's own API key ran out of credits, they need to add credits on OpenAI
    if (lastQuotaExceeded != null) {
      // Check if this happened after an API key update (meaning user tried and failed)
      // For now, we don't block sending as user may have added credits on OpenAI
      // They'll just get the error again if they haven't
      return false;
    }

    // If platform credits ran out, check if user added their API key to resolve
    if (lastCreditLimitReached != null) {
      // If ApiKeyUpdatedResponse came after CreditLimitReachedResponse, it's resolved
      final creditLimitIndex = messages.indexOf(lastCreditLimitReached);
      final apiKeyIndex = lastApiKeyUpdated != null
          ? messages.indexOf(lastApiKeyUpdated)
          : -1;

      // Not resolved if no API key update OR if credit limit reached after API key update
      return apiKeyIndex < creditLimitIndex;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Watch chat messages to check for credit exhaustion
    final messages = ref.watch(chatMessagesProvider).valueOrNull ?? [];
    final isCreditsExhausted = _areCreditsExhausted(messages);

    final isDisabled = isEndpointTimeExpired ||
        _isSendingMessage ||
        ref.watch(isChatLoadingProvider) ||
        isCreditsExhausted;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ChangeAiModelButton(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ZenTextfield(
                  controller: _promptEC,
                  focusNode: _focusNode,
                  labelText: isCreditsExhausted
                      ? 'Add API key to continue...'
                      : 'Ask for any modification...',
                  hintText: '',
                  minLines: 1,
                  maxLines: 5,
                  enabled: !isDisabled,
                  onSubmitted: (_) => _sendMessage(),
                  validator: ValidationBuilder()
                      .minLength(3, 'Message must be at least 3 characters')
                      .maxLength(
                          1000, 'Message must be less than 1000 characters')
                      .build(),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                borderRadius: BorderRadius.circular(12),
                color: isDisabled
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.primary,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isDisabled ? null : _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: _isSendingMessage
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: isDisabled
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.onPrimary,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
