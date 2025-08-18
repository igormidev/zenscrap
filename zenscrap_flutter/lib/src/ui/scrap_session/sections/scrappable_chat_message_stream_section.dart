import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/chat_scroll_controller_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';

class ScrappableChatMessageStreamSection extends ConsumerStatefulWidget {
  const ScrappableChatMessageStreamSection({super.key});

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
        child: CircularProgressIndicator(),
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

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 20, bottom: 32),
          itemCount: messages.length,
          itemBuilder: (context, index) {
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
      userName = "AI (GEMINI)";
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
    } else if (message is MessageTextAndNewExtractRulesResponse) {
      final extractMessage = message as MessageTextAndNewExtractRulesResponse;
      messageContent = _ExtractRulesMessage(
        messageText: extractMessage.messageText,
        extractRules: extractMessage.newExtractRules,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    } else if (message is NewExtractRuleResponse) {
      final newRuleMessage = message as NewExtractRuleResponse;
      messageContent = _NewRuleMessage(
        messageText: newRuleMessage.messageText,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

class _ExtractRulesMessage extends StatefulWidget {
  final String messageText;
  final String extractRules;
  final Color textColor;
  final Color backgroundColor;

  const _ExtractRulesMessage({
    required this.messageText,
    required this.extractRules,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  State<_ExtractRulesMessage> createState() => _ExtractRulesMessageState();
}

class _ExtractRulesMessageState extends State<_ExtractRulesMessage> {
  bool _isExpanded = false;

  void _copyToClipboard() {
    // Try to decode the JSON and format it properly
    final decodedJson = tryDecode(widget.extractRules);
    String textToCopy;

    if (decodedJson != null) {
      // Format JSON with proper indentation
      const encoder = JsonEncoder.withIndent('  ');
      textToCopy = encoder.convert(decodedJson);
    } else {
      // If not valid JSON, copy as-is
      textToCopy = widget.extractRules;
    }

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Extract rules copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decodedJson = tryDecode(widget.extractRules);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText(
          widget.messageText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: widget.textColor,
            height: 1.4,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
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
                        Icons.code_rounded,
                        size: 16,
                        color: widget.textColor.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Extract Rules',
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
                      ? Text(
                          JsonEncoder.withIndent('  ').convert(decodedJson),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: widget.textColor.withValues(alpha: 0.85),
                            height: 1.3,
                            fontSize: 14,
                          ),
                        )
                      : SingleChildScrollView(
                          child: SelectableText(
                            widget.extractRules,
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
