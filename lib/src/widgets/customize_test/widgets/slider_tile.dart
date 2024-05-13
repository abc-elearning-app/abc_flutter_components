import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_themes.dart';
import '../../../../providers/exam_simulator_provider.dart';

class SliderTile extends StatelessWidget {
  final ValueType type;
  final int maxValue;
  final int minValue;

  const SliderTile(
      {super.key,
      required this.type,
      required this.maxValue,
      required this.minValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          color: context.isDarkMode
              ? context.colorScheme.secondary
              : context.colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Selector<ExamSimulatorProvider, double>(
        selector: (_, provider) => _getSelector(provider).toDouble(),
        builder: (context, value, _) => Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.never,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                activeTrackColor: context.colorScheme.primary,
                thumbColor: context.colorScheme.primary,
                thumbShape: ThumbShape(maxValue: maxValue, minValue: minValue),
                inactiveTrackColor: Colors.grey.shade300,
              ),
              child: Slider(
                value: value,
                onChanged: (double newValue) {
                  _setValue(context, newValue);
                },
                min: minValue.toDouble(),
                max: maxValue.toDouble(),
                divisions: ((maxValue - minValue) * 10).toInt(),
                label: value.floor().toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$minValue',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('$maxValue',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  _getSelector(ExamSimulatorProvider provider) {
    switch (type) {
      case ValueType.question:
        return provider.questionCount;
      case ValueType.minute:
        return provider.minuteCount;
      case ValueType.passRate:
        return provider.passRate;
    }
  }

  _setValue(BuildContext context, double newValue) {
    switch (type) {
      case ValueType.question:
        {
          context.read<ExamSimulatorProvider>().questionCount =
              newValue.toInt();
          break;
        }
      case ValueType.minute:
        {
          context.read<ExamSimulatorProvider>().minuteCount = newValue.toInt();
          break;
        }
      case ValueType.passRate:
        {
          context.read<ExamSimulatorProvider>().passRate = newValue.toInt();
          break;
        }
    }
  }
}

class ThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;
  final double borderRadius;
  final double triangleWidth;
  final double yOffset;
  final int maxValue;
  final int minValue;

  ThumbShape({
    this.thumbWidth = 36,
    this.thumbHeight = 36,
    this.borderRadius = 8,
    this.triangleWidth = 15,
    this.yOffset = -36,
    required this.maxValue,
    required this.minValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final Path path = Path();

    // Draw circular thumb with red color
    const double radius = 8;
    context.canvas.drawCircle(center, radius, paint);

    // Draw rounded square box and triangle with blue color
    paint.color = const Color(0xFF676767);
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + yOffset), // Adjusted y offset
        width: thumbWidth,
        height: thumbHeight,
      ),
      Radius.circular(borderRadius),
    );
    path.addRRect(roundedRect);

    // Draw triangle
    final double triangleHalfWidth = triangleWidth;
    path.moveTo(center.dx - triangleHalfWidth, center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset );
    path.lineTo(center.dx + triangleHalfWidth, center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset );
    path.lineTo(center.dx, center.dy + thumbHeight / 2 + yOffset / 1.2);
    path.close();

    context.canvas.drawPath(path, paint);

    // Display value on the square
    final TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      text: (minValue + (maxValue - minValue) * value).toInt().toString(),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center, // Center the text
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(context.canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2 + yOffset));

  }
}