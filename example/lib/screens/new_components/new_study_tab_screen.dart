import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewStudyTabScreen extends StatelessWidget {
  const TestNewStudyTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectDataList = <SubjectData>[
      SubjectData(
        'assets/images/subject_icon.svg',
        'Arithmetic Reasoning',
        22,
      ),
      SubjectData(
        'assets/images/subject_icon.svg',
        'Assembling Objects',
        50,
      ),
      SubjectData(
        'assets/images/subject_icon.svg',
        'Tư Tưởng Hồ Chí Minh',
        100,
      ),
      SubjectData(
        'assets/images/subject_icon.svg',
        'Gangnam Style',
        80,
      ),
      SubjectData(
        'assets/images/subject_icon.svg',
        'Mathematics Knowledge',
        30,
      ),
      SubjectData(
        'assets/images/subject_icon.svg',
        'Haz Mat',
        70,
      ),
    ];

    return Scaffold(
        backgroundColor: const Color(0xFFF5F4EE),
        body: SafeArea(
            child: NewStudyTab(
          buttonText: '',
          mainColor: const Color(0xFFE3A651),
          subjectDataList: subjectDataList,
          dayStreak: 14,
          passingProbability: 30,
          onClickTodayQuestion: () {},
        )));
  }
}
