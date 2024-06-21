import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomLinearProgress extends StatelessWidget {
  final double percent;

  final Color mainColor;
  final Color backgroundColor;
  final Color indicatorColor;

  const CustomLinearProgress(
      {super.key,
      required this.mainColor,
      required this.percent,
      required this.backgroundColor,
      required this.indicatorColor});

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
          offset: Offset(_getIndicatorDisposition(), 1),
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

  double _getIndicatorDisposition() {
    if (percent == 0) return 0;
    if (percent < 5) return -5;
    return -9;
  }
}
