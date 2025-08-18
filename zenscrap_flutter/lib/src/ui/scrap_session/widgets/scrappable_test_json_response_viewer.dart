import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

class ScrappableTestJsonResponseViewer extends StatefulWidget {
  final Map<String, dynamic>? testResponse;
  final ByteData? htmlData;
  final ByteData? screenshotData;

  const ScrappableTestJsonResponseViewer({
    super.key,
    required this.testResponse,
    this.htmlData,
    this.screenshotData,
  });

  @override
  State<ScrappableTestJsonResponseViewer> createState() =>
      _ScrappableTestJsonResponseViewerState();
}

class _ScrappableTestJsonResponseViewerState
    extends State<ScrappableTestJsonResponseViewer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isJsonHovered = false;
  bool _isHtmlHovered = false;
  double _jsonFontSize = 14.0;
  double _htmlFontSize = 14.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildHoverControls({
    required VoidCallback onCopy,
    required VoidCallback onIncreaseFontSize,
    required VoidCallback onDecreaseFontSize,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            onPressed: onCopy,
            tooltip: 'Copy',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: onIncreaseFontSize,
            tooltip: 'Increase font size',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: onDecreaseFontSize,
            tooltip: 'Decrease font size',
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LottieBuilder.network(
              'https://lottie.host/3c4defca-fca7-4045-a13e-2a92f5f397fe/5G9WkNELtD.lottie',
              decoder: customDecoder,
              height: 260,
              width: 260,
              fit: BoxFit.contain,
            ),
          ).animate().fadeIn(delay: 500.ms),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildJsonTab() {
    if (widget.testResponse == null || widget.testResponse!.isEmpty) {
      return _buildEmptyState('No JSON response available');
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isJsonHovered = true),
      onExit: (_) => setState(() => _isJsonHovered = false),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              JsonEncoder.withIndent('  ').convert(widget.testResponse),
              style: context.t.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: context.c.outline,
                height: 1.3,
                fontSize: _jsonFontSize,
              ),
            ),
          ),
          if (_isJsonHovered)
            Positioned(
              top: 8,
              right: 8,
              child: _buildHoverControls(
                onCopy: () {
                  final jsonString = const JsonEncoder.withIndent('  ')
                      .convert(widget.testResponse);
                  _copyToClipboard(jsonString);
                },
                onIncreaseFontSize: () {
                  setState(() {
                    _jsonFontSize = (_jsonFontSize + 2).clamp(10, 24);
                  });
                },
                onDecreaseFontSize: () {
                  setState(() {
                    _jsonFontSize = (_jsonFontSize - 2).clamp(10, 24);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHtmlTab() {
    if (widget.htmlData == null) {
      return _buildEmptyState('No HTML content available');
    }

    final htmlString = utf8.decode(widget.htmlData!.buffer.asUint8List());

    return MouseRegion(
      onEnter: (_) => setState(() => _isHtmlHovered = true),
      onExit: (_) => setState(() => _isHtmlHovered = false),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              htmlString,
              style: TextStyle(
                fontSize: _htmlFontSize,
                fontFamily: 'monospace',
                color: context.c.outline,
              ),
            ),
          ),
          if (_isHtmlHovered)
            Positioned(
              top: 8,
              right: 8,
              child: _buildHoverControls(
                onCopy: () => _copyToClipboard(htmlString),
                onIncreaseFontSize: () {
                  setState(() {
                    _htmlFontSize = (_htmlFontSize + 2).clamp(10, 24);
                  });
                },
                onDecreaseFontSize: () {
                  setState(() {
                    _htmlFontSize = (_htmlFontSize - 2).clamp(10, 24);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScreenshotTab() {
    if (widget.screenshotData == null) {
      return _buildEmptyState('No screenshot available');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Image.memory(
          widget.screenshotData!.buffer.asUint8List(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLowest,
        border: Border.all(color: context.c.outline.withAlpha(80), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.c.surfaceContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: context.c.primary,
              unselectedLabelColor: context.c.onSurfaceVariant,
              indicatorColor: context.c.primary,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'JSON'),
                Tab(text: 'HTML'),
                Tab(text: 'Screenshot'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJsonTab(),
                _buildHtmlTab(),
                _buildScreenshotTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
