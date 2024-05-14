import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestCustomizeTest extends StatelessWidget {
  const TestCustomizeTest({super.key});

  @override
  Widget build(BuildContext context) {
    final tmpList = <CustomizeSubjectData>[
      CustomizeSubjectData(icon: 'wrench', title: 'Arithmetic Reasoning'),
      CustomizeSubjectData(icon: 'wrench', title: 'Assembling Objects'),
      CustomizeSubjectData(icon: 'wrench', title: 'Auto and Shop Information'),
      CustomizeSubjectData(icon: 'wrench', title: 'Electronics Information'),
      CustomizeSubjectData(icon: 'wrench', title: 'General Science'),
      CustomizeSubjectData(icon: 'wrench', title: 'Mathematics Knowledge'),
      CustomizeSubjectData(icon: 'wrench', title: 'Mechanical Comprehension'),
      CustomizeSubjectData(icon: 'wrench', title: 'Paragraph Comprehension'),
      CustomizeSubjectData(icon: 'wrench', title: 'Word Knowledge'),
    ];

    final modes = <ModeData>[
      ModeData(
        'Newbie Mode',
        'Immediately after answering each question, the correct answers and explanations are displayed.',
      ),
      ModeData(
        'Expert Mode',
        'Only for expert, not normal people like you. Think very carefully when you select this mode !',
      ),
      ModeData(
        'Exam Mode',
        'Exam-like questions to simulate a real life exam',
      )
    ];

    return CustomizeTestWrapper(
      mainColor: const Color(0xFFE3A651),
      backgroundColor: const Color(0xFFF5F4EE),
      subjectIconColor: Colors.white,
      subjectIconBackgroundColor: const Color(0xFF7C6F5B),
      isPro: false,
      modes: modes,
      subjects: tmpList,
      onStart: (
        modeIndex,
        questionCount,
        duration,
        passingScore,
        subjectSelections,
      ) {
        print(
            '$modeIndex $questionCount $duration $passingScore ${subjectSelections.where((e) => e).length}');
      },
    );
  }
}
