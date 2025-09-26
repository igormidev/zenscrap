import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/animated_thinking_dots.dart';

class LLMThinkingBubble extends StatefulWidget {
  final List<String> thinkingStream;

  const LLMThinkingBubble({
    super.key,
    required this.thinkingStream,
  });

  @override
  State<LLMThinkingBubble> createState() => _LLMThinkingBubbleState();
}

class _LLMThinkingBubbleState extends State<LLMThinkingBubble> {
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  static const int _compactCharLimit = 200;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getDisplayText(String fullText) {
    if (_isExpanded) {
      // Show all text when expanded (with ability to scroll)
      return fullText;
    } else {
      // Show last 200 characters when compact
      if (fullText.length <= _compactCharLimit) {
        return fullText;
      }

      final startIndex = fullText.length - _compactCharLimit;
      String compactText = fullText.substring(startIndex);

      // Clean up the start to begin at a word boundary if possible
      final firstSpace = compactText.indexOf(' ');
      if (firstSpace > 0 && firstSpace < 20) {
        compactText = '...${compactText.substring(firstSpace + 1)}';
      } else {
        compactText = '...$compactText';
      }

      return compactText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fullText = widget.thinkingStream.join();
    final displayText = _getDisplayText(fullText);

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              Icons.psychology,
              size: 18,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          // Message bubble
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username with icon
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outlined,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI (Thinking)',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Thinking bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerHigh,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha(20),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Thinking text content with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        constraints: BoxConstraints(
                          maxHeight: _isExpanded ? 300 : 80,
                        ),
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(
                            overscroll: false,
                            scrollbars: _isExpanded,
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            physics: _isExpanded
                                ? const AlwaysScrollableScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            child: SelectableText(
                              displayText,
                              key: ValueKey(
                                  '${displayText.length}_$_isExpanded'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                                height: 1.5,
                                fontSize: 12,
                                color:
                                    colorScheme.onSurfaceVariant.withAlpha(204),
                              ),
                            )
                                .animate(
                                  key: ValueKey(
                                      '${displayText.length}_$_isExpanded'),
                                )
                                .fadeIn(
                                  duration: 400.ms,
                                  curve: Curves.easeOut,
                                )
                                .slideX(
                                  begin: -0.02,
                                  end: 0,
                                  duration: 400.ms,
                                  curve: Curves.easeOut,
                                ),
                          ),
                        ),
                      ),
                      // Bottom bar with expand button and thinking indicator
                      if (fullText.length > _compactCharLimit) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Expand/Collapse button
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                  if (_isExpanded) {
                                    _scrollController.jumpTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                    );
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _isExpanded ? 'Show less' : 'Show more',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 14,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Animated thinking dots with tooltip
                            Tooltip(
                              message: 'AI is thinking...',
                              child: AnimatedThinkingDots(
                                color: colorScheme.primary,
                                size: 5,
                                spacing: 1.5,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 300.ms),
                      ] else ...[
                        // Show thinking indicator even for short messages
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Tooltip(
                            message: 'AI is thinking...',
                            child: AnimatedThinkingDots(
                              color: colorScheme.primary,
                              size: 5,
                              spacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
