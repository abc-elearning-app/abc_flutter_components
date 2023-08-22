import 'package:flutter/cupertino.dart';

import '../constants/app_enums.dart';
import '../constants/app_themes.dart';

class AppThemeProvider extends ChangeNotifier {
  var currentAppTheme = AppThemeEnum.light;

  void initTheme() {
    AppTheme.isDarkMode = currentAppTheme != AppThemeEnum.light;
    notifyListeners();
  }

  void changeAppTheme() {
    if (currentAppTheme == AppThemeEnum.light) {
      currentAppTheme = AppThemeEnum.dark;
    } else {
      currentAppTheme = AppThemeEnum.light;
    }
    AppTheme.isDarkMode = currentAppTheme != AppThemeEnum.light;
    notifyListeners();
  }
}
