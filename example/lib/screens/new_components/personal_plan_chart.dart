import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final startDate = DateTime(2024, 6, 15);
    final examDate = DateTime(2024, 6, 25);
    final valueList = [30, 40, 30, 35, 35, 45, 20, 30];

    return Container(
      decoration: BoxDecoration(
          image: AppTheme.isDarkMode
              ? null
              : const DecorationImage(
                  image: AssetImage('assets/images/chart_background.png'),
                  fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Column(
          children: [
            PersonalPlanChart(
              isDarkMode: AppTheme.isDarkMode,
              startTime: startDate,
              examDate: examDate,
              valueList: valueList,
            )
          ],
        ),
      ),
    );
  }
}
