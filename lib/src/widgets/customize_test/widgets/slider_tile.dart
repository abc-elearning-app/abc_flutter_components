import 'package:flutter/material.dart';

import '../customize_test.dart';

class SliderTile extends StatefulWidget {
  final ValueType type;
  final int maxValue;
  final int minValue;

  const SliderTile(
      {super.key,
      required this.type,
      required this.maxValue,
      required this.minValue});

  @override
  State<SliderTile> createState() => _SliderTileState();
}

class _SliderTileState extends State<SliderTile> {
  late double selectedValue;

  @override
  void initState() {
    selectedValue = 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xFFE3A651)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
          child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.never,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              activeTrackColor: const Color(0xFFE3A651),
              thumbColor: Colors.white,
              thumbShape: ThumbShape(
                  maxValue: widget.maxValue, minValue: widget.minValue),
              inactiveTrackColor: Colors.grey.shade300,
            ),
            child: Slider(
              value: selectedValue,
              onChanged: (double newValue) {
                _setValue(context, newValue);
              },
              min: widget.minValue.toDouble(),
              max: widget.maxValue.toDouble(),
              divisions: ((widget.maxValue - widget.minValue) * 10).toInt(),
              label: selectedValue.floor().toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.minValue}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15)),
                Text('${widget.maxValue}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15)),
              ],
            ),
          )
        ],
      )),
    );
  }

  _setValue(BuildContext context, double newValue) {
    setState(() {
      selectedValue = newValue;
    });
    // switch (widget.type) {
    //   case ValueType.question:
    //     {
    //       // context.read<ExamSimulatorProvider>().questionCount =
    //       //     newValue.toInt();
    //       break;
    //     }
    //   case ValueType.minute:
    //     {
    //       // context.read<ExamSimulatorProvider>().minuteCount = newValue.toInt();
    //       break;
    //     }
    //   case ValueType.passRate:
    //     {
    //       // context.read<ExamSimulatorProvider>().passRate = newValue.toInt();
    //       break;
    //     }
    // }
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
    this.thumbHeight = 30,
    this.borderRadius = 8,
    this.triangleWidth = 15,
    this.yOffset = -30,
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
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final Path path = Path();

    // Draw circular thumb with red color
    const double radius = 8;
    context.canvas.drawCircle(center + const Offset(0, 3), radius, shadowPaint);
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
    path.moveTo(center.dx - triangleHalfWidth,
        center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset);
    path.lineTo(center.dx + triangleHalfWidth,
        center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset);
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
    tp.paint(context.canvas,
        Offset(center.dx - tp.width / 2, center.dy - tp.height / 2 + yOffset));
  }
}
