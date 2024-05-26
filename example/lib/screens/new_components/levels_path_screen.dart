import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLevelsPathScreen extends StatefulWidget {
  const TestLevelsPathScreen({super.key});

  @override
  State<TestLevelsPathScreen> createState() => _TestLevelsPathScreenState();
}

class _TestLevelsPathScreenState extends State<TestLevelsPathScreen> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _backgroundOffset;

  @override
  void initState() {
    _scrollController = ScrollController();
    _backgroundOffset = ValueNotifier<double>(0);

    _scrollController.addListener(
        () => _backgroundOffset.value = _scrollController.offset / 15);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _backgroundOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupList = <LevelGroup>[
      LevelGroup(
        'Life Science',
        'assets/images/path_start.png',
        const Color(0xFF3CC079),
        DrawType.nextLevel,
        [
          LevelData(title: 'Anatomy 1', progress: 85, isLock: false),
          LevelData(title: 'Ecology 1', progress: 65, isLock: false),
          LevelData(
            title: 'Botany 1',
            progress: 10,
            isLock: false,
            isCurrent: true,
          ),
          LevelData(title: 'Anatomy 2', progress: 0),
          LevelData(title: 'Anatomy 3', progress: 0),
          LevelData(title: 'Anatomy 4', progress: 0),
        ],
      ),
      LevelGroup(
        'Calculus',
        'assets/images/path_start.png',
        const Color(0xFFFF9669),
        DrawType.firstTimeOpen,
        [
          LevelData(
            title: 'Botany 1',
            progress: 0,
            isLock: false,
            isCurrent: true,
          ),
          LevelData(title: 'Anatomy 1', progress: 0),
          LevelData(title: 'Ecology 1', progress: 0),
          LevelData(title: 'Ecology 1', progress: 0),
          LevelData(title: 'Ecology 1', progress: 0),
        ],
      ),
    ];

    return PathLevelScreen(levelGroupList: groupList);
  }
}
