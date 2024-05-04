import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPersonalPlanReadyScreen extends StatelessWidget {
  const TestPersonalPlanReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonalPlanReadyScreen(
        questions: 69,
        passingScore: 89,
        onStartLearning: () => print('onStartLearning'));
  }
}
