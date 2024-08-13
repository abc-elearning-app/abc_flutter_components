import 'package:flutter/material.dart';

import '../segment_slider/custom_sliding_segment_control.dart';

class FilterSegment extends StatefulWidget {
  final int initialValue;
  final int allValue;
  final int correctValue;
  final int incorrectValue;

  final Color backgroundColor;
  final bool isDarkMode;
  final Color selectedTextColor;

  final void Function(int id) onChange;

  const FilterSegment({
    super.key,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.selectedTextColor,
    required this.onChange,
    required this.initialValue,
    required this.allValue,
    required this.correctValue,
    required this.incorrectValue,
  });

  @override
  State<FilterSegment> createState() => _FilterSegmentState();
}

class _FilterSegmentState extends State<FilterSegment> {
  int statusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: MediaQuery.of(context).size.width < 380 ? 0.95 : 1,
      child: CustomSlidingSegmentedControl(
        decoration: BoxDecoration(color: widget.isDarkMode ? Colors.grey.shade900 : widget.backgroundColor, borderRadius: BorderRadius.circular(8)),
        initialValue: widget.initialValue,
        children: <int, Widget>{
          0: _buildSegmentButton(0, 'All', widget.allValue),
          1: _buildSegmentButton(1, 'Correct', widget.correctValue),
          2: _buildSegmentButton(2, 'Incorrect', widget.incorrectValue),
        },
        thumbDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        onValueChanged: (id) {
          setState(() => statusIndex = id);
          widget.onChange(statusIndex);
        },
      ),
    );
  }

  Widget _buildSegmentButton(int index, String title, int value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textColor(index),
                )),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 8,
              backgroundColor: statusIndex == index ? const Color(0xFF7C6F5B).withOpacity(0.08) : Colors.grey.shade400.withOpacity(0.2),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: _textColor(index),
                ),
              ),
            )
          ],
        ),
      );

  _textColor(int index) => widget.isDarkMode
      ? statusIndex == index
          ? Colors.black
          : Colors.white
      : statusIndex == index
          ? widget.selectedTextColor
          : Colors.black;
}
