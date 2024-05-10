import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/progress_line.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/question_page.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/report_tab.dart';
import 'package:flutter_abc_jsc_components/src/widgets/page_animation.dart';
import 'package:provider/provider.dart';

class DiagnosticTestWrapper extends StatelessWidget {
  final QuestionData? prevQuestion;
  final QuestionData nextQuestion;

  // For displaying progress line
  final int correctQuestions;
  final int incorrectQuestions;
  final int totalQuestions;

  // Callbacks
  final void Function() onFinish;
  final void Function() onClickExplanation;
  final void Function(List<ReportData>, String otherReason) onReport;

  // Custom color
  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;
  final Color progressBackgroundColor;

  const DiagnosticTestWrapper({
    super.key,
    required this.prevQuestion,
    required this.nextQuestion,
    required this.onFinish,
    required this.onClickExplanation,
    required this.onReport,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.correctColor = const Color(0xFF07C58C),
    this.incorrectColor = const Color(0xFFFF746D),
    this.progressBackgroundColor = Colors.white,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DiagnosticQuestionProvider(),
        child: DiagnosticTestQuestions(
          prevQuestion: prevQuestion,
          nextQuestion: nextQuestion,
          onFinish: onFinish,
          onClickExplanation: onClickExplanation,
          onReport: onReport,
          backgroundColor: backgroundColor,
          correctColor: correctColor,
          progressBackgroundColor: progressBackgroundColor,
          incorrectColor: incorrectColor,
          correctQuestions: correctQuestions,
          incorrectQuestions: incorrectQuestions,
          totalQuestions: totalQuestions,
        ));
  }
}

class DiagnosticTestQuestions extends StatefulWidget {
  final QuestionData? prevQuestion;
  final QuestionData nextQuestion;

  // For displaying progress line
  final int correctQuestions;
  final int incorrectQuestions;
  final int totalQuestions;

  // Callbacks
  final void Function() onFinish;
  final void Function() onClickExplanation;
  final void Function(List<ReportData>, String otherReason) onReport;

  // Custom color
  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;
  final Color progressBackgroundColor;

  const DiagnosticTestQuestions({
    super.key,
    required this.prevQuestion,
    required this.nextQuestion,
    required this.backgroundColor,
    required this.correctColor,
    required this.incorrectColor,
    required this.progressBackgroundColor,
    required this.onFinish,
    required this.onClickExplanation,
    required this.onReport,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.totalQuestions,
  });

  @override
  State<DiagnosticTestQuestions> createState() =>
      _DiagnosticTestQuestionsState();
}

class _DiagnosticTestQuestionsState extends State<DiagnosticTestQuestions> {
  final _buttonStatus = ValueNotifier<ButtonStatus>(ButtonStatus.disabled);
  final _questionIndex = ValueNotifier<int>(1);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiagnosticQuestionProvider>().init(
          prevQuestion: widget.prevQuestion, nextQuestion: widget.nextQuestion);
    });
    super.initState();
  }

  @override
  void dispose() {
    _buttonStatus.dispose();
    _questionIndex.dispose();
    super.dispose();
  }

  GlobalKey<PageAnimationState> animationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress line
        Selector<DiagnosticQuestionProvider, List<QuestionData>>(
            selector: (context, provider) => provider.questions,
            builder: (_, value, __) => ProgressLine(
                  correctColor: widget.correctColor,
                  incorrectColor: widget.incorrectColor,
                  backgroundColor: widget.progressBackgroundColor,
                  lineHeight: 4,
                  totalQuestions: widget.questions.length,
                  correctQuestions: value
                      .where((e) =>
                          e.isCorrectlyChosen != null && e.isCorrectlyChosen!)
                      .length,
                  incorrectQuestions: value
                      .where((e) =>
                          e.isCorrectlyChosen != null && !e.isCorrectlyChosen!)
                      .length,
                )),

        // Question index
        Selector<DiagnosticQuestionProvider, int>(
          selector: (_, provider) => provider.currentQuestionIndex,
          builder: (_, value, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Question ${value + 1}/${widget.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        // Question pages
        Selector<DiagnosticQuestionProvider, int>(
          selector: (_, provider) => provider.currentQuestionIndex,
          builder: (_, value, __) => Expanded(
              child: PageAnimation(
            key: animationKey,
            prevChild: value <= 0
                ? null
                : QuestionPage(
                    questionIndex: value - 1,
                    questionData: widget.questions[value - 1],
                    onSelectAnswer: (bool isCorrect) =>
                        _handleOnSelectAnswer(isCorrect),
                    onClickExplanation: widget.onClickExplanation,
                  ),
            nextChild: QuestionPage(
              questionIndex: value,
              questionData: widget.questions[value],
              onSelectAnswer: (bool isCorrect) =>
                  _handleOnSelectAnswer(isCorrect),
              onClickExplanation: widget.onClickExplanation,
            ),
          )),
        ),

        // Buttons
        _buildContinueButton()
      ],
    );
  }

  Widget _buildContinueButton() =>
      Consumer<DiagnosticQuestionProvider>(builder: (_, provider, __) {
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: MainButton(
              onPressed: () => _handleContinueButtonClick(provider),
              disabled: provider.questions.isEmpty ||
                  provider.getButtonStatus() == ButtonStatus.disabled,
              padding: const EdgeInsets.symmetric(vertical: 15),
              title: 'Continue',
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor:
                  provider.getButtonStatus() == ButtonStatus.correct
                      ? widget.correctColor
                      : widget.incorrectColor,
            ));
      });

  _handleContinueButtonClick(DiagnosticQuestionProvider provider) {
    if (provider.currentQuestionIndex < widget.questions.length - 1) {
      _buttonStatus.value = ButtonStatus.disabled;
      provider.increaseCurrentQuestion();
      animationKey.currentState?.onAnimated();
    } else {
      widget.onFinish();
    }
  }

  _handleOnSelectAnswer(bool isCorrect) {
    // Update button
    _buttonStatus.value =
        isCorrect ? ButtonStatus.correct : ButtonStatus.incorrect;
  }
}
