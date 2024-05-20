import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/common/passing_probability_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/overview_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/subject_analysis_box.dart';

class NewStatisticTab extends StatelessWidget {
  final int dayStreak;
  final double passingProbability;
  final Color mainColor;

  const NewStatisticTab(
      {super.key,
      this.mainColor = const Color(0xFFE3A651),
      required this.dayStreak,
      required this.passingProbability});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PassingProbabilityBox(
              passingProbability: passingProbability,
              mainColor: mainColor,
              dayStreak: dayStreak,
            ),
            const OverviewBox(
              answeredQuestions: 155,
              totalQuestions: 1426,
              correctAnswers: 148,
              accuracyRate: 21,
            ),
            const Text(
              'Subject Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SubjectAnalysisBox(
              title: 'Arithmetic Reasoning',
              icon: 'assets/images/subject_icon.svg',
              iconColor: Colors.white,
              progressColor: Colors.red,
              iconBackgroundColor: Color(0xFF7C6F5B),
              accuracyRate: 86,
              correctQuestions: 86,
              incorrectQuestions: 10,
              unansweredQuestions: 4,
            ),
            const SubjectAnalysisBox(
              title: 'Object Assembling',
              icon: 'assets/images/subject_icon.svg',
              iconColor: Colors.white,
              progressColor: Colors.green,
              iconBackgroundColor: Colors.red,
              accuracyRate: 90,
              correctQuestions: 90,
              incorrectQuestions: 5,
              unansweredQuestions: 5,
            )
          ],
        ),
      ),
    );
  }
}
