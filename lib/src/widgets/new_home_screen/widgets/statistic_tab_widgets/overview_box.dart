import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/final_test_result/widgets/half_circle_progress.dart';

class OverviewBox extends StatelessWidget {
  final int answeredQuestions;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracyRate;

  final Color textColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;

  final String background;

  const OverviewBox(
      {super.key,
      required this.answeredQuestions,
      required this.totalQuestions,
      required this.correctAnswers,
      required this.accuracyRate,
      this.textColor = Colors.black,
      this.correctColor = const Color(0xFF15CB9F),
      this.incorrectColor = const Color(0xFFFC5656),
      this.upperBackgroundColor = Colors.white,
      this.lowerBackgroundColor = const Color(0xFFFFFDF1),
      this.background = 'assets/images/overview_box_background.png'});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 3,
          blurRadius: 3,
        )
      ], borderRadius: BorderRadius.circular(20), color: upperBackgroundColor),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(
              children: [
                const Text('Overview',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 15),
                HalfCircleProgressIndicator(
                  progress: accuracyRate / 100,
                  lineWidth: 20,
                  radius: 120,
                  center: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${accuracyRate.toInt()}%',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const Text('Accuracy Rate'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: lowerBackgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Answered Questions',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$answeredQuestions/$totalQuestions',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),

                  // Vertical divider
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: 2,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                    height: 50,
                  ),

                  Column(
                    children: [
                      const Text(
                        'Correct Answers',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        correctAnswers.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: correctColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
