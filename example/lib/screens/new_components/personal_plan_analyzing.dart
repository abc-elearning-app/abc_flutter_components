import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestAnalyzingScreen extends StatelessWidget {
  const TestAnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersonalPlanAnalyzingScreen(onFinish: () => print('onFinish'));
  }
}
