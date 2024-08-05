import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';

import '../../../flutter_abc_jsc_components.dart';

class LevelGroup {
  final String title;
  final String startImage;
  final Color startColor;
  final List<LevelData> levels;
  bool isFocused;
  DrawType drawType;

  LevelGroup({
    required this.title,
    required this.startImage,
    required this.startColor,
    required this.levels,
    this.drawType = DrawType.firstTimeOpen,
    this.isFocused = false,
  });
}

class PathLevelScreen extends StatefulWidget {
  final List<LevelGroup> levelGroupList;
  final String backgroundImage;
  final String finalLevelImage;
  final String finalLevelAnimation;

  final int upperRowCount;
  final int lowerRowCount;

  final String title;

  final Color backgroundColor;
  final Color lineBackgroundColor;
  final Color passColor;
  final Color mainColor;
  final Color lockColor;
  final Color dividerColor;

  final Duration drawSpeed;
  final bool isDarkMode;
  final bool hasSubTopic;

  final void Function(int id, int groupIndex) onClickLevel;
  final void Function() onClickLockLevel;

  const PathLevelScreen({
    super.key,
    required this.levelGroupList,
    required this.title,
    required this.backgroundImage,
    required this.finalLevelImage,
    required this.isDarkMode,
    required this.finalLevelAnimation,
    this.mainColor = const Color(0xFFE3A651),
    this.passColor = const Color(0xFF15CB9F),
    this.lockColor = const Color(0xFFF3F2F2),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.dividerColor = const Color(0xFF7C6F5B),
    this.lineBackgroundColor = const Color(0xFFF3EADA),
    this.upperRowCount = 1,
    this.lowerRowCount = 2,
    this.drawSpeed = const Duration(milliseconds: 250),
    required this.onClickLevel,
    required this.onClickLockLevel,
    required this.hasSubTopic,
  });

  @override
  State<PathLevelScreen> createState() => _PathLevelScreenState();
}

class _PathLevelScreenState extends State<PathLevelScreen> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _backgroundOffset;

  double percent = 0;
  int passedLevels = 0;
  double totalPercent = 0;
  int totalLevels = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _backgroundOffset = ValueNotifier<double>(0);

    _scrollController.addListener(_scrollListener);

    _initialCalculate();

    super.initState();
  }

  _initialCalculate() {
    /// Calculation for linear progress bar

    // This loop loops through all groups
    for (var group in widget.levelGroupList) {
      passedLevels += group.levels.where((level) => level.progress == 100).length;
      totalPercent += group.levels.fold(0, (previousValue, element) => previousValue + element.progress);
      totalLevels += group.levels.length;
    }
    percent = totalPercent / totalLevels;

    /// Calculate auto scroll position
    double currentPosition = 0;
    if (widget.hasSubTopic) {
      // This loop may not loop through all groups since it stops at the current group
      for (var group in widget.levelGroupList) {
        // Divider's height
        currentPosition += 50;

        if (group.isFocused) {
          int levelsTillCurrent = group.levels.indexWhere((level) => level.isCurrent) + 1;
          int completeCycleCount = levelsTillCurrent ~/ (widget.upperRowCount + widget.lowerRowCount);
          int remainLevels = levelsTillCurrent - completeCycleCount * (widget.upperRowCount + widget.lowerRowCount);
          currentPosition += completeCycleCount * 240 +
              (remainLevels == 0
                  ? 0
                  : remainLevels > widget.upperRowCount
                      ? 240
                      : 120);
          break;
        }

        if (group.levels.length == 2) {
          currentPosition += 120;
          continue;
        }

        int completeCycleCount = group.levels.length ~/ (widget.upperRowCount + widget.lowerRowCount);
        int remainLevels = group.levels.length - completeCycleCount * (widget.upperRowCount + widget.lowerRowCount);
        currentPosition += completeCycleCount * 240 +
            (remainLevels == 0
                ? 0
                : remainLevels > widget.upperRowCount
                    ? 240
                    : 120);
      }
    } else {
      final levelList = widget.levelGroupList.last.levels;
      int levelsTillCurrent = levelList.indexWhere((level) => level.isCurrent) + 1;
      int completeCycleCount = levelsTillCurrent ~/ (widget.upperRowCount + widget.lowerRowCount);
      int remainLevels = levelsTillCurrent - completeCycleCount * (widget.upperRowCount + widget.lowerRowCount);
      currentPosition += completeCycleCount * 240 +
          (remainLevels == 0
              ? 0
              : remainLevels > widget.upperRowCount
                  ? 240
                  : 120);
    }

    currentPosition -= 120;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // double screenHeight = MediaQuery.of(context).size.height;

      if (currentPosition >= 240) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(currentPosition, duration: const Duration(milliseconds: 500), curve: Curves.linear);
        }
      }
    });
  }

  void _scrollListener() {
    _backgroundOffset.value = _scrollController.offset / 15;

    // Avoid overscroll
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
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
      decoration: BoxDecoration(color: widget.isDarkMode ? Colors.black : widget.backgroundColor),
      child: Stack(
        children: [
          // Background image
          _backgroundImage(),

          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: widget.isDarkMode ? Colors.black : widget.backgroundColor,
                  scrolledUnderElevation: 0),
              body: SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${percent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text('$passedLevels/$totalLevels Lessons', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 15,
                        top: 5,
                      ),
                      child: CustomLinearProgress(
                          mainColor: widget.mainColor,
                          percent: percent < 0 ? 0 : percent,
                          backgroundColor: widget.isDarkMode ? Colors.grey.shade900 : widget.lineBackgroundColor,
                          indicatorColor: Colors.white)),
                  Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
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

  Widget _backgroundImage() => ValueListenableBuilder(
      valueListenable: _backgroundOffset,
      builder: (_, value, __) => Transform.translate(
          offset: Offset(0, 30 - value / 3),
          child: Container(
              height: 450,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(widget.backgroundImage),
                fit: BoxFit.fitWidth,
              )))));

  Widget _buildGroup(int groupIndex) {
    final currentGroup = widget.levelGroupList[groupIndex];
    return Column(
      children: [
        if (widget.hasSubTopic) _buildDivider(currentGroup.title),
        PathLevelComponent(
          hasSubTopic: widget.hasSubTopic,
          levelList: currentGroup.levels,
          drawType: currentGroup.drawType,
          isDarkMode: widget.isDarkMode,
          isGroupFocused: currentGroup.isFocused,
          finalLevelImage: widget.finalLevelImage,
          finalLevelAnimation: widget.finalLevelAnimation,
          cycleSpeed: widget.drawSpeed,
          lastCycleSpeed: widget.drawSpeed,
          startColor: currentGroup.startColor,
          startImage: currentGroup.startImage,
          mainColor: widget.mainColor,
          lockColor: widget.lockColor,
          passColor: widget.passColor,
          lineBackgroundColor: widget.isDarkMode ? Colors.grey.shade900 : widget.lineBackgroundColor,
          upperRowCount: widget.upperRowCount,
          lowerRowCount: widget.lowerRowCount,
          onClickLevel: (id) => widget.onClickLevel(id, groupIndex),
          onClickLockLevel: widget.onClickLockLevel,
        ),
      ],
    );
  }

  Widget _buildDivider(String title) => Padding(
        padding: const EdgeInsets.all(20),
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
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(fontWeight: FontWeight.w500, color: widget.isDarkMode ? Colors.white : widget.dividerColor, fontSize: 18),
              ),
            ),
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
