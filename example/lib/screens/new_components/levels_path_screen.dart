import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatelessWidget {
  const TestLevelsPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levelDataList = <LevelData>[
      LevelData(progress: 60, isLock: false, isCurrent: false, isFreeToday: false),
      LevelData(progress: 80, isLock: false, isCurrent: false, isFreeToday: false),
      LevelData(progress: 50, isLock: false, isCurrent: false, isFreeToday: false),
      LevelData(progress: 10, isLock: false, isCurrent: false, isFreeToday: false),
      LevelData(progress: 100, isLock: false, isCurrent: false, isFreeToday: false),
      LevelData(progress: 0, isLock: false, isCurrent: true, isFreeToday: false),
      LevelData(progress: 0, isLock: true, isCurrent: false, isFreeToday: false),
      LevelData(progress: 0, isLock: true, isCurrent: false, isFreeToday: false),
      LevelData(progress: 0, isLock: true, isCurrent: false, isFreeToday: false),
      LevelData(progress: 0, isLock: true, isCurrent: false, isFreeToday: false),
      // LevelData(progress: 0, isLock: true, isCurrent: false, isFreeToday: false),
    ];
    return LevelsPath(levelDataList: levelDataList);
  }
}
