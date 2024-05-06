import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatelessWidget {
  const TestLevelsPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentLevel = 1;
    final levelDataList = <LevelData>[
      LevelData(
          progress: 100,
          isLock: 0 > currentLevel,
          isCurrent: 0 == currentLevel,
          isFreeToday: false),
      LevelData(
          progress: 80,
          isLock: 1 > currentLevel,
          isCurrent: 1 == currentLevel,
          isFreeToday: false),
      LevelData(
          progress: 50,
          isLock: 2 > currentLevel,
          isCurrent: 2 == currentLevel,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel,
          isCurrent: 3 == currentLevel,
          isFreeToday: false),

    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEEFFFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Word Knowledge',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            )),
      ),
      body: SingleChildScrollView(
        child: LevelsPath(
          levelDataList: levelDataList,
          drawSpeed: 300,
          isFirstTimeOpen: true,
        ),
      ),
    );
  }
}
