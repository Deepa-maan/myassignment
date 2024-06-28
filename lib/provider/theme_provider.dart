import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/cache_manager.dart';

class ThemeProvider with ChangeNotifier {
  String currentTheme = "light";

  ThemeMode get themeMode {
    if (currentTheme == "light") {
      return ThemeMode.light;
    } else if (currentTheme == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void changeTheme(String theme) async {
    CacheManager.setString("theme", theme);

   

    currentTheme = theme;

    notifyListeners();
  }

  void initialize() async {
    

    currentTheme = CacheManager.getString("theme") ?? "light";

    notifyListeners();
  }
}
