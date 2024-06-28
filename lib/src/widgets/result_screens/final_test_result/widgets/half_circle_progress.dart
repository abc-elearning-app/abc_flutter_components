import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HalfCircleProgressIndicator extends StatelessWidget {
  final double progress;
  final Color correctColor;
  final Color incorrectColor;
  final double lineWidth;
  final double radius;
  final Widget center;

  const HalfCircleProgressIndicator({
    super.key,
    this.progress = 0,
    this.correctColor = const Color(0xFF14CA9E),
    this.incorrectColor = const Color(0xFFF14A4A),
    this.lineWidth = 10,
    this.radius = 100,
    required this.center,
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
            progressColor: incorrectColor,
          ),
          CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              radius: radius,
              startAngle: 270,
              percent: 0.5 * progress,
              animation: true,
              lineWidth: lineWidth,
              backgroundColor: Colors.transparent,
              progressColor: correctColor,
              center: center),
        ],
      ),
    );
  }
}
