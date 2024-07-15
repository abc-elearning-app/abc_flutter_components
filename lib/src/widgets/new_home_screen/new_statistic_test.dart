import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/common/passing_probability_section.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/overview_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/personal_plan_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/subject_analysis_box.dart';

import '../../../flutter_abc_jsc_components.dart';

class NewStatisticTab extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color darkModeMainColor;

  final int dayStreak;
  final double passingProbability;
  final bool isDarkMode;
  final bool isSetupStudyPlan;
  final List<SubjectAnalysisData> subjectList;
  final DateTime startDate;
  final DateTime examDate;
  final List<int> personalPlanValueList;

  final String streakIcon;
  final String overviewBackground;

  const NewStatisticTab({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.darkModeMainColor = const Color(0xFFCFAF83),
    required this.dayStreak,
    required this.passingProbability,
    required this.isDarkMode,
    required this.subjectList,
    required this.streakIcon,
    required this.overviewBackground,
    required this.startDate,
    required this.examDate,
    required this.personalPlanValueList,
    required this.isSetupStudyPlan,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PassingProbabilitySection(
              dayStreak: dayStreak,
              passingProbability: passingProbability,
              streakIcon: streakIcon,
              isDarkMode: isDarkMode,
              mainColor: mainColor,
              darkModeMainColor: darkModeMainColor,
            ),
            OverviewBox(
              answeredQuestions: 155,
              totalQuestions: 1426,
              correctAnswers: 148,
              accuracyRate: 21,
              background: overviewBackground,
              isDarkMode: isDarkMode,
            ),
            PersonalPlanBox(
              isDarkMode: isDarkMode,
              mainColor: mainColor,
              secondaryColor: secondaryColor,
              backgroundColor: const Color(0xFFFFFDF1),
              startDate: startDate,
              examDate: examDate,
              valueList: personalPlanValueList,
              expectedQuestions: 50,
              studyPlanLogo: '',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Subject Analysis',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjectList.length,
                itemBuilder: (_, index) => SubjectAnalysisBox(
                    dotIcon: 'assets/static/icons/dot.svg',
                    subjectAnalysisData: subjectList[index],
                    isDarkMode: isDarkMode))
          ],
        ),
      ),
    );
  }
}
