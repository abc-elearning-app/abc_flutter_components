import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/streak/widgets/challenge_section.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:table_calendar/table_calendar.dart';

class StreakScreen extends StatefulWidget {
  final bool isStarted;

  const StreakScreen({
    super.key,
    required this.isStarted,
  });

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  // Can be toggled on/off by long pressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final mainColor = const Color(0xFFEEAF56);

  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;

  @override
  void initState() {
    _rangeStart = DateTime(2024, 5, 28);
    _rangeEnd = DateTime(2024, 6, 12);
    kToday = DateTime.now();
    kFirstDay = DateTime(kToday.year - 10, kToday.month, kToday.day);
    kLastDay = DateTime(kToday.year + 10, kToday.month, kToday.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Streak',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          children: [
            Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/streak_background.png'),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StrokeText(
                              text: '12',
                              textStyle: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFE3A651),
                              ),
                              strokeColor: Colors.white,
                              textScaler: TextScaler.linear(6),
                              strokeWidth: 6),
                          Transform.translate(
                            offset: const Offset(0, -10),
                            child: const StrokeText(
                                text: 'Day Streak',
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFE3A651),
                                ),
                                strokeColor: Colors.white,
                                strokeWidth: 3),
                          ),
                        ],
                      ),
                      SvgPicture.asset('assets/images/streak_fire.svg')
                    ],
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 15),
                  child: Text(
                    'Streak Challenge',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                ChallengeSection(
                  isStarted: widget.isStarted,
                  mainColor: mainColor,
                ),
                TableCalendar(
                  shieldedDays: [
                    DateTime.now(),
                    DateTime.now().add(const Duration(days: 2)),
                    DateTime.now().add(const Duration(days: 5)),
                  ],
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    withinRangeTextStyle:
                        TextStyle(fontSize: 16, color: mainColor),
                    rangeStartTextStyle:
                        TextStyle(fontSize: 16, color: mainColor),
                    rangeHighlightColor: mainColor.withOpacity(0.2),
                    rangeStartDecoration: BoxDecoration(
                      color: mainColor.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(60),
                        right: Radius.zero,
                      ),
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _rangeStart = null; // Important to clean those
                        _rangeEnd = null;
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                      });
                    }
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    setState(() {
                      _selectedDay = null;
                      _focusedDay = focusedDay;
                      _rangeStart = start;
                      _rangeEnd = end;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
