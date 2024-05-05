import 'package:flutter/material.dart';

import 'new_widgets/level_grid.dart';
import 'new_widgets/upgraded_path_animation.dart';

class LevelData {
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;

  LevelData(
      {required this.progress,
      this.isCurrent = false,
      this.isLock = true,
      this.isFreeToday = false});
}

class LevelsPath extends StatefulWidget {
  final int drawSpeed;
  final List<LevelData> levelDataList;

  const LevelsPath(
      {super.key, required this.levelDataList, this.drawSpeed = 250});

  @override
  State<LevelsPath> createState() => _LevelsPathState();
}

class _LevelsPathState extends State<LevelsPath> {
  // Number of items on long and short row
  final int longRowCount = 2;
  final int shortRowCount = 2;

  // The shorter the faster
  late Duration roundDrawSpeed;
  late Duration lastRoundDrawSpeed;

  final bool isFirstTimeOpen = true;

  // Additional data to draw
  late int dashRoundCount;
  late int lineRoundCount;
  late int lastRoundDashLevelCount;
  late int lastRoundLineCount;

  @override
  void initState() {
    roundDrawSpeed = Duration(milliseconds: widget.drawSpeed);
    lastRoundDrawSpeed =
        Duration(milliseconds: (widget.drawSpeed - 100).clamp(100, 500));

    // Calculate number of items to draw dash line
    final dashLevelLength = widget.levelDataList.length;
    dashRoundCount = dashLevelLength <= longRowCount + shortRowCount
        ? 0
        : (dashLevelLength % (longRowCount + shortRowCount) == 0)
            ? dashLevelLength ~/ (longRowCount + shortRowCount) - 1
            : dashLevelLength ~/ (longRowCount + shortRowCount);

    // Calculate number of items to draw progress line
    final progressLevelLength = widget.levelDataList.indexOf(
            widget.levelDataList.firstWhere((level) => level.isCurrent)) +
        1;
    lineRoundCount = progressLevelLength <= longRowCount + shortRowCount
        ? 0
        : (progressLevelLength % (longRowCount + shortRowCount) == 0)
            ? progressLevelLength ~/ (longRowCount + shortRowCount) - 1
            : progressLevelLength ~/ (longRowCount + shortRowCount);

    lastRoundDashLevelCount =
        dashLevelLength - dashRoundCount * (longRowCount + shortRowCount);
    lastRoundLineCount =
        progressLevelLength - lineRoundCount * (longRowCount + shortRowCount);

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
            title: const Text('Word Knowledge',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Stack(children: [
                  UpgradedPathAnimation(
                    lineColor: const Color(0xFFD6EFE8),
                    roundDrawSpeed: roundDrawSpeed,
                    lastRoundDrawSpeed: lastRoundDrawSpeed,
                    longRowCount: longRowCount,
                    shortRowCount: shortRowCount,
                    rounds: dashRoundCount,
                    isFirstTimeOpen: isFirstTimeOpen,
                    lastRoundLevelCount: lastRoundDashLevelCount,
                  ),
                  FutureBuilder(
                    future: Future.delayed(
                        Duration(milliseconds: isFirstTimeOpen ? 500 : 0)),
                    builder: (context, snapShot) =>
                        snapShot.connectionState == ConnectionState.done
                            ? UpgradedPathAnimation(
                                lineColor: const Color(0xFF579E89),
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
                  LevelGrid(
                      isFirstTimeOpen: isFirstTimeOpen,
                      longRowCount: longRowCount,
                      shortRowCount: shortRowCount,
                      levelDataList: widget.levelDataList),

                  Image.asset('assets/images/path_start.png'),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset('assets/images/path_finish.png')),
                ])),
          )),
    );
  }
}
