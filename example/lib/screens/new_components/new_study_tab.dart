import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../../constants/app_themes.dart';

class TestNewStudyTabScreen extends StatelessWidget {
  const TestNewStudyTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectDataList = <SubjectData>[
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Arithmetic Reasoning',
        progress: 18,
      ),
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Assembling Objects',
        progress: 19,
      ),
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Tư Tưởng Hồ Chí Minh',
        progress: 40,
      ),
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Gangnam Style',
        progress: 80,
      ),
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Mathematics Knowledge',
        progress: 30,
      ),
      SubjectData(
        id: '',
        icon: 'assets/images/subject_icon.svg',
        title: 'Haz Mat',
        progress: 70,
      ),
    ];

    return Scaffold(
        backgroundColor:
            AppTheme.isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
        body: SafeArea(
            child: NewStudyTab(
          isDarkMode: AppTheme.isDarkMode,
          subjectDataList: subjectDataList,
          dayStreak: 14,
          passingProbability: 30,
          onClickDailyChallenge: () => debugPrint("Daily challenge"),
          onSelectSubject: (id) => debugPrint(id),
        )));
  }
}
