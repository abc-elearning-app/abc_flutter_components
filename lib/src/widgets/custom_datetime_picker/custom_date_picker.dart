import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// DatePicker Ultra pro max
enum PickerType { day, month, year }

class CustomDatePicker extends StatefulWidget {
  final void Function(DateTime selectedDate) onSelectDate;

  const CustomDatePicker({super.key, required this.onSelectDate});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _dayController = FixedExtentScrollController(initialItem: 0);
  final _monthController = FixedExtentScrollController(initialItem: 0);
  final _yearController = FixedExtentScrollController(initialItem: 0);

  int startDayIndex = 0;
  int maxDayIndex = 28;
  int startMonthIndex = 0;

  final List<String> monthStrings = [
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
  final List<String> yearStrings = List.generate(30, (index) => (DateTime.now().year + index).toString());

  @override
  void initState() {
    final currentDateTime = DateTime.now();

    // Get maximum days in current month
    startDayIndex = currentDateTime.day - 1;
    maxDayIndex = _getDaysInMonth(currentDateTime.year, currentDateTime.month);

    // Get minimum month
    startMonthIndex = currentDateTime.month - 1;

    // Scroll to minimum day and month
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dayController.selectedItem < startDayIndex) {
        _dayController.animateToItem(startDayIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      if (_monthController.selectedItem < startMonthIndex) {
        _monthController.animateToItem(startMonthIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 100, child: _customCupertinoPicker(PickerType.day, List.generate(31, (index) => index + 1))),
          Expanded(child: _customCupertinoPicker(PickerType.month, monthStrings)),
          SizedBox(width: 110, child: _customCupertinoPicker(PickerType.year, yearStrings)),
        ],
      ),

      // Magnifier section
      IgnorePointer(
        ignoring: true,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          ),
        ),
      )
    ]);
  }

  Widget _customCupertinoPicker(PickerType type, List<dynamic> items) => CupertinoPicker(
        scrollController: _getScrollController(type),
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(background: Colors.transparent),
        offAxisFraction: _getOffAxisFraction(type),
        itemExtent: 35,
        magnification: 1.2,
        diameterRatio: 2,
        squeeze: 0.9,
        onSelectedItemChanged: (int value) => _handleSelectDate(type, value),
        children: List.generate(
            items.length,
            (index) => Align(
                  alignment: type != PickerType.day ? Alignment.centerLeft : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: type != PickerType.day ? 15 : 0, right: type == PickerType.day ? 20 : 0),
                    child: Text(
                      items[index].toString(),
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 20, color: _getItemColor(type, index)),
                    ),
                  ),
                )),
      );

  _handleSelectDate(PickerType type, int value) {
    switch (type) {
      case PickerType.day:
        {
          // Block past days and invalid days
          if (_dayController.selectedItem < startDayIndex) {
            _dayController.animateToItem(startDayIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          } else if (_dayController.selectedItem >= maxDayIndex) {
            _dayController.animateToItem(maxDayIndex - 1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          }

          // Update day
          _update();
          break;
        }
      case PickerType.month:
        {
          setState(() {
            // If at current month and year, block scrolling to past days
            if (_monthController.selectedItem == startMonthIndex && _yearController.selectedItem == 0) {
              // Calculate start valid day
              startDayIndex = DateTime.now().day - 1;

              // If current day is past, scroll to minimum valid day
              if (_dayController.selectedItem < startDayIndex) {
                _dayController.animateToItem(startDayIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
              }
            } else {
              // If month and year are in the future, set startDay
              startDayIndex = 0;
            }

            // Calculate days in month to block invalid days
            maxDayIndex = _getDaysInMonth(DateTime.now().year, value + 1);

            // After calculation, if current day is invalid, move to the maximum valid day
            if (_dayController.selectedItem >= maxDayIndex) {
              _dayController.animateToItem(maxDayIndex - 1, duration: const Duration(milliseconds: 200), curve: Curves.linear);
            }

            // Block if scroll to past months
            if (_monthController.selectedItem < startMonthIndex) {
              _monthController.animateToItem(startMonthIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
            }
          });

          // Update month
          _update();
          break;
        }
      case PickerType.year:
        {
          setState(() {
            // If scroll to current year, calculate startMonthIndex to block past months
            if (value == 0) {
              startMonthIndex = DateTime.now().month - 1;

              // If at past month, scroll to minimum valid month
              if (_monthController.selectedItem < startMonthIndex) {
                _monthController.animateToItem(startMonthIndex, duration: const Duration(milliseconds: 200), curve: Curves.linear);
              }

              // If at current month, calculate start day
              if (_monthController.selectedItem == startMonthIndex) {
                startDayIndex = DateTime.now().day - 1;
              }
            } else {
              // If at future years, reset start day and month
              startDayIndex = 0;
              startMonthIndex = 0;
            }
          });

          // Update year
          _update();
          break;
        }
    }
  }

  _update() {
    widget.onSelectDate(DateTime(DateTime.now().year + _yearController.selectedItem, _monthController.selectedItem + 1, _dayController.selectedItem + 1));
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
        return 0.3;
      case PickerType.year:
        return 0.6;
    }
  }

  _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  _getItemColor(PickerType type, int index) {
    switch (type) {
      case PickerType.day:
        return index < startDayIndex || index >= maxDayIndex ? Colors.grey : null;
      case PickerType.month:
        return index < startMonthIndex ? Colors.grey : null;
      case PickerType.year:
        return null;
    }
  }
}
