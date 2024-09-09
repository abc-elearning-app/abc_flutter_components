import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../utils.dart';
import 'header_style.dart';
import 'month_picker.dart';

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
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;
  final Function(DateTime) setSelectedYear;

  const CalendarHeader({
    Key? key,
    this.locale,
    required this.focusedDate,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
    required this.firstDate,
    required this.lastDate,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.setSelectedYear,
    required this.isDarkMode,
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
    print(widget.focusedDate.month);
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.27)),
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
                            value: widget.focusedDate.month,
                            underline: const SizedBox(),
                            // TODO: Dropdown icon
                            items: List.generate(
                                13,
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
                            onChanged: (_) {},
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
                              // TODO: Dropdown icon
                              items: List.generate(
                                  10,
                                  (index) => DropdownMenuItem(
                                        value: 2024 + index,
                                        child: Text(
                                          (2024 + index).toString(),
                                          style: TextStyle(
                                            color: widget.isDarkMode ? Colors.white : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )),
                              onChanged: (_) {}),
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
              // if (widget.headerStyle.rightChevronVisible)
              //   CustomIconButton(
              //     icon: widget.headerStyle.leftChevronIcon,
              //     onTap: () {
              //       if (_isYearSelection) {
              //         _yearPageController.animateToPage(
              //           _yearDisplayPage - 1,
              //           duration: const Duration(milliseconds: 400),
              //           curve: Curves.easeIn,
              //         );
              //       } else {
              //         widget.onLeftChevronTap.call();
              //       }
              //     },
              //     margin: widget.headerStyle.leftChevronMargin,
              //     padding: widget.headerStyle.leftChevronPadding,
              //   ),
              // if (widget.headerStyle.rightChevronVisible)
              //   CustomIconButton(
              //     icon: widget.headerStyle.rightChevronIcon,
              //     onTap: () {
              //       if (_isYearSelection) {
              //         _yearPageController.animateToPage(
              //           _yearDisplayPage + 1,
              //           duration: const Duration(milliseconds: 400),
              //           curve: Curves.easeIn,
              //         );
              //       } else {
              //         widget.onRightChevronTap.call();
              //       }
              //     },
              //     margin: widget.headerStyle.rightChevronMargin,
              //     padding: widget.headerStyle.rightChevronPadding,
              //   ),
            ],
          ),
          if (_isYearSelection)
            Divider(
              thickness: 2,
              color: Colors.grey.withOpacity(0.3),
            ),
          if (_isYearSelection)
            MonthPicker(
                yearPageController: _yearPageController,
                initialDate: widget.focusedDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                primaryColor: widget.primaryColor,
                onPrimaryColor: widget.onPrimaryColor,
                surfaceColor: widget.surfaceColor,
                onSurfaceColor: widget.onSurfaceColor,
                setYearDisplayPage: (page) {
                  setState(() => _yearDisplayPage = page);
                },
                setSelectedYear: widget.setSelectedYear),
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

  List<String> fullMonthNames = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}
