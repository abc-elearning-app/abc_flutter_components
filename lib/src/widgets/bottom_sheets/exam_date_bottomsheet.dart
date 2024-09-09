import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../table_calendar/utils.dart';

class ExamDateBottomsheet extends StatefulWidget {
  final String dropdownIcon;
  final String bellIcon;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool isDarkMode;

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
  });

  @override
  State<ExamDateBottomsheet> createState() => _ExamDateBottomsheetState();
}

class _ExamDateBottomsheetState extends State<ExamDateBottomsheet> {
  bool initialized = false;

  late DateTime rangeStart;
  late DateTime rangeEnd;
  late DateTime focusedDate;

  @override
  void initState() {
    rangeStart = DateTime.now();
    rangeEnd = DateTime.now().add(const Duration(days: 10));
    focusedDate = DateTime.now();

    initializeDateFormatting('vi_VN', null).then((value) => setState(() => initialized = true));
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
                child: Text('Select Exam Date',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: widget.isDarkMode ? Colors.white : Colors.black)),
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
                  onPressed: () => widget.onSave(DateTime.now().add(const Duration(days: 10))),
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
                Text(_getDisplayDate(DateTime.now()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.mainColor))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Days left', style: TextStyle(fontSize: 12, color: widget.isDarkMode ? Colors.white : Colors.black)),
                Text('23 Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.mainColor))
              ],
            ),
          ],
        ),
      );

  Widget _calendarBox() => initialized
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 15),
          height: 380,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white),
          child: SingleChildScrollView(
            child: TableCalendar(
              mainColor: widget.mainColor,
              secondaryColor: widget.secondaryColor,
              bellIcon: widget.bellIcon,
              focusedDay: DateTime.now().add(const Duration(days: 2)),
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 10000)),
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              calendarFormat: CalendarFormat.month,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
              isDarkMode: widget.isDarkMode,
              onRangeSelected: (startDate, endDate, focusedDate) {
                setState(() {
                  if (startDate != null) {
                    rangeStart = startDate;
                    rangeEnd = rangeStart;
                  }
                  if (endDate != null) rangeEnd = endDate;
                });
              },
            ),
          ),
        )
      : const SizedBox();

  _getDisplayDate(DateTime time) {
    List<String> abrMonthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${abrMonthNames[time.month]} ${time.day}, ${time.year}';
  }
}
