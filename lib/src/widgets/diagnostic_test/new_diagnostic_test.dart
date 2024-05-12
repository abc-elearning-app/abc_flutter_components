import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/question_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/report_tab.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/page_animation.dart';

class DiagnosticTestQuestions extends StatefulWidget {
  final QuestionData? prevQuestion;
  final QuestionData nextQuestion;

  final int currentQuestionIndex;

  // For displaying progress line
  final int correctQuestions;
  final int incorrectQuestions;
  final int totalQuestions;

  // Callbacks
  final void Function() onClickExplanation;
  final void Function() onContinue;
  final void Function(List<ReportData>, String otherReason) onReport;
  final void Function(bool isCorrect) onSelectAnswer;
  final void Function(bool isSelected) onToggleBookmark;
  final void Function(bool isSelected) onToggleLike;
  final void Function(bool isSelected) onToggleDislike;

  // Custom color
  final Color correctColor;
  final Color incorrectColor;
  final Color progressBackgroundColor;

  const DiagnosticTestQuestions({
    super.key,
    required this.prevQuestion,
    required this.nextQuestion,
    this.correctColor = const Color(0xFF07C58C),
    this.incorrectColor = const Color(0xFFFF746D),
    this.progressBackgroundColor = Colors.white,
    required this.onClickExplanation,
    required this.onReport,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.onContinue,
    required this.onSelectAnswer,
    required this.onToggleBookmark,
    required this.onToggleLike,
    required this.onToggleDislike,
  });

  @override
  State<DiagnosticTestQuestions> createState() =>
      _DiagnosticTestQuestionsState();
}

class _DiagnosticTestQuestionsState extends State<DiagnosticTestQuestions> {
  final _buttonStatus = ValueNotifier<ButtonStatus>(ButtonStatus.disabled);

  @override
  void dispose() {
    _buttonStatus.dispose();
    super.dispose();
  }

  GlobalKey<PageAnimationState> animationKey = GlobalKey<PageAnimationState>();

  @override
  Widget build(BuildContext context) {
    animationKey.currentState?.onAnimated();
    return Column(
      children: [
        // Question index
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Question ${widget.currentQuestionIndex + 1}/${widget.totalQuestions}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        // Question pages
        Expanded(child: _buildQuestion()),

        // Buttons
        _buildContinueButton()
      ],
    );
  }

  Widget _buildQuestion() => PageAnimation(
        key: animationKey,
        prevChild: widget.currentQuestionIndex == 0
            ? null
            : QuestionPage(
                questionIndex: widget.currentQuestionIndex - 1,
                questionData: widget.prevQuestion!,
                onSelectAnswer: (bool isCorrect) =>
                    _handleOnSelectAnswer(isCorrect),
                onClickExplanation: widget.onClickExplanation,
                onToggleBookmark: widget.onToggleBookmark,
                onToggleLike: widget.onToggleLike,
                onToggleDislike: widget.onToggleDislike,
              ),
        nextChild: QuestionPage(
          questionIndex: widget.currentQuestionIndex,
          questionData: widget.nextQuestion,
          onSelectAnswer: (bool isCorrect) => _handleOnSelectAnswer(isCorrect),
          onClickExplanation: widget.onClickExplanation,
          onToggleBookmark: widget.onToggleBookmark,
          onToggleLike: widget.onToggleLike,
          onToggleDislike: widget.onToggleDislike,
        ),
      );

  Widget _buildContinueButton() => ValueListenableBuilder(
        valueListenable: _buttonStatus,
        builder: (_, value, __) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: MainButton(
              onPressed: () => _handleContinueButtonClick(),
              disabled: value == ButtonStatus.disabled,
              padding: const EdgeInsets.symmetric(vertical: 15),
              title: 'Continue',
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: value == ButtonStatus.correct
                  ? widget.correctColor
                  : widget.incorrectColor,
            )),
      );

  _handleContinueButtonClick() {
    _buttonStatus.value = ButtonStatus.disabled;
    widget.onContinue();
  }

  _handleOnSelectAnswer(bool isCorrect) {
    _buttonStatus.value =
        isCorrect ? ButtonStatus.correct : ButtonStatus.incorrect;

    widget.onSelectAnswer(isCorrect);
  }
}
