import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class LevelGroup {
  final String title;
  final String startImage;
  final Color startColor;
  final List<LevelData> levels;
  final DrawType drawType;

  LevelGroup(
      this.title, this.startImage, this.startColor, this.drawType, this.levels);
}

class PathLevelScreen extends StatefulWidget {
  final List<LevelGroup> levelGroupList;
  final String backgroundImage;
  final String finalLevelImage;
  final Color backgroundColor;

  const PathLevelScreen({
    super.key,
    this.backgroundImage = 'assets/images/path_level_background.png',
    this.finalLevelImage = 'assets/images/final_cup.png',
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.levelGroupList,
  });

  @override
  State<PathLevelScreen> createState() => _PathLevelScreenState();
}

class _PathLevelScreenState extends State<PathLevelScreen> {
  late ScrollController _scrollController;
  late ValueNotifier<double> _backgroundOffset;

  @override
  void initState() {
    _scrollController = ScrollController();
    _backgroundOffset = ValueNotifier<double>(0);

    _scrollController.addListener(
        () => _backgroundOffset.value = _scrollController.offset / 15);

    super.initState();
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
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.backgroundImage),
                              fit: BoxFit.fitWidth))))),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                scrolledUnderElevation: 0,
              ),
              body: SafeArea(
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: widget.levelGroupList.length,
                      itemBuilder: (_, index) => _buildGroup(index)))),
        ],
      ),
    );
  }

  Widget _buildGroup(int index) {
    final currentGroup = widget.levelGroupList[index];
    return Column(
      children: [
        _buildDivider(currentGroup.title),
        PathLevel(
          finalLevelImage: widget.finalLevelImage,
          startColor: currentGroup.startColor,
          startImage: currentGroup.startImage,
          levelList: currentGroup.levels,
          drawType: currentGroup.drawType,
        ),
      ],
    );
  }

  Widget _buildDivider(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
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
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
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
