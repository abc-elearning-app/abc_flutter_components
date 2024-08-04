import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  final double lineHeight;
  final int totalQuestions;
  final int correctQuestions;
  final int incorrectQuestions;

  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;

  const ProgressLine({
    super.key,
    required this.lineHeight,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.incorrectQuestions,
    this.correctColor = const Color(0xFF07C58C),
    this.incorrectColor = const Color(0xFFFF746D),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildColorProgress(context, correctColor, correctQuestions),
          _buildColorProgress(context, incorrectColor, incorrectQuestions),
        ],
      ),
    );
  }

  Widget _buildColorProgress(BuildContext context, Color color, int value) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: lineHeight,
        color: color,
        width: MediaQuery.of(context).size.width * (value / totalQuestions),
      );
}
