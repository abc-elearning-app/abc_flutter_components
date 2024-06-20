import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:table_calendar/table_calendar.dart';

class TestStreakScreen extends StatefulWidget {
  const TestStreakScreen({super.key});

  @override
  State<TestStreakScreen> createState() => _TestStreakScreenState();
}

class _TestStreakScreenState extends State<TestStreakScreen> {
  bool isStarted = true;
  bool refillShield = false;

  @override
  Widget build(BuildContext context) {
    return StreakScreen(
        isDarkMode: AppTheme.isDarkMode,
        isStarted: isStarted,
        refillShield: refillShield,
        rangeStartDate: DateTime(2024, 6, 1),
        rangeEndDate: DateTime.now(),
        shieldedDays: [
          // DateTime.now(),
          DateTime.now().add(const Duration(days: -5)),
        ],
        onUseShield: () => print('Shield used'),
        onJoinChallenge: () => print('Join Challenge'));
  }
}
