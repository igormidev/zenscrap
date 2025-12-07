import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/chat_scroll_controller_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/llm_thinking_bubble.dart';

class ScrappableChatMessageStreamSection extends ConsumerStatefulWidget {
  final List<String>? llmThinkingStream;
  const ScrappableChatMessageStreamSection({
    super.key,
    required this.llmThinkingStream,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableChatMessageStreamSectionState();
}

class _ScrappableChatMessageStreamSectionState
    extends ConsumerState<ScrappableChatMessageStreamSection> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ref.watch(chatScrollControllerProvider);
    final scrollHelper = ref.watch(chatScrollHelperProvider);
    final messagesAsync = ref.watch(chatMessagesProvider);
    ref.listen(chatMessagesProvider, (_, __) => scrollHelper.scrollToBottom());

    return messagesAsync.when(
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Syncing...', textAlign: TextAlign.center),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading messages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (messages) {
        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Send a message to start the conversation',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                      ),
                ),
              ],
            ),
          );
        }
        final bool willHideLoading = messages.willHideLoading;

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 20, bottom: 32),
          itemCount: messages.length + (willHideLoading ? 0 : 1),
          itemBuilder: (context, index) {
            final bool isLastIndex = index == messages.length;
            if (isLastIndex &&
                widget.llmThinkingStream != null &&
                widget.llmThinkingStream!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LLMThinkingBubble(
                  thinkingStream: widget.llmThinkingStream!,
                ),
              );
            }

            if (isLastIndex && !willHideLoading) {
              return GenericLoadingBubble();
            }

            final message = messages[index];
            return _ChatMessageBubble(
              message: message,
              isLastMessage: index == messages.length - 1,
            );
          },
        );
      },
    );
  }
}

class GenericLoadingBubble extends StatelessWidget {
  const GenericLoadingBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 36),
        child: Transform.scale(
          scale: 1.41,
          child: Lottie.network(
            'https://lottie.host/dfab8b34-c79f-4d84-9e3d-d866b2096c74/zPpMTjtNaK.lottie',
            decoder: customDecoder,
            width: 60,
          ),
        ).animate().fadeIn(),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final ChatResponse message;
  final bool isLastMessage;

  const _ChatMessageBubble({
    required this.message,
    required this.isLastMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isUserMessage = message.role == PromptRole.user;
    final isSystemMessage = message.role == PromptRole.system;

    Color backgroundColor;
    Color textColor;
    IconData roleIcon;
    Color iconBackgroundColor;
    Color iconColor;
    MainAxisAlignment rowAlignment;
    BorderRadius messageBorderRadius;
    EdgeInsetsGeometry messagePadding;
    const double border = 22;
    String userName;

    if (isUserMessage) {
      userName = "You";
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      roleIcon = Icons.person;
      iconBackgroundColor = colorScheme.primaryContainer;
      iconColor = colorScheme.onPrimaryContainer;
      rowAlignment = MainAxisAlignment.end;
      messageBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(border),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(border),
        bottomRight: Radius.circular(border),
      );
      messagePadding = const EdgeInsets.only(left: 56, right: 0);
    } else if (isSystemMessage) {
      userName = "ZenBot";
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurfaceVariant;
      roleIcon = Icons.spa;
      iconBackgroundColor = colorScheme.surfaceContainerHigh;
      iconColor = colorScheme.onSurfaceVariant;
      rowAlignment = MainAxisAlignment.start;
      messageBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(border),
        bottomLeft: Radius.circular(border),
        bottomRight: Radius.circular(border),
      );
      messagePadding = const EdgeInsets.only(left: 0, right: 56);
    } else {
      // Model/AI message
      userName = "AI (CHAT GPT 5.1)";
      backgroundColor = colorScheme.surfaceContainerHigh;
      textColor = colorScheme.onSurface;
      roleIcon = Icons.smart_toy;
      iconBackgroundColor = colorScheme.secondaryContainer;
      iconColor = colorScheme.onSecondaryContainer;
      rowAlignment = MainAxisAlignment.start;
      messageBorderRadius = const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(border),
        bottomLeft: Radius.circular(border),
        bottomRight: Radius.circular(border),
      );
      messagePadding = const EdgeInsets.only(left: 0, right: 56);
    }

    // Override message bubble colors for specific message types (keep role icon unchanged)
    if (message is ErrorTextResponse) {
      // Error messages get error-themed bubble but keep role icon
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      // Do NOT change roleIcon - it should remain as the sender's role icon
    } else if (message is NewExtractRuleResponse) {
      // Success messages get success-themed bubble
      // backgroundColor = colorScheme.tertiaryContainer;
      // textColor = colorScheme.onTertiaryContainer;
      backgroundColor = const Color.fromARGB(255, 211, 245, 188);
      textColor = Colors.green[800]!;
      // Do NOT change roleIcon - it should remain as the sender's role icon
    }

    Widget messageContent = const SizedBox.shrink();

    if (message is MessageTextResponse) {
      messageContent = _TextMessage(
        text: (message as MessageTextResponse).messageText,
        textColor: textColor,
      );
    } else if (message is ErrorTextResponse) {
      final errorMessage = message as ErrorTextResponse;
      messageContent = _ErrorMessage(
        errorMessage: errorMessage.errorMessage,
        textColor: textColor,
      );
    } else if (message is CandidateExtractLogicUpdate) {
      final extractMessage = message as CandidateExtractLogicUpdate;
      messageContent = _JsonDisplayMessage(
        messageText: extractMessage.messageText,
        jsonData: extractMessage.scrappingBeeExtractLogic.extractRules,
        jsonTitle: 'Extract Rules',
        icon: Icons.code_rounded,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is TestEndpointCalledSuccessResponse) {
      final successMessage = message as TestEndpointCalledSuccessResponse;
      messageContent = _TestEndpointSuccessMessage(
        inputPayload: successMessage.inputPayload,
        responseData: successMessage.responseData,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is TestEndpointCalledErrorResponse) {
      final errorMessage = message as TestEndpointCalledErrorResponse;
      // Override bubble color for error
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      messageContent = _TestEndpointErrorMessage(
        errorTitle: errorMessage.errorTitle,
        errorDescription: errorMessage.errorDescription,
        inputPayload: errorMessage.inputPayload,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is NewExtractRuleResponse) {
      final newRuleMessage = message as NewExtractRuleResponse;
      messageContent = _NewRuleMessage(
        messageText: newRuleMessage.messageText,
        textColor: textColor,
      );
    } else if (message is UpdatedScrappableRequestResponse) {
      final updatedRequest = message as UpdatedScrappableRequestResponse;
      messageContent = _UpdatedScrappableRequestMessage(
        messageText: updatedRequest.messageText,
        url: updatedRequest.url,
        pathParams: updatedRequest.pathParams,
        queryParams: updatedRequest.queryParams,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is CreditLimitReachedResponse) {
      final creditMsg = message as CreditLimitReachedResponse;
      // Override to warning colors
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      messageContent = _CreditLimitReachedMessage(
        messageText: creditMsg.messageText,
        creditsSpent: creditMsg.creditsSpent,
        creditsLimit: creditMsg.creditsLimit,
        canUseOwnApiKey: creditMsg.canUseOwnApiKey,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is UserApiKeyQuotaExceededResponse) {
      final quotaMsg = message as UserApiKeyQuotaExceededResponse;
      // Override to warning colors
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      messageContent = _UserApiKeyQuotaExceededMessage(
        messageText: quotaMsg.messageText,
        openAiErrorMessage: quotaMsg.openAiErrorMessage,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is ApiKeyUpdatedResponse) {
      final keyUpdatedMsg = message as ApiKeyUpdatedResponse;
      // Override to success colors
      backgroundColor = const Color.fromARGB(255, 211, 245, 188);
      textColor = Colors.green[800]!;
      messageContent = _ApiKeyUpdatedMessage(
        messageText: keyUpdatedMsg.messageText,
        textColor: textColor,
      );
    }

    return Padding(
      padding: messagePadding.add(const EdgeInsets.symmetric(vertical: 4)),
      child: Row(
        mainAxisAlignment: rowAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            _MessageAvatar(
              icon: roleIcon,
              backgroundColor: iconBackgroundColor,
              iconColor: iconColor,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    userName,
                    style: context.t.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: messageBorderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: messageContent,
                  ),
                ),
              ],
            ),
          ),
          if (isUserMessage) ...[
            const SizedBox(width: 8),
            _MessageAvatar(
              icon: roleIcon,
              backgroundColor: iconBackgroundColor,
              iconColor: iconColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageAvatar extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _MessageAvatar({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
    );
  }
}

class _TextMessage extends StatelessWidget {
  final String text;
  final Color textColor;

  const _TextMessage({
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
            height: 1.4,
            fontSize: 14,
          ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String errorMessage;
  final Color textColor;

  const _ErrorMessage({
    required this.errorMessage,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            Text(
              'Error',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SelectableText(
          errorMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withValues(alpha: 0.9),
                height: 1.4,
                fontSize: 14,
              ),
        ),
      ],
    );
  }
}

/// Reusable template widget for displaying JSON data with expandable/collapsible UI
class _JsonDisplayMessage extends StatefulWidget {
  final String? messageText;
  final String jsonData;
  final String jsonTitle;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;

  const _JsonDisplayMessage({
    this.messageText,
    required this.jsonData,
    required this.jsonTitle,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  State<_JsonDisplayMessage> createState() => _JsonDisplayMessageState();
}

class _JsonDisplayMessageState extends State<_JsonDisplayMessage> {
  bool _isExpanded = false;

  void _copyToClipboard() {
    // Try to decode the JSON and format it properly
    final decodedJson = tryDecode(widget.jsonData);
    String textToCopy;

    if (decodedJson != null) {
      // Format JSON with proper indentation
      const encoder = JsonEncoder.withIndent('  ');
      textToCopy = encoder.convert(decodedJson);
    } else {
      // If not valid JSON, copy as-is
      textToCopy = widget.jsonData;
    }

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.jsonTitle} copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decodedJson = tryDecode(widget.jsonData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.messageText != null) ...[
          SelectableText(
            widget.messageText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.textColor,
              height: 1.4,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: widget.textColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.textColor.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        widget.icon,
                        size: 16,
                        color: widget.textColor.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.jsonTitle,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: widget.textColor.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: _copyToClipboard,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 14,
                            color: widget.textColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: widget.textColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: widget.textColor.withValues(alpha: 0.1),
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  padding: const EdgeInsets.all(10),
                  child: decodedJson != null
                      ? SingleChildScrollView(
                          child: SelectableText(
                            JsonEncoder.withIndent('  ').convert(decodedJson),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: widget.textColor.withValues(alpha: 0.85),
                              height: 1.3,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: SelectableText(
                            widget.jsonData,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: widget.textColor.withValues(alpha: 0.85),
                              height: 1.3,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _NewRuleMessage extends StatelessWidget {
  final String messageText;
  final Color textColor;

  const _NewRuleMessage({
    required this.messageText,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: textColor.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SelectableText(
            messageText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  height: 1.4,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _UpdatedScrappableRequestMessage extends StatelessWidget {
  final String messageText;
  final String url;
  final List<String> pathParams;
  final Map<String, String?> queryParams;
  final Color textColor;
  final Color backgroundColor;

  const _UpdatedScrappableRequestMessage({
    required this.messageText,
    required this.url,
    required this.pathParams,
    required this.queryParams,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                messageText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: textColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                icon: Icons.link,
                label: 'URL:',
                value: url,
                textColor: textColor,
              ),
              if (pathParams.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.label_outline,
                  label: 'Path Parameters:',
                  value: pathParams.map((p) => '{$p}').join(', '),
                  textColor: textColor,
                ),
              ],
              if (queryParams.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.tune,
                  label: 'Query Parameters:',
                  value: queryParams.entries
                      .map((e) => '${e.key}=${e.value ?? "dynamic"}')
                      .join(', '),
                  textColor: textColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: textColor.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontFamily: 'monospace',
                ),
          ),
        ),
      ],
    );
  }
}

class _TestEndpointSuccessMessage extends StatelessWidget {
  final String inputPayload;
  final String responseData;
  final Color textColor;
  final Color backgroundColor;

  const _TestEndpointSuccessMessage({
    required this.inputPayload,
    required this.responseData,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            Text(
              'Test Endpoint Called Successfully',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _JsonDisplayMessage(
          jsonData: inputPayload,
          jsonTitle: 'Request Payload',
          icon: Icons.input_rounded,
          textColor: textColor,
          backgroundColor: backgroundColor,
        ),
        const SizedBox(height: 8),
        _JsonDisplayMessage(
          jsonData: responseData,
          jsonTitle: 'Response Data',
          icon: Icons.output_rounded,
          textColor: textColor,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}

class _TestEndpointErrorMessage extends StatelessWidget {
  final String errorTitle;
  final String errorDescription;
  final String inputPayload;
  final Color textColor;
  final Color backgroundColor;

  const _TestEndpointErrorMessage({
    required this.errorTitle,
    required this.errorDescription,
    required this.inputPayload,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_rounded,
              size: 16,
              color: textColor.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 6),
            Text(
              'Test Endpoint Failed',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: textColor.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                errorDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor.withValues(alpha: 0.9),
                      height: 1.4,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _JsonDisplayMessage(
          jsonData: inputPayload,
          jsonTitle: 'Request Payload',
          icon: Icons.input_rounded,
          textColor: textColor,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}

/// Material 3 styled message widget for when platform credits are exhausted.
/// Shows a prominent CTA for users to add their own OpenAI API key.
class _CreditLimitReachedMessage extends ConsumerWidget {
  final String messageText;
  final double creditsSpent;
  final double creditsLimit;
  final bool canUseOwnApiKey;
  final Color textColor;
  final Color backgroundColor;

  const _CreditLimitReachedMessage({
    required this.messageText,
    required this.creditsSpent,
    required this.creditsLimit,
    required this.canUseOwnApiKey,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check if API key has already been added (resolve state)
    final messages = ref.watch(chatMessagesProvider).valueOrNull ?? [];
    final hasApiKeyUpdated =
        messages.any((m) => m is ApiKeyUpdatedResponse);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with warning icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 18,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Credit Limit Reached',
              style: theme.textTheme.titleSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Credit usage progress bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: textColor.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Credits Used',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    '\$${creditsSpent.toStringAsFixed(2)} / \$${creditsLimit.toStringAsFixed(2)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (creditsSpent / creditsLimit).clamp(0.0, 1.0),
                  backgroundColor: textColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.error),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Message text
        SelectableText(
          messageText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),

        // CTA Button - only show if user can use own API key and hasn't added one yet
        if (canUseOwnApiKey && !hasApiKeyUpdated) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showApiKeyDialog(context, ref),
              icon: const Icon(Icons.key_rounded, size: 18),
              label: const Text('Add Your OpenAI API Key'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use your own API key to continue without limits',
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Show resolved state if API key was added
        if (hasApiKeyUpdated) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  'Resolved - API key added',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showApiKeyDialog(BuildContext context, WidgetRef ref) async {
    final apiKeyController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.key_rounded, color: colorScheme.primary),
            const SizedBox(width: 12),
            const Expanded(child: Text('Add OpenAI API Key')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your OpenAI API key to continue chatting without using platform credits.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: apiKeyController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'API Key',
                  hintText: 'sk-...',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'Your key is stored securely',
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => launchUrl(
                  Uri.parse('https://platform.openai.com/api-keys'),
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Get an API key from OpenAI',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final key = apiKeyController.text.trim();
              if (key.isNotEmpty) {
                Navigator.of(context).pop(key);
              }
            },
            child: const Text('Save API Key'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      try {
        await ref.read(scrapChatProvider.notifier).updateUserApiKey(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('API key saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save API key: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

/// Material 3 styled message widget for when the user's own OpenAI API key
/// has run out of credits.
class _UserApiKeyQuotaExceededMessage extends StatelessWidget {
  final String messageText;
  final String? openAiErrorMessage;
  final Color textColor;
  final Color backgroundColor;

  const _UserApiKeyQuotaExceededMessage({
    required this.messageText,
    this.openAiErrorMessage,
    required this.textColor,
    required this.backgroundColor,
  });

  static const _openAiBillingUrl = 'https://platform.openai.com/settings/organization/billing/overview';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.credit_card_off_rounded,
                size: 18,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'OpenAI API Credits Exhausted',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Message text
        SelectableText(
          messageText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),

        // OpenAI error details (collapsible)
        if (openAiErrorMessage != null && openAiErrorMessage!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: textColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'OpenAI Error Details',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  openAiErrorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],

        // CTA Button to add credits to OpenAI
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => launchUrl(Uri.parse(_openAiBillingUrl)),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Add Credits on OpenAI'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'After adding credits, try sending your message again',
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Simple success message for when API key is updated
class _ApiKeyUpdatedMessage extends StatelessWidget {
  final String messageText;
  final Color textColor;

  const _ApiKeyUpdatedMessage({
    required this.messageText,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: textColor.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SelectableText(
            messageText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  height: 1.4,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
