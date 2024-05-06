import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../flutter_abc_jsc_components.dart';
import 'level_widget.dart';

class LevelGrid extends StatelessWidget {
  final int drawSpeed;
  final int rowItemCount;
  final bool isFirstTimeOpen;
  final List<LevelData> levelDataList;

  const LevelGrid({
    super.key,
    required this.isFirstTimeOpen,
    required this.levelDataList,
    required this.drawSpeed,
    required this.rowItemCount,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowList = [];
    int i = 0;

    // Calculate number of rows
    // Add 1 since there's a place holder at the 1st position of 1st row
    int rows = (levelDataList.length + 1) ~/ rowItemCount;
    if ((levelDataList.length + 1) % rowItemCount != 0) rows++;

    for (int k = 0; k < rows; k++) {
      final levelsInARow = <Widget>[];

      if (k == 0) {
        // Add initial space for start image
        levelsInARow.add(const PlaceholderLevel());

        // Add the rest to 1st row
        for (int j = 0; j < rowItemCount - 1; j++) {
          final currentLevel = levelDataList[i];
          levelsInARow.add(_getLevelWidget(i, currentLevel));
          i++;
        }
      } else if (k == rows - 1) {
        // Add 1 to length since there is a placeholder level at 1st position
        int remainingLevelCount = (levelDataList.length + 1) % rowItemCount;

        // Add remaining levels to last row
        for (int j = i; j < levelDataList.length; j++) {
          final currentLevel = levelDataList[j];
          levelsInARow.add(_getLevelWidget(i, currentLevel));
          i++;
        }

        // If last round is not full
        if (remainingLevelCount != 0) {
          for (int j = 0; j < rowItemCount - remainingLevelCount; j++) {
            levelsInARow.add(const PlaceholderLevel());
          }
        }
      } else {
        for (int j = 0; j < rowItemCount; j++) {
          final currentLevel = levelDataList[i];
          levelsInARow.add(_getLevelWidget(i, currentLevel));
          i++;
        }
      }

      // Translate level widgets to left and right symmetrically
      rowList.add(
        SizedBox(
          height: 120,
          child: Transform.translate(
            offset: Offset(rowList.length % 2 == 0 ? -20 : 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowList.length % 2 == 0
                  ? levelsInARow
                  : levelsInARow.reversed.toList(),
            ),
          ),
        ),
      );
    }

    return Column(children: rowList);
  }

  Widget _getLevelWidget(int index, LevelData levelData) => Level(
      rowItemCount: rowItemCount,
      progress: levelData.progress,
      isCurrent: levelData.isCurrent,
      index: index,
      isLock: levelData.isLock,
      isFreeToday: levelData.isFreeToday,
      isFirstTimeOpen: isFirstTimeOpen,
      drawSpeed: drawSpeed,
      isFinalLevel: index == levelDataList.length - 1);
}
