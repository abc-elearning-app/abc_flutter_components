import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/level_grid.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/path_animation.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/start_image.dart';

class LevelData {
  String id;
  String title;
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;
  String icon;

  LevelData(
      {required this.id,
      required this.title,
      required this.progress,
      this.icon = 'assets/images/topic_icon_0.svg',
      this.isCurrent = false,
      this.isLock = true,
      this.isFreeToday = false});
}

class PathLevel extends StatefulWidget {
  final List<LevelData> levelList;
  final DrawType drawType;

  // Arrangement
  final int upperRowCount;
  final int lowerRowCount;

  // Draw speed
  final Duration cycleSpeed;
  final Duration lastCycleSpeed;

  // Colors
  final Color mainColor;
  final Color passColor;
  final Color lockColor;
  final Color startColor;
  final Color lineColor;
  final Color lineBackgroundColor;

  // Images
  final String startImage;
  final String finalLevelImage;

  final bool isFirstGroup;

  final bool isDarkMode;

  final void Function(String id) onClickLevel;

  const PathLevel({
    super.key,
    required this.levelList,
    required this.drawType,
    required this.upperRowCount,
    required this.lowerRowCount,
    required this.cycleSpeed,
    required this.lastCycleSpeed,
    required this.startImage,
    required this.startColor,
    required this.finalLevelImage,
    required this.isFirstGroup,
    required this.mainColor,
    required this.passColor,
    required this.lockColor,
    required this.lineColor,
    required this.lineBackgroundColor,
    required this.onClickLevel,
    required this.isDarkMode,
  });

  @override
  State<PathLevel> createState() => _PathLevelState();
}

class _PathLevelState extends State<PathLevel> {
  late int totalCycleCount;
  late int currentCycleCount;
  late int lastCycleTotalCount;
  late int lastCycleCurrentCount;

  @override
  void initState() {
    _calculateData();
    super.initState();
  }

  _calculateData() {
    final upperRowCount = widget.upperRowCount;
    final lowerRowCount = widget.lowerRowCount;
    final groupCount = upperRowCount + lowerRowCount;

    final totalLength = widget.levelList.length;
    totalCycleCount = totalLength > groupCount
        ? totalLength ~/ groupCount - (totalLength % groupCount == 0 ? 1 : 0)
        : 0;

    final currentLength =
        widget.levelList.indexWhere((level) => level.isCurrent) + 1;
    currentCycleCount = currentLength > groupCount
        ? currentLength ~/ groupCount -
            (currentLength % groupCount == 0 ? 1 : 0)
        : 0;

    lastCycleTotalCount = totalLength - totalCycleCount * groupCount;
    lastCycleCurrentCount = currentLength - currentCycleCount * groupCount;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Start image
      PathStartImage(drawType: widget.drawType, imagePath: widget.startImage),

      PathAnimation(
          drawType: widget.drawType == DrawType.nextLevel
              ? DrawType.noAnimation
              : widget.drawType,
          roundDrawSpeed: widget.cycleSpeed,
          lastCycleDrawSpeed: widget.lastCycleSpeed,
          upperRowCount: widget.upperRowCount,
          lowerRoundCount: widget.lowerRowCount,
          rounds: totalCycleCount,
          lastCycleLevelCount: lastCycleTotalCount,
          lineColor: widget.lineBackgroundColor),

      FutureBuilder(
          future: Future.delayed(Duration(
              milliseconds:
                  widget.drawType == DrawType.firstTimeOpen ? 500 : 0)),
          builder: (context, snapShot) =>
              snapShot.connectionState == ConnectionState.done
                  ? PathAnimation(
                      drawType: widget.drawType,
                      roundDrawSpeed: widget.cycleSpeed,
                      lastCycleDrawSpeed: widget.lastCycleSpeed,
                      upperRowCount: widget.upperRowCount,
                      lowerRoundCount: widget.lowerRowCount,
                      rounds: currentCycleCount,
                      lastCycleLevelCount: lastCycleCurrentCount,
                      lineColor: widget.lineColor)
                  : const SizedBox()),

      LevelGrid(
          isDarkMode: widget.isDarkMode,
          drawType: widget.drawType,
          drawSpeed: widget.cycleSpeed,
          longRowCount: widget.upperRowCount,
          shortRowCount: widget.lowerRowCount,
          levelDataList: widget.levelList,
          finalLevelImage: widget.finalLevelImage,
          startColor: widget.startColor,
          isFirstGroup: widget.isFirstGroup,
          mainColor: widget.mainColor,
          passColor: widget.passColor,
          lockColor: widget.lockColor,
          onClickLevel: widget.onClickLevel),
    ]);
  }
}
