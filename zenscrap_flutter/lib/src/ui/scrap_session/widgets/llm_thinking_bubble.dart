import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/animated_thinking_dots.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/llm_thinking_dialog.dart';

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
  /// Removes ANSI escape codes and other control characters
  String _cleanText(String text) {
    // Remove ANSI escape codes (color codes, cursor movements, etc.)
    // Pattern matches ESC[ followed by any characters up to a letter
    final ansiPattern = RegExp(r'\x1B\[[0-9;]*[a-zA-Z]');
    String cleaned = text.replaceAll(ansiPattern, '');

    // Remove other common control characters except newlines and tabs
    cleaned =
        cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]'), '');

    return cleaned;
  }

  void _showFullThinkingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => LLMThinkingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fullText = _cleanText(widget.thinkingStream.join());

    // Split by newline and get EXACTLY the last 10 lines
    final allLines = fullText.split('\n');
    final linesToShow =
        allLines.sublist(allLines.length - 10 < 0 ? 0 : allLines.length - 10);
    final cleanedLines =
        linesToShow.join('\n').replaceAll(r'\n', '\n').split('\n');
    final displayText = cleanedLines
        .sublist(cleanedLines.length - 10 < 0 ? 0 : cleanedLines.length - 10)
        .join('\n');

    return GestureDetector(
      onTap: () => _showFullThinkingDialog(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and label
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.psychology,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI (Thinking)',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedThinkingDots(
                    color: colorScheme.primary,
                    size: 4,
                    spacing: 1.5,
                  ),
                  Spacer(),
                  Text(
                    '• Tap to view full',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withAlpha(153),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Display last 15 lines with NO scroll - just plain text with fade
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.85, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Text(
                  // RegExp('^\s*$'),
                  displayText.replaceAll(RegExp(r'^\s*$'), ''),
                  // displayText.replaceAll('\n\n', '\n'),
                  // RegExp().,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.6,
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant.withAlpha(179),
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
