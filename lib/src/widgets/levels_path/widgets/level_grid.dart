import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/path_level_component.dart';

import 'level_widget.dart';
import 'path_animation.dart';

class LevelGrid extends StatelessWidget {
  final DrawType drawType;
  final int longRowCount;
  final int shortRowCount;
  final Duration drawSpeed;
  final List<LevelData> levelDataList;
  final String finalLevelImage;
  final String finalLevelAnimation;
  final bool isFirstGroup;
  final bool isDarkMode;
  final bool isLastGroup;

  final Color mainColor;
  final Color passColor;
  final Color lockColor;
  final Color startColor;

  final void Function(String id) onClickLevel;

  const LevelGrid({
    super.key,
    required this.drawType,
    required this.levelDataList,
    required this.longRowCount,
    required this.shortRowCount,
    required this.drawSpeed,
    required this.startColor,
    required this.finalLevelImage,
    required this.isFirstGroup,
    required this.mainColor,
    required this.passColor,
    required this.lockColor,
    required this.onClickLevel,
    required this.isDarkMode,
    required this.isLastGroup,
    required this.finalLevelAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildLevelWidgets());
  }

  Widget _buildLevelWidgets() {
    if (levelDataList.length == 2) {
      return SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              2,
              (i) => LevelWidget(
                    index: i,
                    isDarkMode: isDarkMode,
                    levelData: levelDataList[i],
                    finalLevelImage: finalLevelImage,
                    finalLevelAnimation: finalLevelAnimation,
                    isFinal: i == levelDataList.length - 1,
                    drawType: drawType,
                    drawSpeed: drawSpeed,
                    startColor: startColor,
                    isFirstGroup: isFirstGroup,
                    lockColor: lockColor,
                    passColor: passColor,
                    mainColor: mainColor,
                    onClickLevel: onClickLevel,
                    isLastGroup: isLastGroup,
                  )),
        ),
      );
    }

    List<Widget> row = [];
    int i = 0;

    while (i < levelDataList.length) {
      List<Widget> levelsInARow = [];
      int rowCount = row.length % 2 == 0 ? longRowCount : shortRowCount;
      for (int j = 0; j < rowCount; j++) {
        final level = i < levelDataList.length
            ? LevelWidget(
                index: i,
                isDarkMode: isDarkMode,
                levelData: levelDataList[i],
                finalLevelImage: finalLevelImage,
                finalLevelAnimation: finalLevelAnimation,
                isFinal: i == levelDataList.length - 1,
                drawType: drawType,
                drawSpeed: drawSpeed,
                startColor: startColor,
                isFirstGroup: isFirstGroup,
                lockColor: lockColor,
                passColor: passColor,
                mainColor: mainColor,
                onClickLevel: onClickLevel,
                isLastGroup: isLastGroup,
              )
            : const PlaceholderLevel();
        levelsInARow.add(level);
        i++;
      }

      row.add(
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.length % 2 != 0 ? levelsInARow : levelsInARow.reversed.toList(),
          ),
        ),
      );
    }

    return Column(children: row);
  }
}
