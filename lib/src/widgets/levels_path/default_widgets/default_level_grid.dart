import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../default_path_level_screen.dart';
import 'default_level_widget.dart';

class DefaultLevelGrid extends StatelessWidget {
  final int longRowCount;
  final int shortRowCount;
  final bool isFirstTimeOpen;
  final List<DefaultLevelData> levelDataList;

  const DefaultLevelGrid({
    super.key,
    required this.isFirstTimeOpen,
    required this.levelDataList,
    required this.longRowCount,
    required this.shortRowCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildLevelWidgets(),
    );
  }

  Widget _buildLevelWidgets() {
    List<Widget> row = [];
    int i = 0;

    while (i < levelDataList.length) {
      List<Widget> levelsInARow = [];
      int rowCount = row.length % 2 == 0 ? longRowCount : shortRowCount;
      for (int j = 0; j < rowCount; j++) {
        final level = i < levelDataList.length
            ? DefaultLevel(
                index: i,
                isFirstTimeOpen: isFirstTimeOpen,
                isFreeToday: levelDataList[i].isFreeToday,
                isLock: levelDataList[i].isLock,
                progress: levelDataList[i].progress,
                isCurrent: levelDataList[i].isCurrent,
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
            children: row.length % 2 == 0
                ? levelsInARow
                : levelsInARow.reversed.toList(),
          ),
        ),
      );
    }

    return Column(
      children: row,
    );
  }
}
