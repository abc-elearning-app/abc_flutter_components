import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';

import '../../../flutter_abc_jsc_components.dart';

enum LevelGroupType { passed, current, upcoming }

class LevelGroup {
  final String title;
  final String startImage;
  final Color startColor;
  final List<LevelData> levels;
  LevelGroupType levelGroupType;

  LevelGroup({
    required this.title,
    required this.startImage,
    required this.startColor,
    required this.levels,
    this.levelGroupType = LevelGroupType.upcoming,
  });
}

class PathLevelScreen extends StatefulWidget {
  final List<LevelGroup> levelGroupList;
  final String backgroundImage;
  final String finalLevelImage;

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

  final bool? openType;

  final void Function(String id) onClickLevel;

  const PathLevelScreen({
    super.key,
    required this.levelGroupList,
    required this.title,
    required this.onClickLevel,
    required this.backgroundImage,
    required this.finalLevelImage,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.passColor = const Color(0xFF15CB9F),
    this.mainColor = const Color(0xFFE3A651),
    this.lockColor = const Color(0xFFF3F2F2),
    this.lineBackgroundColor = const Color(0xFFF3EADA),
    this.dividerColor = const Color(0xFF7C6F5B),
    this.upperRowCount = 1,
    this.lowerRowCount = 2,
    this.drawSpeed = const Duration(milliseconds: 250),
    required this.isDarkMode,
    this.openType,
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

    _scrollController.addListener(_scrollListener);

    _initialCalculate();

    super.initState();
  }

  _initialCalculate() {
    // Calculation for linear progress bar
    for (var group in widget.levelGroupList) {
      passedLevels += group.levels.where((level) => level.progress > 0).length;
      totalLevels += group.levels.length;
    }
    percent = passedLevels / totalLevels * 100;

    // Calculation for auto scroll
    double currentPosition = 0;
    for (LevelGroup group in widget.levelGroupList) {
      double groupHeight = 0;

      if (group.levelGroupType == LevelGroupType.current) {
        int levelsTillCurrent =
            group.levels.indexWhere((level) => level.isCurrent) + 1;
        int completeCycleCount =
            levelsTillCurrent ~/ (widget.upperRowCount + widget.lowerRowCount);
        groupHeight += completeCycleCount * 240;
        int remainLevels = levelsTillCurrent -
            completeCycleCount * (widget.upperRowCount + widget.lowerRowCount);
        groupHeight += remainLevels > widget.upperRowCount ? 240 : 120;

        currentPosition += groupHeight;
        break;
      }

      if (group.levels.length == 2) {
        currentPosition += 120;
        continue;
      }

      int completeCycleCount =
          group.levels.length ~/ (widget.upperRowCount + widget.lowerRowCount);
      groupHeight += completeCycleCount * 240;
      int remainLevels = group.levels.length -
          completeCycleCount * (widget.upperRowCount + widget.lowerRowCount);
      groupHeight += remainLevels > widget.upperRowCount ? 240 : 120;

      currentPosition += groupHeight;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenHeight = MediaQuery.of(context).size.height;

      if (currentPosition > screenHeight * 0.5) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(currentPosition,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        }
      }
    });
  }

  void _scrollListener() {
    _backgroundOffset.value = _scrollController.offset / 15;

    // Avoid overscroll
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
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
      decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.black : widget.backgroundColor),
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
                  backgroundColor:
                      widget.isDarkMode ? Colors.black : widget.backgroundColor,
                  scrolledUnderElevation: 0),
              body: SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${percent.toInt()}%',
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
                        bottom: 15,
                        top: 5,
                      ),
                      child: CustomLinearProgress(
                          mainColor: widget.mainColor,
                          percent: percent < 0 ? 0 : percent,
                          backgroundColor: widget.isDarkMode
                              ? Colors.grey.shade900
                              : widget.lineBackgroundColor,
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
          offset: Offset(0, -value / 3),
          child: Container(
              height: 450,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(widget.backgroundImage),
                      fit: BoxFit.fitWidth)))));

  Widget _buildGroup(int index) {
    final currentGroup = widget.levelGroupList[index];

    final lastCycleDrawSpeed = widget.drawSpeed;
    // Duration(
    //     milliseconds: (widget.drawSpeed.inMilliseconds - 20).clamp(100, 1000));

    late DrawType drawType = widget.openType == null
        ? DrawType.firstTimeOpen
        : widget.openType == true
            ? currentGroup.levelGroupType == LevelGroupType.current
                ? DrawType.nextLevel
                : DrawType.noAnimation
            : DrawType.noAnimation;

    return Column(
      children: [
        _buildDivider(currentGroup.title, index == 0),
        PathLevelComponent(
          levelGroupType: currentGroup.levelGroupType,
          isDarkMode: widget.isDarkMode,
          finalLevelImage: widget.finalLevelImage,
          levelList: currentGroup.levels,
          drawType: drawType,
          isFirstGroup: index == 0,
          cycleSpeed: widget.drawSpeed,
          lastCycleSpeed: lastCycleDrawSpeed,
          startColor: currentGroup.startColor,
          startImage: currentGroup.startImage,
          mainColor: widget.mainColor,
          lockColor: widget.lockColor,
          passColor: widget.passColor,
          lineBackgroundColor: widget.isDarkMode
              ? Colors.grey.shade900
              : widget.lineBackgroundColor,
          upperRowCount: widget.upperRowCount,
          lowerRowCount: widget.lowerRowCount,
          onClickLevel: widget.onClickLevel,
          isLastGroup: index == widget.levelGroupList.length - 1,
        ),
      ],
    );
  }

  Widget _buildDivider(String title, bool isFirstDivider) => Padding(
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
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        widget.isDarkMode ? Colors.white : widget.dividerColor,
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
