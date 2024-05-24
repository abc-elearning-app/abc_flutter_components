import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/level_grid.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/path_animation.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/widgets/start_image.dart';

class UpdatedLevelData {
  String title;
  double progress;
  bool isFreeToday;
  bool isLock;
  bool isCurrent;

  UpdatedLevelData(
      {required this.title,
      required this.progress,
      this.isCurrent = false,
      this.isLock = true,
      this.isFreeToday = false});
}

class UpdatedPathLevelScreen extends StatefulWidget {
  final List<UpdatedLevelData> levelList;
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
  final Color failColor;
  final Color lockColor;

  final String startImage;

  const UpdatedPathLevelScreen({
    super.key,
    required this.levelList,
    required this.drawType,
    this.upperRowCount = 1,
    this.lowerRowCount = 2,
    this.mainColor = const Color(0xFFE3A651),
    this.passColor = const Color(0xFF3CC079),
    this.failColor = const Color(0xFFFC5656),
    this.lockColor = const Color(0xFFF3F2F2),
    this.cycleSpeed = const Duration(milliseconds: 250),
    this.lastCycleSpeed = const Duration(milliseconds: 150),
    this.startImage = 'assets/images/path_start.png',
  });

  @override
  State<UpdatedPathLevelScreen> createState() => _UpdatedPathLevelScreenState();
}

class _UpdatedPathLevelScreenState extends State<UpdatedPathLevelScreen> {
  late int totalCycleCount;
  late int currentCycleCount;
  late int lastCycleTotalCount;
  late int lastCycleLevelCount;

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
    lastCycleLevelCount = currentLength - currentCycleCount * groupCount;
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
          lastRoundDrawSpeed: widget.lastCycleSpeed,
          upperRowCount: widget.upperRowCount,
          lowerRoundCount: widget.lowerRowCount,
          rounds: totalCycleCount,
          lastCycleLevelCount: lastCycleTotalCount,
          lineColor: const Color(0xFFF3EADA)),
      FutureBuilder(
        future: Future.delayed(Duration(
            milliseconds: widget.drawType == DrawType.firstTimeOpen ? 500 : 0)),
        builder: (context, snapShot) =>
            snapShot.connectionState == ConnectionState.done
                ? PathAnimation(
                    drawType: widget.drawType,
                    roundDrawSpeed: widget.cycleSpeed,
                    lastRoundDrawSpeed: widget.lastCycleSpeed,
                    upperRowCount: widget.upperRowCount,
                    lowerRoundCount: widget.lowerRowCount,
                    rounds: currentCycleCount,
                    lastCycleLevelCount: lastCycleLevelCount)
                : const SizedBox(),
      ),
      LevelGrid(
          drawType: widget.drawType,
          drawSpeed: widget.cycleSpeed,
          longRowCount: widget.upperRowCount,
          shortRowCount: widget.lowerRowCount,
          levelDataList: widget.levelList,
          isFirstTimeOpen: true),
    ]);
  }
}
