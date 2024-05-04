import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestExamSetupTime extends StatelessWidget {
  const TestExamSetupTime({super.key});

  @override
  Widget build(BuildContext context) {
    final pageImages = [
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_1_1.png'),
          Image.asset('assets/images/exam_date_1_2.png'),
        ],
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_3_1.png'),
          Image.asset('assets/images/exam_date_3_2.png'),
        ],
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_4_1.png'),
          Image.asset('assets/images/exam_date_4_2.png'),
        ],
      ),
    ];

    return ExamTimeSelectPages(
        showBackButton: true,
        pageImages: pageImages,
        onStartDiagnostic: () => print('onStartDiagnostic'),
        onSkipDiagnostic: () => print('onStartDiagnostic'),
        onSelectExamDate: (date) => print(date),
        onSelectReminderTime: (time) => print(time));
  }
}
