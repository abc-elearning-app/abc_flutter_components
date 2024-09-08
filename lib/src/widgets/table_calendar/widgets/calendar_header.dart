import 'package:flutter/material.dart';

import '../utils.dart';
import 'header_style.dart';

class CalendarHeader extends StatefulWidget {
  final bool isDarkMode;
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
    required this.setSelectedYear, required this.isDarkMode,
  }) : super(key: key);

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: widget.headerStyle.headerMargin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (_, constraint) =>
                Row(
                  children: [
                    ...List.generate(
                      7,
                          (index) =>
                          Container(
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
          //           padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          //           child: Container(
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 widget.headerTitleBuilder?.call(context, widget.focusedMonth) ??
          //                     Text(
          //                       text,
          //                       style: widget.headerStyle.titleTextStyle,
          //                     ),
          //                 const SizedBox(
          //                   width: 10,
          //                 ),
          //                 Icon(
          //                   _isYearSelection ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp,
          //                   size: 24,
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
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
          // if (_isYearSelection)
          //   Divider(
          //     thickness: 2,
          //     color: Colors.grey.withOpacity(0.3),
          //   ),
          // if (_isYearSelection)
          //   MonthPicker(
          //       yearPageController: _yearPageController,
          //       initialDate: widget.focusedMonth,
          //       firstDate: widget.firstDate,
          //       lastDate: widget.lastDate,
          //       primaryColor: widget.primaryColor,
          //       onPrimaryColor: widget.onPrimaryColor,
          //       surfaceColor: widget.surfaceColor,
          //       onSurfaceColor: widget.onSurfaceColor,
          //       setYearDisplayPage: (page) {
          //         setState(() => _yearDisplayPage = page);
          //       },
          //       setSelectedYear: widget.setSelectedYear)
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
}
