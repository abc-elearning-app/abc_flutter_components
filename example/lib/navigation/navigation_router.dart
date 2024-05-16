import 'package:example/screens/animations_screen/animations_screen.dart';
import 'package:example/screens/bottom_nav_bars_screen/bottom_nav_bars_screen.dart';
import 'package:example/screens/check_boxes_screen/check_boxes_screen.dart';
import 'package:example/screens/emails_screen/emails_screen.dart';
import 'package:example/screens/loadings_screen/loadings_screen.dart';
import 'package:example/screens/logins_screen/logins_screen.dart';
import 'package:example/screens/new_components/customize_test.dart';
import 'package:example/screens/new_components/diagnostic_questions.dart';
import 'package:example/screens/new_components/diagnostic_result_screen.dart';
import 'package:example/screens/new_components/exam_time_setup_screen.dart';
import 'package:example/screens/new_components/final_test_result.dart';
import 'package:example/screens/new_components/group_questions_list_page.dart';
import 'package:example/screens/new_components/intro_personal_screens.dart';
import 'package:example/screens/new_components/levels_path_screen.dart';
import 'package:example/screens/new_components/login_screen.dart';
import 'package:example/screens/new_components/new_practice_tab.dart';
import 'package:example/screens/new_components/new_study_tab.dart';
import 'package:example/screens/new_components/new_test_tab.dart';
import 'package:example/screens/new_components/part_test_result.dart';
import 'package:example/screens/new_components/personal_plan_analyzing.dart';
import 'package:example/screens/new_components/personal_plan_ready.dart';
import 'package:example/screens/new_components/practice_test_grid.dart';
import 'package:example/screens/sliders_screen/sliders_screen.dart';
import 'package:example/screens/tab_views_screen/tab_views_screen.dart';
import 'package:example/screens/texts_screen/texts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

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
    case AppRoute.checkBoxes:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const CheckBoxesScreen(),
      );
    case AppRoute.emails:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const EmailsScreen(),
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
    case AppRoute.sliders:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const SlidersScreen(),
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

    // New components
    case AppRoute.newLogin:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestLoginScreen(),
      );

    case AppRoute.introPersonalPlan:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestIntroPersonalPlanScreen(),
      );

    case AppRoute.diagnosticResult:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestDiagnosticScreen(),
      );

    case AppRoute.personalPlanAnalyzing:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestAnalyzingScreen(),
      );

    case AppRoute.personalPlanReady:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestPersonalPlanReadyScreen(),
      );

    case AppRoute.examTimeSetup:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestExamSetupTime(),
      );
    case AppRoute.newStudyTab:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestNewStudyTabScreen(),
      );
    case AppRoute.levelsPath:
      return _getPageRoute(
        routeName: routeName,
        viewToShow: const TestLevelsPathScreen(),
      );
    case AppRoute.diagnosticQuestion:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestDiagnosticQuestionsPage());
    case AppRoute.newPracticeTab:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestNewPracticeTab());
    case AppRoute.groupQuestionList:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestGroupQuestionList());
    case AppRoute.customizeTest:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestCustomizeTest());
    case AppRoute.finalTestResult:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestFinalTestResult());
    case AppRoute.partTestResult:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestPartTestResult());
    case AppRoute.newTestTab:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestNewTestTab());
    case AppRoute.practiceTestGrid:
      return _getPageRoute(
          routeName: routeName,
          viewToShow: const TestPracticeTestGrid());
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
