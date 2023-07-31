import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FullCircleProgressIndicator extends StatefulWidget {
  final double value;
  final Color? correctColor;
  final Color? incorrectColor;
  final double lineWidth;
  final double radius;
  final Widget? centerWidget;

  const FullCircleProgressIndicator({
    super.key,
    this.value = 0,
    this.correctColor,
    this.incorrectColor,
    this.lineWidth = 10,
    this.radius = 100,
    this.centerWidget,
  });

  @override
  State<FullCircleProgressIndicator> createState() =>
      _FullCircleProgressIndicatorState();
}

class _FullCircleProgressIndicatorState
    extends State<FullCircleProgressIndicator> {
  var startIncorrectIndicatorAnim = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        CircularPercentIndicator(
          circularStrokeCap: CircularStrokeCap.round,
          radius: widget.radius + 3,
          startAngle: 0,
          percent: 1,
          lineWidth: widget.lineWidth + 6,
          backgroundColor: Colors.transparent,
          progressColor: const Color(0x7C6F5B1F).withOpacity(0.12),
        ),
        CircularPercentIndicator(
          reverse: true,
          circularStrokeCap: CircularStrokeCap.round,
          radius: widget.radius,
          startAngle: 360 - 360 * widget.value - 0.0225 * 360 > 0
              ? 360 - 360 * widget.value - 0.0225 * 360
              : 0,
          percent: startIncorrectIndicatorAnim
              ? ((1 - widget.value - 0.045) < 0
                  ? 0
                  : ((1 - widget.value + 0.045) > 1
                      ? 1
                      : (1 - widget.value - 0.045)))
              : 0,
          animation: true,
          animationDuration: (1600 - 1600 * widget.value).toInt() == 0
              ? 100
              : (1600 - 1600 * widget.value).toInt(),
          lineWidth: widget.lineWidth,
          backgroundColor: Colors.transparent,
          progressColor: widget.incorrectColor ?? const Color(0xFFED2939),
        ),
        CircularPercentIndicator(
            reverse: true,
            circularStrokeCap: CircularStrokeCap.round,
            radius: widget.radius,
            startAngle: 360 - 0.0225 * 360,
            percent: (widget.value - 0.045) < 0
                ? 0
                : ((widget.value + 0.045) > 1 ? 1 : (widget.value - 0.045)),
            animation: true,
            animationDuration: (1600 * widget.value).toInt() == 0
                ? 100
                : (1600 * widget.value).toInt(),
            lineWidth: widget.lineWidth,
            backgroundColor: Colors.transparent,
            progressColor: widget.correctColor ?? const Color(0xFF14CA9E),
            onAnimationEnd: () {
              setState(() {
                startIncorrectIndicatorAnim = true;
              });
            },
            center: widget.centerWidget)
      ],
    );
  }
}
