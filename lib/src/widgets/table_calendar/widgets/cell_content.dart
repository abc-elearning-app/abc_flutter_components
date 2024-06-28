// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../customization/calendar_builders.dart';
import '../customization/calendar_style.dart';
import '../table_calendar.dart';

class CellContent extends StatefulWidget {
  final DateTime day;
  final DateTime focusedDay;
  final dynamic locale;
  final bool isTodayHighlighted;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isShielded;
  final bool isWithinRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isHoliday;
  final bool isWeekend;
  final int shieldAnimationDelay;
  final OpenType openType;
  final CalendarStyle calendarStyle;
  final CalendarBuilders calendarBuilders;

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
    required this.isShielded,
    required this.isWithinRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isHoliday,
    required this.isWeekend,
    required this.shieldAnimationDelay,
    required this.openType,
    this.locale,
  }) : super(key: key);

  @override
  State<CellContent> createState() => _CellContentState();
}

class _CellContentState extends State<CellContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _sparklingController;
  late Animation _sparklingAnimation1;
  late Animation _sparklingAnimation2;
  late Animation _sparklingAnimation3;

  final int joinChallengeDelayTime = 500;

  @override
  void initState() {
    _sparklingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _sparklingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _sparklingController.forward(from: 0);
      }
    });
    _sparklingAnimation1 = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _sparklingController,
        curve: Interval(0, 0.5, curve: Curves.easeInOut)));
    _sparklingAnimation2 = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _sparklingController,
        curve: Interval(0.25, 0.75, curve: Curves.easeInOut)));
    _sparklingAnimation3 = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _sparklingController,
        curve: Interval(0.5, 1, curve: Curves.easeInOut)));

    if (widget.isToday && widget.isShielded)
      Future.delayed(
          Duration(seconds: widget.openType == FontWeight.normal ? 0 : 2),
          () => _sparklingController.forward());

    super.initState();
  }

  @override
  void dispose() {
    _sparklingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dowLabel = DateFormat.EEEE(widget.locale).format(widget.day);
    final dayLabel = DateFormat.yMMMMd(widget.locale).format(widget.day);
    final semanticsLabel = '$dowLabel, $dayLabel';

    Widget? cell = widget.calendarBuilders.prioritizedBuilder
        ?.call(context, widget.day, widget.focusedDay);

    if (cell != null) {
      return Semantics(
        label: semanticsLabel,
        excludeSemantics: true,
        child: cell,
      );
    }

    final text = '${widget.day.day}';
    final margin = widget.calendarStyle.cellMargin;
    final padding = widget.calendarStyle.cellPadding;
    final alignment = widget.calendarStyle.cellAlignment;

    if (widget.isDisabled) {
      cell = widget.calendarBuilders.disabledBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.disabledDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.disabledTextStyle),
          );
    } else if (widget.isSelected) {
      cell = widget.calendarBuilders.selectedBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.selectedDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.selectedTextStyle),
          );
    } else if (widget.isToday) {
      cell = widget.calendarBuilders.todayBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          _buildTodayCell(margin, padding, alignment, text);
    } else if (widget.isShielded) {
      cell = Container(
        margin: margin,
        padding: padding,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/shield.png', scale: 0.8),
            Text(text)
          ],
        ),
      );
    } else if (widget.isRangeEnd ||
        (widget.isRangeStart && widget.isRangeEnd)) {
      cell = Container(
        margin: margin,
        padding: padding,
        child: widget.calendarBuilders.rangeEndBuilder
                ?.call(context, widget.day, widget.focusedDay) ??
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Transform.scale(
                    scale: 3,
                    child: Image.asset('assets/images/burning.gif'),
                  ),
                ),
                CircleAvatar(
                  child: Container(
                      decoration: widget.calendarStyle.rangeEndDecoration,
                      alignment: alignment,
                      child: Center(
                          child: Text(text,
                              style: widget.calendarStyle.rangeEndTextStyle))),
                ),
              ],
            ),
      );
    } else if (widget.isRangeStart) {
      cell = widget.calendarBuilders.rangeStartBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.rangeStartDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.rangeStartTextStyle),
          );
    }
    // else if (isToday && isTodayHighlighted) {
    //   cell = calendarBuilders.todayBuilder?.call(context, day, focusedDay) ??
    //       Container(
    //         margin: margin,
    //         padding: padding,
    //         decoration: calendarStyle.todayDecoration,
    //         alignment: alignment,
    //         child: Text(text, style: calendarStyle.todayTextStyle),
    //       );
    // }
    else if (widget.isHoliday) {
      cell = widget.calendarBuilders.holidayBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.holidayDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.holidayTextStyle),
          );
    } else if (widget.isWithinRange) {
      cell = widget.calendarBuilders.withinRangeBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.withinRangeDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.withinRangeTextStyle),
          );
    } else if (widget.isOutside) {
      cell = widget.calendarBuilders.outsideBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.calendarStyle.outsideDecoration,
            alignment: alignment,
            child: Text(text, style: widget.calendarStyle.outsideTextStyle),
          );
    } else {
      cell = widget.calendarBuilders.defaultBuilder
              ?.call(context, widget.day, widget.focusedDay) ??
          Container(
            margin: margin,
            padding: padding,
            decoration: widget.isWeekend
                ? widget.calendarStyle.weekendDecoration
                : widget.calendarStyle.defaultDecoration,
            alignment: alignment,
            child: Text(text,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5), fontSize: 16)
                // isWeekend
                //     ? calendarStyle.weekendTextStyle
                //     : calendarStyle.defaultTextStyle,
                ),
          );
    }

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: cell,
    );
  }

  _buildTodayCell(
    EdgeInsets margin,
    EdgeInsets padding,
    AlignmentGeometry alignment,
    String text,
  ) {
    Widget child = Placeholder();

    switch (widget.openType) {
      case OpenType.notStarted:
        child = Center(
            child: CircleAvatar(
                child: Container(
                    decoration: widget.calendarStyle.rangeEndDecoration,
                    alignment: alignment,
                    child: Center(
                        child: Text(text,
                            style: widget.calendarStyle.rangeEndTextStyle)))));
        break;
      case OpenType.joinChallenge:
        child = Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
              future: Future.delayed(
                  Duration(milliseconds: joinChallengeDelayTime + 500)),
              builder: (_, snapShot) =>
                  snapShot.connectionState == ConnectionState.done
                      ? Transform.translate(
                          offset: const Offset(0, -25),
                          child: Transform.scale(
                            scale: 3,
                            child: Image.asset('assets/images/burning.gif'),
                          ),
                        )
                      : SizedBox.shrink(),
            ),
            CircleAvatar(
              child: Container(
                  decoration: widget.calendarStyle.rangeEndDecoration,
                  alignment: alignment,
                  child: Center(
                      child: Text(text,
                          style: widget.calendarStyle.rangeEndTextStyle))),
            ),
          ],
        );
        break;
      case OpenType.normal:
        child = widget.isShielded
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/shield.png', scale: 0.8),
                  Text(text),
                  _sparkleAnimation()
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.openType != OpenType.notStarted)
                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: Transform.scale(
                        scale: 3,
                        child: Image.asset('assets/images/burning.gif'),
                      ),
                    ),
                  CircleAvatar(
                    child: Container(
                        decoration: widget.calendarStyle.rangeEndDecoration,
                        alignment: alignment,
                        child: Center(
                            child: Text(text,
                                style:
                                    widget.calendarStyle.rangeEndTextStyle))),
                  ),
                ],
              );
        break;
      case OpenType.useShield:
        child = Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
              future: Future.delayed(
                  Duration(milliseconds: widget.shieldAnimationDelay + 200)),
              builder: (_, snapShot) => Opacity(
                opacity:
                    snapShot.connectionState == ConnectionState.done ? 1 : 0,
                child: Hero(
                  tag: 'shield',
                  child: Image.asset(
                    'assets/images/shield.png',
                    scale: 0.8,
                  ),
                ),
              ),
            ),
            Text(text),
            _sparkleAnimation()
          ],
        );
    }

    return Container(margin: margin, padding: padding, child: child);
  }

  _sparkleAnimation() => AnimatedBuilder(
      animation: _sparklingController,
      builder: (_, __) => Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: _sparklingAnimation1.value,
                child: Transform.translate(
                    offset: const Offset(-15, -15),
                    child: SvgPicture.asset('assets/images/sparkle.svg')),
              ),
              Opacity(
                opacity: _sparklingAnimation2.value,
                child: Transform.translate(
                    offset: const Offset(0, 25),
                    child: SvgPicture.asset('assets/images/sparkle.svg')),
              ),
              Opacity(
                opacity: _sparklingAnimation3.value,
                child: Transform.translate(
                    offset: const Offset(20, 0),
                    child: SvgPicture.asset('assets/images/sparkle.svg')),
              ),
            ],
          ));
}
