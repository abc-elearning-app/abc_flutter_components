import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final PageController yearPageController;
  final Function(int) setYearDisplayPage;
  final Function(DateTime) setSelectedYear;

  const MonthPicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.yearPageController,
    required this.setYearDisplayPage,
    required this.setSelectedYear,
  }) : super(key: key);

  @override
  State<MonthPicker> createState() => __MonthPickerState();
}

class __MonthPickerState extends State<MonthPicker> {
  final _pageViewKey = GlobalKey();
  late DateTime _selectedDate;
  late final DateTime _firstDate;
  late final DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(widget.firstDate.year, widget.firstDate.month);
    _lastDate = DateTime(widget.lastDate.year, widget.lastDate.month);
    _selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pager = _buildPager(
      theme.colorScheme,
      widget.primaryColor,
      widget.onPrimaryColor,
      widget.surfaceColor,
      widget.onSurfaceColor,
    );
    return pager;
  }

  _buildPager(
    ColorScheme colorScheme,
    Color primaryColor,
    Color onPrimaryColor,
    Color surfaceColor,
    Color onSurfaceColor,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 300,
      child: PageView.builder(
        key: _pageViewKey,
        controller: widget.yearPageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) => widget.setYearDisplayPage(index),
        pageSnapping: true,
        itemBuilder: (context, page) {
          return Center(
            child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: List<int>.generate(15, (i) => page * 15 + i)
                    .map((year) => DateTime(year, _selectedDate.month))
                    .map(
                      (date) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getYearButton(
                          date,
                          colorScheme,
                          widget.primaryColor,
                          widget.onPrimaryColor,
                          widget.surfaceColor,
                          widget.onSurfaceColor,
                        ),
                      ),
                    )
                    .toList()),
          );
        },
      ),
    );
  }

  _getYearButton(
    DateTime date,
    ColorScheme colorScheme,
    Color primaryColor,
    Color onPrimaryColor,
    Color surfaceColor,
    Color onSurfaceColor,
  ) {
    bool isSelected =
        date.month == _selectedDate.month && date.year == _selectedDate.year;

    return TextButton(
      onPressed: () {
        if (widget.firstDate.year > date.year ||
            widget.lastDate.year < date.year) return;
        setState(() => _selectedDate = DateTime(date.year, date.month));
        widget.setSelectedYear(_selectedDate);
        print("Hello");
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : null,
        foregroundColor: widget.firstDate.year > date.year ||
                widget.lastDate.year < date.year
            ? Colors.grey
            : isSelected
                ? onPrimaryColor
                : date.year == DateTime.now().year
                    ? primaryColor
                    : onSurfaceColor.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        DateFormat.y().format(DateTime(date.year)),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}
