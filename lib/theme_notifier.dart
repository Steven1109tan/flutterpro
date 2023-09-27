import 'package:flutter/material.dart';
import 'package:wifi_connectivity_test/theme.dart';

class ThemeChanger extends ValueNotifier<ThemeMode> {
  ThemeChanger(ThemeMode themeMode) : super(themeMode);

  void toggleTheme() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
