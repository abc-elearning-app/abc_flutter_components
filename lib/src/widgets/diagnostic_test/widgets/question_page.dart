import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionPage extends StatelessWidget {
  final QuestionData questionData;
  final Color correctColor;
  final Color incorrectColor;

  QuestionPage(
      {super.key,
      required this.questionData,
      this.correctColor = const Color(0xFF07C58C),
      this.incorrectColor = const Color(0xFFFF746D)});

  int selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding:
              const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 30),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                    blurRadius: 5)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NEW QUESTION',
                  style: TextStyle(
                      color: const Color(0xFF212121).withOpacity(0.52),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(questionData.question,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16))
            ],
          ),
        ),

        // Answer list
        Expanded(
          child: StatefulBuilder(
              builder: (_, setState) => ListView.builder(
                  padding: const EdgeInsets.only(top: 15),
                  itemCount: questionData.answers.length,
                  itemBuilder: (_, index) => _buildAnswer(index, setState))),
        )
      ],
    );
  }

  Widget _buildAnswer(
      int index, void Function(void Function() action) setState) {
    final currentAnswer = questionData.answers[index];
    return GestureDetector(
      onTap: () {
        // Only allow to select once
        if (selectedAnswerIndex == -1) {
          setState(() => selectedAnswerIndex = index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: _getAnswerBackgroundColor(index, currentAnswer.isCorrect),
            borderRadius: BorderRadius.circular(15),
            border: _buildAnswerBorder(index, currentAnswer.isCorrect)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Answer content
            Text(
              currentAnswer.content,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),

            // Icon (after selected)
            _buildIcon(index, currentAnswer.isCorrect)
          ],
        ),
      ),
    );
  }

  _getAnswerBackgroundColor(int index, bool isCorrect) {
    switch (_checkAnswer(index, isCorrect)) {
      case 0: return Colors.white;
      case 1: return Color.lerp(correctColor, Colors.white, 0.8);
      case 2: return Color.lerp(incorrectColor, Colors.white, 0.8);
    }
  }

  _buildAnswerBorder(int index, bool isCorrect) {
    switch (_checkAnswer(index, isCorrect)) {
      case 0: return null;
      case 1: return Border.all(color: correctColor, width: 1);
      case 2: return Border.all(color: incorrectColor, width: 1);
    }
  }

  _buildIcon(int index, bool isCorrect) {
    switch (_checkAnswer(index, isCorrect)) {
      case 0: return const SizedBox();
      case 1: return SvgPicture.asset('assets/images/correct.svg');
      case 2: return SvgPicture.asset('assets/images/incorrect.svg');
    }
  }

  /// 0 - default,  1 - correct,  2 - incorrect
  int _checkAnswer(int index, bool isCorrect) {
    if (selectedAnswerIndex == -1 ||
        (selectedAnswerIndex != index && !isCorrect)) {
      return 0;
    }

    return isCorrect ? 1 : 2;
  }
}
