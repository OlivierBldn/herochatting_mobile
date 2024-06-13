// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

/// ThemeProvider is a class that provides theme-related functionality.
/// It uses the ChangeNotifier mixin to notify listeners when changes occur.
/// 
/// It has a private field _themeMode which holds the current theme mode.
/// It provides a getter for the _themeMode field.
/// 
/// The class provides a method toggleTheme to toggle between light and dark themes.
/// When the theme is toggled, it updates the _themeMode field and notifies listeners.
/// 
/// The constructor takes a boolean isDarkMode parameter to set the initial theme mode.
/// If isDarkMode is true, the initial theme mode is dark; otherwise, it is light.
/// 
/// The theme mode can be accessed using the themeMode getter.
/// To toggle the theme mode, call the toggleTheme method.
/// 
/// 
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider({required bool isDarkMode})
      : _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}