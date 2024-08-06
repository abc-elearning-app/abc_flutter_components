import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/level_grid.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/path_animation_2.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/start_image.dart';

class LevelData {
  int id;
  String title;
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;
  bool passed;
  bool isPlaying;
  int lastUpdate;
  String icon;

  LevelData({
    required this.id,
    required this.title,
    required this.progress,
    required this.icon,
    this.isCurrent = false,
    this.isLock = true,
    this.isFreeToday = false,
    this.passed = false,
    this.isPlaying = false,
    this.lastUpdate = -1,
  });
}

class PathLevelComponent extends StatefulWidget {
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
  final Color lineBackgroundColor;

  // Images
  final String startImage;
  final String finalLevelImage;
  final String finalLevelAnimation;

  final bool isGroupFocused;
  final bool isDarkMode;
  final bool hasSubTopic;

  final void Function(int id) onClickLevel;
  final void Function() onClickLockLevel;
  final void Function(int id) onClickFinishedLevel;

  const PathLevelComponent({
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
    required this.mainColor,
    required this.passColor,
    required this.lockColor,
    required this.lineBackgroundColor,
    required this.onClickLevel,
    required this.isDarkMode,
    required this.finalLevelAnimation,
    required this.isGroupFocused,
    required this.onClickLockLevel,
    required this.hasSubTopic,
    required this.onClickFinishedLevel,
  });

  @override
  State<PathLevelComponent> createState() => _PathLevelComponentState();
}

class _PathLevelComponentState extends State<PathLevelComponent> with AutomaticKeepAliveClientMixin {
  late int totalCycleCount;
  late int currentCycleCount;
  late int lastCycleTotalCount;
  late int lastCycleCurrentCount;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _calculateData();
    super.initState();
  }

  _calculateData() {
    final groupCount = widget.upperRowCount + widget.lowerRowCount;

    final totalLength = widget.levelList.length;
    totalCycleCount = totalLength > groupCount ? totalLength ~/ groupCount - (totalLength % groupCount == 0 ? 1 : 0) : 0;

    int currentLength = widget.levelList.indexWhere((level) => level.isCurrent) + 1;
    // int currentLength = widget.levelGroupType == LevelGroupType.passed
    //     ? totalLength
    //     : widget.levelGroupType == LevelGroupType.upcoming
    //         ? 0
    //         : widget.levelList.indexWhere((level) => level.isCurrent) + 1;
    // if (currentLength == 0) currentLength = widget.levelList.length;
    currentCycleCount = currentLength > groupCount ? currentLength ~/ groupCount - (currentLength % groupCount == 0 ? 1 : 0) : 0;

    lastCycleTotalCount = totalLength - totalCycleCount * groupCount;
    lastCycleCurrentCount = currentLength - currentCycleCount * groupCount;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    int currentLevelPosition = 0;
    if (widget.levelList.length == 2) {
      if (widget.levelList.where((level) => level.isCurrent).isNotEmpty) {
        currentLevelPosition = widget.levelList[0].isCurrent ? 1 : 2;
      }
      // if (widget.levelGroupType == LevelGroupType.passed) currentLevelPosition = 2;
    }

    return Stack(children: [
      // Start image
      if (widget.levelList.length != 2 && widget.levelList.length != 1) PathStartImage(drawType: widget.drawType, imagePath: widget.startImage),

      if (widget.levelList.length != 2)
        PathAnimation(
            drawType: widget.drawType == DrawType.nextLevel ? DrawType.noAnimation : widget.drawType,
            cycleDrawSpeed: widget.cycleSpeed,
            lastCycleDrawSpeed: widget.lastCycleSpeed,
            upperRowCount: widget.upperRowCount,
            lowerRoundCount: widget.lowerRowCount,
            cycles: totalCycleCount,
            lastCycleLevelCount: lastCycleTotalCount,
            lineColor: widget.lineBackgroundColor),

      if (widget.levelList.length != 2
          // && widget.levelGroupType != LevelGroupType.upcoming
          )
        FutureBuilder(
            future: Future.delayed(Duration(milliseconds: widget.drawType == DrawType.firstTimeOpen ? 500 : 0)),
            builder: (context, snapShot) => snapShot.connectionState == ConnectionState.done
                ? PathAnimation(
                    drawType: widget.drawType,
                    cycleDrawSpeed: widget.cycleSpeed,
                    lastCycleDrawSpeed: widget.lastCycleSpeed,
                    upperRowCount: widget.upperRowCount,
                    lowerRoundCount: widget.lowerRowCount,
                    cycles: currentCycleCount,
                    lastCycleLevelCount: lastCycleCurrentCount,
                    lineColor: widget.mainColor)
                : const SizedBox()),

      if (widget.levelList.length == 2)
        Transform.translate(
          offset: const Offset(0, 55),
          child: PathAnimation2(
            drawType: widget.drawType,
            currentLevelPosition: currentLevelPosition,
            lineBackgroundColor: widget.lineBackgroundColor,
            mainColor: widget.mainColor,
          ),
        ),

      LevelGrid(
        levelDataList: widget.levelList,
        drawType: widget.drawType,
        longRowCount: widget.upperRowCount,
        shortRowCount: widget.lowerRowCount,
        isGroupFocused: widget.isGroupFocused,
        isDarkMode: widget.isDarkMode,
        drawSpeed: widget.cycleSpeed,
        finalLevelImage: widget.finalLevelImage,
        finalLevelAnimation: widget.finalLevelAnimation,
        startColor: widget.startColor,
        mainColor: widget.mainColor,
        passColor: widget.passColor,
        lockColor: widget.lockColor,
        onClickLevel: widget.onClickLevel,
        onClickLockLevel: widget.onClickLockLevel,
        onClickFinishedLevel: widget.onClickFinishedLevel,
        hasSubTopic: widget.hasSubTopic,
      ),
    ]);
  }
}
