import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewPracticeTab extends StatelessWidget {
  const TestNewPracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final groupList = <QuestionGroupData>[
      QuestionGroupData(
          title: 'Random Questions',
          subtitle: 'Select questions randomly from the question bank.',
          icon: 'assets/images/random_questions.svg',
          iconBackgroundColor: const Color(0xFFBAE8DB),
          onClick: () => _handleOpenDialog(context)
        ),
        QuestionGroupData(
          title: 'Weak Questions',
          subtitle: 'Retake missed questions to improve your score.',
          icon: 'weak_questions',
          iconBackgroundColor: const Color(0xFFFFC7C7),
          onClick: () => _handleOpenDialog(context)
        ),
        QuestionGroupData(
          title: 'Hardest Questions',
          subtitle: 'Practice commonly answered incorrectly questions.',
          icon: 'hardest_questions',
          iconBackgroundColor: const Color(0xFFD3F7FF),
          onClick: () => _handleOpenDialog(context)
        ),
        QuestionGroupData(
          title: 'Saved Questions',
          subtitle: 'Practice saved questions from lessons.',
          icon: 'saved_questions',
          iconBackgroundColor: const Color(0xFFFEEDD5),
          onClick: () => _handleOpenDialog(context)
        ),
        QuestionGroupData(
          title: 'Exam Simulator',
          subtitle: 'Customize the test according to your preferences.',
          icon: 'exam_simulator',
          iconBackgroundColor: const Color(0xFFDEEBFF),
          onClick: () => _handleOpenDialog(context)
        ),
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
