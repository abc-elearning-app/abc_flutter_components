import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:table_calendar/table_calendar.dart';

class TestStreakScreen extends StatefulWidget {
  const TestStreakScreen({super.key});

  @override
  State<TestStreakScreen> createState() => _TestStreakScreenState();
}

class _TestStreakScreenState extends State<TestStreakScreen> {
  bool isStarted = false;
  bool refillShield = false;

  @override
  Widget build(BuildContext context) {
    return StreakScreen(
        isStarted: isStarted,
        refillShield: refillShield,
        rangeStartDate: DateTime.now(),
        rangeEndDate: DateTime.now(),
        shieldedDays: [
          // DateTime.now(),
          DateTime.now().add(const Duration(days: -5)),
        ],
        onUseShield: () => print('Shield used'),
        onJoinChallenge: () => print('Join Challenge'));
  }
}
