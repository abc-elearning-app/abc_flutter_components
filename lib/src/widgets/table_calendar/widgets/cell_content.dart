import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:intl/intl.dart';

import 'calendar_builder.dart';
import 'calendar_style.dart';

class CellContent extends StatelessWidget {
  final DateTime day;
  final DateTime focusedDay;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;
  final Color mainColor;
  final Color secondaryColor;
  final String bellIcon;

  const CellContent({
    Key? key,
    required this.day,
    required this.focusedDay,
    required this.calendarStyle,
    required this.calendarBuilders,
    required this.isTodayHighlighted,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    required this.mainColor,
    required this.secondaryColor,
    required this.bellIcon,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(locale).format(day);
    final dayLabel = DateFormat.yMMMMd(locale).format(day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell = calendarBuilders.prioritizedBuilder?.call(context, day, focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${day.day}';
    final margin = calendarStyle.cellMargin;
    final padding = calendarStyle.cellPadding;
    final alignment = calendarStyle.cellAlignment;
    final rangeStartDecoration = BoxDecoration(
      color: const Color(0xFF5497FF),
      borderRadius: BorderRadius.circular(8),
    );
    final rangeEndDecoration = BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(8));

    if (isRangeStart) {
      cell = calendarBuilders.rangeStartBuilder?.call(context, day, focusedDay) ??
          Container(
            height: 32,
            width: 32,
            margin: margin,
            padding: padding,
            decoration: rangeStartDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.rangeStartTextStyle),
          );
    } else if (isRangeEnd) {
      cell = Stack(children: [
        calendarBuilders.rangeEndBuilder?.call(context, day, focusedDay) ??
            Container(
              height: 32,
              width: 32,
              margin: margin,
              padding: padding,
              decoration: rangeEndDecoration,
              alignment: alignment,
              child: Text(text, style: calendarStyle.rangeEndTextStyle),
            ),
        Positioned(
          top: 0,
          right: 0,
          child: Transform.translate(
            offset: const Offset(5, -5),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: IconWidget(icon: bellIcon, height: 10),
            ),
          ),
        ),
      ]);
    } else if (isOutside) {
      cell = calendarBuilders.outsideBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.outsideTextStyle),
          );
    } else if (isDisabled) {
      cell = calendarBuilders.disabledBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: calendarStyle.disabledDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.disabledTextStyle),
          );
    } else if (isSelected) {
      cell = calendarBuilders.selectedBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: calendarStyle.selectedDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.selectedTextStyle),
          );
    } else if (isToday && isTodayHighlighted) {
      cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: const EdgeInsets.all(6),
            padding: padding,
            decoration: calendarStyle.todayDecoration,
            alignment: alignment,
            child: Center(child: Text(text, style: calendarStyle.todayTextStyle.copyWith(color: mainColor))),
          );
    } else if (isHoliday) {
      cell = calendarBuilders.holidayBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.holidayTextStyle),
          );
    } else if (isWithinRange) {
      cell = calendarBuilders.withinRangeBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: calendarStyle.withinRangeDecoration,
            alignment: alignment,
            child: Text(text, style: calendarStyle.withinRangeTextStyle),
          );
    } else {
      cell = calendarBuilders.defaultBuilder?.call(context, day, focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: isWeekend ? calendarStyle.weekendDecoration : calendarStyle.defaultDecoration,
            alignment: alignment,
            child: Text(
              text,
              style: isWeekend ? calendarStyle.weekendTextStyle : calendarStyle.defaultTextStyle,
            ),
          );
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: cell,
    );
  }
}
