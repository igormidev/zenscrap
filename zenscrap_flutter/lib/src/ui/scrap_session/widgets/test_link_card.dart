import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestLinkCard extends StatefulWidget {
  final String testLink;
  const TestLinkCard({super.key, required this.testLink});

  @override
  State<TestLinkCard> createState() => _TestLinkCardState();
}

class _TestLinkCardState extends State<TestLinkCard> {
  bool _isHovered = false;

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.testLink));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Tooltip(
      message: 'This is the reference link used to test\n'
          'the scrapper that you are creating with AI',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.testLink,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isHovered) ...[
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: color,
                  ),
                  onPressed: _copyToClipboard,
                  tooltip: 'Copy link',
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
