import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';

class ScrappableChatMessageStreamSection extends ConsumerStatefulWidget {
  const ScrappableChatMessageStreamSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableChatMessageStreamSectionState();
}

class _ScrappableChatMessageStreamSectionState
    extends ConsumerState<ScrappableChatMessageStreamSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    ref.listen(chatMessagesProvider, (_, __) => _scrollToBottom());

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
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
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
    IconData? roleIcon;
    String roleLabel;
    CrossAxisAlignment alignment;
    EdgeInsets margin;

    if (isUserMessage) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      roleIcon = Icons.person;
      roleLabel = 'You';
      alignment = CrossAxisAlignment.end;
      margin = const EdgeInsets.only(left: 48, right: 0, bottom: 12);
    } else if (isSystemMessage) {
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurfaceVariant;
      roleIcon = Icons.info_outline;
      roleLabel = 'System';
      alignment = CrossAxisAlignment.center;
      margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    } else {
      backgroundColor = colorScheme.secondaryContainer;
      textColor = colorScheme.onSecondaryContainer;
      roleIcon = Icons.smart_toy;
      roleLabel = 'AI Assistant';
      alignment = CrossAxisAlignment.start;
      margin = const EdgeInsets.only(left: 0, right: 48, bottom: 12);
    }

    Widget messageContent = const SizedBox.shrink();

    if (message is MessageTextResponse) {
      messageContent = _TextMessage(
        text: (message as MessageTextResponse).messageText,
        textColor: textColor,
      );
    } else if (message is ErrorTextResponse) {
      final errorMessage = message as ErrorTextResponse;
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      roleIcon = Icons.error_outline;
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
      backgroundColor = colorScheme.tertiaryContainer;
      textColor = colorScheme.onTertiaryContainer;
      roleIcon = Icons.check_circle_outline;
      messageContent = _NewRuleMessage(
        messageText: newRuleMessage.messageText,
        textColor: textColor,
      );
    }

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (!isSystemMessage)
          Padding(
            padding: margin.copyWith(bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUserMessage) ...[
                  Icon(roleIcon,
                      size: 16, color: textColor.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                ],
                Text(
                  roleLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isUserMessage) ...[
                  const SizedBox(width: 4),
                  Icon(roleIcon,
                      size: 16, color: textColor.withValues(alpha: 0.7)),
                ],
              ],
            ),
          ),
        Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isUserMessage ? 16 : 4),
              topRight: Radius.circular(isUserMessage ? 4 : 16),
              bottomLeft: const Radius.circular(16),
              bottomRight: const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: messageContent,
        ),
        if (isLastMessage) const SizedBox(height: 8),
      ],
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
            height: 1.5,
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
      children: [
        Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 20,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SelectableText(
          errorMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.5,
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
    Clipboard.setData(ClipboardData(text: widget.extractRules));
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          widget.messageText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: widget.textColor,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.textColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.code,
                        size: 18,
                        color: widget.textColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Extract Rules',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: widget.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _copyToClipboard,
                        icon: Icon(
                          Icons.copy,
                          size: 16,
                          color: widget.textColor.withValues(alpha: 0.7),
                        ),
                        tooltip: 'Copy to clipboard',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: widget.textColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded) ...[
                const Divider(height: 1),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      widget.extractRules,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: widget.textColor.withValues(alpha: 0.9),
                        height: 1.4,
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
      children: [
        Icon(
          Icons.check_circle,
          size: 20,
          color: textColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            messageText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
