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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLowest,
        border: Border.all(color: context.c.outline.withAlpha(80), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _JsonTab(
                      testResponse: widget.testResponse,
                      isHovered: _isJsonHovered,
                      fontSize: _jsonFontSize,
                      onHoverChanged: (value) =>
                          setState(() => _isJsonHovered = value),
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
                    _HtmlTab(
                      htmlData: widget.htmlData,
                      isHovered: _isHtmlHovered,
                      fontSize: _htmlFontSize,
                      onHoverChanged: (value) =>
                          setState(() => _isHtmlHovered = value),
                      onCopy: () {
                        if (widget.htmlData != null) {
                          final htmlString = utf8
                              .decode(widget.htmlData!.buffer.asUint8List());
                          _copyToClipboard(htmlString);
                        }
                      },
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
                    _ScreenshotTab(
                      screenshotData: widget.screenshotData,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonTab extends StatelessWidget {
  final Map<String, dynamic>? testResponse;
  final bool isHovered;
  final double fontSize;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onCopy;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const _JsonTab({
    required this.testResponse,
    required this.isHovered,
    required this.fontSize,
    required this.onHoverChanged,
    required this.onCopy,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (testResponse == null || testResponse!.isEmpty) {
      return const _EmptyStateWidget(message: 'No JSON response available');
    }

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(testResponse),
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'monospace',
                color: context.c.outline,
              ),
            ),
          ),
          if (isHovered)
            Positioned(
              top: 8,
              right: 8,
              child: _HoverControls(
                onCopy: onCopy,
                onIncreaseFontSize: onIncreaseFontSize,
                onDecreaseFontSize: onDecreaseFontSize,
              ),
            ),
        ],
      ),
    );
  }
}

class _HtmlTab extends StatelessWidget {
  final ByteData? htmlData;
  final bool isHovered;
  final double fontSize;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onCopy;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const _HtmlTab({
    required this.htmlData,
    required this.isHovered,
    required this.fontSize,
    required this.onHoverChanged,
    required this.onCopy,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (htmlData == null) {
      return const _EmptyStateWidget(message: 'No HTML content available');
    }

    final htmlString = utf8.decode(htmlData!.buffer.asUint8List());

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              htmlString,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'monospace',
                color: context.c.outline,
              ),
            ),
          ),
          if (isHovered)
            Positioned(
              top: 8,
              right: 8,
              child: _HoverControls(
                onCopy: onCopy,
                onIncreaseFontSize: onIncreaseFontSize,
                onDecreaseFontSize: onDecreaseFontSize,
              ),
            ),
        ],
      ),
    );
  }
}

class _ScreenshotTab extends StatefulWidget {
  final ByteData? screenshotData;

  const _ScreenshotTab({
    required this.screenshotData,
  });

  @override
  State<_ScreenshotTab> createState() => _ScreenshotTabState();
}

class _ScreenshotTabState extends State<_ScreenshotTab> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screenshotData == null) {
      return const _EmptyStateWidget(message: 'No screenshot available');
    }

    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      panEnabled: true,
      scaleEnabled: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Image.memory(
          widget.screenshotData!.buffer.asUint8List(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _HoverControls extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const _HoverControls({
    required this.onCopy,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _EmptyStateWidget extends StatelessWidget {
  final String message;

  const _EmptyStateWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
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
}
