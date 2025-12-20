import 'dart:convert';

import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/string_extension.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/elements/animated_switch.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum ResponseTab { result, html, screenshot }

class ExampleResponseDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;

  const ExampleResponseDialog({
    super.key,
    required this.scrappable,
  });

  @override
  ConsumerState<ExampleResponseDialog> createState() =>
      _ExampleResponseDialogState();
}

class _ExampleResponseDialogState extends ConsumerState<ExampleResponseDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _resultFontSize = 14.0;
  double _htmlFontSize = 14.0;
  bool _isResultHovered = false;
  bool _isHtmlHovered = false;
  bool _isScreenshotHovered = false;

  // Lazy loading states
  ByteData? _htmlData;
  ByteData? _screenshotData;
  bool _isLoadingHtml = false;
  bool _isLoadingScreenshot = false;
  bool _hasTriedLoadingHtml = false;
  bool _hasTriedLoadingScreenshot = false;

  // Toast state
  bool _showToast = false;
  String _toastMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFontSizes();

    // Listen to tab changes to trigger lazy loading
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final currentTab = ResponseTab.values[_tabController.index];

    if (currentTab == ResponseTab.html && !_hasTriedLoadingHtml) {
      _loadHtmlData();
    } else if (currentTab == ResponseTab.screenshot &&
        !_hasTriedLoadingScreenshot) {
      _loadScreenshotData();
    }
  }

  void _loadFontSizes() {
    final prefs = ref.read(sharedPreferencesProvider);
    setState(() {
      _resultFontSize = prefs.getDouble('example_response_result_font') ?? 14.0;
      _htmlFontSize = prefs.getDouble('example_response_html_font') ?? 14.0;
    });
  }

  Future<void> _saveFontSize(String key, double size) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setDouble(key, size);
  }

  void _showToastMessage(String message) {
    setState(() {
      _showToast = true;
      _toastMessage = message;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  Future<void> _loadHtmlData() async {
    if (_isLoadingHtml || _hasTriedLoadingHtml) return;

    setState(() {
      _isLoadingHtml = true;
      _hasTriedLoadingHtml = true;
    });

    try {
      final client = ref.read(clientProvider);
      final language = ref.read(currentLanguageProvider);
      final byteData = await client.publicScrappable.getByteTestData(
        widget.scrappable.id!,
        language: language,
      );

      if (byteData?.referenceHtmlPage != null) {
        setState(() {
          _htmlData = byteData!.referenceHtmlPage;
        });
      }
    } catch (e) {
      debugPrint('Error loading HTML data: $e');
    } finally {
      setState(() {
        _isLoadingHtml = false;
      });
    }
  }

  Future<void> _loadScreenshotData() async {
    if (_isLoadingScreenshot || _hasTriedLoadingScreenshot) return;

    setState(() {
      _isLoadingScreenshot = true;
      _hasTriedLoadingScreenshot = true;
    });

    try {
      final client = ref.read(clientProvider);
      final language = ref.read(currentLanguageProvider);
      final byteData = await client.publicScrappable.getByteTestData(
        widget.scrappable.id!,
        language: language,
      );

      if (byteData?.referenceSiteScreenshot != null) {
        setState(() {
          _screenshotData = byteData!.referenceSiteScreenshot;
        });
      }
    } catch (e) {
      debugPrint('Error loading screenshot data: $e');
    } finally {
      setState(() {
        _isLoadingScreenshot = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final contentHeight = context.responsiveValue(
      compact: screenHeight * 0.7,
      medium: screenHeight * 0.6,
      expanded: screenHeight * 0.6 + 92,
    );

    return Stack(
      children: [
        AlertDialog(
          title: Text(AppLocalizations.of(context)!.marketplace_example_response),
          insetPadding: EdgeInsets.symmetric(
            vertical: context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 20.0,
            ),
            horizontal: context.responsiveValue(
              compact: 16.0,
              medium: 40.0,
              expanded: 40.0,
            ),
          ),
          titlePadding: EdgeInsets.only(
            left: context.responsiveValue(
              compact: 16.0,
              medium: 24.0,
              expanded: 24.0,
            ),
            right: context.responsiveValue(
              compact: 16.0,
              medium: 24.0,
              expanded: 24.0,
            ),
            top: context.responsiveValue(
              compact: 20.0,
              medium: 24.0,
              expanded: 24.0,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: contentHeight,
              maxWidth: context.responsiveValue(
                compact: double.infinity,
                medium: 500.0,
                expanded: 600.0,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsiveValue(
                        compact: 16.0,
                        medium: 24.0,
                        expanded: 24.0,
                      ),
                    ),
                    child: ReferenceLinkWidget(widget: widget),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsiveValue(
                        compact: 16.0,
                        medium: 24.0,
                        expanded: 24.0,
                      ),
                    ),
                    child: ZenAnimatedSwitch(
                      tabController: _tabController,
                      tabs: [
                        AnimatedSwitchItem(AppLocalizations.of(context)!.marketplace_tab_result, fontSize: 16),
                        AnimatedSwitchItem(AppLocalizations.of(context)!.marketplace_tab_html, fontSize: 16),
                        AnimatedSwitchItem(AppLocalizations.of(context)!.marketplace_tab_screenshot, fontSize: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: context.responsiveValue(
                              compact: 16.0,
                              medium: 24.0,
                              expanded: 24.0,
                            ),
                            right: context.responsiveValue(
                              compact: 16.0,
                              medium: 24.0,
                              expanded: 24.0,
                            ),
                          ),
                          child: _ResultTab(
                            scrappable: widget.scrappable,
                            fontSize: _resultFontSize,
                            isHovered: _isResultHovered,
                            onHoverChanged: (value) =>
                                setState(() => _isResultHovered = value),
                            onCopy: () {
                              final decodedJson = tryDecode(widget
                                  .scrappable.referenceTestData?.scrapResultJson);
                              if (decodedJson != null) {
                                final jsonString =
                                    const JsonEncoder.withIndent('  ')
                                        .convert(decodedJson);
                                Clipboard.setData(
                                    ClipboardData(text: jsonString));
                                _showToastMessage(AppLocalizations.of(context)!.marketplace_result_copied);
                              }
                            },
                            onIncreaseFontSize: () {
                              setState(() {
                                _resultFontSize =
                                    (_resultFontSize + 2).clamp(10, 24);
                                _saveFontSize('example_response_result_font',
                                    _resultFontSize);
                              });
                            },
                            onDecreaseFontSize: () {
                              setState(() {
                                _resultFontSize =
                                    (_resultFontSize - 2).clamp(10, 24);
                                _saveFontSize('example_response_result_font',
                                    _resultFontSize);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: context.responsiveValue(
                              compact: 8.0,
                              medium: 8.0,
                              expanded: 8.0,
                            ),
                            right: context.responsiveValue(
                              compact: 8.0,
                              medium: 8.0,
                              expanded: 8.0,
                            ),
                          ),
                          child: _HtmlTab(
                            htmlData: _htmlData,
                            isLoading: _isLoadingHtml,
                            fontSize: _htmlFontSize,
                            isHovered: _isHtmlHovered,
                            onHoverChanged: (value) =>
                                setState(() => _isHtmlHovered = value),
                            onCopy: () {
                              if (_htmlData != null) {
                                final htmlString =
                                    utf8.decode(_htmlData!.buffer.asUint8List());
                                Clipboard.setData(
                                    ClipboardData(text: htmlString));
                                _showToastMessage(AppLocalizations.of(context)!.marketplace_html_copied);
                              }
                            },
                            onIncreaseFontSize: () {
                              setState(() {
                                _htmlFontSize = (_htmlFontSize + 2).clamp(10, 24);
                                _saveFontSize(
                                    'example_response_html_font', _htmlFontSize);
                              });
                            },
                            onDecreaseFontSize: () {
                              setState(() {
                                _htmlFontSize = (_htmlFontSize - 2).clamp(10, 24);
                                _saveFontSize(
                                    'example_response_html_font', _htmlFontSize);
                              });
                            },
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: _ScreenshotTab(
                            screenshotData: _screenshotData,
                            isLoading: _isLoadingScreenshot,
                            isHovered: _isScreenshotHovered,
                            onHoverChanged: (value) =>
                                setState(() => _isScreenshotHovered = value),
                            onCopy: () {
                              _showToastMessage(AppLocalizations.of(context)!.marketplace_screenshot_info_copied);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showToast)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(77),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: context.c.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _toastMessage,
                      style: context.t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 200.ms)
                  .scale(begin: const Offset(0.8, 0.8))
                  .then(delay: 1600.ms)
                  .fadeOut(duration: 200.ms),
            ),
          ),
      ],
    );
  }
}

class ReferenceLinkWidget extends StatefulWidget {
  const ReferenceLinkWidget({
    super.key,
    required this.widget,
  });

  final ExampleResponseDialog widget;

  @override
  State<ReferenceLinkWidget> createState() => _ReferenceLinkWidgetState();
}

class _ReferenceLinkWidgetState extends State<ReferenceLinkWidget> {
  bool _isHovered = false;

  String get _url =>
      widget.widget.scrappable.referenceTestData?.referenceLinkUsed ?? '';

  void _copyToClipboard() {
    if (_url.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _url));
    }
  }

  void _openUrl() {
    if (_url.isNotEmpty) {
      launchUrlString(_url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surfaceContainerHighest.withAlpha(77),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.c.outline.withAlpha(51),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BabelSelectableText(
                    AppLocalizations.of(context)!.marketplace_reference_url,
                    style: context.t.titleSmall
                        ?.copyWith(color: context.c.primary),
                  ),
                  BabelSelectableText(
                    _url.shortUrl,
                    // underline
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.outline,
                    ),
                  ),
                ],
              ),
              if (_isHovered)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.c.surface.withAlpha(230),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.open_in_new, size: 16),
                            onPressed: _openUrl,
                            tooltip: AppLocalizations.of(context)!.marketplace_open_url,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: _copyToClipboard,
                            tooltip: AppLocalizations.of(context)!.marketplace_copy_url,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 150.ms),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultTab extends StatelessWidget {
  final Scrappable scrappable;
  final double fontSize;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onCopy;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const _ResultTab({
    required this.scrappable,
    required this.fontSize,
    required this.isHovered,
    required this.onHoverChanged,
    required this.onCopy,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final String? result = scrappable.referenceTestData?.scrapResultJson;
    final decodedJson = tryDecode(result);

    if (result == null || result.isEmpty || decodedJson == null) {
      return _EmptyStateWidget(message: AppLocalizations.of(context)!.marketplace_no_example_response);
    }

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(decodedJson),
              style: context.t.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontSize: fontSize,
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
  final bool isLoading;
  final double fontSize;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onCopy;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;

  const _HtmlTab({
    required this.htmlData,
    required this.isLoading,
    required this.fontSize,
    required this.isHovered,
    required this.onHoverChanged,
    required this.onCopy,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (htmlData == null) {
      return _EmptyStateWidget(message: AppLocalizations.of(context)!.marketplace_no_html_content);
    }

    final htmlString = utf8.decode(htmlData!.buffer.asUint8List());

    if (htmlString.isEmpty) {
      return _EmptyStateWidget(message: AppLocalizations.of(context)!.marketplace_no_html_content);
    }

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
                color: context.c.onSurface,
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
  final bool isLoading;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onCopy;

  const _ScreenshotTab({
    required this.screenshotData,
    required this.isLoading,
    required this.isHovered,
    required this.onHoverChanged,
    required this.onCopy,
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
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.screenshotData == null) {
      return _EmptyStateWidget(message: AppLocalizations.of(context)!.marketplace_no_screenshot);
    }

    return MouseRegion(
      onEnter: (_) => widget.onHoverChanged(true),
      onExit: (_) => widget.onHoverChanged(false),
      child: Stack(
        children: [
          InteractiveViewer(
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
          ),
          if (widget.isHovered)
            Positioned(
              top: 8,
              right: 8,
              child: _ScreenshotControls(
                onCopy: widget.onCopy,
              ),
            ),
        ],
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
            color: Colors.black.withAlpha(26),
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
            tooltip: AppLocalizations.of(context)!.marketplace_copy,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: onIncreaseFontSize,
            tooltip: AppLocalizations.of(context)!.marketplace_increase_font_size,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: onDecreaseFontSize,
            tooltip: AppLocalizations.of(context)!.marketplace_decrease_font_size,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _ScreenshotControls extends StatelessWidget {
  final VoidCallback onCopy;

  const _ScreenshotControls({
    required this.onCopy,
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
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.copy, size: 18),
        onPressed: onCopy,
        tooltip: AppLocalizations.of(context)!.marketplace_copy,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
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
