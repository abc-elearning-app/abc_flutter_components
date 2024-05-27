import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomLinearProgress extends StatelessWidget {
  final double percent;
  final double indicatorPosition;

  final Color mainColor;
  final Color backgroundColor;
  final Color indicatorColor;

  const CustomLinearProgress(
      {super.key,
      required this.mainColor,
      required this.percent,
      required this.backgroundColor,
      required this.indicatorColor,
      this.indicatorPosition = -15});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      lineHeight: 10,
      animation: true,
      barRadius: const Radius.circular(15),
      backgroundColor: backgroundColor,
      progressColor: mainColor,
      percent: percent / 100,
      widgetIndicator: Transform.translate(
          offset: Offset(indicatorPosition, 1),
          child: Transform.scale(
              scale: 0.6,
              child: CircleAvatar(
                radius: 9,
                backgroundColor: mainColor,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: indicatorColor,
                ),
              ))),
    );
  }
}
