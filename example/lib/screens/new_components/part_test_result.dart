import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPartTestResult extends StatelessWidget {
  const TestPartTestResult({super.key});

  @override
  Widget build(BuildContext context) {
    return PartResultScreen(
      isDarkMode: AppTheme.isDarkMode,
      partIndex: 2,
      correctQuestions: 9,
      totalQuestions: 10,
      improvedPercent: 13,
      passingProbability: 42,
      onTryAgain: () => print('Try Again'),
      onContinue: () => print('Continue'),
    );
  }
}
