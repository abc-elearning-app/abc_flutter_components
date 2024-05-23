import 'package:flutter/cupertino.dart';
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
  final int dummyListLength = 6;
  late List<UpdatedLevelData> levelList;

  final int upperRowCount = 1;
  final int lowerRoundCount = 2;

  // The shorter the faster
  final roundDrawSpeed = const Duration(milliseconds: 250);
  final lastRoundDrawSpeed = const Duration(milliseconds: 150);

  late int dashRoundCount;
  late int currentCycleCount;
  late int lastRoundDashLevelCount;
  late int lastCycleLevelCount;

  @override
  void initState() {
    // Create dummy list (instead of passing in)
    levelList = List.generate(
        dummyListLength,
        (index) => UpdatedLevelData(
            progress: index * 10, isCurrent: index == 2, isLock: index > 2));

    final endDashLevelLength = levelList.length;
    dashRoundCount = endDashLevelLength <= upperRowCount + lowerRoundCount
        ? 0
        : (endDashLevelLength % (upperRowCount + lowerRoundCount) == 0)
            ? endDashLevelLength ~/ (upperRowCount + lowerRoundCount) - 1
            : endDashLevelLength ~/ (upperRowCount + lowerRoundCount);

    final currentLevelLength =
        levelList.indexWhere((level) => level.isCurrent) + 1;
    currentCycleCount = currentLevelLength <= upperRowCount + lowerRoundCount
        ? 0
        : (currentLevelLength % (upperRowCount + lowerRoundCount) == 0)
            ? currentLevelLength ~/ (upperRowCount + lowerRoundCount) - 1
            : currentLevelLength ~/ (upperRowCount + lowerRoundCount);

    lastRoundDashLevelCount =
        endDashLevelLength - dashRoundCount * (upperRowCount + lowerRoundCount);
    lastCycleLevelCount = currentLevelLength -
        currentCycleCount * (upperRowCount + lowerRoundCount);

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
            title: const Text('ABC',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Stack(children: [
                  UpdatedPathAnimation(
                    drawType: DrawType.firstTimeOpen,
                    roundDrawSpeed: roundDrawSpeed,
                    lastRoundDrawSpeed: lastRoundDrawSpeed,
                    upperRowCount: upperRowCount,
                    lowerRoundCount: lowerRoundCount,
                    rounds: dashRoundCount,
                    lastCycleLevelCount: lastRoundDashLevelCount,
                    lineColor: const Color(0xFFF3EADA),
                  ),
                  FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 500)),
                    builder: (context, snapShot) =>
                        snapShot.connectionState == ConnectionState.done
                            ? UpdatedPathAnimation(
                                drawType: DrawType.firstTimeOpen,
                                roundDrawSpeed: roundDrawSpeed,
                                lastRoundDrawSpeed: lastRoundDrawSpeed,
                                upperRowCount: upperRowCount,
                                lowerRoundCount: lowerRoundCount,
                                rounds: currentCycleCount,
                                lastCycleLevelCount: lastCycleLevelCount,
                              )
                            : const SizedBox(),
                  ),
                  UpdatedLevelGrid(
                      drawType: DrawType.firstTimeOpen,
                      longRowCount: upperRowCount,
                      shortRowCount: lowerRoundCount,
                      levelDataList: levelList, isFirstTimeOpen: true,),
                ])),
          )),
    );
  }
}
