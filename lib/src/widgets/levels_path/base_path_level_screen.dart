import 'package:flutter/material.dart';

import 'base_widgets/base_level_grid.dart';
import 'base_widgets/base_path_animation.dart';

class DefaultLevelData {
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;

  DefaultLevelData(
      {required this.progress,
      this.isCurrent = false,
      this.isLock = true,
      this.isFreeToday = false});
}

class NewPathLevelScreen extends StatefulWidget {
  const NewPathLevelScreen({super.key});

  @override
  State<NewPathLevelScreen> createState() => _NewPathLevelScreenState();
}

class _NewPathLevelScreenState extends State<NewPathLevelScreen> {
  final int dummyListLength = 20;
  late List<DefaultLevelData> levelDataList;

  final int longRowCount = 3;
  final int shortRowCount = 2;

  // The shorter the faster
  final roundDrawSpeed = const Duration(milliseconds: 250);
  final lastRoundDrawSpeed = const Duration(milliseconds: 150);

  final bool isFirstTimeOpen = false;

  late int dashRoundCount;
  late int lineRoundCount;
  late int lastRoundDashLevelCount;
  late int lastRoundLineCount;

  @override
  void initState() {
    // Create dummy list (instead of passing in)
    levelDataList = List.generate(
        dummyListLength,
        (index) => DefaultLevelData(
            progress: index * 10, isCurrent: index == 10, isLock: index > 10));

    final endDashLevelLength = levelDataList.length;
    dashRoundCount = endDashLevelLength <= longRowCount + shortRowCount
        ? 0
        : (endDashLevelLength % (longRowCount + shortRowCount) == 0)
            ? endDashLevelLength ~/ (longRowCount + shortRowCount) - 1
            : endDashLevelLength ~/ (longRowCount + shortRowCount);

    final endLineLevelLength = levelDataList
            .indexOf(levelDataList.firstWhere((level) => level.isCurrent)) +
        1;
    lineRoundCount = endLineLevelLength <= longRowCount + shortRowCount
        ? 0
        : (endLineLevelLength % (longRowCount + shortRowCount) == 0)
            ? endLineLevelLength ~/ (longRowCount + shortRowCount) - 1
            : endLineLevelLength ~/ (longRowCount + shortRowCount);

    lastRoundDashLevelCount =
        endDashLevelLength - dashRoundCount * (longRowCount + shortRowCount);
    lastRoundLineCount =
        endLineLevelLength - lineRoundCount * (longRowCount + shortRowCount);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Vuờn cà chua của Đại',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Transform.scale(
                  scale: 0.9,
                  child: Stack(children: [
                    BasePathAnimation(
                      roundDrawSpeed: roundDrawSpeed,
                      lastRoundDrawSpeed: lastRoundDrawSpeed,
                      longRowCount: longRowCount,
                      shortRowCount: shortRowCount,
                      rounds: dashRoundCount,
                      isDash: true,
                      isFirstTimeOpen: isFirstTimeOpen,
                      lastRoundLevelCount: lastRoundDashLevelCount,
                    ),
                    FutureBuilder(
                      future: Future.delayed(
                          Duration(milliseconds: isFirstTimeOpen ? 500 : 0)),
                      builder: (context, snapShot) =>
                          snapShot.connectionState == ConnectionState.done
                              ? BasePathAnimation(
                                  roundDrawSpeed: roundDrawSpeed,
                                  lastRoundDrawSpeed: lastRoundDrawSpeed,
                                  longRowCount: longRowCount,
                                  shortRowCount: shortRowCount,
                                  rounds: lineRoundCount,
                                  isFirstTimeOpen: isFirstTimeOpen,
                                  lastRoundLevelCount: lastRoundLineCount,
                                )
                              : const SizedBox(),
                    ),
                    BaseLevelGrid(
                        isFirstTimeOpen: isFirstTimeOpen,
                        longRowCount: longRowCount,
                        shortRowCount: shortRowCount,
                        levelDataList: levelDataList),
                  ]),
                )),
          )),
    );
  }
}
