import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewStatisticTab extends StatelessWidget {
  const TestNewStatisticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: const Color(0xFFF5F4EE),
      body: SafeArea(
          child: NewStatisticTab(
        isDarkMode: AppTheme.isDarkMode,
        dayStreak: 14,
        passingProbability: 31,
      )),
    );
  }
}
