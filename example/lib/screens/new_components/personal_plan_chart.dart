import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {
    final expectedLineValues = <double>[50, 55, 60, 65, 70, 75, 80, 85, 85, 90, 95, 98, 98, 98, 98, 98, 98, 98];

    int x = -3;
    final dataList = <ChartData>[
      ChartData(DateTime.now().add(Duration(days: -5 + x)), 10),
      ChartData(DateTime.now().add(Duration(days: -4 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: -3 + x)), 25),
      ChartData(DateTime.now().add(Duration(days: -2 + x)), 15),
      ChartData(DateTime.now().add(Duration(days: -1 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: 0 + x)), 30),
      ChartData(DateTime.now().add(Duration(days: 1 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: 2 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: 3 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: 4 + x)), 20),
      ChartData(DateTime.now().add(Duration(days: 5 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 6 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 7 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 8 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 9 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 10 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 11 + x)), 20),
      // ChartData(DateTime.now().add(Duration(days: 12 + x)), 20),
    ];

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
