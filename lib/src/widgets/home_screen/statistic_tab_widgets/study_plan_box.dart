import 'package:flutter/material.dart';

import '../../../../../flutter_abc_jsc_components.dart';
import '../../icons/icon_box.dart';

class StudyPlanBoxComponent extends StatelessWidget {
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String studyPlanLogo;

  final DateTime startDate;
  final DateTime examDate;
  final List<int> valueList;

  final int expectedQuestions;

  const StudyPlanBoxComponent({
    super.key,
    required this.isDarkMode,
    required this.backgroundColor,
    required this.mainColor,
    required this.secondaryColor,
    required this.startDate,
    required this.examDate,
    required this.valueList,
    required this.expectedQuestions,
    required this.studyPlanLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDarkMode ? Colors.white.withOpacity(0.3) : backgroundColor,
          boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2)] : null),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  // Icon
                  IconBox(
                    size: 35,
                    icon: studyPlanLogo,
                    iconColor: Colors.white,
                    backgroundColor: secondaryColor,
                  ),

                  const SizedBox(width: 15),

                  // Title
                  Expanded(
                      child: Text(
                    'Study Plan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
                  )),
                ],
              ),
            ),
          ),
          Container(
            height: 280,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: StudyPlanChart(
              leftYAxisTitle: 'Learnt Questions',
              isDarkMode: isDarkMode,
              lineSectionHeight: 120,
              barSectionHeight: 120,
              startDate: startDate,
              examDate: examDate,
              valueList: valueList,
              questionPerDay: expectedQuestions,
            ),
          ),
        ],
      ),
    );
  }
}
