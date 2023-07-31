import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HaftCircleProgressIndicator extends StatelessWidget {
  final double value;
  final Color? correctColor;
  final Color? incorrectColor;
  final Color textColor;
  final double lineWidth;
  final double radius;

  const HaftCircleProgressIndicator({
    super.key,
    this.value = 0,
    this.correctColor,
    this.incorrectColor,
    this.lineWidth = 10,
    this.radius = 100,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      size: Size.fromHeight(radius + 24),
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            radius: radius,
            startAngle: 270,
            percent: 0.5,
            animation: true,
            lineWidth: lineWidth,
            backgroundColor: Colors.transparent,
            progressColor: incorrectColor ?? const Color(0xFFED2939),
          ),
          CircularPercentIndicator(
            circularStrokeCap: CircularStrokeCap.round,
            radius: radius,
            startAngle: 270,
            percent: 0.5 * value,
            animation: true,
            lineWidth: lineWidth,
            backgroundColor: Colors.transparent,
            progressColor: correctColor ?? const Color(0xFF14CA9E),
            center: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text.rich(
                TextSpan(
                  text: "${(value * 100).round()}",
                  children: const [
                    TextSpan(
                      text: "%",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
