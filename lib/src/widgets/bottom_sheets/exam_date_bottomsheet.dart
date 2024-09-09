import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/table_calendar/table_calendar.dart';

import '../table_calendar/utils.dart';

class ExamDateBottomsheet extends StatefulWidget {
  final String dropdownIcon;
  final String bellIcon;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool isDarkMode;

  final DateTime startDate;
  final DateTime examDate;

  final void Function(DateTime examDate) onSave;

  const ExamDateBottomsheet({
    super.key,
    required this.dropdownIcon,
    required this.isDarkMode,
    required this.mainColor,
    required this.backgroundColor,
    required this.secondaryColor,
    required this.bellIcon,
    required this.onSave,
    required this.startDate,
    required this.examDate,
  });

  @override
  State<ExamDateBottomsheet> createState() => _ExamDateBottomsheetState();
}

class _ExamDateBottomsheetState extends State<ExamDateBottomsheet> {
  late DateTime selectedExamDate;
  late DateTime focusedDate;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    firstDate = widget.startDate;
    lastDate = DateTime.now().add(const Duration(days: 100000));
    selectedExamDate = widget.examDate;
    focusedDate = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconWidget(icon: widget.dropdownIcon),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Select Exam Date',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: widget.isDarkMode ? Colors.white : Colors.black),
                ),
              ),
              _informationBox(),
              _calendarBox(),
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  title: 'Save',
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  borderRadius: 16,
                  backgroundColor: widget.mainColor,
                  textColor: Colors.white,
                  disabled: selectedExamDate.difference(widget.examDate).inDays == 0 || selectedExamDate.difference(widget.startDate).inDays == 0,
                  disabledColor: (widget.isDarkMode ? Colors.white : Colors.black).withOpacity(0.12),
                  onPressed: () => widget.onSave(selectedExamDate),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _informationBox() => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('When is your exam date?', style: TextStyle(fontSize: 12, color: widget.isDarkMode ? Colors.white : Colors.black)),
                Text(_getDisplayDate(selectedExamDate), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.mainColor))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Days left', style: TextStyle(fontSize: 12, color: widget.isDarkMode ? Colors.white : Colors.black)),
                Text(
                  '${_getRoundedTime(selectedExamDate).difference(_getRoundedTime(widget.startDate)).inDays} Days',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.mainColor),
                )
              ],
            ),
          ],
        ),
      );

  Widget _calendarBox() => Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white),
        child: TableCalendar(
          rowHeight: 40,
          focusedDay: focusedDate,
          firstDay: firstDate,
          lastDay: lastDate,
          onDisabledDayTapped: (_) => showToastError('Please select a date in the future'),
          rangeStartDay: widget.startDate,
          rangeEndDay: selectedExamDate,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          mainColor: widget.mainColor,
          calendarFormat: CalendarFormat.month,
          secondaryColor: widget.secondaryColor,
          bellIcon: widget.bellIcon,
          isDarkMode: widget.isDarkMode,
          onRangeSelected: (date, _, __) {
            setState(() {
              if (date != null) selectedExamDate = date;
            });
          },
        ),
      );

  _getDisplayDate(DateTime time) {
    List<String> abrMonthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${abrMonthNames[time.month]} ${time.day}, ${time.year}';
  }

  _getRoundedTime(DateTime time) => time.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
