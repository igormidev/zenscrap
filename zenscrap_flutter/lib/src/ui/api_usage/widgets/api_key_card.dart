import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';

class ApiKeyCard extends ConsumerStatefulWidget {
  final AccountApiKey apiKey;
  final int usageCount;
  final bool canDelete;
  final VoidCallback onDelete;

  const ApiKeyCard({
    super.key,
    required this.apiKey,
    required this.usageCount,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  ConsumerState<ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends ConsumerState<ApiKeyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final isActive = widget.apiKey.isActive;

    final cardPadding = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 8.0,
      medium: 12.0,
      expanded: 12.0,
    );
    final iconContainerPadding = context.responsiveValue(
      compact: 6.0,
      medium: 8.0,
      expanded: 8.0,
    );
    final iconSize = context.responsiveValue(
      compact: 18.0,
      medium: 20.0,
      expanded: 20.0,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: _isHovered
              ? context.c.surfaceContainerHighest.withAlpha(50)
              : context.c.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isActive
                ? (_isHovered
                    ? context.c.primary
                    : context.c.outline.withAlpha(100))
                : context.c.error.withAlpha(100),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: context.c.primary.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(iconContainerPadding),
                  decoration: BoxDecoration(
                    color: isActive
                        ? context.c.primary.withAlpha(20)
                        : context.c.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(borderRadius * 0.67),
                  ),
                  child: Icon(
                    Icons.vpn_key,
                    color: isActive ? context.c.primary : context.c.error,
                    size: iconSize,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.apiKey.name,
                              style: context.t.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isActive)
                            Flexible(
                              flex: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.c.error.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  l10n.api_usage_inactive,
                                  style: context.t.labelSmall?.copyWith(
                                    color: context.c.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.api_usage_created_date(dateFormatter.format(widget.apiKey.createdAt)),
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive && widget.canDelete)
                  IconButton(
                    tooltip: l10n.api_usage_deactivate_api_key,
                    icon: Icon(
                      Icons.delete,
                      color: context.c.error,
                    ),
                    onPressed: widget.onDelete,
                  ),
              ],
            ),
            SizedBox(height: cardPadding * 0.75),
            // Use Column layout on compact to prevent overflow
            if (context.windowSizeClass == WindowSizeClass.compact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatChip(
                    icon: Icons.analytics,
                    value: l10n.api_usage_requests_count(widget.usageCount),
                    label: l10n.api_usage_last_30_days,
                    color: context.c.primary,
                  ),
                  const SizedBox(height: 8),
                  _ApiKeyContainer(
                    apiKey: widget.apiKey,
                    borderRadius: borderRadius,
                    onCopy: () {
                      ref
                          .read(analyticsServiceProvider)
                          .trackApiUsageCopyApiKeyCard(
                            keyId: widget.apiKey.id!,
                            keyName: widget.apiKey.name,
                          );
                      Clipboard.setData(
                        ClipboardData(text: widget.apiKey.apiKey),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.api_usage_api_key_copied),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Row(
                children: [
                  _StatChip(
                    icon: Icons.analytics,
                    value: l10n.api_usage_requests_count(widget.usageCount),
                    label: l10n.api_usage_last_30_days,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ApiKeyContainer(
                      apiKey: widget.apiKey,
                      borderRadius: borderRadius,
                      onCopy: () {
                        ref
                            .read(analyticsServiceProvider)
                            .trackApiUsageCopyApiKeyCard(
                              keyId: widget.apiKey.id!,
                              keyName: widget.apiKey.name,
                            );
                        Clipboard.setData(
                          ClipboardData(text: widget.apiKey.apiKey),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.api_usage_api_key_copied),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ApiKeyContainer extends StatelessWidget {
  final AccountApiKey apiKey;
  final double borderRadius;
  final VoidCallback onCopy;

  const _ApiKeyContainer({
    required this.apiKey,
    required this.borderRadius,
    required this.onCopy,
  });

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 20) {
      return apiKey;
    }
    final prefix = apiKey.substring(0, 10);
    final suffix = apiKey.substring(apiKey.length - 10);
    return '$prefix...$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCompact = context.windowSizeClass == WindowSizeClass.compact;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 16,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(30),
        borderRadius: BorderRadius.circular(borderRadius * 0.67),
        border: Border.all(
          color: context.c.outline.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.api_usage_api_key_label,
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.onSurface.withAlpha(150),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SelectableText(
                  _maskApiKey(apiKey.apiKey),
                  style: context.t.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: isCompact ? 10 : 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 18,
              color: context.c.primary,
            ),
            onPressed: onCopy,
            tooltip: l10n.api_usage_copy_api_key,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = context.windowSizeClass == WindowSizeClass.compact;
    final horizontalPadding = isCompact ? 8.0 : 12.0;
    final iconSize = isCompact ? 18.0 : 22.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          SizedBox(width: isCompact ? 4 : 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.t.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: isCompact ? 11 : null,
                ),
              ),
              if (!isCompact)
                Text(
                  label,
                  style: context.t.labelSmall?.copyWith(
                    color: color.withAlpha(150),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
