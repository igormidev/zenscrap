import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A beautiful, animated view that shows AI thinking process in real-time.
/// Features Material 3 design with smooth animations and visual feedback.
class AiThinkingStreamView extends StatefulWidget {
  final String referenceLink;
  final List<String> thinkingChunks;
  final GroundingMetadataInfo? groundingMetadata;

  const AiThinkingStreamView({
    super.key,
    required this.referenceLink,
    required this.thinkingChunks,
    this.groundingMetadata,
  });

  @override
  State<AiThinkingStreamView> createState() => _AiThinkingStreamViewState();
}

class _AiThinkingStreamViewState extends State<AiThinkingStreamView>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _pulseController;
  late final AnimationController _brainWaveController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _brainWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void didUpdateWidget(AiThinkingStreamView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-scroll to bottom when new thinking chunks arrive
    if (widget.thinkingChunks.length > oldWidget.thinkingChunks.length) {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    _brainWaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.c.surface,
            context.c.surfaceContainerLow,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildThinkingContent(context),
          ),
          if (widget.groundingMetadata != null) _buildGroundingInfo(context),
          _buildStatusBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: context.c.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Animated brain icon
              _buildAnimatedBrainIcon(context),
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
                    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                    const SizedBox(height: 4),
                    Text(
                      widget.referenceLink,
                      style: context.t.bodyMedium?.copyWith(
                        color: context.c.primary,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress indicator
          _buildProgressIndicator(context),
        ],
      ),
    );
  }

  Widget _buildAnimatedBrainIcon(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                context.c.primary.withValues(alpha: 0.2 + _pulseController.value * 0.3),
                context.c.primary.withValues(alpha: 0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.c.primary.withValues(alpha: 0.3 * _pulseController.value),
                blurRadius: 20 * _pulseController.value,
                spreadRadius: 5 * _pulseController.value,
              ),
            ],
          ),
          child: Icon(
            Icons.psychology_rounded,
            size: 32,
            color: context.c.primary,
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _brainWaveController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(double.infinity, 8),
                      painter: _WavePainter(
                        progress: _brainWaveController.value,
                        color: context.c.primary,
                        backgroundColor: context.c.surfaceContainerHighest,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.thinkingChunks.length} thoughts processed',
              style: context.t.labelSmall?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
            Row(
              children: [
                Container(
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
                      duration: 800.ms,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(0.8, 0.8),
                      duration: 800.ms,
                    ),
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

  Widget _buildThinkingContent(BuildContext context) {
    if (widget.thinkingChunks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: context.c.primary.withValues(alpha: 0.5),
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
              style: context.t.titleMedium?.copyWith(
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
      itemCount: widget.thinkingChunks.length,
      itemBuilder: (context, index) {
        final chunk = widget.thinkingChunks[index];
        final isLatest = index == widget.thinkingChunks.length - 1;

        return _ThinkingChunkCard(
          chunk: chunk,
          index: index,
          isLatest: isLatest,
        );
      },
    );
  }

  Widget _buildGroundingInfo(BuildContext context) {
    final grounding = widget.groundingMetadata;
    if (grounding == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.c.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.travel_explore,
                size: 20,
                color: context.c.tertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Web Search Grounding',
                style: context.t.titleSmall?.copyWith(
                  color: context.c.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (grounding.searchQueries.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: grounding.searchQueries.map((query) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.c.tertiary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        size: 14,
                        color: context.c.tertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        query,
                        style: context.t.labelSmall?.copyWith(
                          color: context.c.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          if (grounding.sources.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${grounding.sources.length} sources referenced',
              style: context.t.labelSmall?.copyWith(
                color: context.c.onTertiaryContainer.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: context.c.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildPulsingDot(context),
          const SizedBox(width: 12),
          Text(
            'Gemini 3 Pro is analyzing your URL pattern...',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.auto_awesome,
            size: 16,
            color: context.c.primary.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(BuildContext context) {
    return AnimatedBuilder(
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
                color: context.c.primary.withValues(alpha: 0.4 * (1 - _pulseController.value)),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThinkingChunkCard extends StatelessWidget {
  final String chunk;
  final int index;
  final bool isLatest;

  const _ThinkingChunkCard({
    required this.chunk,
    required this.index,
    required this.isLatest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLatest
                      ? context.c.primary
                      : context.c.surfaceContainerHighest,
                  border: Border.all(
                    color: isLatest
                        ? context.c.primary
                        : context.c.outlineVariant,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isLatest
                      ? Icon(
                          Icons.lightbulb,
                          size: 16,
                          color: context.c.onPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: context.t.labelSmall?.copyWith(
                            color: context.c.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (!isLatest)
                Container(
                  width: 2,
                  height: 20,
                  color: context.c.outlineVariant.withValues(alpha: 0.5),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLatest
                    ? context.c.primaryContainer.withValues(alpha: 0.3)
                    : context.c.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLatest
                      ? context.c.primary.withValues(alpha: 0.3)
                      : context.c.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                chunk,
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05, curve: Curves.easeOutCubic);
  }
}

/// Custom painter for animated wave progress indicator
class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _WavePainter({
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
        const Radius.circular(4),
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
      final waveOffset = math.sin((normalizedX * 4 * math.pi) + (progress * 2 * math.pi)) * 2;
      final y = size.height / 2 + waveOffset;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(4),
      ),
    );
    canvas.drawPath(path, wavePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
