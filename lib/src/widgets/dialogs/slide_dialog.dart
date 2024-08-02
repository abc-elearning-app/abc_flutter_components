import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: widget.isDarkMode ? Colors.grey.shade900 : widget.backgroundColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Change font size',
                  style: TextStyle(fontSize: 20, color: widget.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  child: SliderTheme(
                    data: SliderThemeData(
                      showValueIndicator: ShowValueIndicator.never,
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      activeTrackColor: widget.mainColor,
                      thumbColor: Colors.white,
                      thumbShape: ThumbShape(
                          showDecimal: true,
                          thumbColor: Colors.white,
                          tooltipColor: widget.isDarkMode ? const Color(0xFF858686) : widget.secondaryColor,
                          maxValue: maxScale,
                          minValue: minScale),
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
