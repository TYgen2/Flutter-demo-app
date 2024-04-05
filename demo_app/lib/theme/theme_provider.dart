import 'package:demo_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  // Force SignIn page and Register page to use lightMode
  ThemeData get defaultTheme => lightMode;

  bool _isDark = false;

  bool get isDark => _isDark;

  // Remember the user preference after app closed
  late SharedPreferences storage;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Theme toggle function in the Home page's drawer
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      storage.setBool('isDark', true);
    } else {
      themeData = lightMode;
      storage.setBool('isDark', false);
    }
    notifyListeners();
  }

  // For displaying the moon / daylight icon in the theme switch
  bool checkTheme() {
    if (_themeData == lightMode) {
      return false;
    } else {
      return true;
    }
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    if (storage.getBool('isDark') == true) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
