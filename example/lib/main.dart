import 'package:example/constants/app_themes.dart';
import 'package:example/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'navigation/app_route.dart';
import 'navigation/navigation_router.dart';
import 'navigation/navigation_service.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = NavigationService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppThemeProvider())
      ],
      child: Consumer<AppThemeProvider>(
        builder: (_, __, ___) => OKToast(
          child: MaterialApp(
            navigatorKey: _navigationService.navigationKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.currentTheme,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              textTheme: const TextTheme(
                bodyText1: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.white),
                headline1: TextStyle(color: Colors.white),
                headline2: TextStyle(color: Colors.white),
                headline3: TextStyle(color: Colors.white),
                headline4: TextStyle(color: Colors.white),
                headline5: TextStyle(color: Colors.white),
                headline6: TextStyle(color: Colors.white),
                subtitle1: TextStyle(color: Colors.white),
                subtitle2: TextStyle(color: Colors.white),
                caption: TextStyle(color: Colors.white),
                button: TextStyle(color: Colors.white),
                overline: TextStyle(color: Colors.white),
              ),
            ),
            title: "Flutter ABC-JSC Components",
            initialRoute: AppRoute.home,
            onGenerateRoute: generateRoute,
          ),
        ),
      ),
    );
  }
}
