import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentButtons extends StatefulWidget {
  final bool isDarkMode;
  final Color selectedTextColor;
  final void Function(int id) onChange;

  const SegmentButtons({
    super.key,
    required this.isDarkMode,
    required this.selectedTextColor,
    required this.onChange,
  });

  @override
  State<SegmentButtons> createState() => _SegmentButtonsState();
}

class _SegmentButtonsState extends State<SegmentButtons> {
  int statusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
        padding: const EdgeInsets.all(5),
        backgroundColor: widget.isDarkMode ? Colors.white.withOpacity(0.16) : const Color(0xFFE9E6D7),
        thumbColor: Colors.white,
        children: <int, Widget>{
          0: _buildSegmentButton(0, 'All'),
          1: _buildSegmentButton(1, 'Correct'),
          2: _buildSegmentButton(2, 'Incorrect'),
        },
        groupValue: statusIndex,
        onValueChanged: (id) {
          setState(() => statusIndex = id!);
          widget.onChange(statusIndex);
        });
  }

  Widget _buildSegmentButton(int index, String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: widget.isDarkMode
                  ? statusIndex == index
                      ? Colors.black
                      : Colors.white
                  : statusIndex == index
                      ? widget.selectedTextColor
                      : Colors.black,
            )),
      );
}
