import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ApiKeyCard extends StatefulWidget {
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
  State<ApiKeyCard> createState() => _ApiKeyCardState();
}

class _ApiKeyCardState extends State<ApiKeyCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

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
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final isActive = widget.apiKey.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? context.c.surfaceContainerHighest.withAlpha(50)
              : context.c.surface,
          borderRadius: BorderRadius.circular(12),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? context.c.primary.withAlpha(20)
                        : context.c.error.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.vpn_key,
                    color: isActive ? context.c.primary : context.c.error,
                    size: 20,
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.c.error.withAlpha(20),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'INACTIVE',
                                style: context.t.labelSmall?.copyWith(
                                  color: context.c.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created ${dateFormatter.format(widget.apiKey.createdAt)}',
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: context.c.onSurface.withAlpha(150),
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatChip(
                  context,
                  Icons.analytics,
                  '${widget.usageCount} requests',
                  'Last 30 days',
                  context.c.primary,
                ),
                const SizedBox(width: 12),
                if (isActive && widget.canDelete)
                  _buildActionButton(
                    context,
                    Icons.delete_outline,
                    'Deactivate',
                    context.c.error,
                    widget.onDelete,
                  ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.c.surfaceContainerHighest.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.outline.withAlpha(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Key',
                      style: context.t.labelMedium?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            _maskApiKey(widget.apiKey.apiKey),
                            style: context.t.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.copy,
                            size: 18,
                            color: context.c.primary,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.apiKey.apiKey),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('API key copied to clipboard'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          tooltip: 'Copy API Key',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use this key in your API requests for authentication',
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface.withAlpha(100),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.t.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: context.t.labelMedium?.copyWith(color: color),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withAlpha(50)),
        ),
      ),
    );
  }
}
