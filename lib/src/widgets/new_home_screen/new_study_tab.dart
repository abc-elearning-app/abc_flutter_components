import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/passing_probability_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/streak_circle.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/subject_tile.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/today_question_button.dart';

class SubjectData {
  final String icon;
  final String title;
  final double progress;

  SubjectData(this.icon, this.title, this.progress);
}

class NewStudyTab extends StatelessWidget {
  final Color mainColor;
  final Color textColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final List<SubjectData> subjectDataList;

  final String? streakIcon;
  final String? buttonBackground;

  final int dayStreak;
  final double passingProbability;
  final String buttonText;

  final void Function() onClickTodayQuestion;

  const NewStudyTab({
    super.key,
    this.streakIcon,
    this.mainColor = const Color(0xFF579E89),
    this.textColor = Colors.white,
    this.buttonBackground,
    this.beginnerColor = const Color(0xFFFC5656),
    this.intermediateColor = const Color(0xFFFFB443),
    this.advancedColor = const Color(0xFF2C9CB5),
    this.buttonText = "Today's Questions",
    required this.dayStreak,
    required this.passingProbability,
    required this.onClickTodayQuestion,
    required this.subjectDataList,
  });

  @override
  Widget build(BuildContext context) {
    // Sort the received list
    subjectDataList.sort(
        (subject1, subject2) => subject1.progress < subject2.progress ? 0 : 1);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // Day streak and passing probability
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreakCircle(
                mainColor: mainColor,
                streakIcon: streakIcon,
                dayStreak: dayStreak,
              ),
              Expanded(
                  child: PassingProbabilityBox(
                      mainColor: mainColor,
                      passingProbability: passingProbability))
            ],
          ),

          // Button
          TodayQuestionButton(
              title: buttonText, buttonBackground: buttonBackground),

          // Subject list
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: subjectDataList.length,
                  itemBuilder: (_, index) => SubjectTile(
                      subjectData: subjectDataList[index],
                      tileColor:
                          _getLevelColor(subjectDataList[index].progress))))
        ],
      ),
    );
  }

  _getLevelColor(double progress) {
    if (progress < 40) {
      return beginnerColor;
    } else if (progress < 80) {
      return intermediateColor;
    }
    return advancedColor;
  }
}
