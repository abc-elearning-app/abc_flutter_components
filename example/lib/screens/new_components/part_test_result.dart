import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestPartTestResult extends StatelessWidget {
  const TestPartTestResult({super.key});

  @override
  Widget build(BuildContext context) {
    return PartResultScreen(
      partIndex: 1,
      correctQuestions: 9,
      totalQuestions: 10,
      improvedPercent: 13,
      passingProbability: 42,
      onTryAgain: () => print('Try Again'),
      onContinue: () => print('Continue'),
      // backgroundColor: Colors.grey.shade300,
      // mainColor: Colors.yellow,
      // boxBackgroundColor: Colors.lightBlueAccent,
      // secondaryColor: Colors.pink,
      // correctColor: Colors.orange,
      // incorrectColor: Colors.indigoAccent,
    );
  }
}
