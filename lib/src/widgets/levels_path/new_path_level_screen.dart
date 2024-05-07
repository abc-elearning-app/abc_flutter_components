import 'package:flutter/material.dart';

import 'new_widgets/level_grid.dart';
import 'new_widgets/path_animation.dart';

enum OpenType { firstTime, nextLevel, normal }

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
  final OpenType type;
  final bool isStarted;
  final String startImage;
  final String finishImage;
  final int drawSpeed;
  final List<LevelData> levelDataList;

  const LevelsPath(
      {super.key,
      this.isStarted = false,
      this.drawSpeed = 250,
      required this.levelDataList,
      required this.startImage,
      required this.finishImage,
      required this.type});

  @override
  State<LevelsPath> createState() => _LevelsPathState();
}

class _LevelsPathState extends State<LevelsPath> {
  // Item count in a row
  final int rowItemCount = 2;

  // The shorter the faster
  late Duration roundDrawSpeed;
  late Duration lastRoundDrawSpeed;

  // Additional data to draw
  late int backgroundCycleCount;
  late int progressCycleCount;
  late int lastCycleBackgroundCount;
  late int lastCycleProgressCount;

  @override
  void initState() {
    // Draw speed
    roundDrawSpeed = Duration(milliseconds: widget.drawSpeed);
    lastRoundDrawSpeed =
        Duration(milliseconds: (widget.drawSpeed - 100).clamp(100, 500));

    // Calculate background's cycles
    final backgroundLevelLength = widget.levelDataList.length + 1;
    backgroundCycleCount = _calculateCycleCount(backgroundLevelLength);

    // Calculate progress's cycles
    if (widget.isStarted) {
      final progressLevelLength = widget.levelDataList.indexOf(
              widget.levelDataList.firstWhere((level) => level.isCurrent)) +
          2;
      progressCycleCount = _calculateCycleCount(progressLevelLength);

      // Progress's last cycle's remaining levels
      lastCycleProgressCount =
          progressLevelLength - progressCycleCount * (rowItemCount * 2);
    }

    // Background's last cycle's remaining levels
    lastCycleBackgroundCount =
        backgroundLevelLength - backgroundCycleCount * (rowItemCount * 2);

    super.initState();
  }

  _calculateCycleCount(int length) => length > rowItemCount * 2
      ? (length % (rowItemCount * 2) == 0)
          ? length ~/ (rowItemCount * 2) - 1
          : length ~/ (rowItemCount * 2)
      : 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Background path
      PathAnimation(
          type: OpenType.firstTime,
          lineColor: const Color(0xFFD6EFE8),
          roundDrawSpeed: roundDrawSpeed,
          lastRoundDrawSpeed: lastRoundDrawSpeed,
          cycles: backgroundCycleCount,
          remainingLevelCount: lastCycleBackgroundCount,
          rowItemCount: rowItemCount),

      // Progress path (Delay for smoother animation)
      // if (widget.isStarted)
      //   FutureBuilder(
      //       future: Future.delayed(
      //           Duration(milliseconds: widget.isFirstTimeOpen ? 500 : 0)),
      //       builder: (context, snapShot) =>
      //           snapShot.connectionState == ConnectionState.done
      //               ? PathAnimation(
      //                   lineColor: const Color(0xFF579E89),
      //                   roundDrawSpeed: roundDrawSpeed,
      //                   lastRoundDrawSpeed: lastRoundDrawSpeed,
      //                   cycles: progressCycleCount,
      //                   remainingLevelCount: lastCycleProgressCount,
      //                   showAnimation: widget.isFirstTimeOpen,
      //                   rowItemCount: rowItemCount,
      //                   isBackground: true)
      //               : const SizedBox()),

      // Levels
      // LevelGrid(
      //     isStarted: widget.isStarted,
      //     drawSpeed: widget.drawSpeed,
      //     rowItemCount: rowItemCount,
      //     isFirstTimeOpen: widget.isFirstTimeOpen,
      //     levelDataList: widget.levelDataList),

      // Start and finish images
      Positioned(top: 0, left: 20, child: Image.asset(widget.startImage)),

      Positioned(top: 250, right: 0, child: Image.asset(widget.finishImage)),
    ]);
  }
}
