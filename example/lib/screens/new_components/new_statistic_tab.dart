import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewStatisticTab extends StatelessWidget {
  const TestNewStatisticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor:
          AppTheme.isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
      body: SafeArea(
          child: NewStatisticTab(
        isDarkMode: AppTheme.isDarkMode,
        dayStreak: 14,
        passingProbability: 31,
        subjectList: [
          SubjectAnalysisData(
              title: 'Arithmetic Reasoning',
              icon: 'assets/images/subject_icon.svg',
              accuracyRate: 86,
              correctQuestions: 86,
              incorrectQuestions: 10,
              unansweredQuestions: 4),
          SubjectAnalysisData(
              title: 'Auto and Shop Information',
              icon: 'assets/images/subject_icon.svg',
              accuracyRate: 86,
              correctQuestions: 86,
              incorrectQuestions: 10,
              unansweredQuestions: 4),
          SubjectAnalysisData(
              title: 'Arithmetic Reasoning',
              icon: 'assets/images/subject_icon.svg',
              accuracyRate: 86,
              correctQuestions: 86,
              incorrectQuestions: 10,
              unansweredQuestions: 4),
        ],
      )),
    );
  }
}
