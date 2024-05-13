import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestDiagnosticScreen extends StatelessWidget {
  const TestDiagnosticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectDataList = <SubjectResultData>[
      SubjectResultData(
        'Electrical Engineering',
        70,
        'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        'Arithmetic Reasoning',
        10,
        'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        'Electrical Engineering',
        60,
        'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        'Haz Mat',
        90,
        'assets/images/subject_icon.svg',
      ),
      SubjectResultData(
        'Arithmetic Reasoning',
        20,
        'assets/images/subject_icon.svg',
      ),
    ];

    return DiagnosticResult(
        subjectList: subjectDataList,
        onNext: () => print('onNext'),
        testDate: DateTime.now(),
        mainProgress: 90);
  }
}
