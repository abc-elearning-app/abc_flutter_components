import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPracticeTestGrid extends StatelessWidget {
  const TestPracticeTestGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceTests = <PracticeTestGridData>[
      PracticeTestGridData('Practice Test 1', 48, 60, 86,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 24, 60, 86,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 60, 70, 86,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 48, 60, 90,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 30, 40, 75,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 48, 50, 86,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 60, 60, 100,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 48, 60, 86,
          'assets/images/practice_test_background.png'),
      PracticeTestGridData('Practice Test 1', 48, 60, 86,
          'assets/images/practice_test_background.png'),
    ];

    return PracticeTestGrid(
      title: 'Arithmetic Reasoning',
      practiceTests: practiceTests,
      onSelected: (index) => print(index),
    );
  }
}
