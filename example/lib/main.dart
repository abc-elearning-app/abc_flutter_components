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
            title: "Flutter ABC-JSC Components",
            initialRoute: AppRoute.home,
            onGenerateRoute: generateRoute,
          ),
        ),
      ),
    );
  }
}
