import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/states/theme/theme_state.dart';

const _colorKey = 'theme_color_value';
const _brightnessKey = 'theme_brightness';

final themeProvider =
    StateNotifierProvider<ThemeStateNotifier, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeStateNotifier(prefs);
});

class ThemeStateNotifier extends StateNotifier<ThemeState> {
  ThemeStateNotifier(this._prefs) : super(_loadFromPrefs(_prefs));

  final dynamic _prefs;

  static ThemeState _loadFromPrefs(dynamic prefs) {
    // ignore: deprecated_member_use
    final colorValue = prefs.getInt(_colorKey) ?? Colors.blue.value;
    final brightnessIndex = prefs.getInt(_brightnessKey) ?? 0;
    return ThemeState(
      colorValue: colorValue,
      brightness: Brightness.values[brightnessIndex],
    );
  }

  void selectColor(Color color) {
    // ignore: deprecated_member_use
    final colorInt = color.value;
    state = state.copyWith(colorValue: colorInt);
    _prefs.setInt(_colorKey, colorInt);
  }

  void selectBrightness(Brightness brightness) {
    state = state.copyWith(brightness: brightness);
    _prefs.setInt(_brightnessKey, brightness.index);
  }

  void toggleBrightness() {
    final newBrightness =
        state.brightness == Brightness.light ? Brightness.dark : Brightness.light;
    selectBrightness(newBrightness);
  }
}
