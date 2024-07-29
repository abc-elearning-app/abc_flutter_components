import 'package:flutter/material.dart';

import '../../custom_circular_progress_indicator/custom_circular_progress_indicator.dart';

class CircularProgressBox extends StatelessWidget {
  final int correctQuestions;
  final int totalQuestions;

  final Color backgroundColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color progressTextColor;

  final bool isDarkMode;

  const CircularProgressBox({
    super.key,
    required this.correctQuestions,
    required this.totalQuestions,
    this.backgroundColor = const Color(0xFFF3F1E5),
    this.correctColor = const Color(0xFF38EFAE),
    this.incorrectColor = const Color(0xFFF14A4A),
    required this.progressTextColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.16) : backgroundColor,
        borderRadius: BorderRadius.circular(16),
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
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w400),
                  children: [
                    const TextSpan(text: 'You correctly answered '),
                    TextSpan(text: '$correctQuestions/$totalQuestions', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                  textColor: isDarkMode ? Colors.white : progressTextColor),
            )
          ],
        ),
      ),
    );
  }
}
