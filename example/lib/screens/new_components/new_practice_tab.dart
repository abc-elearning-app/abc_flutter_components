import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewPracticeTab extends StatelessWidget {
  const TestNewPracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final groupList = <QuestionGroupData>[
      QuestionGroupData(
          'Random Questions',
          'Select questions randomly from the question bank.',
          'random_questions',
          iconBackgroundColor: const Color(0xFFBAE8DB),
          () => _handleOpenDialog(context)),
      QuestionGroupData(
          'Weak Questions',
          'Retake missed questions to improve your score.',
          'weak_questions',
          iconBackgroundColor: const Color(0xFFFFC7C7),
          () => _handleOpenDialog(context)),
      QuestionGroupData(
          'Hardest Questions',
          'Practice commonly answered incorrectly questions.',
          'hardest_questions',
          iconBackgroundColor: const Color(0xFFD3F7FF),
          () => _handleOpenDialog(context)),
      QuestionGroupData(
          'Saved Questions',
          'Practice saved questions from lessons.',
          'saved_questions',
          iconBackgroundColor: const Color(0xFFFEEDD5),
          () => _handleOpenDialog(context)),
      QuestionGroupData(
          'Exam Simulator',
          'Customize the test according to your preferences.',
          'exam_simulator',
          iconBackgroundColor: const Color(0xFFDEEBFF),
          () {}),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F4EE)),
      body: NewPracticeTab(
        groupList: groupList,
      ),
    );
  }

  _handleOpenDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Wrap(children: [QuestionCountDialog()]));
  }
}
