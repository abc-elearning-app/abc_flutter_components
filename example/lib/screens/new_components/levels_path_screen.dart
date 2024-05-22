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

    return UpdatedPathLevelScreen();
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
