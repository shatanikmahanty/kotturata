import 'package:flutter/material.dart';
import 'package:kotturata/prefs/dark_theme_prefs.dart';

class ThemeBloc extends ChangeNotifier {

  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value){
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
