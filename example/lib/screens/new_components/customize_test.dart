import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestCustomizeTest extends StatelessWidget {
  const TestCustomizeTest({super.key});

  @override
  Widget build(BuildContext context) {
    final tmpList = <CustomizeSubjectData>[
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Arithmetic Reasoning',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Assembling Objects',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Auto and Shop Information',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Electronics Information',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'General Science',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Mathematics Knowledge',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Mechanical Comprehension',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Paragraph Comprehension',
      ),
      CustomizeSubjectData(
        icon: 'assets/images/subject_icon_0.svg',
        title: 'Word Knowledge',
      ),
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
      isDarkMode: AppTheme.isDarkMode,
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
