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
          const Color(0xFFBAE8DB),
          () => print('Random Questions')),
      QuestionGroupData(
          'Weak Questions',
          'Retake missed questions to improve your score.',
          'weak_questions',
          const Color(0xFFFFC7C7),
          () => print('Weak Questions')),
      QuestionGroupData(
          'Hardest Questions',
          'Practice commonly answered incorrectly questions.',
          'hardest_questions',
          const Color(0xFFD3F7FF),
          () => print('Hardest Questions')),
      QuestionGroupData(
          'Saved Questions',
          'Practice saved questions from lessons.',
          'saved_questions',
          const Color(0xFFFEEDD5),
          () => print('Saved Questions')),
      QuestionGroupData(
          'Exam Simulator',
          'Customize the test according to your preferences.',
          'exam_simulator',
          const Color(0xFFDEEBFF),
          () => _handleOpenDialog(context)),
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
