import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/study_tab_widgets/home_icon.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudyTabSubjectTile extends StatelessWidget {
  final SubjectData subjectData;
  final Color tileColor;
  final Color tileSecondaryColor;
  final bool isDarkMode;
  final void Function(String id) onSelectSubject;

  const StudyTabSubjectTile({
    super.key,
    required this.subjectData,
    required this.tileColor,
    required this.tileSecondaryColor,
    required this.isDarkMode,
    required this.onSelectSubject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelectSubject(subjectData.id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: !isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 2),
                        spreadRadius: 2)
                  ]
                : null),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: tileSecondaryColor,
              ),
              child: HomeIcon(icon: subjectData.icon, tileColor: tileColor)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  subjectData.title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
            CircularPercentIndicator(
              animation: true,
              radius: 35,
              percent: subjectData.progress / 100,
              progressColor: tileColor,
              backgroundColor: tileSecondaryColor,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 7,
              center: Text(
                '${subjectData.progress.toInt()}%',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getLevelTitle(double progress) {
    if (progress < 40) {
      return 'Beginner';
    } else if (progress < 80) {
      return 'Intermediate';
    }
    return 'Advanced';
  }
}
