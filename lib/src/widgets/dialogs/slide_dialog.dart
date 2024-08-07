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

class _SlideDialogComponentState extends State<SlideDialogComponent> with TickerProviderStateMixin {
  late AnimationController leftAController;
  late AnimationController rightAController;
  late Animation leftAAnimation;
  late Animation rightAAnimation;

  late double value;

  @override
  void initState() {
    value = widget.initialValue;
    leftAController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    rightAController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    leftAAnimation = Tween<double>(begin: 0, end: -32).animate(leftAController);
    rightAAnimation = Tween<double>(begin: 0, end: 32).animate(rightAController);
    if (value < 0.9) {
      leftAController.forward();
    } else if (value > 2) {
      rightAController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    leftAController.dispose();
    rightAController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              if (value > 0.9 && leftAController.status == AnimationStatus.completed) {
                                leftAController.reverse();
                              } else if (value <= 0.9 && leftAController.status == AnimationStatus.dismissed) {
                                leftAController.forward();
                              }

                              if (value < 2 && rightAController.status == AnimationStatus.completed) {
                                rightAController.reverse();
                              } else if (value >= 2 && rightAController.status == AnimationStatus.dismissed) {
                                rightAController.forward();
                              }

                              widget.onChange(value);
                            },
                            label: value.toString(),
                            activeColor: widget.mainColor,
                          ),
                        ),
                      ),
                      Positioned(
                          left: 38,
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                                animation: leftAAnimation,
                                builder: (_, __) => Transform.translate(
                                      offset: Offset(leftAAnimation.value, 0),
                                      child: Text('A',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget.isDarkMode ? value < 0.9 ? Colors.white : Colors.black : value < 0.9 ? Colors.black : Colors.white,
                                          )),
                                    )),
                          )),
                      Positioned(
                          right: 38,
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                                animation: rightAAnimation,
                                builder: (_, __) => Transform.translate(
                                      offset: Offset(rightAAnimation.value, 0),
                                      child: Text('A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: widget.isDarkMode ? Colors.white : Colors.black,
                                          )),
                                    )),
                          )),
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
