import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/use cases/change_theme_use_case.dart';
import '../utilities/dependency_injection.dart';

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
