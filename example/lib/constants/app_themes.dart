import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static bool isDarkMode = false;

  static ThemeData get currentTheme =>
      isDarkMode ? _appDarkTheme : _appLightTheme;

  static final ThemeData _appLightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );

  static final ThemeData _appDarkTheme = ThemeData(
    colorScheme: _darkColorScheme,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF006491),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFC9E6FF),
    onPrimaryContainer: Color(0xFF001E2F),
    secondary: Color(0xFF0061A4),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD1E4FF),
    onSecondaryContainer: Color(0xFF001D36),
    tertiary: Color(0xFF006879),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA9EDFF),
    onTertiaryContainer: Color(0xFF001F26),
    error: Color(0xFF9F3E44),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD9),
    onErrorContainer: Color(0xFF40000A),
    outline: Color(0xFFA1B5DE),
    background: Color(0xFFFBFCFF),
    onBackground: Color(0xFF191C1E),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF191C1E),
    surfaceVariant: Color(0xFFDEE3EB),
    onSurfaceVariant: Color(0xFF42474E),
    inverseSurface: Color(0xFF2E3133),
    onInverseSurface: Color(0xFFF0F1F3),
    inversePrimary: Color(0xFF8ACEFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF006491),
    outlineVariant: Color(0xFFC2C7CF),
    scrim: Color(0xFF000000),
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8ACEFF),
    onPrimary: Color(0xFF00344E),
    primaryContainer: Color(0xFF004B6F),
    onPrimaryContainer: Color(0xFFC9E6FF),
    secondary: Color(0xFF9ECAFF),
    onSecondary: Color(0xFF003258),
    secondaryContainer: Color(0xFF00497D),
    onSecondaryContainer: Color(0xFFD1E4FF),
    tertiary: Color(0xFF54D7F2),
    onTertiary: Color(0xFF003640),
    tertiaryContainer: Color(0xFF004E5B),
    onTertiaryContainer: Color(0xFFA9EDFF),
    error: Color(0xFFFFB3B3),
    onError: Color(0xFF620F1A),
    errorContainer: Color(0xFF80272E),
    onErrorContainer: Color(0xFFFFDAD9),
    outline: Color(0xFF8C9199),
    background: Color(0xFF191C1E),
    onBackground: Color(0xFFE1E2E5),
    surface: Color(0xFF111416),
    onSurface: Color(0xFFC5C6C9),
    surfaceVariant: Color(0xFF42474E),
    onSurfaceVariant: Color(0xFFC2C7CF),
    inverseSurface: Color(0xFFE1E2E5),
    onInverseSurface: Color(0xFF191C1E),
    inversePrimary: Color(0xFF006491),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF8ACEFF),
    outlineVariant: Color(0xFF42474E),
    scrim: Color(0xFF000000),
  );
}
