import 'package:example/screens/animations_screen/animations_screen.dart';
import 'package:example/screens/app_bars_screen/app_bars_screen.dart';
import 'package:example/screens/bottom_nav_bars_screen/bottom_nav_bars_screen.dart';
import 'package:example/screens/card_items_screen/card_items_screen.dart';
import 'package:example/screens/check_boxes_screen/check_boxes_screen.dart';
import 'package:example/screens/dialogs_screen/dialogs_screen.dart';
import 'package:example/screens/emails_screen/emails_screen.dart';
import 'package:example/screens/games_screen/games_screen.dart';
import 'package:example/screens/loadings_screen/loadings_screen.dart';
import 'package:example/screens/logins_screen/logins_screen.dart';
import 'package:example/screens/menus_screen/menus_screen.dart';
import 'package:example/screens/others_screen/others_screen.dart';
import 'package:example/screens/progress_items_screen/progress_items_screen.dart';
import 'package:example/screens/ratings_screen/ratings_screen.dart';
import 'package:example/screens/reviews_screen/reviews_screen.dart';
import 'package:example/screens/sliders_screen/sliders_screen.dart';
import 'package:example/screens/switches_screen/switches_screen.dart';
import 'package:example/screens/tab_views_screen/tab_views_screen.dart';
import 'package:example/screens/texts_screen/texts_screen.dart';
import 'package:example/screens/toasters_screen/toasters_screen.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_sheets_screen/bottom_sheets_screen.dart';
import '../screens/buttons_screen/buttons_screen.dart';
import '../screens/home_screen/home_screen.dart';
import 'index.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments as Map<String, dynamic>? ?? {};
  final routeName = settings.name as String;
  switch (settings.name) {
    case AppRoute.home:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const HomeScreen(),
      );
    case AppRoute.buttons:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const ButtonsScreen(),
      );
    case AppRoute.animations:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const AnimationsScreen(),
      );
    case AppRoute.bottomNavBars:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const BottomNavBarsScreen(),
      );
    case AppRoute.bottomSheets:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const BottomSheetsScreen(),
      );
    case AppRoute.appBars:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const AppBarsScreen(),
      );
    case AppRoute.cardItems:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const CardItemsScreen(),
      );
    case AppRoute.checkBoxes:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const CheckBoxesScreen(),
      );
    case AppRoute.dialogs:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const DialogsScreen(),
      );
    case AppRoute.emails:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const EmailsScreen(),
      );
    case AppRoute.games:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const GamesScreen(),
      );
    case AppRoute.loadings:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const LoadingsScreen(),
      );
    case AppRoute.logins:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const LoginsScreen(),
      );
    case AppRoute.menus:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const MenusScreen(),
      );
    case AppRoute.progressItems:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const ProgressItemsScreen(),
      );
    case AppRoute.ratings:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const RatingScreen(),
      );
    case AppRoute.reviews:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const ReviewsScreen(),
      );
    case AppRoute.sliders:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const SlidersScreen(),
      );
    case AppRoute.switches:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const SwitchesScreen(),
      );
    case AppRoute.tabViews:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TabViewsScreen(),
      );
    case AppRoute.texts:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TextsScreen(),
      );
    case AppRoute.toasters:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const ToastersScreen(),
      );
    case AppRoute.others:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const OthersScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

PageRoute _getPageRoute(
    {required String routeName,
    required Widget viewToShow,
    bool animation = true,
    bool scale = false}) {
  RouteSettings settings = RouteSettings(
    name: routeName,
  );
  animation = true;
  if (animation) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => viewToShow,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (scale) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        }
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        );
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
