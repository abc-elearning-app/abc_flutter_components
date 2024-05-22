import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final startDate = DateTime(2024, 5, 15);
    final examDate = DateTime(2024, 6, 20);
    final valueList = <int>[0, 0, 0, 0, 35, 30, 20, 30];

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/chart_background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Column(
          children: [
            PersonalPlanChart(
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
