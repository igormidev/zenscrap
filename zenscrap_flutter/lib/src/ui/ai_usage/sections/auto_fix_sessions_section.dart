import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/ai_usage_card.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/load_more_button.dart';

/// Displays the paginated auto-fix sessions list.
/// Shows AI-powered automatic repair attempts for broken scrappables.
class AutoFixSessionsSection extends StatelessWidget {
  final List<AutoFixSession> sessions;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const AutoFixSessionsSection({
    super.key,
    required this.sessions,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return AiUsageCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: AiUsageCardHeader(
              icon: Icons.auto_fix_high,
              title: 'Auto-Fix Sessions',
            ),
          ),
          Expanded(
            child: _AutoFixSessionsList(
              sessions: sessions,
              isLoadingMore: isLoadingMore,
              hasMore: hasMore,
              onLoadMore: onLoadMore,
            ),
          ),
        ],
      ),
    );
  }
}

class _AutoFixSessionsList extends StatelessWidget {
  final List<AutoFixSession> sessions;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _AutoFixSessionsList({
    required this.sessions,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return _EmptySessionsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: sessions.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == sessions.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: LoadMoreButton(
              isLoading: isLoadingMore,
              onPressed: onLoadMore,
            ),
          );
        }

        final session = sessions[index];
        return _AutoFixSessionItem(session: session);
      },
    );
  }
}

class _EmptySessionsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_fix_high,
              size: 48,
              color: context.c.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No auto-fix sessions yet',
              style: context.t.bodyLarge?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When your scrappables break, our AI will automatically attempt to fix them. Those sessions will appear here.',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurface.withAlpha(100),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoFixSessionItem extends StatelessWidget {
  final AutoFixSession session;

  const _AutoFixSessionItem({required this.session});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, y h:mm a');
    final dateStr = dateFormatter.format(session.createdAt);

    // Determine status styling
    final (IconData icon, Color color, String statusLabel) =
        _getStatusStyling(context, session.status);

    // Build model label
    final modelLabel = session.usedAiModel == AiModel.powerful
        ? 'Powerful Model'
        : 'Normal Model';

    // Token usage info
    final totalTokens = session.totalInputTokens + session.totalOutputTokens;
    final tokenInfo = totalTokens > 0 ? '${_formatTokens(totalTokens)} tokens' : null;

    // Cost info (only if not using user's own API key)
    final costInfo = !session.usedUserApiKey && session.totalCostUsd > 0
        ? '\$${session.totalCostUsd.toStringAsFixed(4)}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withAlpha(50),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Scrappable #${session.scrappableId}',
                style: context.t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _StatusBadge(label: statusLabel, color: color),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$dateStr • $modelLabel',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ),
        children: [
          _SessionDetails(
            session: session,
            tokenInfo: tokenInfo,
            costInfo: costInfo,
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _getStatusStyling(
    BuildContext context,
    AutoFixSessionStatus status,
  ) {
    return switch (status) {
      AutoFixSessionStatus.pending => (
          Icons.hourglass_empty,
          context.c.tertiary,
          'Pending',
        ),
      AutoFixSessionStatus.in_progress => (
          Icons.sync,
          context.c.primary,
          'In Progress',
        ),
      AutoFixSessionStatus.success => (
          Icons.check_circle,
          Colors.green,
          'Success',
        ),
      AutoFixSessionStatus.failed => (
          Icons.error,
          context.c.error,
          'Failed',
        ),
      AutoFixSessionStatus.exhausted => (
          Icons.block,
          context.c.error,
          'Exhausted',
        ),
      AutoFixSessionStatus.cancelled => (
          Icons.cancel,
          context.c.onSurface.withAlpha(150),
          'Cancelled',
        ),
    };
  }

  String _formatTokens(int tokens) {
    if (tokens >= 1000000) {
      return '${(tokens / 1000000).toStringAsFixed(1)}M';
    } else if (tokens >= 1000) {
      return '${(tokens / 1000).toStringAsFixed(1)}K';
    }
    return tokens.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: context.t.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SessionDetails extends StatelessWidget {
  final AutoFixSession session;
  final String? tokenInfo;
  final String? costInfo;

  const _SessionDetails({
    required this.session,
    this.tokenInfo,
    this.costInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        // Trigger info
        _DetailRow(
          label: 'Triggered at',
          value: '${session.triggeredAtErrorCount} consecutive errors (threshold: ${session.configuredThreshold})',
        ),
        const SizedBox(height: 8),
        // API key info
        _DetailRow(
          label: 'API Key',
          value: session.usedUserApiKey ? 'Your own key' : 'Platform key',
        ),
        if (tokenInfo != null) ...[
          const SizedBox(height: 8),
          _DetailRow(label: 'Tokens used', value: tokenInfo!),
        ],
        if (costInfo != null) ...[
          const SizedBox(height: 8),
          _DetailRow(label: 'Cost', value: costInfo!),
        ],
        // Success summary or failure reason
        if (session.successSummary != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fix Summary',
                  style: context.t.labelMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.successSummary!,
                  style: context.t.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (session.failureReason != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.errorContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failure Reason',
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  session.failureReason!,
                  style: context.t.bodySmall?.copyWith(
                    color: context.c.error,
                  ),
                ),
              ],
            ),
          ),
        ],
        // Attempts list
        if (session.attempts != null && session.attempts!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Attempts (${session.attempts!.length})',
            style: context.t.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...session.attempts!.map((attempt) => _AttemptItem(attempt: attempt)),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.t.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _AttemptItem extends StatelessWidget {
  final AutoFixAttempt attempt;

  const _AttemptItem({required this.attempt});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (attempt.status) {
      AutoFixAttemptStatus.in_progress => context.c.primary,
      AutoFixAttemptStatus.success => Colors.green,
      AutoFixAttemptStatus.ai_error => context.c.error,
      AutoFixAttemptStatus.api_error => context.c.error,
      AutoFixAttemptStatus.validation_failed => context.c.tertiary,
    };

    final statusLabel = switch (attempt.status) {
      AutoFixAttemptStatus.in_progress => 'In Progress',
      AutoFixAttemptStatus.success => 'Success',
      AutoFixAttemptStatus.ai_error => 'AI Error',
      AutoFixAttemptStatus.api_error => 'API Error',
      AutoFixAttemptStatus.validation_failed => 'Validation Failed',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.c.outline.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${attempt.attemptNumber}',
                style: context.t.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusLabel,
                  style: context.t.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
                if (attempt.errorMessage != null)
                  Text(
                    attempt.errorMessage!,
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurface.withAlpha(150),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (attempt.inputTokens > 0 || attempt.outputTokens > 0)
            Text(
              '${attempt.inputTokens + attempt.outputTokens} tok',
              style: context.t.labelSmall?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
            ),
        ],
      ),
    );
  }
}
