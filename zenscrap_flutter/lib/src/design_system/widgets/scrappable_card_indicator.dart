import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/scraper_category_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ScrappableCardIndicator extends StatelessWidget {
  final bool isNew;
  final Scrappable scrappable;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  const ScrappableCardIndicator({
    super.key,
    required this.scrappable,
    this.isNew = false,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = scrappable.targetRequest?.url != null;
    final url = scrappable.targetRequest?.url ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.outline.withAlpha(51),
            width: 1,
          ),
          color: context.c.surfaceContainerLowest.withAlpha(100),
          // color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.c.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    scrappable.category.icon,
                    color: context.c.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              scrappable.name,
                              style: context.t.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.c.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onEdit != null) ...[
                            InkWell(
                              onTap: onEdit,
                              hoverColor: context.c.primaryContainer,
                              child: Icon(
                                Icons.edit,
                                size: 26,
                                color: context.c.primary,
                              ),
                            ),
                            SizedBox(width: 4),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scrappable.description,
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasUrl) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.c.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.outline.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      size: 16,
                      color: context.c.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        url,
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.primary,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.c.primaryContainer.withAlpha(51),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: context.c.primary.withAlpha(51),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        scrappable.category.icon,
                        size: 14,
                        color: context.c.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        scrappable.category.displayName,
                        style: context.t.labelSmall?.copyWith(
                          color: context.c.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: !isNew
                        ? Colors.green.withAlpha(26)
                        : Colors.orange.withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: !isNew
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isNew
                            ? 'This endpoint will be active and attached to your account after you sign In'
                            : 'Active',
                        style: context.t.labelSmall?.copyWith(
                          color: !isNew
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Created ${_formatDate(scrappable.createdAt)}',
                  style: context.t.labelSmall?.copyWith(
                    color: context.c.onSurfaceVariant.withAlpha(179),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
