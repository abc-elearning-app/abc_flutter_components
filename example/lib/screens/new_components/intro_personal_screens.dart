import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestIntroPersonalPlanScreen extends StatelessWidget {
  const TestIntroPersonalPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabList = <IntroPersonalPlanData>[
      IntroPersonalPlanData(
          index: 0,
          title: 'Exam-Like Questions',
          subtitle:
              'We offer a wide range of questions compiled by experts that closely resemble the real exam.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_1_1.png'),
              Image.asset('assets/images/intro_1_2.png'),
            ],
          )),
      IntroPersonalPlanData(
          index: 1,
          title: 'Powerful Learning Method',
          subtitle:
              'We use a combination of active recall, spaced repetition, and interleaving to strengthen memory retention.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_2_1.png'),
              Image.asset('assets/images/intro_2_2.png'),
            ],
          )),
      IntroPersonalPlanData(
          index: 2,
          title: 'Personalized Study Plan',
          subtitle:
              'Based on your exam date and Diagnostic Test, we build a personalized study plan for you, maximizing your chances of exam success.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_3_1.png'),
              Image.asset('assets/images/intro_3_2.png'),
              Image.asset('assets/images/intro_3_3.png'),
            ],
          ))
    ];

    return IntroPersonalPlanPages(
      tabList: tabList,
      onFinish: () => print('onFinish'),
    );
  }
}
