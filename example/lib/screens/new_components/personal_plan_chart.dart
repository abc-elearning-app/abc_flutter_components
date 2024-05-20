import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {
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
              mainColor: const Color(0xFFE3A651),
              correctColor: const Color(0xFF00CA9F),
            )
          ],
        ),
      ),
    );
  }
}
