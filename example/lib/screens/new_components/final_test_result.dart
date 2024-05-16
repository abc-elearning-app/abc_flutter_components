import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestFinalTestResult extends StatelessWidget {
  const TestFinalTestResult({super.key});

  @override
  Widget build(BuildContext context) {
    final progressList = [
      ProgressTileData(
          title: 'Engineering Comprehension',
          progress: 9,
          icon: 'subject_icon_0'),
      ProgressTileData(
          title: 'Arithmetic Comprehension',
          progress: 60,
          icon: 'subject_icon_0'),
      ProgressTileData(
          title: 'Mechanical Comprehension',
          progress: 95,
          icon: 'subject_icon_0'),
    ];
    return FinalTestResult(
      progressList: progressList,
      progress: 90,
      correctQuestions: 80,
      incorrectQuestions: 10,
      averageProgress: 65,
      onReviewAnswer: () => print('Review'),
      onTryAgain: () => print('Try again'),
      onContinue: () => print('Continue'),
      onImproveSubject: (index) => print(progressList[index].title),
    );
  }
}
