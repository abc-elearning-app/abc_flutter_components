import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestNewStatisticTab extends StatelessWidget {
  const TestNewStatisticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: NewStatisticTab(dayStreak: 14, passingProbability: 31,)),
    );
  }
}
