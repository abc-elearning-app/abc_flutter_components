// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../customization/header_style.dart';
import '../shared/utils.dart';
import 'month_picker.dart';

class CalendarHeader extends StatefulWidget {
  final dynamic locale;
  final DateTime focusedMonth;
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
    required this.focusedMonth,
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
    _yearDisplayPage = widget.focusedMonth.year ~/ 15;
    _yearPageController = PageController(initialPage: _yearDisplayPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.headerStyle.titleTextFormatter
            ?.call(widget.focusedMonth, widget.locale) ??
        DateFormat.yMMMM('en').format(widget.focusedMonth);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.27)),
      margin: widget.headerStyle.headerMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      _getWeekdaysAbbreviationByNumber(index),
                      style: widget.headerStyle.weekDaysTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: GestureDetector(
          //         onTap: () {
          //           // onHeaderTap.call();
          //           setState(() {
          //             _isYearSelection = !_isYearSelection;
          //           });
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 18.0, vertical: 10),
          //           child: Container(
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 widget.headerTitleBuilder
          //                         ?.call(context, widget.focusedMonth) ??
          //                     Text(
          //                       text,
          //                       style: widget.headerStyle.titleTextStyle,
          //                     ),
          //                 const SizedBox(width: 10),
          //                 Icon(
          //                   _isYearSelection
          //                       ? Icons.arrow_drop_up_sharp
          //                       : Icons.arrow_drop_down_sharp,
          //                   size: 24,
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     if (widget.headerStyle.leftChevronVisible)
          //       CustomIconButton(
          //         icon: widget.headerStyle.leftChevronIcon,
          //         onTap: () {
          //           if (_isYearSelection) {
          //             _yearPageController.animateToPage(
          //               _yearDisplayPage - 1,
          //               duration: const Duration(milliseconds: 400),
          //               curve: Curves.easeIn,
          //             );
          //           } else {
          //             widget.onLeftChevronTap.call();
          //           }
          //         },
          //         margin: widget.headerStyle.leftChevronMargin,
          //         padding: widget.headerStyle.leftChevronPadding,
          //       ),
          //     if (widget.headerStyle.rightChevronVisible)
          //       CustomIconButton(
          //         icon: widget.headerStyle.rightChevronIcon,
          //         onTap: () {
          //           if (_isYearSelection) {
          //             _yearPageController.animateToPage(
          //               _yearDisplayPage + 1,
          //               duration: const Duration(milliseconds: 400),
          //               curve: Curves.easeIn,
          //             );
          //           } else {
          //             widget.onRightChevronTap.call();
          //           }
          //         },
          //         margin: widget.headerStyle.rightChevronMargin,
          //         padding: widget.headerStyle.rightChevronPadding,
          //       ),
          //   ],
          // ),
          if (_isYearSelection)
            Divider(
              thickness: 2,
              color: Colors.grey.withOpacity(0.3),
            ),
          if (_isYearSelection)
            MonthPicker(
                yearPageController: _yearPageController,
                initialDate: widget.focusedMonth,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                primaryColor: widget.primaryColor,
                onPrimaryColor: widget.onPrimaryColor,
                surfaceColor: widget.surfaceColor,
                onSurfaceColor: widget.onSurfaceColor,
                setYearDisplayPage: (page) {
                  setState(() => _yearDisplayPage = page);
                },
                setSelectedYear: widget.setSelectedYear)
        ],
      ),
    );
  }

  String _getWeekdaysAbbreviationByNumber(int number) {
    switch (number) {
      case 0:
        return 'SUN';
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      default:
        return '';
    }
  }
}
