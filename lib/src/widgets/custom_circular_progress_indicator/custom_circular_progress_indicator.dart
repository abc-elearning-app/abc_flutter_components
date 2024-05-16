import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color backgroundColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color textColor;

  final int correctQuestions;
  final int totalQuestions;

  const CustomCircularProgressIndicator(
      {super.key,
      required this.backgroundColor,
      required this.correctColor,
      required this.incorrectColor,
      required this.correctQuestions,
      required this.totalQuestions,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      CircularPercentIndicator(
          radius: 54, lineWidth: 12, backgroundColor: backgroundColor),
      CircularPercentIndicator(
          radius: 50,
          circularStrokeCap: CircularStrokeCap.round,
          startAngle: 9,
          lineWidth: 6,
          progressColor: incorrectColor,
          backgroundColor: Colors.transparent,
          percent: correctQuestions != totalQuestions
              ? 1 - (correctQuestions / totalQuestions) - 0.05
              : 0),
      CircularPercentIndicator(
        radius: 50,
        percent: correctQuestions / totalQuestions,
        reverse: true,
        progressColor: correctColor,
        backgroundColor: Colors.transparent,
        circularStrokeCap: CircularStrokeCap.round,
        lineWidth: 6,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$correctQuestions/$totalQuestions',
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              'questions',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: textColor
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
