import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/blur_effect.dart';
import 'package:flutter_abc_jsc_components/src/widgets/buttons/toggle_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../flutter_abc_jsc_components.dart';

enum ButtonType { bookmark, like, dislike }

class MainQuestionPage extends StatelessWidget {
  final int questionIndex;
  final QuestionData questionData;
  final bool isPro;

  // Colors
  final Color correctColor;
  final Color incorrectColor;
  final String? correctIcon;
  final String? incorrectIcon;

  // Callbacks
  final void Function(bool isCorrect)? onSelectAnswer;
  final void Function()? onClickExplanation;
  final void Function(bool isSelected)? onToggleBookmark;
  final void Function(bool isSelected)? onToggleLike;
  final void Function(bool isSelected)? onToggleDislike;

  MainQuestionPage(
      {super.key,
      required this.questionIndex,
      required this.questionData,
      this.isPro = false,
      this.correctColor = const Color(0xFF07C58C),
      this.incorrectColor = const Color(0xFFFF746D),
      this.onSelectAnswer,
      this.onClickExplanation,
      this.onToggleBookmark,
      this.onToggleLike,
      this.onToggleDislike,
      this.correctIcon,
      this.incorrectIcon});

  int selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Question
                _buildQuestionBox(),

                StatefulBuilder(
                  builder: (_, setState) => Column(
                    children: [
                      // Answers
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 15),
                          itemCount: questionData.answers.length,
                          itemBuilder: (_, index) =>
                              _buildAnswer(context, index, setState)),

                      // Explanation
                      _buildExplanation()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bookmark, like and dislike buttons
        _buildOptions()
      ],
    );
  }

  Widget _buildQuestionBox() => Container(
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
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
          ],
        ),
      );

  Widget _buildAnswer(
    BuildContext context,
    int answerIndex,
    void Function(void Function() action) setState,
  ) {
    final currentAnswer = questionData.answers[answerIndex];
    return GestureDetector(
      // Handle select answer
      onTap: () {
        if (selectedAnswerIndex == -1) {
          setState(() => selectedAnswerIndex = answerIndex);
          if (onSelectAnswer != null) {
            onSelectAnswer!(currentAnswer.isCorrect == true);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _answerBackgroundColor(answerIndex, currentAnswer.isCorrect),
            border: _answerBorder(answerIndex, currentAnswer.isCorrect)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentAnswer.content,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),

            // Icon (after selected)
            _buildIcon(answerIndex, currentAnswer.isCorrect)
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation() => AnimatedCrossFade(
      firstChild: GestureDetector(
        onTap: !isPro ? onClickExplanation : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Explanation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  if (!isPro)
                    SvgPicture.asset(
                      'assets/images/pro_content.svg',
                      height: 25,
                    )
                ],
              ),
              const SizedBox(height: 10),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    questionData.explanation,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                if (!isPro) const BlurEffect()
              ])
            ],
          ),
        ),
      ),
      secondChild: const SizedBox(),
      crossFadeState: selectedAnswerIndex == -1
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200));

  Widget _buildOptions() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ToggleButton(
              iconSize: 30,
              unselectedIcon: 'bookmark',
              selectedIcon: 'bookmarked',
              isSelected: questionData.bookmarked,
              onToggle: (isSelected) => onToggleBookmark != null
                  ? onToggleBookmark!(isSelected)
                  : null),
          ToggleButton(
              iconSize: 30,
              unselectedIcon: 'like',
              selectedIcon: 'liked',
              isSelected: questionData.liked,
              onToggle: (isSelected) =>
                  onToggleLike != null ? onToggleLike!(isSelected) : null),
          ToggleButton(
              iconSize: 30,
              unselectedIcon: 'dislike',
              selectedIcon: 'disliked',
              isSelected: questionData.disliked,
              onToggle: (isSelected) => onToggleDislike != null
                  ? onToggleDislike!(isSelected)
                  : null),
        ],
      );

  _answerBackgroundColor(int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return Colors.white;
      case 1:
        return Color.lerp(correctColor, Colors.white, 0.8);
      case 2:
        return Color.lerp(incorrectColor, Colors.white, 0.8);
    }
  }

  _answerBorder(int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return null;
      case 1:
        return Border.all(color: correctColor, width: 1);
      case 2:
        return Border.all(color: incorrectColor, width: 1);
    }
  }

  _buildIcon(int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return const SizedBox();
      case 1:
        return SvgPicture.asset(
            'assets/images/${correctIcon ?? 'correct'}.svg');
      case 2:
        return SvgPicture.asset(
            'assets/images/${incorrectIcon ?? 'incorrect'}.svg');
    }
  }

  /// 0 - default,  1 - correct,  2 - incorrect
  int _checkAnswer(int answerIndex, bool? isCorrect) {
    // If not select any answer yet
    if (selectedAnswerIndex == -1) return 0;

    // Display correct answer
    if (isCorrect == true) return 1;

    // Display incorrect answer (if choose wrong)
    if (selectedAnswerIndex == answerIndex) return 2;

    return 0;
  }
}
