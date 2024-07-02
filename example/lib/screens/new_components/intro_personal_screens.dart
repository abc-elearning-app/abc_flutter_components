import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestIntroPersonalPlanScreen extends StatelessWidget {
  const TestIntroPersonalPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabList = <IntroPersonalPlanData>[
      IntroPersonalPlanData(
          index: 0,
          title: 'Exam-Like Questions',
          subtitle:
              'We offer a wide range of questions compiled by experts that closely resemble the real exam.',
          image: 'assets/images/personal_plan_1.png',
          imageDark: ''),
      IntroPersonalPlanData(
          index: 1,
          title: 'Powerful Learning Method',
          subtitle:
              'We use a combination of active recall, spaced repetition, and interleaving to strengthen memory retention.',
          image: 'assets/images/personal_plan_2.png',
          imageDark: ''),
      IntroPersonalPlanData(
          index: 2,
          title: 'Personalized Study Plan',
          subtitle:
              'Based on your exam date and Diagnostic Test, we build a personalized study plan for you, maximizing your chances of exam success.',
          image: 'assets/images/personal_plan_3.png',
          imageDark: '')
    ];

    return IntroPersonalPlanPages(
      tabList: tabList,
      darkMode: AppTheme.isDarkMode,
      onFinish: () => Navigator.of(context).pop(),
    );
  }
}
