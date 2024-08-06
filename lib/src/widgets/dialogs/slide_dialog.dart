import 'package:flutter/material.dart';

class SlideDialogComponent extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;

  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(double value) onChange;

  const SlideDialogComponent({
    super.key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.isDarkMode,
    required this.mainColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.onChange,
  });

  @override
  State<SlideDialogComponent> createState() => _SlideDialogComponentState();
}

class _SlideDialogComponentState extends State<SlideDialogComponent> {
  late double value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxScale = 2.2;
    double minScale = 0.7;

    return Center(
      child: Wrap(children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: widget.isDarkMode ? Colors.grey.shade900 : widget.backgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change Font Size',
                  style: TextStyle(fontSize: 20, color: widget.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Transform.translate(offset: const Offset(8, 0), child: const Text('a')),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 20,
                            showValueIndicator: ShowValueIndicator.never,
                            activeTickMarkColor: Colors.transparent,
                            inactiveTickMarkColor: Colors.transparent,
                            activeTrackColor: widget.mainColor,
                            thumbColor: Colors.white,
                            thumbShape: CustomThumbShape(
                              thumbColor: Colors.white,
                              thumbHeight: 12,
                              maxValue: maxScale,
                              minValue: minScale,
                            ),
                            inactiveTrackColor: widget.isDarkMode ? Colors.white.withOpacity(0.12) : Colors.grey.shade300,
                          ),
                          child: Slider(
                            value: value,
                            min: minScale,
                            max: maxScale,
                            divisions: 70,
                            onChanged: (newValue) {
                              setState(() => value = newValue);
                              widget.onChange(value);
                            },
                            label: value.toString(),
                            activeColor: widget.mainColor,
                          ),
                        ),
                      ),
                      Transform.translate(offset: const Offset(-8, 0), child: const Text('A')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  final Color thumbColor;
  final double minValue;
  final double maxValue;
  final double thumbHeight;

  CustomThumbShape({
    required this.thumbColor,
    required this.minValue,
    required this.maxValue,
    this.thumbHeight = 14,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20.0, 20.0); // Size of the thumb
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
    final Canvas canvas = context.canvas;

    // Draw the thumb circle
    final Paint paint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbHeight, paint);

    // Draw the value inside the thumb
    final TextSpan textSpan = TextSpan(
      text: ((maxValue - minValue) * value + minValue).toStringAsFixed(1),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Poppins'),
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    Offset textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, textCenter);
  }
}
