import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';

/// Standard device sizes for responsive testing
/// Based on RESPONSIVE_ARCHITECTURE.md Section 8
class TestDeviceSizes {
  /// iPhone SE, small Android phones (320x568)
  static const Size smallPhone = Size(320, 568);

  /// iPhone X/11/12/13/14 (375x812)
  static const Size phone = Size(375, 812);

  /// iPhone 14 Pro Max (428x926)
  static const Size largePhone = Size(428, 926);

  /// Medium breakpoint start - tablets portrait (600x1024)
  static const Size tabletPortrait = Size(600, 1024);

  /// Large tablet landscape (900x600)
  static const Size tabletLandscape = Size(900, 600);

  /// Desktop (1200x800)
  static const Size desktop = Size(1200, 800);

  /// Wide desktop monitors (1600x900)
  static const Size wideDesktop = Size(1600, 900);

  /// All standard sizes for iteration
  static const List<Size> all = [
    smallPhone,
    phone,
    largePhone,
    tabletPortrait,
    tabletLandscape,
    desktop,
    wideDesktop,
  ];

  /// Compact screen sizes (< 600dp width)
  static const List<Size> compactSizes = [smallPhone, phone, largePhone];

  /// Medium screen sizes (600-839dp width)
  static const List<Size> mediumSizes = [tabletPortrait];

  /// Expanded screen sizes (>= 840dp width)
  static const List<Size> expandedSizes = [
    tabletLandscape,
    desktop,
    wideDesktop,
  ];

  /// Breakpoint edge cases - critical for testing layout switching
  static const List<Size> breakpointEdges = [
    Size(599, 800), // Just before medium breakpoint
    Size(600, 800), // Exactly at medium breakpoint start
    Size(839, 800), // Just before expanded breakpoint
    Size(840, 800), // Exactly at expanded breakpoint start
    Size(1199, 800), // Just before large breakpoint
    Size(1200, 800), // Exactly at large breakpoint start
  ];

  /// Names for test output
  static String nameFor(Size size) {
    return switch (size) {
      smallPhone => 'smallPhone (320x568)',
      phone => 'phone (375x812)',
      largePhone => 'largePhone (428x926)',
      tabletPortrait => 'tabletPortrait (600x1024)',
      tabletLandscape => 'tabletLandscape (900x600)',
      desktop => 'desktop (1200x800)',
      wideDesktop => 'wideDesktop (1600x900)',
      Size(width: 599) => 'edge_before_medium (599x800)',
      Size(width: 600, height: 800) => 'edge_at_medium (600x800)',
      Size(width: 839) => 'edge_before_expanded (839x800)',
      Size(width: 840) => 'edge_at_expanded (840x800)',
      Size(width: 1199) => 'edge_before_large (1199x800)',
      Size(width: 1200) => 'edge_at_large (1200x800)',
      _ => 'custom (${size.width.toInt()}x${size.height.toInt()})',
    };
  }

  TestDeviceSizes._();
}

/// Extension on WidgetTester for responsive testing utilities
extension ResponsiveTester on WidgetTester {
  /// Sets the test surface size for responsive testing
  ///
  /// This properly configures both the binding surface size and the view
  /// physical size to simulate different device sizes.
  Future<void> setScreenSize(Size size) async {
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
  }

  /// Sets screen size and pumps the widget, then settles
  Future<void> pumpAtSize(Widget widget, Size size) async {
    await setScreenSize(size);
    await pumpWidget(widget);
    await pumpAndSettle(const Duration(milliseconds: 100));
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
      await pumpAndSettle(const Duration(milliseconds: 100));
      await testCallback(size);
    }
  }
}

/// Setup mock SharedPreferences for testing
/// Must be called before tests that use widgets with providers
Future<SharedPreferences> setupMockSharedPreferences([
  Map<String, Object>? values,
]) async {
  SharedPreferences.setMockInitialValues(values ?? {});
  return SharedPreferences.getInstance();
}

/// Wrapper for testing responsive widgets with proper Material context
/// and all required providers and localizations
///
/// Note: Call setupMockSharedPreferences() before using this wrapper
/// if the widget uses SharedPreferences-dependent providers.
Widget responsiveTestWrapper(
  Widget child, {
  Locale locale = const Locale('en'),
  SharedPreferences? sharedPreferences,
}) {
  return ProviderScope(
    overrides: [
      if (sharedPreferences != null)
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: Scaffold(body: child),
    ),
  );
}

/// Wrapper for testing full-page widgets (like LandingPage that has its own Scaffold)
Widget fullPageTestWrapper(
  Widget child, {
  Locale locale = const Locale('en'),
  SharedPreferences? sharedPreferences,
}) {
  return ProviderScope(
    overrides: [
      if (sharedPreferences != null)
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: child,
    ),
  );
}

/// A test wrapper that captures overflow errors during widget testing
class OverflowErrorCapture {
  final List<String> errors = [];
  void Function(FlutterErrorDetails)? _originalHandler;

  /// Start capturing overflow errors
  void start() {
    _originalHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      final message = details.toString();
      if (message.contains('overflowed') ||
          message.contains('RenderFlex') ||
          message.contains('OVERFLOW') ||
          message.contains('pixels on the')) {
        errors.add(message);
      } else {
        _originalHandler?.call(details);
      }
    };
  }

  /// Stop capturing and restore original handler
  void stop() {
    if (_originalHandler != null) {
      FlutterError.onError = _originalHandler;
      _originalHandler = null;
    }
  }

  /// Clear captured errors
  void clear() {
    errors.clear();
  }

  /// Check if any overflow errors were captured
  bool get hasOverflow => errors.isNotEmpty;

  /// Get a summary of all overflow errors
  String get summary => errors.join('\n---\n');
}

/// Helper class for testing widget visibility at different breakpoints
class VisibilityTestHelper {
  final WidgetTester tester;

  VisibilityTestHelper(this.tester);

  /// Expects the finder to find exactly one widget
  void expectVisible(Finder finder, {String? reason}) {
    expect(finder, findsOneWidget, reason: reason);
  }

  /// Expects the finder to find no widgets
  void expectNotVisible(Finder finder, {String? reason}) {
    expect(finder, findsNothing, reason: reason);
  }

  /// Expects the finder to find at least one widget
  void expectAtLeastOneVisible(Finder finder, {String? reason}) {
    expect(finder, findsWidgets, reason: reason);
  }
}

/// Breakpoint helper for tests
class BreakpointHelper {
  /// Returns true if the width falls into compact category (< 600)
  static bool isCompact(double width) => width < 600;

  /// Returns true if the width falls into medium category (600-839)
  static bool isMedium(double width) => width >= 600 && width < 840;

  /// Returns true if the width falls into expanded category (>= 840)
  static bool isExpanded(double width) => width >= 840;

  /// Returns the category name for a given width
  static String categoryName(double width) {
    if (isCompact(width)) return 'compact';
    if (isMedium(width)) return 'medium';
    return 'expanded';
  }
}
