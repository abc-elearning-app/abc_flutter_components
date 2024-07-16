import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/diagnostic_test_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/final_test_box.dart';

class TestTab extends StatelessWidget {
  final List<TopicData> topics;
  final List<TestData> tests;
  final double diagnosticProgress;
  final double finalTestProgress;
  final bool isDarkMode;
  final bool displayTests;

  final Color mainColor;
  final Color secondaryColor;

  final List<Color> gradientColors;

  final String diagnosticTestIcon;
  final String finalTestIcon;
  final String diagnosticBoxBackground;
  final String finalTestBackground;

  final void Function() onTryAgainDiagnosticTab;
  final void Function(int id) onSelectItem;
  final void Function() onClickFinalTest;
  final void Function() onSeeAll;

  const TestTab({
    super.key,
    this.topics = const [],
    this.tests = const [],
    required this.isDarkMode,
    this.mainColor = const Color(0xFFF8BB67),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.gradientColors = const [
      Color(0xFFC0A67C),
      Color(0xFF958366),
    ],
    required this.diagnosticTestIcon,
    required this.finalTestIcon,
    required this.diagnosticBoxBackground,
    required this.finalTestBackground,
    required this.onTryAgainDiagnosticTab,
    required this.onClickFinalTest,
    required this.diagnosticProgress,
    required this.finalTestProgress,
    required this.onSelectItem,
    required this.onSeeAll,
    required this.displayTests,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiagnosticTestBox(
            icon: diagnosticTestIcon,
            background: diagnosticBoxBackground,
            isDarkMode: isDarkMode,
            progress: diagnosticProgress,
            onClick: onTryAgainDiagnosticTab,
            color: secondaryColor,
            gradientColors: gradientColors,
          ),

          // Title and See All button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Practice Tests',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                MainButton(
                  padding: EdgeInsets.zero,
                  onPressed: onSeeAll,
                  backgroundColor: Colors.transparent,
                  borderRadius: 30,
                  title: 'See All',
                  textColor: isDarkMode ? mainColor : secondaryColor,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),

          displayTests
              ? TestList(
                  practiceTests: tests,
                  onSelect: onSelectItem,
                  isDarkMode: isDarkMode,
                  mainColor: mainColor,
                  secondaryColor: secondaryColor)
              : TopicList(
                  topics: topics,
                  onSelect: onSelectItem,
                  isDarkMode: isDarkMode,
                  color: secondaryColor),

          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              'Exam Mode',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),

          FinalTestBox(
            isDarkMode: isDarkMode,
            mainColor: mainColor,
            gradientColors: gradientColors,
            secondaryColor: secondaryColor,
            progress: finalTestProgress,
            answeredQuestions: 18,
            totalQuestions: 60,
            correctPercent: 20,
            icon: finalTestIcon,
            background: finalTestBackground,
            onClickFinal: onClickFinalTest,
          )
        ],
      ),
    );
  }
}
