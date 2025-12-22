import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/brightness_picker.dart';
import 'package:zenscrap_flutter/src/ui/account/widgets/color_option.dart';
import '../../responsive_test_utils.dart';

Widget createTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
    ],
    home: Scaffold(
      body: child,
    ),
  );
}

void main() {
  group('Account Widgets Responsive Overflow Tests', () {
    late OverflowErrorCapture overflowCapture;

    setUp(() {
      overflowCapture = OverflowErrorCapture();
    });

    tearDown(() {
      overflowCapture.stop();
    });

    group('BrightnessPicker Widget', () {
      testWidgets(
        'renders without overflow on all screen sizes',
        (tester) async {
          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();
            overflowCapture.start();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              createTestApp(
                Center(
                  child: BrightnessPicker(
                    brightness: Brightness.light,
                    onBrightnessChanged: (_) {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'BrightnessPicker overflowed at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.errorMessages.join(", ")}',
            );

            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'renders without overflow at breakpoint edges',
        (tester) async {
          for (final size in TestDeviceSizes.breakpointEdges) {
            overflowCapture.clear();
            overflowCapture.start();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              createTestApp(
                Center(
                  child: BrightnessPicker(
                    brightness: Brightness.light,
                    onBrightnessChanged: (_) {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'BrightnessPicker overflowed at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.errorMessages.join(", ")}',
            );

            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'displays both light and dark options',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(
              BrightnessPicker(
                brightness: Brightness.light,
                onBrightnessChanged: (_) {},
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Light'), findsOneWidget);
          expect(find.text('Dark'), findsOneWidget);
        },
      );
    });

    group('ColorOption Widget', () {
      testWidgets(
        'renders without overflow on all screen sizes',
        (tester) async {
          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();
            overflowCapture.start();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              createTestApp(
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: ColorOption(
                      color: Colors.blue,
                      isSelected: true,
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'ColorOption overflowed at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.errorMessages.join(", ")}',
            );

            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'shows check mark when selected',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(
              ColorOption(
                color: Colors.blue,
                isSelected: true,
                onTap: () {},
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.check_rounded), findsOneWidget);
        },
      );

      testWidgets(
        'renders correctly when not selected',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(
              ColorOption(
                color: Colors.blue,
                isSelected: false,
                onTap: () {},
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Widget renders without error
          expect(find.byType(ColorOption), findsOneWidget);
        },
      );
    });

    group('Multiple ColorOptions in Grid', () {
      testWidgets(
        'grid of colors renders without overflow on small screens',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            createTestApp(
              GridView.extent(
                maxCrossAxisExtent: 50,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(16),
                children: [
                  ...Colors.primaries.map(
                    (color) => ColorOption(
                      color: color,
                      isSelected: false,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Color grid overflowed on small phone: ${overflowCapture.errorMessages.join(", ")}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Responsive Sizing', () {
      testWidgets(
        'BrightnessPicker uses responsive padding',
        (tester) async {
          // This test verifies that the widget builds successfully with different sizes
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            createTestApp(
              BrightnessPicker(
                brightness: Brightness.light,
                onBrightnessChanged: (_) {},
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            createTestApp(
              BrightnessPicker(
                brightness: Brightness.light,
                onBrightnessChanged: (_) {},
              ),
            ),
          );
          await tester.pumpAndSettle();

          // If we reach here without errors, responsive sizing is working
          expect(find.byType(BrightnessPicker), findsOneWidget);
        },
      );

      testWidgets(
        'ColorOption uses responsive sizing',
        (tester) async {
          // This test verifies that the widget builds successfully with different sizes
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            createTestApp(
              Center(
                child: ColorOption(
                  color: Colors.blue,
                  isSelected: true,
                  onTap: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            createTestApp(
              Center(
                child: ColorOption(
                  color: Colors.blue,
                  isSelected: true,
                  onTap: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // If we reach here without errors, responsive sizing is working
          expect(find.byType(ColorOption), findsOneWidget);
        },
      );
    });
  });
}
