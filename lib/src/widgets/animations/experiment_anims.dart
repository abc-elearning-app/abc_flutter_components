import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ExperimentAnims extends StatefulWidget {
  const ExperimentAnims({super.key});

  @override
  State<ExperimentAnims> createState() => _ExperimentAnimsState();
}

class _ExperimentAnimsState extends State<ExperimentAnims> with TickerProviderStateMixin {
  late AnimationController prevController;
  late AnimationController nextController;

  late Animation<double> prevScaleAnimation;
  late Animation<double> prevFadeAnimation;

  late Animation<double> nextTranslateAnimation;
  late Animation<double> nextFadeAnimation;

  late AnimationController oldQuestion;
  late AnimationController newQuestion;

  List<AnimationController> oldAnswers = [];
  List<AnimationController> newAnswers = [];

  late Animation<double> oldQuestionAnim;
  late Animation<double> newQuestionAnim;

  List<Animation<double>> oldAnswersAnim = [];
  List<Animation<double>> newAnswersAnim = [];

  @override
  void initState() {
    prevController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    nextController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    prevFadeAnimation = Tween<double>(begin: 1, end: 0).animate(prevController);
    prevScaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(prevController);

    nextTranslateAnimation = Tween<double>(begin: 100, end: 0).animate(nextController);
    nextFadeAnimation = Tween<double>(begin: 0, end: 1).animate(nextController);

    oldQuestion = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    oldQuestionAnim = Tween<double>(begin: 0, end: -500).animate(oldQuestion);
    newQuestion = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    newQuestionAnim = Tween<double>(begin: 500, end: 0).animate(newQuestion);

    oldAnswers = List.generate(4, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    oldAnswersAnim = List.generate(4, (index) => Tween<double>(begin: 0, end: -500).animate(oldAnswers[index]));
    newAnswers = List.generate(4, (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 200)));
    newAnswersAnim = List.generate(4, (index) => Tween<double>(begin: 500, end: 0).animate(newAnswers[index]));

    super.initState();
  }

  @override
  void dispose() {
    prevController.dispose();
    nextController.dispose();

    oldQuestion.dispose();
    newQuestion.dispose();

    for (var a in oldAnswers) a.dispose();
    for (var a in newAnswers) a.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ANIMATION LAB'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Stack(
                children: [
                  // AnimatedBuilder(
                  //   animation: prevController,
                  //   builder: (_, __) => ScaleTransition(
                  //     scale: prevScaleAnimation,
                  //     child: Opacity(opacity: prevFadeAnimation.value, child: _buildDummyQuestion(Colors.red)),
                  //   ),
                  // ),
                  // AnimatedBuilder(
                  //   animation: nextController,
                  //   builder: (_, __) => Transform.translate(
                  //     offset: Offset(nextTranslateAnimation.value, 0),
                  //     child: Opacity(
                  //       opacity: nextFadeAnimation.value,
                  //       child: _buildDummyQuestion(Colors.blue),
                  //     ),
                  //   ),
                  // )

                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: oldQuestion,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(oldQuestionAnim.value, 0),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red, width: 2),
                              color: Colors.red.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Column(
                          children: List.generate(
                              4,
                              (index) => AnimatedBuilder(
                                    animation: oldAnswersAnim[index],
                                    builder: (_, __) => Transform.translate(
                                      offset: Offset(oldAnswersAnim[index].value, 0),
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.red, width: 2),
                                          color: Colors.red.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ))),
                    ],
                  ),

                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: newQuestion,
                        builder: (_, __) => Transform.translate(
                          offset: Offset(newQuestionAnim.value, 0),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue, width: 2),
                              color: Colors.blue.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Column(
                          children: List.generate(
                              4,
                              (index) => AnimatedBuilder(
                                    animation: newAnswersAnim[index],
                                    builder: (_, __) => Transform.translate(
                                      offset: Offset(newAnswersAnim[index].value, 0),
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: Colors.blue, width: 2),
                                          color: Colors.blue.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                  ))),
                    ],
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: MainButton(
                    title: 'REVERSE',
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      // nextController.reverse();
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   prevController.reverse();
                      // });

                      for (int i = newAnswers.length - 1; i >= 0; i--) {
                        Future.delayed(Duration(milliseconds: (newAnswers.length - i - 1) * 100), () => newAnswers[i].reverse());
                      }
                      Future.delayed(const Duration(milliseconds: 400), () => newQuestion.reverse());

                      Future.delayed(const Duration(milliseconds: 400), () {
                        for (int i = oldAnswers.length - 1; i >= 0; i--) {
                          Future.delayed(Duration(milliseconds: (oldAnswers.length - i - 1) * 100), () => oldAnswers[i].reverse());
                        }
                        Future.delayed(const Duration(milliseconds: 400), () => oldQuestion.reverse());
                      });
                    },
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                      child: MainButton(
                    title: 'FORWARD',
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      // prevController.forward();
                      // Future.delayed(const Duration(milliseconds: 100), () {
                      //   nextController.forward();
                      // });
                      oldQuestion.forward();
                      for (int i = 0; i < oldAnswers.length; i++) {
                        Future.delayed(Duration(milliseconds: (i + 1) * 100), () => oldAnswers[i].forward());
                      }

                      Future.delayed(const Duration(milliseconds: 400), () {
                        newQuestion.forward();
                        for (int i = 0; i < newAnswers.length; i++) {
                          Future.delayed(Duration(milliseconds: (i + 1) * 100), () => newAnswers[i].forward());
                        }
                      });
                    },
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildDummyQuestion(Color color) => Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: color, width: 2), color: color.withOpacity(0.1)),
          ),
          Column(
              children: List.generate(
                  4,
                  (index) => Container(
                        height: 60,
                        width: double.infinity,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color, width: 2),
                          color: color.withOpacity(0.1),
                        ),
                      ))),
        ],
      );
}
