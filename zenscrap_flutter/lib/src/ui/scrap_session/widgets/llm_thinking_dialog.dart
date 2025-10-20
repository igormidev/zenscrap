import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

class LLMThinkingDialog extends ConsumerWidget {
  const LLMThinkingDialog({super.key});

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

  static String fullContext = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for state changes and auto-close when thinking ends
    ref.listen(scrapChatProvider, (previous, next) {
      final thinkingStream = next.maybeMap(
        standard: (value) => value.llmThinkingStream,
        orElse: () => null,
      );

      // If thinking stream becomes null, the AI has finished thinking
      if ((thinkingStream == null || thinkingStream.isEmpty) && !kDebugMode) {
        Navigator.of(context).pop();
      }
    });

    final scrapChatState = ref.watch(scrapChatProvider);

    // Extract thinking stream from the state
    final thinkingStream = scrapChatState.maybeMap(
      standard: (value) => value.llmThinkingStream,
      orElse: () => null,
    );

    // Join the thinking stream into full text
    if (thinkingStream != null && thinkingStream.isNotEmpty) {
      fullContext = _cleanText(thinkingStream.join());
    }

    return Dialog(
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const Spacer(),
                  if (kDebugMode)
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: fullContext));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
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
                    fullContext,
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
    );
  }
}
