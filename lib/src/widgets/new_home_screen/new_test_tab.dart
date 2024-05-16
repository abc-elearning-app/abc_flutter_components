import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/diagnostic_test_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/final_test_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/test_tab_widgets/practice_test_list.dart';

class NewTestTab extends StatelessWidget {
  final List<PracticeTestBoxData> practiceTests;

  final Color mainColor;
  final Color secondaryColor;
  final Color boxTextColor;

  final String diagnosticTestIcon;
  final String finalTestIcon;
  final String diagnosticBoxBackground;
  final String finalTestBackground;

  const NewTestTab(
      {super.key,
      required this.practiceTests,
      this.mainColor = const Color(0xFF7C6F5B),
      this.secondaryColor = const Color(0xFFF6AF4D),
      this.diagnosticTestIcon = 'assets/images/test_tab_icon.png',
      this.finalTestIcon = 'assets/images/test_tab_icon.png',
      this.diagnosticBoxBackground = 'assets/images/test_tab_background_1.png',
      this.finalTestBackground = 'assets/images/test_tab_background_4.png',
      this.boxTextColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiagnosticTestBox(
            progressColor: boxTextColor,
            icon: diagnosticTestIcon,
            background: diagnosticBoxBackground,
            textColor: boxTextColor,
          ),

          // Title and See All button
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Practice Tests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),

          PracticeTestList(
            practiceTests: practiceTests,
            textColor: boxTextColor,
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              'Exam Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),

          FinalTestBox(
              answeredQuestions: 18,
              totalQuestions: 60,
              correctPercent: 20,
              progressColor: secondaryColor,
              textColor: boxTextColor,
              icon: finalTestIcon,
              background: finalTestBackground)
        ],
      ),
    );
  }
}
