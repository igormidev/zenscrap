import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

/// A Material 3 styled dialog that shows the AI thinking process while creating a scrappable.
/// This dialog is non-dismissable and automatically closes when creation completes or fails.
class CreatingScrappableDialog extends ConsumerStatefulWidget {
  const CreatingScrappableDialog({super.key});

  /// Shows the dialog and returns when creation is complete or an error occurs.
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => const CreatingScrappableDialog(),
    );
  }

  @override
  ConsumerState<CreatingScrappableDialog> createState() =>
      _CreatingScrappableDialogState();
}

class _CreatingScrappableDialogState
    extends ConsumerState<CreatingScrappableDialog>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _pulseController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to auto-close dialog
    ref.listen(scrapChatProvider, (previous, next) {
      next.maybeWhen(
        // Close dialog when we transition to standard state (success)
        standard: (scrappable, expDate, uuid, thinking) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        // Close dialog on error (landing page will show error view)
        withError: (_) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        orElse: () {},
      );
    });

    final state = ref.watch(scrapChatProvider);

    return state.maybeWhen(
      creatingScrappable: (referenceLink, thinkingChunks, groundingMetadata) {
        // Scroll to bottom when new chunks arrive
        if (thinkingChunks.isNotEmpty) {
          _scrollToBottom();
        }

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: _buildDialogContent(
            context,
            referenceLink,
            thinkingChunks,
            groundingMetadata,
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildDialogContent(
    BuildContext context,
    String referenceLink,
    List<String> thinkingChunks,
    GroundingMetadataInfo? groundingMetadata,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.6).clamp(400.0, 800.0);
    final dialogHeight = (screenSize.height * 0.75).clamp(400.0, 700.0);

    return Container(
      width: dialogWidth,
      height: dialogHeight,
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: context.c.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.c.shadow.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: context.c.primary.withValues(alpha: 0.05),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            _buildHeader(context, referenceLink, thinkingChunks.length),
            Expanded(
              child: _buildThinkingContent(context, thinkingChunks),
            ),
            if (groundingMetadata != null)
              _buildGroundingInfo(context, groundingMetadata),
            _buildStatusBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String referenceLink,
    int thoughtCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.c.primaryContainer.withValues(alpha: 0.5),
            context.c.surfaceContainerHighest.withValues(alpha: 0.5),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: context.c.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAnimatedIcon(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analyzing URL',
                      style: context.t.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.c.onSurface,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const SizedBox(height: 4),
                    Text(
                      referenceLink,
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.primary,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(context, thoughtCount),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                context.c.primary.withValues(alpha: 0.15 + _pulseController.value * 0.2),
                context.c.primary.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.c.primary.withValues(alpha: 0.25 * _pulseController.value),
                blurRadius: 16 * _pulseController.value,
                spreadRadius: 4 * _pulseController.value,
              ),
            ],
          ),
          child: Icon(
            Icons.psychology_rounded,
            size: 28,
            color: context.c.primary,
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, int thoughtCount) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(double.infinity, 6),
                painter: _WaveProgressPainter(
                  progress: _waveController.value,
                  color: context.c.primary,
                  backgroundColor: context.c.surfaceContainerHighest,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$thoughtCount thoughts processed',
              style: context.t.labelSmall?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPulsingDot(context),
                const SizedBox(width: 8),
                Text(
                  'AI is thinking...',
                  style: context.t.labelSmall?.copyWith(
                    color: context.c.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPulsingDot(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.c.tertiary,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 700.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.8, 0.8),
          duration: 700.ms,
        );
  }

  Widget _buildThinkingContent(
    BuildContext context,
    List<String> thinkingChunks,
  ) {
    if (thinkingChunks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 56,
              color: context.c.primary.withValues(alpha: 0.4),
            )
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: 3.seconds)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 1500.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(0.9, 0.9),
                  duration: 1500.ms,
                ),
            const SizedBox(height: 16),
            Text(
              'Initializing AI analysis...',
              style: context.t.titleSmall?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ).animate().fadeIn().shimmer(duration: 2.seconds),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: thinkingChunks.length,
      itemBuilder: (context, index) {
        final chunk = thinkingChunks[index];
        final isLatest = index == thinkingChunks.length - 1;

        return _ThinkingChunkItem(
          chunk: chunk,
          index: index,
          isLatest: isLatest,
        );
      },
    );
  }

  Widget _buildGroundingInfo(
    BuildContext context,
    GroundingMetadataInfo grounding,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.tertiaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.travel_explore,
            size: 18,
            color: context.c.tertiary,
          ),
          const SizedBox(width: 8),
          Text(
            'Web Search Grounding',
            style: context.t.labelMedium?.copyWith(
              color: context.c.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (grounding.sources.isNotEmpty)
            Text(
              '${grounding.sources.length} sources',
              style: context.t.labelSmall?.copyWith(
                color: context.c.onTertiaryContainer.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          top: BorderSide(
            color: context.c.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.lerp(
                    context.c.primary,
                    context.c.tertiary,
                    _pulseController.value,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.c.primary.withValues(alpha: 0.3 * (1 - _pulseController.value)),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gemini 3 Pro is analyzing your URL pattern...',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
          ),
          Icon(
            Icons.auto_awesome,
            size: 16,
            color: context.c.primary.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

/// Individual thinking chunk item with timeline indicator
class _ThinkingChunkItem extends StatelessWidget {
  final String chunk;
  final int index;
  final bool isLatest;

  const _ThinkingChunkItem({
    required this.chunk,
    required this.index,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLatest
                      ? context.c.primary
                      : context.c.surfaceContainerHighest,
                  border: Border.all(
                    color: isLatest ? context.c.primary : context.c.outlineVariant,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isLatest
                      ? Icon(
                          Icons.lightbulb_rounded,
                          size: 14,
                          color: context.c.onPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: context.t.labelSmall?.copyWith(
                            color: context.c.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                ),
              ),
              if (!isLatest)
                Container(
                  width: 2,
                  height: 16,
                  color: context.c.outlineVariant.withValues(alpha: 0.4),
                ),
            ],
          ),
          const SizedBox(width: 10),
          // Content card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLatest
                    ? context.c.primaryContainer.withValues(alpha: 0.25)
                    : context.c.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLatest
                      ? context.c.primary.withValues(alpha: 0.25)
                      : context.c.outlineVariant.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                chunk,
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideX(begin: 0.03, curve: Curves.easeOutCubic);
  }
}

/// Custom painter for animated wave progress indicator
class _WaveProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _WaveProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(3),
      ),
      bgPaint,
    );

    // Wave
    final wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final normalizedX = x / size.width;
      final waveOffset =
          math.sin((normalizedX * 4 * math.pi) + (progress * 2 * math.pi)) * 1.5;
      final y = size.height / 2 + waveOffset;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(3),
      ),
    );
    canvas.drawPath(path, wavePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WaveProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
