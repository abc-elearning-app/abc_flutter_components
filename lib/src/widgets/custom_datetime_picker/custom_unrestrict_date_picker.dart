import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// DatePicker Ultra pro max
enum PickerType { day, month, year }

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime selectedDate) onSelectDate;

  const CustomDatePicker(
      {super.key, required this.onSelectDate, this.initialDate});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _dayController = FixedExtentScrollController(initialItem: 0);
  final _monthController = FixedExtentScrollController(initialItem: 0);
  final _yearController = FixedExtentScrollController(initialItem: 0);

  int maxDayIndex = 28;

  // Cupertino picker item lists
  final dayItems = List.generate(31, (index) => (index + 1).toString());

  final monthItems = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final yearItems =
  List.generate(30, (index) =>
      (DateTime
          .now()
          .year + index).toString());

  @override
  void initState() {
    // Get maximum days in current month
    final currentDateTime = widget.initialDate ?? DateTime.now();
    maxDayIndex = _getDaysInMonth(currentDateTime.year, currentDateTime.month);

    // Scroll to initial date
    const scrollDuration = Duration(milliseconds: 200);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dayController.animateToItem(currentDateTime.day - 1,
          duration: scrollDuration, curve: Curves.easeInOut);
      _monthController.animateToItem(currentDateTime.month - 1,
          duration: scrollDuration, curve: Curves.easeInOut);
      _yearController.animateToItem(currentDateTime.year - DateTime
          .now()
          .year,
          duration: scrollDuration, curve: Curves.easeInOut);
    });

    super.initState();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3 cupertino pickers: Day - Month - Year
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: _customCupertinoPicker(
                PickerType.day,
                dayItems,
              )),
          Expanded(
              flex: 2,
              child: _customCupertinoPicker(
                PickerType.month,
                monthItems,
              )),
          Expanded(
              flex: 1,
              child: _customCupertinoPicker(
                PickerType.year,
                yearItems,
              )),
        ],
      ),

      // Magnifier
      IgnorePointer(
        ignoring: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      )
    ]);
  }

  Widget _customCupertinoPicker(PickerType type, List<dynamic> items) =>
      CupertinoPicker(
        scrollController: _getScrollController(type),
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent),
        offAxisFraction: _getOffAxisFraction(type),
        itemExtent: 35,
        magnification: 1.2,
        diameterRatio: 2,
        squeeze: 0.9,
        onSelectedItemChanged: (int value) => _handleSelectDate(type),
        children: List.generate(
            items.length,
                (index) =>
                Align(
                  alignment: type != PickerType.day
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: type != PickerType.day ? 15 : 0,
                        right: type == PickerType.day ? 20 : 0),
                    child: Text(
                      items[index].toString(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: type == PickerType.day
                              ? _getDayItemColor(index, maxDayIndex)
                              : null),
                    ),
                  ),
                )),
      );

  _handleSelectDate(PickerType type) {
    switch (type) {
      case PickerType.day:
        {
          // Avoid scrolling to not exist day
          if (_dayController.selectedItem + 1 > maxDayIndex) {
            _dayController.animateToItem(maxDayIndex - 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.linear);
          }
          break;
        }
      default:
        {
          setState(() {
            // Update the maximum days of selected month
            maxDayIndex = _getDaysInMonth(
                _yearController.selectedItem + DateTime
                    .now()
                    .year,
                _monthController.selectedItem + 1);

            // Scroll back to exist day
            if (_dayController.selectedItem + 1 > maxDayIndex) {
              _dayController.animateToItem(maxDayIndex - 1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            }
          });
        }
    }

    // Trigger callback
    widget.onSelectDate(DateTime(
        DateTime
            .now()
            .year + _yearController.selectedItem,
        _monthController.selectedItem + 1,
        _dayController.selectedItem + 1));
  }

  _getScrollController(PickerType type) {
    switch (type) {
      case PickerType.day:
        return _dayController;
      case PickerType.month:
        return _monthController;
      case PickerType.year:
        return _yearController;
    }
  }

  _getOffAxisFraction(PickerType type) {
    switch (type) {
      case PickerType.day:
        return -0.5;
      case PickerType.month:
        return 0.2;
      case PickerType.year:
        return 0.5 ;
    }
  }

  _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }

    const daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return daysInMonth[month - 1];
  }

  _getDayItemColor(int index, int maxDays) =>
      index >= maxDayIndex ? Colors.grey : null;
}
