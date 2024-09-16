import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'home_icon.dart';

class SubjectData {
  final int id;
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

class StudyTabSubjectTile extends StatelessWidget {
  final int index;
  final SubjectData subjectData;
  final Color tileColor;
  final Color tileSecondaryColor;
  final bool isDarkMode;
  final void Function(int id) onSelectSubject;

  const StudyTabSubjectTile({
    super.key,
    required this.index,
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)] : null),
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
                child: HomeIcon(icon: subjectData.icon, tileColor: tileColor)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  subjectData.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
            CircularPercentIndicator(
              animation: true,
              radius: 35,
              percent: subjectData.progress / 100,
              progressColor: tileColor,
              backgroundColor: isDarkMode ? Colors.white.withOpacity(0.12) : tileSecondaryColor,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 7,
              center: Text(
                '${subjectData.progress.toInt()}%',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
