import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatefulWidget {
  const TestLevelsPathScreen({super.key});

  @override
  State<TestLevelsPathScreen> createState() => _TestLevelsPathScreenState();
}

class _TestLevelsPathScreenState extends State<TestLevelsPathScreen> {
  @override
  Widget build(BuildContext context) {
    final groupList = <LevelGroup>[
      LevelGroup(
        title: 'Life Science',
        startImage: 'assets/images/path_start_1.png',
        startColor: const Color(0xFF3CC079),
        drawType: DrawType.firstTimeOpen,
        levels: [
          LevelData(id: 'ABC', title: 'Anatomy 1', progress: 85, isLock: false),
          LevelData(id: 'ABC', title: 'Anatomy 3', progress: 0, isLock: false),
          LevelData(
            id: 'ABC',
            title: 'Botany 1',
            progress: 0,
            isLock: false,
            isCurrent: true,
          ),
          LevelData(id: 'ABC', title: 'Anatomy 4', progress: 0),
          LevelData(id: 'ABC', title: 'Anatomy 4', progress: 0),
          LevelData(id: 'ABC', title: 'Anatomy 4', progress: 0),
        ],
      ),
      LevelGroup(
        title: 'Calculus',
        startImage: 'assets/images/path_start_2.png',
        startColor: const Color(0xFFFF9669),
        drawType: DrawType.firstTimeOpen,
        levels: [
          LevelData(
              id: 'ABC',
              title: 'Botany 1',
              progress: 0,
              isLock: false,
              isCurrent: true),
          LevelData(id: 'ABC', title: 'Anatomy 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
        ],
      ),
      LevelGroup(
        title: 'Algebra',
        startImage: 'assets/images/path_start_3.png',
        startColor: const Color(0xFF2C9CB5),
        drawType: DrawType.firstTimeOpen,
        levels: [
          LevelData(
              id: 'ABC',
              title: 'Botany 1',
              progress: 0,
              isLock: false,
              isCurrent: true),
          LevelData(id: 'ABC', title: 'Anatomy 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
          LevelData(id: 'ABC', title: 'Ecology 1', progress: 0),
        ],
      ),
    ];

    return PathLevelScreen(
      isDarkMode: AppTheme.isDarkMode,
      upperRowCount: 2,
      lowerRowCount: 3,
      levelGroupList: groupList,
      title: 'General Science',
      onClickLevel: (id) => debugPrint(id),
    );
  }
}
