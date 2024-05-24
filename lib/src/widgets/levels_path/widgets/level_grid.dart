import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/levels_path/path_level_screen.dart';

import 'level_widget.dart';
import 'path_animation.dart';

class LevelGrid extends StatelessWidget {
  final DrawType drawType;
  final int longRowCount;
  final int shortRowCount;
  final bool isFirstTimeOpen;
  final Duration drawSpeed;
  final List<UpdatedLevelData> levelDataList;

  const LevelGrid(
      {super.key,
      required this.drawType,
      required this.isFirstTimeOpen,
      required this.levelDataList,
      required this.longRowCount,
      required this.shortRowCount,
      required this.drawSpeed});

  @override
  Widget build(BuildContext context) {
    return Center(child: _buildLevelWidgets());
  }

  Widget _buildLevelWidgets() {
    List<Widget> row = [];
    int i = 0;

    while (i < levelDataList.length) {
      List<Widget> levelsInARow = [];
      int rowCount = row.length % 2 == 0 ? longRowCount : shortRowCount;
      for (int j = 0; j < rowCount; j++) {
        final level = i < levelDataList.length
            ? LevelWidget(
                index: i,
                title: levelDataList[i].title,
                isFirstTimeOpen: isFirstTimeOpen,
                isFreeToday: levelDataList[i].isFreeToday,
                isLock: levelDataList[i].isLock,
                progress: levelDataList[i].progress,
                isCurrent: levelDataList[i].isCurrent,
                isFinal: i == levelDataList.length - 1 && j == rowCount - 1,
                drawType: drawType,
                drawSpeed: drawSpeed,
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
            children: row.length % 2 != 0
                ? levelsInARow
                : levelsInARow.reversed.toList(),
          ),
        ),
      );
    }

    return Column(children: row);
  }
}
