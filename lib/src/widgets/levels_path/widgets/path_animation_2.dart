import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../flutter_abc_jsc_components.dart';

class PathAnimation2 extends StatelessWidget {
  final DrawType drawType;
  final Color lineBackgroundColor;
  final Color mainColor;

  final int currentLevelPosition;

  const PathAnimation2({
    super.key,
    required this.drawType,
    required this.lineBackgroundColor,
    required this.mainColor,
    required this.currentLevelPosition,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 2 / 3 - 50;
    double lineHeight = 12;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          LinearPercentIndicator(
            lineHeight: lineHeight,
            backgroundColor: Colors.transparent,
            progressColor: lineBackgroundColor,
            animation: drawType == DrawType.firstTimeOpen,
            percent: 1,
            width: width,
          ),
          if (currentLevelPosition == 2)
            FutureBuilder(
                future: Future.delayed(Duration(milliseconds: drawType == DrawType.noAnimation ? 10 : 500)),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.done
                    ? LinearPercentIndicator(
                        lineHeight: lineHeight,
                        backgroundColor: Colors.transparent,
                        progressColor: mainColor,
                        animation: drawType == DrawType.firstTimeOpen || drawType == DrawType.nextLevel,
                        animationDuration: drawType == DrawType.firstTimeOpen ? 300 : 800,
                        percent: 1,
                        width: width,
                      )
                    : const SizedBox.shrink()),
        ]),
      ],
    );
  }
}
