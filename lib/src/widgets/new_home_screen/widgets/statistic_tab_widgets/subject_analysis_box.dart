import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum QuestionType { correct, incorrect, unanswered }

class SubjectAnalysisBox extends StatelessWidget {
  final String title;
  final String icon;

  final double accuracyRate;
  final int correctQuestions;
  final int incorrectQuestions;
  final int unansweredQuestions;

  final Color iconColor;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color iconBackgroundColor;
  final Color progressColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color unansweredColor;

  const SubjectAnalysisBox(
      {super.key,
      required this.title,
      required this.icon,
      required this.iconColor,
      required this.iconBackgroundColor,
      required this.progressColor,
      this.upperBackgroundColor = const Color(0xFFFFFDF1),
      this.lowerBackgroundColor = Colors.white,
      this.correctColor = const Color(0xFF15CB9F),
      this.incorrectColor = const Color(0xFFFC5656),
      this.unansweredColor = const Color(0xFFD9D9D9),
      required this.accuracyRate,
      required this.correctQuestions,
      required this.incorrectQuestions,
      required this.unansweredQuestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: upperBackgroundColor),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Icon
                IconBox(
                    icon: icon,
                    iconColor: iconColor,
                    backgroundColor: iconBackgroundColor),
                const SizedBox(width: 10),

                // Title
                Expanded(
                    child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )),

                // Dropdown button
                SvgPicture.asset(
                  'assets/images/chevron_down.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  height: 10,
                )
              ],
            ),
          ),

          // Main content
          Container(
            decoration: BoxDecoration(
                color: lowerBackgroundColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Accuracy Rate',
                          style: TextStyle(fontSize: 16)),
                      Text(
                        '${accuracyRate.toInt()}%',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: LinearPercentIndicator(
                    percent: accuracyRate / 100,
                    animation: true,
                    progressColor: progressColor,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.zero,
                    lineHeight: 10,
                    barRadius: const Radius.circular(10),
                  ),
                ),
                const Divider(),
                _buildQuestionInfo(QuestionType.correct, correctQuestions),
                _buildQuestionInfo(QuestionType.incorrect, incorrectQuestions),
                _buildQuestionInfo(
                    QuestionType.unanswered, unansweredQuestions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildQuestionInfo(QuestionType type, int questionCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          Text('●', style: TextStyle(color: _getColor(type))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(_getTitle(type)),
            ),
          ),
          Text(
            questionCount.toString(),
            style: TextStyle(
                color: _getColor(type, isText: true),
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  _getTitle(QuestionType type) {
    switch (type) {
      case QuestionType.correct:
        return 'Correct Questions';
      case QuestionType.incorrect:
        return 'Incorrect Questions';
      case QuestionType.unanswered:
        return 'Unanswered Questions';
    }
  }

  _getColor(QuestionType type, {bool isText = false}) {
    switch (type) {
      case QuestionType.correct:
        return correctColor;
      case QuestionType.incorrect:
        return incorrectColor;
      case QuestionType.unanswered:
        return isText ? Colors.black : unansweredColor;
    }
  }
}
