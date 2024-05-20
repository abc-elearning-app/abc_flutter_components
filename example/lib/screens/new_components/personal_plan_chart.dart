import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanChart extends StatelessWidget {
  const TestPersonalPlanChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          PersonalPlanChart(
            mainColor: const Color(0xFFE3A651),
            correctColor: const Color(0xFF00CA9F),
          )
        ],
      ),
    );
  }
}
