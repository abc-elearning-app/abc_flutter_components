import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/blur_effect.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../provider/diagnostic_questions_provider.dart';

enum ButtonType { bookmark, like, dislike }

class QuestionPage extends StatelessWidget {
  final int questionIndex;
  final QuestionData questionData;
  final Color correctColor;
  final Color incorrectColor;
  final void Function(bool isCorrect) onSelectAnswer;
  final void Function() onClickExplanation;

  QuestionPage(
      {super.key,
      required this.questionIndex,
      required this.questionData,
      this.correctColor = const Color(0xFF07C58C),
      this.incorrectColor = const Color(0xFFFF746D),
      required this.onSelectAnswer,
      required this.onClickExplanation});

  int selectedAnswerIndex = -1;

  // Debug
  final bool isPro = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _buildQuestionBox(),

              // Answers
              StatefulBuilder(
                builder: (_, setState) => Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: questionData.answers.length,
                        itemBuilder: (_, index) =>
                            _buildAnswer(context, index, setState)),
                    _buildExplanation()
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bookmark, like and dislike buttons
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _iconButton(context, ButtonType.bookmark, () {
        //       context
        //           .read<DiagnosticQuestionProvider>()
        //           .toggleBookmark(questionIndex);
        //     }),
        //     _iconButton(context, ButtonType.like, () {
        //       context
        //           .read<DiagnosticQuestionProvider>()
        //           .toggleLike(questionIndex);
        //     }),
        //     _iconButton(context, ButtonType.dislike, () {
        //       context
        //           .read<DiagnosticQuestionProvider>()
        //           .toggleDislike(questionIndex);
        //     }),
        //   ],
        // )
      ],
    );
  }

  Widget _iconButton(
          BuildContext context, ButtonType type, void Function() action) =>
      Selector<DiagnosticQuestionProvider, bool>(
        selector: (_, provider) => provider.questions[questionIndex].liked,
        builder: (_, value, __) => GestureDetector(
          onTap: action,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
                'assets/images/${_getIconName(context, type)}.svg',
                width: 30),
          ),
        ),
      );

  _getIconName(BuildContext context, ButtonType type) {
    final currentQuestion =
        context.read<DiagnosticQuestionProvider>().questions[questionIndex];
    bool isChosen = false;
    switch (type) {
      case ButtonType.bookmark:
        isChosen = currentQuestion.bookmarked;
        break;

      case ButtonType.like:
        isChosen = currentQuestion.liked;
        break;

      case ButtonType.dislike:
        isChosen = currentQuestion.disliked;
        break;
    }

    String iconName = '';
    if (isChosen) {
      switch (type) {
        case ButtonType.bookmark:
          iconName = 'bookmarked';
          break;
        case ButtonType.like:
          iconName = 'liked';
          break;
        default:
          iconName = 'disliked';
      }
    } else {
      switch (type) {
        case ButtonType.bookmark:
          iconName = 'bookmark';
          break;
        case ButtonType.like:
          iconName = 'like';
          break;
        default:
          iconName = 'dislike';
      }
    }

    return iconName;
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

  Widget _buildAnswer(BuildContext context, int answerIndex,
      void Function(void Function() action) setState) {
    final currentAnswer = questionData.answers[answerIndex];
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color:
                _getAnswerBackgroundColor(answerIndex, currentAnswer.isCorrect),
            borderRadius: BorderRadius.circular(15),
            border: _buildAnswerBorder(answerIndex, currentAnswer.isCorrect)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Answer content
            Text(
              currentAnswer.content,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),

            // Icon (after selected)
            _buildIcon(answerIndex, currentAnswer.isCorrect)
          ],
        ),
      ),

      // Handle select answer
      onTap: () {
        if (selectedAnswerIndex == -1) {
          setState(() => selectedAnswerIndex = answerIndex);
          context
              .read<DiagnosticQuestionProvider>()
              .updateQuestionStatus(questionIndex, currentAnswer.isCorrect);

          onSelectAnswer(currentAnswer.isCorrect);
        }
      },
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
                Text(
                  questionData.explanation,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
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

  _getAnswerBackgroundColor(int answerIndex, bool isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return Colors.white;
      case 1:
        return Color.lerp(correctColor, Colors.white, 0.8);
      case 2:
        return Color.lerp(incorrectColor, Colors.white, 0.8);
    }
  }

  _buildAnswerBorder(int answerIndex, bool isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return null;
      case 1:
        return Border.all(color: correctColor, width: 1);
      case 2:
        return Border.all(color: incorrectColor, width: 1);
    }
  }

  _buildIcon(int answerIndex, bool isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return const SizedBox();
      case 1:
        return SvgPicture.asset('assets/images/correct.svg');
      case 2:
        return SvgPicture.asset('assets/images/incorrect.svg');
    }
  }

  /// 0 - default,  1 - correct,  2 - incorrect
  int _checkAnswer(int answerIndex, bool isCorrect) {
    if (selectedAnswerIndex == -1 ||
        (selectedAnswerIndex != answerIndex && !isCorrect)) {
      return 0;
    }

    return isCorrect ? 1 : 2;
  }
}
