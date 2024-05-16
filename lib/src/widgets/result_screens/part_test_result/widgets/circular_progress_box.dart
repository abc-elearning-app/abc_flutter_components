import 'package:flutter/material.dart';

import '../../../custom_circular_progress_indicator/custom_circular_progress_indicator.dart';

class CircularProgressBox extends StatelessWidget {
  final int correctQuestions;
  final int totalQuestions;

  final Color backgroundColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color progressTextColor;

  const CircularProgressBox(
      {super.key,
      required this.backgroundColor,
      required this.correctQuestions,
      required this.totalQuestions,
      required this.correctColor,
      required this.incorrectColor,
      required this.progressTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text
            Expanded(
                child: RichText(
              text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400),
                  children: [
                    const TextSpan(text: 'You correctly answered '),
                    TextSpan(
                        text: '$correctQuestions/$totalQuestions',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const TextSpan(text: ' questions on the first turn.'),
                  ]),
            )),

            // Graph
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomCircularProgressIndicator(
                  backgroundColor: progressTextColor.withOpacity(0.1),
                  correctColor: correctColor,
                  incorrectColor: incorrectColor,
                  correctQuestions: correctQuestions,
                  totalQuestions: totalQuestions,
                  textColor: progressTextColor),
            )
          ],
        ),
      ),
    );
  }
}
