import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  final double lineHeight;
  final int totalQuestions;
  final int correctQuestions;
  final int incorrectQuestions;

  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;

  const ProgressLine(
      {super.key,
      required this.lineHeight,
      required this.totalQuestions,
      required this.correctQuestions,
      required this.incorrectQuestions,
      required this.correctColor,
      required this.incorrectColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildColorProgress(context, correctColor, true),
          _buildColorProgress(context, incorrectColor, false),
        ],
      ),
    );
  }

  Widget _buildColorProgress(
          BuildContext context, Color color, bool isCorrect) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: lineHeight,
        color: color,
        width: MediaQuery.of(context).size.width *
            ((isCorrect ? correctQuestions : incorrectQuestions) /
                totalQuestions),
      );
}
