import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewPracticeTab extends StatelessWidget {
  const TestNewPracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final groupList = <QuestionGroupData>[
      QuestionGroupData(
          id: 'abc',
          title: 'Random Questions',
          subtitle: 'Select questions randomly from the question bank.',
          icon: 'assets/images/random_questions.svg',
          iconBackgroundColor: const Color(0xFFBAE8DB)),
      QuestionGroupData(
          id: 'abc',
          title: 'Weak Questions',
          subtitle: 'Retake missed questions to improve your score.',
          icon: 'assets/images/weak_questions.svg',
          iconBackgroundColor: const Color(0xFFFFC7C7)),
      QuestionGroupData(
          id: 'abc',
          title: 'Hardest Questions',
          subtitle: 'Practice commonly answered incorrectly questions.',
          icon: 'assets/images/hardest_questions.svg',
          iconBackgroundColor: const Color(0xFFD3F7FF)),
      QuestionGroupData(
          id: 'abc',
          title: 'Saved Questions',
          subtitle: 'Practice saved questions from lessons.',
          icon: 'assets/images/saved_questions.svg',
          iconBackgroundColor: const Color(0xFFFEEDD5)),
      QuestionGroupData(
          id: 'abc',
          title: 'Exam Simulator',
          subtitle: 'Customize the test according to your preferences.',
          icon: 'assets/images/exam_simulator.svg',
          iconBackgroundColor: const Color(0xFFDEEBFF)),
    ];

    return Scaffold(
      backgroundColor:
          AppTheme.isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: NewPracticeTab(
        groupList: groupList,
        isDarkMode: AppTheme.isDarkMode,
        onSelect: (id) => _handleOpenDialog(context, id),
      ),
    );
  }

  _handleOpenDialog(BuildContext context, String id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => QuestionCountDialog(
              isDarkMode: AppTheme.isDarkMode,
              onPracticeClick: (questions) => debugPrint(questions.toString()),
            ));
  }
}
