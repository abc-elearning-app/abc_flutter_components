import 'package:flutter/material.dart';

class SliderTile extends StatefulWidget {
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;

  final int maxValue;
  final int defaultValue;
  final int minValue;

  final void Function(double value) onSelect;

  const SliderTile({
    super.key,
    required this.maxValue,
    required this.minValue,
    required this.defaultValue,
    required this.mainColor,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.onSelect,
  });

  @override
  State<SliderTile> createState() => _SliderTileState();
}

class _SliderTileState extends State<SliderTile> {
  late double selectedValue;

  @override
  void initState() {
    selectedValue = widget.defaultValue.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: widget.mainColor),
        color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
          child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              showValueIndicator: ShowValueIndicator.never,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              activeTrackColor: widget.mainColor,
              thumbColor: Colors.white,
              thumbShape: ThumbShape(
                  thumbColor: Colors.white,
                  tooltipColor: widget.isDarkMode ? const Color(0xFF858686) : widget.secondaryColor,
                  maxValue: widget.maxValue.toDouble(),
                  minValue: widget.minValue.toDouble()),
              inactiveTrackColor: widget.isDarkMode ? Colors.white.withOpacity(0.12) : Colors.grey.shade300,
            ),
            child: Slider(
              value: selectedValue,
              onChanged: (newValue) {
                setState(() => selectedValue = newValue);
                widget.onSelect(selectedValue);
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
                Text('${widget.minValue}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: widget.isDarkMode ? Colors.white : Colors.black)),
                Text('${widget.maxValue}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: widget.isDarkMode ? Colors.white : Colors.black)),
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ThumbShape extends SliderComponentShape {
  final bool showDecimal;

  final double thumbWidth;
  final double thumbHeight;
  final double borderRadius;
  final double triangleWidth;
  final double yOffset;
  final double maxValue;
  final double minValue;
  final Color thumbColor;
  final Color tooltipColor;

  ThumbShape({
    this.thumbWidth = 36,
    this.thumbHeight = 30,
    this.borderRadius = 8,
    this.triangleWidth = 15,
    this.yOffset = -30,
    this.showDecimal = false,
    required this.tooltipColor,
    required this.thumbColor,
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
      ..color = thumbColor;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final Path path = Path();

    // Draw circular thumb with red color
    const double radius = 8;
    context.canvas.drawCircle(center + const Offset(0, 3), radius, shadowPaint);
    context.canvas.drawCircle(center, radius, paint);

    // Draw rounded square box and triangle with blue color
    paint.color = tooltipColor;
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
    path.moveTo(center.dx - triangleHalfWidth, center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset);
    path.lineTo(center.dx + triangleHalfWidth, center.dy + thumbHeight / 2 - triangleWidth / 3 + yOffset);
    path.lineTo(center.dx, center.dy + thumbHeight / 2 + yOffset / 1.2);
    path.close();

    context.canvas.drawPath(path, paint);

    // Display value on the square
    final TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      text: showDecimal ? (minValue + (maxValue - minValue) * value).toStringAsFixed(1) : (minValue + (maxValue - minValue) * value).toInt().toString(),
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
