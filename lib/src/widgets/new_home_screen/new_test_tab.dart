import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/diagnostic_test_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/final_test_box.dart';

class NewTestTab extends StatelessWidget {
  final List<PracticeTestData> practiceTests;
  final double diagnosticProgress;
  final double finalTestProgress;
  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;

  final List<Color> gradientColors;

  final String diagnosticTestIcon;
  final String finalTestIcon;
  final String diagnosticBoxBackground;
  final String finalTestBackground;

  final void Function() onTryAgainDiagnosticTab;
  final void Function() onSeeAllPracticeTests;
  final void Function(int index) onSelectPracticeTest;
  final void Function() onClickFinalTest;
  final void Function() onSeeAll;

  const NewTestTab(
      {super.key,
      required this.practiceTests,
      required this.isDarkMode,
      this.mainColor = const Color(0xFFF8BB67),
      this.secondaryColor = const Color(0xFF7C6F5B),
      this.gradientColors = const [
        Color(0xFFC0A67C),
        Color(0xFF958366),
      ],
      this.diagnosticTestIcon = 'assets/images/test_tab_diagnostic.png',
      this.finalTestIcon = 'assets/images/test_tab_final.png',
      this.diagnosticBoxBackground = 'assets/images/test_tab_diagnostic_bg.png',
      this.finalTestBackground = 'assets/images/test_tab_final_bg.png',
      required this.onTryAgainDiagnosticTab,
      required this.onSeeAllPracticeTests,
      required this.onClickFinalTest,
      required this.diagnosticProgress,
      required this.finalTestProgress,
      required this.onSelectPracticeTest,
      required this.onSeeAll,
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiagnosticTestBox(
            isDarkMode: isDarkMode,
            progress: diagnosticProgress,
            onClick: onTryAgainDiagnosticTab,
            icon: diagnosticTestIcon,
            background: diagnosticBoxBackground,
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
                      fontSize: 20,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),

          PracticeTestList(
            color: secondaryColor,
            practiceTests: practiceTests,
            onSelect: onSelectPracticeTest,
            isDarkMode: isDarkMode,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              'Exam Mode',
              style: TextStyle(
                  fontSize: 20,
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
