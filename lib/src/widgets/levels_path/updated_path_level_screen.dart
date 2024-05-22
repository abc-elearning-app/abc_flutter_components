import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/updated_widgets/updated_path_animation.dart';

import 'updated_widgets/updated_level_grid.dart';

class UpdatedLevelData {
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;

  UpdatedLevelData(
      {required this.progress,
      this.isCurrent = false,
      this.isLock = true,
      this.isFreeToday = false});
}

class UpdatedPathLevelScreen extends StatefulWidget {
  const UpdatedPathLevelScreen({super.key});

  @override
  State<UpdatedPathLevelScreen> createState() => _UpdatedPathLevelScreenState();
}

class _UpdatedPathLevelScreenState extends State<UpdatedPathLevelScreen> {
  final int dummyListLength = 20;
  late List<UpdatedLevelData> levelDataList;

  final int longRowCount = 2;
  final int shortRowCount = 3;

  // The shorter the faster
  final roundDrawSpeed = const Duration(milliseconds: 250);
  final lastRoundDrawSpeed = const Duration(milliseconds: 150);

  final bool isFirstTimeOpen = true;

  late int dashRoundCount;
  late int lineRoundCount;
  late int lastRoundDashLevelCount;
  late int lastRoundLineCount;

  @override
  void initState() {
    // Create dummy list (instead of passing in)
    levelDataList = List.generate(
        dummyListLength,
        (index) => UpdatedLevelData(
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

    print('$endDashLevelLength - $endLineLevelLength');

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
                    // UpdatedPathAnimation(
                    //   roundDrawSpeed: roundDrawSpeed,
                    //   lastRoundDrawSpeed: lastRoundDrawSpeed,
                    //   longRowCount: longRowCount,
                    //   shortRowCount: shortRowCount,
                    //   rounds: dashRoundCount,
                    //   isDash: true,
                    //   isFirstTimeOpen: isFirstTimeOpen,
                    //   lastRoundLevelCount: lastRoundDashLevelCount,
                    // ),
                    FutureBuilder(
                      future: Future.delayed(
                          Duration(milliseconds: isFirstTimeOpen ? 500 : 0)),
                      builder: (context, snapShot) =>
                          snapShot.connectionState == ConnectionState.done
                              ? UpdatedPathAnimation(
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
                    UpdatedLevelGrid(
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
