import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestDiagnosticScreen extends StatelessWidget {
  const TestDiagnosticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectDataList = <SubjectResultData>[
      SubjectResultData(
        title: 'Electrical Engineering',
        progress: 70,
        icon: 'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        title: 'Arithmetic Reasoning',
        progress: 10,
        icon: 'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        title: 'Electrical Engineering',
        progress: 60,
        icon: 'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        title: 'Haz Mat',
        progress: 90,
        icon: 'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        title: 'Arithmetic Reasoning',
        progress: 20,
        icon: 'assets/images/subject_icon.svg',
      ),
    ];

    return DiagnosticResult(
      mainProgress: 60,
      subjectList: subjectDataList,
      onNext: () => Navigator.of(context).pop(),
      testDate: DateTime.now(),
      isDarkMode: AppTheme.isDarkMode,
    );
  }
}
