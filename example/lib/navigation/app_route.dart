class AppRoute {
  AppRoute._();

  static const String home = '/home';
  static const String buttons = '/buttons';
  static const String animations = '/animations';
  static const String bottomNavBars = '/bottom_nav_bars';
  static const String bottomSheets = '/bottom_sheets';
  static const String appBars = '/app_bars';
  static const String cardItems = '/card_items';
  static const String checkBoxes = '/check_boxes';
  static const String dialogs = '/dialogs';
  static const String emails = '/emails';
  static const String games = '/games';
  static const String icons = '/icons';
  static const String loadings = '/loadings';
  static const String logins = '/logins';
  static const String menus = '/menus';
  static const String progressItems = '/progress_items';
  static const String ratings = '/ratings';
  static const String reviews = '/reviews';
  static const String sliders = '/sliders';
  static const String switches = '/switches';
  static const String tabViews = '/tab_views';
  static const String texts = '/texts';
  static const String toasters = '/toasters';
  static const String others = '/others';

  static const String newLogin = '/new_login';
  static const String introPersonalPlan = '/intro_personal_plan';
  static const String diagnosticResult = '/diagnostic_result';
  static const String personalPlanAnalyzing = '/personal_plan_analyzing';
  static const String personalPlanReady = '/personal_plan_ready';
  static const String examTimeSetup = '/exam_time_setup';
  static const String newStudyTab = '/new_study_tab';
  static const String levelsPath = '/level_path';
  static const String diagnosticQuestion = '/diagnostic_question';
  static const String newPracticeTab = '/practice_tab';
  static const String groupQuestionList = '/group_question_list';

  static List<String> getAppRoute() {
    return [
      AppRoute.newLogin,
      AppRoute.introPersonalPlan,
      AppRoute.diagnosticResult,
      AppRoute.personalPlanAnalyzing,
      AppRoute.personalPlanReady,
      AppRoute.examTimeSetup,
      AppRoute.newStudyTab,
      AppRoute.levelsPath,
      AppRoute.diagnosticQuestion,
      AppRoute.newPracticeTab,
      AppRoute.groupQuestionList
    ];
  }
}
