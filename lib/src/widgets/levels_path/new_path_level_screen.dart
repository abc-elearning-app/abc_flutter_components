import 'package:flutter/material.dart';

import 'new_widgets/level_grid.dart';
import 'new_widgets/path_animation.dart';

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
  final bool isStarted;
  final String startImage;
  final String finishImage;
  final int drawSpeed;
  final bool isFirstTimeOpen;
  final List<LevelData> levelDataList;

  const LevelsPath(
      {super.key,
      this.isStarted = false,
      required this.levelDataList,
      this.drawSpeed = 250,
      this.isFirstTimeOpen = true,
      required this.startImage,
      required this.finishImage});

  @override
  State<LevelsPath> createState() => _LevelsPathState();
}

class _LevelsPathState extends State<LevelsPath> {
  // Number of items on long and short row
  final int longRowCount = 2;
  final int shortRowCount = 2;

  final int rowItemCount = 2;

  // The shorter the faster
  late Duration roundDrawSpeed;
  late Duration lastRoundDrawSpeed;

  // Additional data to draw
  late int backgroundCycleCount;
  late int progressCycleCount;
  late int lastCycleBackgroundLevelCount;
  late int lastCycleProgressCount;

  @override
  void initState() {
    // Draw speed
    roundDrawSpeed = Duration(milliseconds: widget.drawSpeed);
    lastRoundDrawSpeed =
        Duration(milliseconds: (widget.drawSpeed - 100).clamp(100, 500));

    // Calculate number of items to draw background line
    final backgroundLevelLength = widget.levelDataList.length + 1;
    backgroundCycleCount = backgroundLevelLength <= longRowCount + shortRowCount
        ? 0
        : (backgroundLevelLength % (longRowCount + shortRowCount) == 0)
            ? backgroundLevelLength ~/ (longRowCount + shortRowCount) - 1
            : backgroundLevelLength ~/ (longRowCount + shortRowCount);

    // Calculate number of items to draw progress line
    final progressLevelLength = widget.levelDataList
            .where((element) => element.isCurrent)
            .isEmpty
        ? 0
        : widget.levelDataList.indexOf(
                widget.levelDataList.firstWhere((level) => level.isCurrent)) +
            2;
    progressCycleCount = progressLevelLength <= longRowCount + shortRowCount
        ? 0
        : (progressLevelLength % (longRowCount + shortRowCount) == 0)
            ? progressLevelLength ~/ (longRowCount + shortRowCount) - 1
            : progressLevelLength ~/ (longRowCount + shortRowCount);

    // Calculate last cycle's remaining levels
    lastCycleBackgroundLevelCount = backgroundLevelLength -
        backgroundCycleCount * (longRowCount + shortRowCount);
    lastCycleProgressCount = progressLevelLength -
        progressCycleCount * (longRowCount + shortRowCount);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Background path
      PathAnimation(
          lineColor: const Color(0xFFD6EFE8),
          roundDrawSpeed: roundDrawSpeed,
          lastRoundDrawSpeed: lastRoundDrawSpeed,
          longRowCount: longRowCount,
          shortRowCount: shortRowCount,
          cycles: backgroundCycleCount,
          remainingLevelCount: lastCycleBackgroundLevelCount,
          showAnimation: widget.isFirstTimeOpen,
          isBackground: true),

      // Progress path (Delay for smoother animation)
      FutureBuilder(
          future: Future.delayed(
              Duration(milliseconds: widget.isFirstTimeOpen ? 500 : 0)),
          builder: (context, snapShot) =>
              snapShot.connectionState == ConnectionState.done
                  ? PathAnimation(
                      lineColor: const Color(0xFF579E89),
                      roundDrawSpeed: roundDrawSpeed,
                      lastRoundDrawSpeed: lastRoundDrawSpeed,
                      longRowCount: longRowCount,
                      shortRowCount: shortRowCount,
                      cycles: progressCycleCount,
                      remainingLevelCount: lastCycleProgressCount,
                      showAnimation: widget.isFirstTimeOpen,
                      isBackground: false)
                  : const SizedBox()),

      // Levels
      LevelGrid(
          isStarted: widget.isStarted,
          drawSpeed: widget.drawSpeed,
          rowItemCount: rowItemCount,
          isFirstTimeOpen: widget.isFirstTimeOpen,
          levelDataList: widget.levelDataList),

      // Start and finish images
      Positioned(
          top: 0,
          left: 20,
          child: Transform.scale(
              scale: 1.2, child: Image.asset(widget.startImage))),

      Positioned(
          bottom: 0,
          right: widget.levelDataList.length % (2 * rowItemCount) < rowItemCount
              ? 20
              : null,
          child: Transform.scale(
              scale: 1.2, child: Image.asset(widget.finishImage))),
    ]);
  }
}
