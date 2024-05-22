import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {

    // Dummy data
    int count = 100;
    final expectedLineValues =
        List.generate(count, (index) => (index * 2 + Random().nextInt(50)).clamp(0, 100).toDouble());
    final dataList = List.generate(
        count,
        (index) =>
            ChartData(DateTime.now().add(Duration(days: index - 20)), (index + 10).clamp(0, 50).toDouble()));

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/chart_background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            PersonalPlanChart(
              dataList: dataList,
              expectedLineValues: expectedLineValues,
            )
          ],
        ),
      ),
    );
  }
}
