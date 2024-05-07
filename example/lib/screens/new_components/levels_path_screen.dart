import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatelessWidget {
  const TestLevelsPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int currentLevel1 = 1;
    final levelDataList1 = <LevelData>[
      LevelData(
          progress: 100,
          isLock: 0 > currentLevel1,
          isCurrent: 0 == currentLevel1,
          isFreeToday: false),
      LevelData(
          progress: 80,
          isLock: 1 > currentLevel1,
          isCurrent: 1 == currentLevel1,
          isFreeToday: false),
      LevelData(
          progress: 50,
          isLock: 2 > currentLevel1,
          isCurrent: 2 == currentLevel1,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel1,
          isCurrent: 3 == currentLevel1,
          isFreeToday: false),
    ];

    const int currentLevel2 = -1;
    final levelDataList2 = <LevelData>[
      LevelData(
          progress: 100,
          isLock: 0 > currentLevel2,
          isCurrent: 0 == currentLevel2,
          isFreeToday: false),
      LevelData(
          progress: 80,
          isLock: 1 > currentLevel2,
          isCurrent: 1 == currentLevel2,
          isFreeToday: false),
      LevelData(
          progress: 50,
          isLock: 2 > currentLevel2,
          isCurrent: 2 == currentLevel2,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel2,
          isCurrent: 3 == currentLevel2,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel2,
          isCurrent: 3 == currentLevel2,
          isFreeToday: false),
    ];

    const int currentLevel3 = -1;
    final levelDataList3 = <LevelData>[
      LevelData(
          progress: 100,
          isLock: 0 > currentLevel3,
          isCurrent: 0 == currentLevel3,
          isFreeToday: false),
      LevelData(
          progress: 80,
          isLock: 1 > currentLevel3,
          isCurrent: 1 == currentLevel3,
          isFreeToday: false),
      LevelData(
          progress: 50,
          isLock: 2 > currentLevel3,
          isCurrent: 2 == currentLevel3,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel3,
          isCurrent: 3 == currentLevel3,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel3,
          isCurrent: 3 == currentLevel3,
          isFreeToday: false),
      LevelData(
          progress: 85,
          isLock: 3 > currentLevel3,
          isCurrent: 3 == currentLevel3,
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
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: LevelsPath(
                type: OpenType.firstTime,
                isStarted: true,
                startImage: 'assets/images/path_start.png',
                finishImage: 'assets/images/path_finish.png',
                levelDataList: levelDataList1,
                drawSpeed: 300,
              ),
            ),
            // _buildDivider('Intermediate'),
            // LevelsPath(
            //   startImage: 'assets/images/path_start_1.png',
            //   finishImage: 'assets/images/path_finish_1.png',
            //   levelDataList: levelDataList2,
            //   drawSpeed: 300,
            //   isFirstTimeOpen: true,
            // ),
            // _buildDivider('Advanced'),
            // LevelsPath(
            //   startImage: 'assets/images/path_start_2.png',
            //   finishImage: 'assets/images/path_finish_2.png',
            //   levelDataList: levelDataList3,
            //   drawSpeed: 300,
            //   isFirstTimeOpen: true,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              fontFamily: 'Poppins',
              fontSize: 18),
        ),
        Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
      ],
    ),
  );
}
