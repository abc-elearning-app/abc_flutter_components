import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewTestTab extends StatelessWidget {
  const TestNewTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceTest = [
      TopicData(
        id: 0,
        title: 'Arithmetic Reasoning',
        icon: 'assets/images/subject_icon.svg',
        background: 'assets/images/test_tab_practice_1.png',
      ),
      TopicData(
        id: 0,
        title: 'Assembling Objects',
        icon: 'assets/images/subject_icon.svg',
        background: 'assets/images/test_tab_practice_2.png',
      ),
      TopicData(
        id: 0,
        title: 'Haz Mat',
        icon: 'assets/images/subject_icon.svg',
        background: 'assets/images/test_tab_practice_1.png',
      ),
      TopicData(
        id: 0,
        title: 'Chemistry',
        icon: 'assets/images/subject_icon.svg',
        background: 'assets/images/test_tab_practice_2.png',
      ),
    ];
    return Scaffold(
      backgroundColor: AppTheme.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: NewTestTab(
        isDarkMode: AppTheme.isDarkMode,
        topics: practiceTest,
        diagnosticProgress: 20,
        finalTestProgress: 40,
        onTryAgainDiagnosticTab: () => print('try again'),
        onSeeAll: () => print('see all'),
        onClickFinalTest: () => print('final test'),
        // onSeeAllPracticeTests: () => print('see all practice test'),
        onSelectItem: (index) => print('Practice test $index'),
      ),
    );
  }
}
