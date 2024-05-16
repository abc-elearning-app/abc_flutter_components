import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewTestTab extends StatelessWidget {
  const TestNewTestTab({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceTest = [
      PracticeTestBoxData(
        0,
        'Arithmetic Reasoning',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_background_2.png',
      ),
      PracticeTestBoxData(
        0,
        'Assembling Objects',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_background_3.png',
      ),
      PracticeTestBoxData(
        0,
        'Haz Mat',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_background_2.png',
      ),
      PracticeTestBoxData(
        0,
        'Chemistry',
        'assets/images/subject_icon.svg',
        'assets/images/test_tab_background_3.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: NewTestTab(practiceTests: practiceTest),
    );
  }
}
