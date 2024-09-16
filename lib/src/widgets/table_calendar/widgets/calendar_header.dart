import 'package:flutter/material.dart';

import '../utils.dart';
import 'header_style.dart';

class CalendarHeader extends StatefulWidget {
  final bool isDarkMode;
  final dynamic locale;
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
  final DayBuilder? headerTitleBuilder;
  final Function(DateTime date) setSelectedDate;

  const CalendarHeader({
    Key? key,
    this.locale,
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
    this.headerTitleBuilder,
  }) : super(key: key);

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  var _isYearSelection = false;
  late int _yearDisplayPage;
  late final PageController _yearPageController;

  @override
  void initState() {
    _yearDisplayPage = widget.focusedDate.year ~/ 15;
    _yearPageController = PageController(initialPage: _yearDisplayPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white.withOpacity(0.27),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
      ),
      margin: widget.headerStyle.headerMargin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // onHeaderTap.call();
                    setState(() {
                      _isYearSelection = !_isYearSelection;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 3,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: DropdownButton(
                            value: widget.focusedDate.month - 1,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded, size: 30),
                            menuMaxHeight: 200,
                            borderRadius: BorderRadius.circular(10),
                            items: List.generate(
                                12,
                                (index) => DropdownMenuItem(
                                      value: index,
                                      child: Text(
                                        fullMonthNames[index],
                                        style: TextStyle(
                                          color: widget.isDarkMode ? Colors.white : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                            onChanged: (int? selectedMonth) {
                              if (selectedMonth != null) widget.setSelectedDate(widget.focusedDate.copyWith(month: selectedMonth + 1));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: DropdownButton(
                              value: widget.focusedDate.year,
                              underline: const SizedBox(),
                              menuMaxHeight: 200,
                              borderRadius: BorderRadius.circular(10),
                              icon: const Icon(Icons.arrow_drop_down_rounded, size: 30),
                              items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem(
                                        value: DateTime.now().year + index,
                                        child: Text(
                                          (DateTime.now().year + index).toString(),
                                          style: TextStyle(
                                            color: widget.isDarkMode ? Colors.white : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )),
                              onChanged: (int? selectedYear) {
                                if (selectedYear != null) widget.setSelectedDate(widget.focusedDate.copyWith(year: selectedYear));
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.headerStyle.leftChevronVisible)
                IconButton(
                  onPressed: () {
                    if (_isYearSelection) {
                      _yearPageController.animateToPage(
                        _yearDisplayPage - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    } else {
                      widget.onLeftChevronTap.call();
                    }
                  },
                  icon: const Icon(Icons.chevron_left_rounded, size: 30),
                ),
              if (widget.headerStyle.rightChevronVisible)
                IconButton(
                  onPressed: () {
                    if (_isYearSelection) {
                      _yearPageController.animateToPage(
                        _yearDisplayPage + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    } else {
                      widget.onRightChevronTap.call();
                    }
                  },
                  icon: const Icon(Icons.chevron_right_rounded, size: 30),
                ),
            ],
          ),
          // MonthPicker(
          //     yearPageController: _yearPageController,
          //     initialDate: widget.focusedDate,
          //     firstDate: widget.firstDate,
          //     lastDate: widget.lastDate,
          //     primaryColor: widget.primaryColor,
          //     onPrimaryColor: widget.onPrimaryColor,
          //     surfaceColor: widget.surfaceColor,
          //     onSurfaceColor: widget.onSurfaceColor,
          //     setYearDisplayPage: (page) {
          //       setState(() => _yearDisplayPage = page);
          //     },
          //     setSelectedYear: widget.setSelectedYear),

          // Days abbreviation
          LayoutBuilder(
            builder: (_, constraint) => Row(
              children: [
                ...List.generate(
                  7,
                  (index) => Container(
                    width: constraint.maxWidth / 7,
                    height: constraint.maxWidth / 7,
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

  String _getWeekdaysAbbrevByNumber(int number) {
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

  List<String> fullMonthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}
