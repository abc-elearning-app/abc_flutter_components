import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestStreakScreen extends StatefulWidget {
  const TestStreakScreen({super.key});

  @override
  State<TestStreakScreen> createState() => _TestStreakScreenState();
}

class _TestStreakScreenState extends State<TestStreakScreen> {
  bool isStarted = false;

  @override
  Widget build(BuildContext context) {
    return StreakScreen(
      isStarted: isStarted,
      rangeStartDate: DateTime(2024, 5, 28),
      rangeEndDate: DateTime(2024, 6, 12),
      shieldedDays: [
        DateTime.now(),
        DateTime.now().add(const Duration(days: 5)),
      ],
      onUseShield: () => print('Shield used'),
      onJoinChallenge: () {
        setState(() {
          isStarted = !isStarted;
        });
      },
    );
  }
}