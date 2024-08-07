import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/final_test_result/half_circle_progress.dart';

class OverviewBoxComponent extends StatelessWidget {
  final int answeredQuestions;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracyRate;
  final bool isDarkMode;

  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;

  final String background;

  const OverviewBoxComponent({
    super.key,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracyRate,
    required this.isDarkMode,
    required this.background,
    this.correctColor = const Color(0xFF15CB9F),
    this.incorrectColor = const Color(0xFFFC5656),
    this.backgroundColor = const Color(0xFFFFFDF1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: !isDarkMode
              ? [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 2)
                ]
              : null),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.fitWidth,
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Column(
              children: [
                Text('Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    )),
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
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        Transform.translate(
                            offset: const Offset(0, -5),
                            child: const Text('Accuracy Rate')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : backgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Answered Questions',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$answeredQuestions/$totalQuestions',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black),
                      )
                    ],
                  ),

                  // Vertical divider
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: 2,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.16)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                    height: 50,
                  ),

                  Column(
                    children: [
                      const Text(
                        'Correct Answers',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        correctAnswers.toString(),
                        style: TextStyle(
                            fontSize: 18,
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
