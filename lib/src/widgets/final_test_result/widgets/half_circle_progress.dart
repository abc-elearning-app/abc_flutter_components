import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HalfCircleProgressIndicator extends StatelessWidget {
  final double value;
  final Color? correctColor;
  final Color? incorrectColor;
  final double lineWidth;
  final double radius;

  const HalfCircleProgressIndicator({
    super.key,
    this.value = 0,
    this.correctColor,
    this.incorrectColor,
    this.lineWidth = 10,
    this.radius = 100,
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
            progressColor: incorrectColor ?? const Color(0xFFF14A4A),
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
            center: Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(color: value < 0.8 ? const Color(0xFFF14A4A) : const Color(0xFF14CA9E), fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: '${(value * 100).round()}', style: const TextStyle(fontSize: 70)),
                    const TextSpan(text: '%', style: TextStyle(fontSize: 40))
                  ]
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
