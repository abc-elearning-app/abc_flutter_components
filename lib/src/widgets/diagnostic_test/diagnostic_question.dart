import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/main_question_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/bottom_sheets/report_tab.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/page_animation.dart';

class QuestionData {
  final String question;
  final List<AnswerData> answers;
  final String explanation;
  bool? isCorrectlyChosen;
  bool bookmarked;
  bool liked;
  bool disliked;

  QuestionData(this.question, this.answers, this.explanation,
      {this.bookmarked = false,
      this.liked = false,
      this.disliked = false,
      this.isCorrectlyChosen});
}

class AnswerData {
  final String content;
  final bool isCorrect;

  AnswerData(this.content, {this.isCorrect = false});
}

enum ButtonStatus { disabled, correct, incorrect }

class DiagnosticQuestion extends StatefulWidget {
  final QuestionData? prevQuestion;
  final QuestionData nextQuestion;

  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isPro;
  final bool isDarkMode;

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
  final String? correctIcon;
  final String? incorrectIcon;

  const DiagnosticQuestion({
    super.key,
    required this.prevQuestion,
    required this.nextQuestion,
    required this.isPro,
    this.correctColor = const Color(0xFF07C58C),
    this.incorrectColor = const Color(0xFFFF746D),
    this.progressBackgroundColor = Colors.white,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.onClickExplanation,
    required this.onReport,
    required this.onContinue,
    required this.onSelectAnswer,
    required this.onToggleBookmark,
    required this.onToggleLike,
    required this.onToggleDislike,
    required this.isDarkMode,
    this.correctIcon,
    this.incorrectIcon,
  });

  @override
  State<DiagnosticQuestion> createState() => _DiagnosticQuestionState();
}

class _DiagnosticQuestionState extends State<DiagnosticQuestion> {
  late ValueNotifier _buttonStatus;

  @override
  void initState() {
    _buttonStatus = ValueNotifier<ButtonStatus>(ButtonStatus.disabled);

    super.initState();
  }

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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
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

        // prevChild only for animation
        prevChild: widget.currentQuestionIndex == 0
            ? null
            : MainQuestionPage(
                questionIndex: widget.currentQuestionIndex - 1,
                questionData: widget.prevQuestion!,
              ),

        nextChild: MainQuestionPage(
          isPro: widget.isPro,
          questionIndex: widget.currentQuestionIndex,
          questionData: widget.nextQuestion,
          correctColor: widget.correctColor,
          incorrectColor: widget.incorrectColor,
          onSelectAnswer: (isCorrect) => _handleOnSelectAnswer(isCorrect),
          onClickExplanation: widget.onClickExplanation,
          onToggleBookmark: widget.onToggleBookmark,
          onToggleLike: widget.onToggleLike,
          onToggleDislike: widget.onToggleDislike,
          correctIcon: widget.correctIcon,
          incorrectIcon: widget.incorrectIcon,
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
    // Reset status and trigger callback
    _buttonStatus.value = ButtonStatus.disabled;
    widget.onContinue();
  }

  _handleOnSelectAnswer(bool isCorrect) {
    // Update status and trigger callback
    _buttonStatus.value =
        isCorrect ? ButtonStatus.correct : ButtonStatus.incorrect;

    widget.onSelectAnswer(isCorrect);
  }
}
