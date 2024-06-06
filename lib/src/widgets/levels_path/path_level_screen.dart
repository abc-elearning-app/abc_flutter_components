import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';

import '../../../flutter_abc_jsc_components.dart';

class LevelGroup {
  final String title;
  final String startImage;
  final Color startColor;
  final List<LevelData> levels;
  final DrawType drawType;

  LevelGroup(
    this.title,
    this.startImage,
    this.startColor,
    this.drawType,
    this.levels,
  );
}

class PathLevelScreen extends StatefulWidget {
  final List<LevelGroup> levelGroupList;
  final String backgroundImage;
  final String finalLevelImage;

  final int upperRowCount;
  final int lowerRowCount;

  final String title;

  final Color backgroundColor;
  final Color lineColor;
  final Color lineBackgroundColor;
  final Color passColor;
  final Color mainColor;
  final Color lockColor;
  final Color dividerColor;

  final Duration drawSpeed;

  final void Function(String id) onClickLevel;

  const PathLevelScreen({
    super.key,
    required this.levelGroupList,
    this.backgroundImage = 'assets/images/path_level_background.png',
    this.finalLevelImage = 'assets/images/final_cup.png',
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.passColor = const Color(0xFF15CB9F),
    this.mainColor = const Color(0xFFE3A651),
    this.lockColor = const Color(0xFFF3F2F2),
    this.lineColor = const Color(0xFFE3A651),
    this.lineBackgroundColor = const Color(0xFFF3EADA),
    this.dividerColor = const Color(0xFF7C6F5B),
    this.upperRowCount = 1,
    this.lowerRowCount = 2,
    this.drawSpeed = const Duration(milliseconds: 250),
    required this.title,
    required this.onClickLevel,
  });

  @override
  State<PathLevelScreen> createState() => _PathLevelScreenState();
}

class _PathLevelScreenState extends State<PathLevelScreen> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _backgroundOffset;

  double percent = 0;
  int passedLevels = 0;
  int totalLevels = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _backgroundOffset = ValueNotifier<double>(0);

    _scrollController.addListener(
        () => _backgroundOffset.value = _scrollController.offset / 15);

    _initCalculate();

    super.initState();
  }

  _initCalculate() {
    for (var group in widget.levelGroupList) {
      passedLevels += group.levels.indexWhere((level) => level.isCurrent);
      totalLevels += group.levels.length;
    }

    percent = passedLevels / totalLevels;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _backgroundOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.backgroundColor),
      child: Stack(
        children: [
          ValueListenableBuilder(
              valueListenable: _backgroundOffset,
              builder: (_, value, __) => Transform.translate(
                  offset: Offset(0, -value),
                  child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.backgroundImage),
                              fit: BoxFit.fitWidth))))),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  title: Text(widget.title,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  backgroundColor: Colors.transparent,
                  scrolledUnderElevation: 0),
              body: SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${percent.toStringAsFixed(2)}%',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        Text('$passedLevels/$totalLevels Lessons',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        top: 5,
                      ),
                      child: CustomLinearProgress(
                          mainColor: widget.mainColor,
                          percent: percent + 10,
                          indicatorPosition: -5,
                          backgroundColor: widget.lineBackgroundColor,
                          indicatorColor: Colors.white)),
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: widget.levelGroupList.length,
                        itemBuilder: (_, index) => _buildGroup(index)),
                  ),
                ],
              ))),
        ],
      ),
    );
  }

  Widget _buildGroup(int index) {
    final currentGroup = widget.levelGroupList[index];
    final lastCycleDrawSpeed = Duration(
        milliseconds: (widget.drawSpeed.inMilliseconds - 100).clamp(100, 1000));
    return Column(
      children: [
        _buildDivider(currentGroup.title, index == 0),
        PathLevel(
            finalLevelImage: widget.finalLevelImage,
            levelList: currentGroup.levels,
            drawType: currentGroup.drawType,
            isFirstGroup: index == 0,
            cycleSpeed: widget.drawSpeed,
            lastCycleSpeed: lastCycleDrawSpeed,
            startColor: currentGroup.startColor,
            startImage: currentGroup.startImage,
            mainColor: widget.mainColor,
            lockColor: widget.lockColor,
            passColor: widget.passColor,
            lineColor: widget.lineColor,
            lineBackgroundColor: widget.lineBackgroundColor,
            upperRowCount: widget.upperRowCount,
            lowerRowCount: widget.lowerRowCount,
            onClickLevel: widget.onClickLevel),
      ],
    );
  }

  Widget _buildDivider(String title, bool isFirstDivider) => Padding(
        padding: EdgeInsets.only(
            left: 10, right: 10, bottom: 50, top: isFirstDivider ? 10 : 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.dividerColor,
                    fontFamily: 'Poppins',
                    fontSize: 18)),
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade400,
            )),
          ],
        ),
      );
}