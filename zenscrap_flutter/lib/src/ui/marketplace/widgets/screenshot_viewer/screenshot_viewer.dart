import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

import 'clipboard_utils.dart';

/// A screenshot viewer widget that fills available space and provides
/// zoom controls and directional panning arrows on hover.
///
/// Uses ValueNotifier for hover state to prevent flickering caused by
/// parent widget rebuilds.
class ScreenshotViewer extends StatefulWidget {
  final ByteData screenshotData;
  final VoidCallback? onCopySuccess;
  final VoidCallback? onCopyError;

  const ScreenshotViewer({
    super.key,
    required this.screenshotData,
    this.onCopySuccess,
    this.onCopyError,
  });

  @override
  State<ScreenshotViewer> createState() => _ScreenshotViewerState();
}

class _ScreenshotViewerState extends State<ScreenshotViewer> {
  // Use ValueNotifier to avoid rebuilding the entire widget tree on hover changes
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  // Scroll controllers
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Zoom state
  final ValueNotifier<double> _zoomLevel = ValueNotifier(1.0);

  // Panning timer
  Timer? _panTimer;

  // Image state
  ui.Image? _decodedImage;
  Size? _imageSize;
  late Uint8List _imageBytes;
  bool _imageLoadError = false;

  // Scroll availability - using ValueNotifier to prevent full rebuilds
  final ValueNotifier<bool> _canScrollUp = ValueNotifier(false);
  final ValueNotifier<bool> _canScrollDown = ValueNotifier(false);
  final ValueNotifier<bool> _canScrollLeft = ValueNotifier(false);
  final ValueNotifier<bool> _canScrollRight = ValueNotifier(false);

  static const double _minZoom = 1.0;
  static const double _maxZoom = 5.0;
  static const double _zoomStep = 0.5;
  static const double _panSpeed = 8.0;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.screenshotData.buffer.asUint8List();
    _decodeImage();
    _horizontalScrollController.addListener(_updateScrollAvailability);
    _verticalScrollController.addListener(_updateScrollAvailability);
    _zoomLevel.addListener(_onZoomChanged);
  }

  @override
  void dispose() {
    // Cancel timer FIRST to prevent callbacks accessing disposed controllers
    _panTimer?.cancel();
    _panTimer = null;

    // Remove listeners BEFORE disposing their targets
    _zoomLevel.removeListener(_onZoomChanged);
    _horizontalScrollController.removeListener(_updateScrollAvailability);
    _verticalScrollController.removeListener(_updateScrollAvailability);

    // Dispose ValueNotifiers
    _isHovered.dispose();
    _zoomLevel.dispose();
    _canScrollUp.dispose();
    _canScrollDown.dispose();
    _canScrollLeft.dispose();
    _canScrollRight.dispose();

    // Dispose scroll controllers
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();

    // Dispose image resources
    _decodedImage?.dispose();
    super.dispose();
  }

  void _onZoomChanged() {
    // Schedule scroll availability update after the layout has been updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateScrollAvailability();
      }
    });
  }

  Future<void> _decodeImage() async {
    ui.Codec? codec;
    try {
      codec = await ui.instantiateImageCodec(_imageBytes);
      final frame = await codec.getNextFrame();

      // Validate image dimensions to prevent division by zero
      final width = frame.image.width.toDouble();
      final height = frame.image.height.toDouble();
      if (width <= 0 || height <= 0) {
        throw Exception('Invalid image dimensions: ${width}x$height');
      }

      if (mounted) {
        setState(() {
          _decodedImage = frame.image;
          _imageSize = Size(width, height);
        });
        // Schedule scroll availability update after layout
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateScrollAvailability();
          }
        });
      }
    } catch (e) {
      debugPrint('Error decoding image: $e');
      if (mounted) {
        setState(() {
          _imageLoadError = true;
        });
      }
    } finally {
      // Always dispose the codec to prevent memory leaks
      codec?.dispose();
    }
  }

  void _updateScrollAvailability() {
    if (!mounted) return;

    // Vertical scroll availability
    if (_verticalScrollController.hasClients &&
        _verticalScrollController.position.hasContentDimensions) {
      final maxScrollV = _verticalScrollController.position.maxScrollExtent;
      final currentScrollV = _verticalScrollController.offset;
      _canScrollUp.value = currentScrollV > 0.5;
      _canScrollDown.value = currentScrollV < maxScrollV - 0.5;
    } else {
      _canScrollUp.value = false;
      _canScrollDown.value = false;
    }

    // Horizontal scroll availability
    if (_horizontalScrollController.hasClients &&
        _horizontalScrollController.position.hasContentDimensions) {
      final maxScrollH = _horizontalScrollController.position.maxScrollExtent;
      final currentScrollH = _horizontalScrollController.offset;
      _canScrollLeft.value = currentScrollH > 0.5;
      _canScrollRight.value = currentScrollH < maxScrollH - 0.5;
    } else {
      _canScrollLeft.value = false;
      _canScrollRight.value = false;
    }
  }

  void _zoomIn() {
    final newZoom = (_zoomLevel.value + _zoomStep).clamp(_minZoom, _maxZoom);
    _zoomLevel.value = newZoom;
  }

  void _zoomOut() {
    final newZoom = (_zoomLevel.value - _zoomStep).clamp(_minZoom, _maxZoom);
    _zoomLevel.value = newZoom;
  }

  void _startPanning(_PanDirection direction) {
    _panTimer?.cancel();
    _panTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _pan(direction);
    });
  }

  void _stopPanning() {
    _panTimer?.cancel();
    _panTimer = null;
  }

  void _pan(_PanDirection direction) {
    if (!mounted) {
      _stopPanning();
      return;
    }

    switch (direction) {
      case _PanDirection.up:
        if (_verticalScrollController.hasClients &&
            _verticalScrollController.position.hasContentDimensions) {
          final newOffset = (_verticalScrollController.offset - _panSpeed)
              .clamp(0.0, _verticalScrollController.position.maxScrollExtent);
          _verticalScrollController.jumpTo(newOffset);
        }
      case _PanDirection.down:
        if (_verticalScrollController.hasClients &&
            _verticalScrollController.position.hasContentDimensions) {
          final newOffset = (_verticalScrollController.offset + _panSpeed)
              .clamp(0.0, _verticalScrollController.position.maxScrollExtent);
          _verticalScrollController.jumpTo(newOffset);
        }
      case _PanDirection.left:
        if (_horizontalScrollController.hasClients &&
            _horizontalScrollController.position.hasContentDimensions) {
          final newOffset = (_horizontalScrollController.offset - _panSpeed)
              .clamp(0.0, _horizontalScrollController.position.maxScrollExtent);
          _horizontalScrollController.jumpTo(newOffset);
        }
      case _PanDirection.right:
        if (_horizontalScrollController.hasClients &&
            _horizontalScrollController.position.hasContentDimensions) {
          final newOffset = (_horizontalScrollController.offset + _panSpeed)
              .clamp(0.0, _horizontalScrollController.position.maxScrollExtent);
          _horizontalScrollController.jumpTo(newOffset);
        }
    }
  }

  Future<void> _copyToClipboard() async {
    final success = await copyImageToClipboard(_imageBytes);
    // Check mounted after async operation to avoid calling callbacks on disposed widget
    if (!mounted) return;
    if (success) {
      widget.onCopySuccess?.call();
    } else {
      widget.onCopyError?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error state if image failed to load
    if (_imageLoadError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 48, color: context.c.outline),
            const SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(color: context.c.outline),
            ),
          ],
        ),
      );
    }

    // Show loading state while decoding
    if (_imageSize == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) {
        _isHovered.value = false;
        _stopPanning();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main scrollable image area
              ValueListenableBuilder<double>(
                valueListenable: _zoomLevel,
                builder: (context, zoom, _) {
                  return _buildScrollableImage(constraints, zoom);
                },
              ),

              // Hover controls overlay - uses ValueListenableBuilder to prevent rebuilds
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, isHovered, child) {
                  if (!isHovered) return const SizedBox.shrink();
                  return child!;
                },
                child: Stack(
                  children: [
                    // Top-right controls (copy, zoom)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _ControlsBar(
                        onCopy: _copyToClipboard,
                        onZoomIn: _zoomIn,
                        onZoomOut: _zoomOut,
                        zoomLevel: _zoomLevel,
                        minZoom: _minZoom,
                        maxZoom: _maxZoom,
                      ),
                    ),

                    // Directional arrows
                    _buildDirectionalArrows(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScrollableImage(BoxConstraints constraints, double zoom) {
    final viewportWidth = constraints.maxWidth;
    final viewportHeight = constraints.maxHeight;

    // Guard against zero dimensions
    if (viewportWidth <= 0 || viewportHeight <= 0) {
      return const SizedBox.shrink();
    }

    // Calculate image dimensions to fill space (cover fit)
    // _imageSize is guaranteed non-null and positive from _decodeImage validation
    final imageAspect = _imageSize!.width / _imageSize!.height;
    final viewportAspect = viewportWidth / viewportHeight;

    double displayWidth;
    double displayHeight;

    if (imageAspect > viewportAspect) {
      // Image is wider than viewport - fit to height and overflow width
      displayHeight = viewportHeight;
      displayWidth = viewportHeight * imageAspect;
    } else {
      // Image is taller than viewport - fit to width and overflow height
      displayWidth = viewportWidth;
      displayHeight = viewportWidth / imageAspect;
    }

    // Apply zoom
    displayWidth *= zoom;
    displayHeight *= zoom;

    return SingleChildScrollView(
      controller: _verticalScrollController,
      physics: const ClampingScrollPhysics(),
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Image.memory(
          _imageBytes,
          width: displayWidth,
          height: displayHeight,
          fit: BoxFit.fill,
          gaplessPlayback: true, // Prevents flicker when image updates
        ),
      ),
    );
  }

  Widget _buildDirectionalArrows() {
    return Stack(
      children: [
        // Up arrow
        Positioned(
          top: 8,
          left: 0,
          right: 0,
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _canScrollUp,
              builder: (context, canScroll, _) {
                if (!canScroll) return const SizedBox.shrink();
                return _DirectionalArrow(
                  direction: _PanDirection.up,
                  onHoverStart: () => _startPanning(_PanDirection.up),
                  onHoverEnd: _stopPanning,
                );
              },
            ),
          ),
        ),

        // Down arrow
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _canScrollDown,
              builder: (context, canScroll, _) {
                if (!canScroll) return const SizedBox.shrink();
                return _DirectionalArrow(
                  direction: _PanDirection.down,
                  onHoverStart: () => _startPanning(_PanDirection.down),
                  onHoverEnd: _stopPanning,
                );
              },
            ),
          ),
        ),

        // Left arrow
        Positioned(
          left: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _canScrollLeft,
              builder: (context, canScroll, _) {
                if (!canScroll) return const SizedBox.shrink();
                return _DirectionalArrow(
                  direction: _PanDirection.left,
                  onHoverStart: () => _startPanning(_PanDirection.left),
                  onHoverEnd: _stopPanning,
                );
              },
            ),
          ),
        ),

        // Right arrow
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _canScrollRight,
              builder: (context, canScroll, _) {
                if (!canScroll) return const SizedBox.shrink();
                return _DirectionalArrow(
                  direction: _PanDirection.right,
                  onHoverStart: () => _startPanning(_PanDirection.right),
                  onHoverEnd: _stopPanning,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

enum _PanDirection { up, down, left, right }

class _ControlsBar extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final ValueNotifier<double> zoomLevel;
  final double minZoom;
  final double maxZoom;

  const _ControlsBar({
    required this.onCopy,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.zoomLevel,
    required this.minZoom,
    required this.maxZoom,
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
          const SizedBox(width: 8),
          ValueListenableBuilder<double>(
            valueListenable: zoomLevel,
            builder: (context, zoom, _) {
              return IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: zoom > minZoom ? onZoomOut : null,
                tooltip: AppLocalizations.of(context)!.marketplace_decrease_font_size,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              );
            },
          ),
          const SizedBox(width: 4),
          ValueListenableBuilder<double>(
            valueListenable: zoomLevel,
            builder: (context, zoom, _) {
              return IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: zoom < maxZoom ? onZoomIn : null,
                tooltip: AppLocalizations.of(context)!.marketplace_increase_font_size,
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 150.ms);
  }
}

class _DirectionalArrow extends StatefulWidget {
  final _PanDirection direction;
  final VoidCallback onHoverStart;
  final VoidCallback onHoverEnd;

  const _DirectionalArrow({
    required this.direction,
    required this.onHoverStart,
    required this.onHoverEnd,
  });

  @override
  State<_DirectionalArrow> createState() => _DirectionalArrowState();
}

class _DirectionalArrowState extends State<_DirectionalArrow> {
  bool _isHovering = false;

  IconData get _icon {
    switch (widget.direction) {
      case _PanDirection.up:
        return Icons.keyboard_arrow_up;
      case _PanDirection.down:
        return Icons.keyboard_arrow_down;
      case _PanDirection.left:
        return Icons.keyboard_arrow_left;
      case _PanDirection.right:
        return Icons.keyboard_arrow_right;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        widget.onHoverStart();
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        widget.onHoverEnd();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isHovering
              ? context.c.primary.withAlpha(200)
              : context.c.surface.withAlpha(200),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _icon,
          size: 24,
          color: _isHovering ? context.c.onPrimary : context.c.onSurface,
        ),
      ),
    ).animate().fadeIn(duration: 150.ms);
  }
}
