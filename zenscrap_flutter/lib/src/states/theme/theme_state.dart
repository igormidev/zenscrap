import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  factory ThemeState({
    required int colorValue,
    required Brightness brightness,
  }) = _ThemeState;

  // ignore: deprecated_member_use
  factory ThemeState.initial() => ThemeState(
        colorValue: Colors.blue.value,
        brightness: Brightness.light,
      );
}

extension ThemeStateExtensions on ThemeState {
  Color get seedColor => Color(colorValue);
  bool get isDarkMode => brightness == Brightness.dark;
}
