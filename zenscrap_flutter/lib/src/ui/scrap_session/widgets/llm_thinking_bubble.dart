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
  bool _isDialogOpen = false;

  @override
  void dispose() {
    // Auto-close dialog when thinking ends (widget is disposed)
    if (_isDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    super.dispose();
  }

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

  void _showFullThinkingDialog(BuildContext context, String fullText) {
    _isDialogOpen = true;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 700,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Full Thinking Process',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _isDialogOpen = false;
                        Navigator.of(dialogContext).pop();
                      },
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      fullText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            height: 1.6,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      // Dialog closed
      if (mounted) {
        setState(() {
          _isDialogOpen = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fullText = _cleanText(widget.thinkingStream.join());

    // Split by newline and get EXACTLY the last 15 lines
    final allLines = fullText.split('\n');
    final linesToShow = allLines.length > 15
        ? allLines.sublist(allLines.length - 15)
        : allLines;
    final displayText = linesToShow.join('\n');

    return GestureDetector(
      onTap: () => _showFullThinkingDialog(context, fullText),
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
                  displayText,
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
