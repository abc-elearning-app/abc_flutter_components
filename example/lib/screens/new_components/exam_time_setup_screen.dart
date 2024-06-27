import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestExamSetupTime extends StatelessWidget {
  const TestExamSetupTime({super.key});

  @override
  Widget build(BuildContext context) {
    final pageImages = [
      'assets/images/exam_setup_1.png',
      'assets/images/exam_setup_2.png',
      'assets/images/exam_setup_3.png',
    ];

    return ExamTimeSetupPages(
      pageImages: pageImages,
      onStartDiagnostic: () => Navigator.of(context).pop(),
      onSkipDiagnostic: () => print('onStartDiagnostic'),
      onSelectExamDate: (date) => print(date),
      onSelectReminderTime: (time) => print(time),
      isDarkMode: AppTheme.isDarkMode, pageImagesDark: [],
    );
  }
}
