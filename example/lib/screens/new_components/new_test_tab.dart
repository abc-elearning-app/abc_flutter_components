import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewTestTab extends StatelessWidget {
  const TestNewTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceTest = [
      PracticeTestData(
        0,
        'Arithmetic Reasoning',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_practice_1.png',
      ),
      PracticeTestData(
        0,
        'Assembling Objects',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_practice_2.png',
      ),
      PracticeTestData(
        0,
        'Haz Mat',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_practice_1.png',
      ),
      PracticeTestData(
        0,
        'Chemistry',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_practice_2.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppTheme.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: NewTestTab(
        isDarkMode: AppTheme.isDarkMode,
        practiceTests: practiceTest,
        diagnosticProgress: 20,
        finalTestProgress: 40,
        onTryAgainDiagnosticTab: () => print('try again'),
        onSeeAll: () => print('see all'),
        onClickFinalTest: () => print('final test'),
        onSeeAllPracticeTests: () => print('see all practice test'),
        onSelectPracticeTest: (index) => print('Practice test $index'),
      ),
    );
  }
}
