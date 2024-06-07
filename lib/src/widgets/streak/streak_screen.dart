import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/streak/widgets/challenge_section.dart';
import 'package:flutter_abc_jsc_components/src/widgets/streak/widgets/general_section.dart';
import 'package:flutter_abc_jsc_components/src/widgets/streak/widgets/popup.dart';
import 'package:gif/gif.dart';
import 'package:table_calendar/table_calendar.dart';

class StreakScreen extends StatefulWidget {
  final bool isStarted;
  final bool refillShield;
  final List<DateTime> shieldedDays;

  final DateTime? rangeStartDate;
  final DateTime? rangeEndDate;

  final Color mainColor;
  final Color progressColor;
  final Color shieldColor;

  final void Function() onJoinChallenge;
  final void Function() onUseShield;

  const StreakScreen({
    super.key,
    required this.isStarted,
    required this.refillShield,
    required this.shieldedDays,
    this.rangeStartDate,
    this.rangeEndDate,
    this.mainColor = const Color(0xFFE3A651),
    this.progressColor = const Color(0xFFFFBA5A),
    this.shieldColor = const Color(0xFF39ACF0),
    required this.onJoinChallenge,
    required this.onUseShield,
  });

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with TickerProviderStateMixin {
  // Table calendar data
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late DateTime kToday;
  late DateTime kFirstDay;
  late DateTime kLastDay;

  int dayStreak = 0;

  late GifController _gifController;

  // Other data
  late ValueNotifier<ChallengeBoxType> _challengeBoxType;
  late AnimationController _darkenController;
  late Animation<double> _darkenAnimation;

  @override
  void initState() {
    kToday = DateTime.now();
    kFirstDay = DateTime(kToday.year - 10, kToday.month, kToday.day);
    kLastDay = DateTime(kToday.year + 10, kToday.month, kToday.day);
    _gifController = GifController(vsync: this);

    if (widget.rangeStartDate != null && widget.rangeEndDate != null) {
      dayStreak =
          widget.rangeEndDate!.difference(widget.rangeStartDate!).inDays;
    }

    _challengeBoxType = ValueNotifier(widget.isStarted
        ? ChallengeBoxType.started
        : ChallengeBoxType.notStarted);

    _darkenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _darkenAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(_darkenController);
    _darkenController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
            const Duration(seconds: 2), () => _darkenController.reverse());
      }
    });

    // Display popup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isStarted) {
        Future.delayed(const Duration(milliseconds: 500),
                () => _showPopUp(context, false));
      } else if (widget.refillShield) {
        Future.delayed(
            const Duration(milliseconds: 500), () => _showPopUp(context, true));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _challengeBoxType.dispose();
    _darkenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // General section
              StreakGeneralSection(
                mainColor: widget.mainColor,
                dayStreak: dayStreak,
              ),

              const Padding(
                  padding: EdgeInsets.only(left: 25, top: 20, bottom: 10),
                  child: Text('Streak Challenge',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ))),

              // Challenge boxes
              ValueListenableBuilder(
                valueListenable: _challengeBoxType,
                builder: (_, value, __) => ChallengeSection(
                  type: value,
                  dayStreak: dayStreak,
                  mainColor: widget.progressColor,
                  shieldColor: widget.shieldColor,
                  onJoinChallenge: () {
                    _challengeBoxType.value = ChallengeBoxType.justStart;
                    widget.onJoinChallenge;
                  },
                  onUseShield: () => _handleUseShield(),
                ),
              ),

              // Main table calendar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TableCalendar(
                  shieldedDays: widget.shieldedDays,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    withinRangeTextStyle:
                        TextStyle(fontSize: 16, color: widget.progressColor),
                    rangeStartTextStyle:
                        TextStyle(fontSize: 16, color: widget.progressColor),
                    rangeHighlightColor: widget.progressColor.withOpacity(0.2),
                    rangeStartDecoration: BoxDecoration(
                      color: widget.progressColor.withOpacity(0.2),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(60),
                        right: Radius.zero,
                      ),
                    ),
                    rangeEndDecoration: BoxDecoration(
                      color: widget.progressColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: widget.rangeStartDate,
                  rangeEndDay: widget.rangeEndDate,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDaySelected: (selectedDay, focusedDay) {},
                  onRangeSelected: (start, end, focusedDay) {},
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      IgnorePointer(
        child: AnimatedBuilder(
          animation: _darkenAnimation,
          builder: (_, __) => Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(_darkenAnimation.value),
              child: Center(
                  child: Gif(
                image: const AssetImage('assets/images/merging_shield.gif'),
                controller: _gifController,
                onFetchCompleted: () {
                  _gifController.reset();
                },
              ))),
        ),
      )
    ]);
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
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
      );

  _showPopUp(BuildContext context, bool isShield) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Wrap(children: [
        StreakPopup(
          mainColor: widget.mainColor,
          shieldColor: widget.shieldColor,
          isShield: isShield,
          onClick: () {
            if (isShield) {
              Future.delayed(
                  const Duration(milliseconds: 300), () => _handleUseShield());
            } else {
              Future.delayed(const Duration(milliseconds: 300),
                  () => _challengeBoxType.value = ChallengeBoxType.justStart);
              widget.onJoinChallenge();
            }
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }

  _handleUseShield() {
    // Callback
    widget.onUseShield;

    _darkenController.forward();
    Future.delayed(const Duration(milliseconds: 300),
        () => _gifController.forward().then((_) => _gifController.reset()));
  }
}
