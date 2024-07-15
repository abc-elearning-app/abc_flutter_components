import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/common/passing_probability_section.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/study_tab_widgets/study_tab_subject_tile.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/study_tab_widgets/study_plan_button.dart';

class SubjectData {
  final String id;
  final String icon;
  final String title;
  final double progress;

  SubjectData({
    required this.id,
    required this.icon,
    required this.title,
    required this.progress,
  });
}

class NewStudyTab extends StatelessWidget {
  final Color mainColor;
  final Color darkModeMainColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color beginnerBackgroundColor;
  final Color intermediateBackgroundColor;
  final Color advancedBackgroundColor;
  final List<SubjectData> subjectDataList;

  final String streakIcon;
  final String buttonBackground;

  final int dayStreak;
  final double passingProbability;
  final bool isDarkMode;
  final bool isSetupStudyPlan;

  final int studyPlanQuestions;
  final int studyPlanDoneQuestions;

  final void Function() onClickStudyPlan;
  final void Function(String id) onSelectSubject;

  const NewStudyTab({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.darkModeMainColor = const Color(0xFFCFAF83),
    this.beginnerColor = const Color(0xFFFC5656),
    this.intermediateColor = const Color(0xFFFF9669),
    this.advancedColor = const Color(0xFF2C9CB5),
    this.beginnerBackgroundColor = const Color(0xFFFFDEDE),
    this.intermediateBackgroundColor = const Color(0xFFFFE8DE),
    this.advancedBackgroundColor = const Color(0xFFD3F7FF),
    required this.streakIcon,
    required this.buttonBackground,
    required this.dayStreak,
    required this.passingProbability,
    required this.subjectDataList,
    required this.isDarkMode,
    required this.onClickStudyPlan,
    required this.onSelectSubject,
    required this.isSetupStudyPlan,
    required this.studyPlanQuestions,
    required this.studyPlanDoneQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          // Day streak and passing probability
          PassingProbabilitySection(
            isDarkMode: isDarkMode,
            dayStreak: dayStreak,
            passingProbability: passingProbability,
            mainColor: mainColor,
            darkModeMainColor: darkModeMainColor,
            streakIcon: streakIcon,
          ),

          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: isSetupStudyPlan
                  ? RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 12),
                          children: [
                          const TextSpan(text: "Today's Plan: "),
                          TextSpan(
                              text:
                                  '$studyPlanDoneQuestions/$studyPlanDoneQuestions',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: ' questions'),
                        ]))
                  : const Text(
                      'Set up study plan to maximize your passing probability!',
                      textAlign: TextAlign.center,
                    )),

          // Button
          StudyPlanButton(
            title: 'DUCK',
            mainColor: mainColor,
            buttonBackground: buttonBackground,
            onClickStudyPlan: onClickStudyPlan,
          ),

          // Subject list
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: subjectDataList.length,
                  itemBuilder: (_, index) => StudyTabSubjectTile(
                      isDarkMode: isDarkMode,
                      subjectData: subjectDataList[index],
                      onSelectSubject: onSelectSubject,
                      tileColor: _levelColor(subjectDataList[index].progress),
                      tileSecondaryColor: _levelBackgroundColor(
                          subjectDataList[index].progress))))
        ],
      ),
    );
  }

  _levelColor(double progress) {
    if (progress < 40) {
      return beginnerColor;
    } else if (progress < 80) {
      return intermediateColor;
    }
    return advancedColor;
  }

  _levelBackgroundColor(double progress) {
    if (progress < 40) {
      return beginnerBackgroundColor;
    } else if (progress < 80) {
      return intermediateBackgroundColor;
    }
    return advancedBackgroundColor;
  }
}
