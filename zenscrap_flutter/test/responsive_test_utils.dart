import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Standard device sizes for responsive testing
class TestDeviceSizes {
  static const Size smallPhone = Size(320, 568);
  static const Size phone = Size(375, 812);
  static const Size largePhone = Size(428, 926);
  static const Size tabletPortrait = Size(600, 1024);
  static const Size tabletLandscape = Size(900, 600);
  static const Size desktop = Size(1200, 800);
  static const Size wideDesktop = Size(1600, 900);

  static const List<Size> all = [
    smallPhone,
    phone,
    largePhone,
    tabletPortrait,
    tabletLandscape,
    desktop,
    wideDesktop,
  ];

  static const List<Size> breakpointEdges = [
    Size(599, 800), // Just before medium
    Size(600, 800), // Medium start
    Size(839, 800), // Just before expanded
    Size(840, 800), // Expanded start
  ];

  /// Returns a human-readable name for the given size
  static String nameFor(Size size) {
    if (size == smallPhone) return 'Small Phone (320x568)';
    if (size == phone) return 'Phone (375x812)';
    if (size == largePhone) return 'Large Phone (428x926)';
    if (size == tabletPortrait) return 'Tablet Portrait (600x1024)';
    if (size == tabletLandscape) return 'Tablet Landscape (900x600)';
    if (size == desktop) return 'Desktop (1200x800)';
    if (size == wideDesktop) return 'Wide Desktop (1600x900)';
    return '${size.width.toInt()}x${size.height.toInt()}';
  }
}

/// Extension on WidgetTester for responsive testing
extension ResponsiveTester on WidgetTester {
  /// Sets the test surface size
  Future<void> setScreenSize(Size size) async {
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  }

  /// Tests a widget across multiple screen sizes
  Future<void> pumpWidgetForSizes(
    Widget widget,
    List<Size> sizes,
    Future<void> Function(Size size) testCallback,
  ) async {
    for (final size in sizes) {
      await setScreenSize(size);
      await pumpWidget(widget);
      await testCallback(size);
    }
  }
}

/// Wrapper for testing responsive widgets with proper Material context
Widget responsiveTestWrapper(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

/// Captures overflow errors for testing
class OverflowErrorCapture {
  final List<FlutterErrorDetails> _overflowErrors = [];
  void Function(FlutterErrorDetails)? _originalHandler;

  /// Start capturing overflow errors
  void start() {
    _overflowErrors.clear();
    _originalHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed') ||
          details.toString().contains('RenderFlex')) {
        _overflowErrors.add(details);
      } else {
        _originalHandler?.call(details);
      }
    };
  }

  /// Stop capturing and restore original handler
  void stop() {
    FlutterError.onError = _originalHandler;
  }

  /// Clear captured errors
  void clear() {
    _overflowErrors.clear();
  }

  /// Check if any overflow errors were captured
  bool get hasOverflow => _overflowErrors.isNotEmpty;

  /// Get all captured overflow errors
  List<FlutterErrorDetails> get errors => List.unmodifiable(_overflowErrors);

  /// Get error messages as strings
  List<String> get errorMessages =>
      _overflowErrors.map((e) => e.toString()).toList();
}
