import 'dart:math';

import 'package:flutter/material.dart';

import 'header_style.dart';

enum OpenPickerStatus { showMonthPicker, showYearPicker, close }

class CalendarHeader extends StatefulWidget {
  final bool isDarkMode;
  final DateTime focusedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final Function(DateTime date) setSelectedDate;
  final Function(OpenPickerStatus status) onTogglePicker;

  const CalendarHeader({
    Key? key,
    required this.focusedDate,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.firstDate,
    required this.lastDate,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.setSelectedDate,
    required this.isDarkMode,
    required this.onTogglePicker,
  }) : super(key: key);

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> with TickerProviderStateMixin {
  bool showMonthPicker = false;
  bool showYearPicker = false;

  late AnimationController chevronMonthController;
  late AnimationController chevronYearController;

  late Animation<double> chevronMonthAnimation;
  late Animation<double> chevronYearAnimation;

  @override
  void initState() {
    chevronMonthController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    chevronMonthAnimation = Tween<double>(begin: 0, end: pi).animate(chevronMonthController);

    chevronYearController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    chevronYearAnimation = Tween<double>(begin: 0, end: pi).animate(chevronYearController);
    super.initState();
  }

  @override
  void dispose() {
    chevronMonthController.dispose();
    chevronYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.headerStyle.headerMargin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: _onToggleMonthPicker,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  fullMonthNames[widget.focusedDate.month - 1],
                                  style: TextStyle(
                                    color: widget.isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: chevronMonthAnimation,
                                  builder: (_, __) => Transform.rotate(
                                    angle: chevronMonthAnimation.value,
                                    child: const Icon(Icons.arrow_drop_down_rounded, size: 30),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: _onToggleYearPicker,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.focusedDate.year.toString(),
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: chevronYearAnimation,
                                builder: (_, __) => Transform.rotate(
                                  angle: chevronYearAnimation.value,
                                  child: const Icon(Icons.arrow_drop_down_rounded, size: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron buttons
              if (widget.headerStyle.leftChevronVisible)
                IconButton(
                  onPressed: widget.onLeftChevronTap,
                  icon: const Icon(Icons.chevron_left_rounded, size: 30),
                ),
              if (widget.headerStyle.rightChevronVisible)
                IconButton(
                  onPressed: widget.onRightChevronTap,
                  icon: const Icon(Icons.chevron_right_rounded, size: 30),
                ),
            ],
          ),

          // Days abbreviation
          LayoutBuilder(
            builder: (_, constraint) => Row(
              children: [
                ...List.generate(
                  7,
                  (index) => Container(
                    width: constraint.maxWidth / 7,
                    height: constraint.maxWidth / 7 - 20,
                    alignment: Alignment.center,
                    child: Text(
                      _getWeekdaysAbbrevByNumber(index),
                      style: widget.headerStyle.weekDaysTextStyle.copyWith(color: (widget.isDarkMode ? Colors.white : Colors.black).withOpacity(0.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onToggleMonthPicker() {
    if (showMonthPicker && chevronMonthController.status == AnimationStatus.completed) {
      chevronMonthController.reverse(from: 1);
      showMonthPicker = !showMonthPicker;
      widget.onTogglePicker(OpenPickerStatus.close);
    } else if (!showMonthPicker && chevronMonthController.status == AnimationStatus.dismissed) {
      // Open month picker
      chevronMonthController.forward(from: 0);
      showMonthPicker = !showMonthPicker;

      // Close year picker if open
      if (showYearPicker) {
        showYearPicker = false;
        chevronYearController.reverse();
      }

      widget.onTogglePicker(OpenPickerStatus.showMonthPicker);
    }
  }

  _onToggleYearPicker() {
    if (showYearPicker && chevronYearController.status == AnimationStatus.completed) {
      chevronYearController.reverse(from: 1);
      showYearPicker = !showYearPicker;
      widget.onTogglePicker(OpenPickerStatus.close);
    } else if (!showYearPicker && chevronYearController.status == AnimationStatus.dismissed) {
      // Open year picker
      chevronYearController.forward(from: 0);
      showYearPicker = !showYearPicker;

      // Close month picker if open
      if (showMonthPicker) {
        showMonthPicker = false;
        chevronMonthController.reverse();
      }

      widget.onTogglePicker(OpenPickerStatus.showYearPicker);
    }
  }

  _getWeekdaysAbbrevByNumber(int number) {
    switch (number) {
      case 0:
        return 'Su';
      case 1:
        return 'Mo';
      case 2:
        return 'Tu';
      case 3:
        return 'We';
      case 4:
        return 'Th';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      default:
        return '';
    }
  }

  final fullMonthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}
