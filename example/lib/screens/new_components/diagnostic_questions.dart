import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestDiagnosticQuestionsPage extends StatefulWidget {
  const TestDiagnosticQuestionsPage({super.key});

  @override
  State<TestDiagnosticQuestionsPage> createState() =>
      _TestDiagnosticQuestionsPageState();
}

class _TestDiagnosticQuestionsPageState
    extends State<TestDiagnosticQuestionsPage> {
  int currentIndex = 0;
  int correctQuestions = 0;
  int incorrectQuestions = 0;

  late ValueNotifier<List<QuestionData>> _questions;

  bool isDarkMode = false;

  @override
  void initState() {
    _questions = ValueNotifier<List<QuestionData>>([
      QuestionData(
          'Some city transit buses may have a brake-door interlock system, this system _____.',
          <AnswerData>[
            AnswerData('An incorrect answer'),
            AnswerData('A correct answer', isCorrect: true),
            AnswerData('An incorrect answer'),
            AnswerData('An incorrect answer'),
          ],
          "There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length."),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Hắc Hường là gì?',
          <AnswerData>[
            AnswerData('Black Pink', isCorrect: true),
            AnswerData("2 Màu sắc"),
            AnswerData('ABC'),
            AnswerData('KS'),
          ],
          "A South Korean girl group, formed by YG Entertainment, in August 2016"),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Diagnostic Test',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _questions,
          builder: (_, value, __) => Column(
            children: [
              // Progress line
              ProgressLine(
                  lineHeight: 5,
                  totalQuestions: value.length,
                  backgroundColor:
                      isDarkMode ? Colors.white.withOpacity(0.5) : Colors.white,
                  correctQuestions: value
                      .where((element) => element.isCorrectlyChosen == true)
                      .length,
                  incorrectQuestions: value
                      .where((element) => element.isCorrectlyChosen == false)
                      .length),

              // Question
              Expanded(
                child: DiagnosticQuestion(
                  isDarkMode: isDarkMode,
                  prevQuestion: currentIndex == 0
                      ? null
                      : value[currentIndex - 1],
                  isPro: true,
                  nextQuestion: value[currentIndex],
                  totalQuestions: value.length,
                  currentQuestionIndex: currentIndex,
                  onContinue: () => _handleContinue(),
                  onClickExplanation: () => print('buyPro'),
                  onReport: (reportDataList, otherReason) {},
                  onSelectAnswer: (isCorrect) =>
                      _handleOnSelectAnswer(isCorrect),
                  onToggleLike: (isSelected) => _handleOnLike(isSelected),
                  onToggleDislike: (isSelected) => _handleOnDislike(isSelected),
                  onToggleBookmark: (isSelected) =>
                      print('Bookmark $isSelected'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleOnSelectAnswer(bool isCorrect) {
    final tmpQuestionList = _questions.value;
    tmpQuestionList[currentIndex].isCorrectlyChosen = isCorrect;

    // Update the progress line
    _questions.value = tmpQuestionList
        .map((e) => QuestionData(e.question, e.answers, e.explanation,
            bookmarked: e.bookmarked,
            liked: e.liked,
            disliked: e.disliked,
            isCorrectlyChosen: e.isCorrectlyChosen))
        .toList();
  }

  _handleOnLike(bool isSelected) {}

  _handleOnDislike(bool isSelected) {
    if (isSelected) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: true,
        builder: (_) => ReportMistakePopup(
          isDarkMode: isDarkMode,
          onClick: (List<MistakeData> mistakeData, String otherReasons) {
            for (var element in mistakeData) {
              print(element.isSelected);
            }
            print(otherReasons);
          },
        ),
      );
    }
  }

  _handleContinue() {
    if (currentIndex < _questions.value.length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.of(context).pop();
    }
  }
}
