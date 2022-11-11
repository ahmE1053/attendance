import 'package:attendance/core/utilities/dependency_injection.dart';
import 'package:attendance/domain/use%20cases/change_theme_use_case.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool darkMode = getIt.get<SharedPreferences>().getBool('darkMode') ?? false;
  Brightness getTheme() {
    if (darkMode) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  Future<void> changeMode() async {
    await getIt.get<ChangeThemeModeUseCase>().run(!darkMode);
    darkMode = getIt.get<SharedPreferences>().getBool('darkMode') ?? false;
    notifyListeners();
  }
}
