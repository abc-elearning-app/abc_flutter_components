import 'package:flutter/material.dart';

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

class _FilterSegmentState extends State<FilterSegment> with TickerProviderStateMixin {
  int statusIndex = 0;
  int previousIndex = 0;

  List<AnimationController> animationControllers = [];
  List<Animation<double>> animations = [];

  @override
  void initState() {
    animationControllers = List.generate(3, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    animations = List.generate(3, (index) => Tween<double>(begin: 0.95, end: 1).animate(animationControllers[index]));

    if (mounted) animationControllers.first.forward();

    super.initState();
  }

  @override
  void dispose() {
    for (var controller in animationControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      height: 45,
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildSegmentButton(0, 'All', widget.allValue)),
          Expanded(flex: 2, child: _buildSegmentButton(1, 'Correct', widget.correctValue)),
          Expanded(flex: 2, child: _buildSegmentButton(2, 'Incorrect', widget.incorrectValue)),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(int index, String title, int value) => GestureDetector(
        onTap: () {
          if (index != previousIndex) {
            previousIndex = index;
            setState(() => statusIndex = index);
            widget.onChange(statusIndex);
            animationControllers[index].forward(from: 0);
          }
        },
        child: ScaleTransition(
          scale: animations[index],
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(color: Colors.white.withOpacity(statusIndex == index ? 1 : 0), borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 7),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _textColor(index),
                    )),
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 9,
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
          ),
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
