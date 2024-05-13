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

  final questionValueNotifier = ValueNotifier<List<QuestionData>>([]);

  @override
  void initState() {
    questionValueNotifier.value = [
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
          'Who was in Paris ?',
          <AnswerData>[
            AnswerData('Joe Cinema'),
            AnswerData('Kayne West', isCorrect: true),
            AnswerData('Mickey Trump'),
            AnswerData('Charles Dicken'),
          ],
          "Anyone could be in Paris !!!"),
      QuestionData(
          'Who is Kim Jisoo ?',
          <AnswerData>[
            AnswerData('Kpop Idol', isCorrect: true),
            AnswerData("Korean's president"),
            AnswerData('Vietnamese singer'),
            AnswerData('Teacher'),
          ],
          "A member of the South Korean girl group Blackpink, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Where is ABC ?',
          <AnswerData>[
            AnswerData('Thành Đông kindergarten', isCorrect: true),
            AnswerData("19 Tố Hữu"),
            AnswerData('Inside the white house'),
            AnswerData('Inside HUST'),
          ],
          "Very simple question"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F4EE),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress line
            ValueListenableBuilder(
              valueListenable: questionValueNotifier,
              builder: (_, value, __) => ProgressLine(
                  lineHeight: 4,
                  totalQuestions: value.length,
                  correctQuestions: value
                      .where((element) => element.isCorrectlyChosen == true)
                      .length,
                  incorrectQuestions: value
                      .where((element) => element.isCorrectlyChosen == false)
                      .length),
            ),

            // Question
            Expanded(
              child: DiagnosticQuestion(
                prevQuestion: currentIndex == 0
                    ? null
                    : questionValueNotifier.value[currentIndex - 1],
                isPro: false,
                nextQuestion: questionValueNotifier.value[currentIndex],
                totalQuestions: questionValueNotifier.value.length,
                currentQuestionIndex: currentIndex,
                onContinue: () => _handleContinue(),
                onClickExplanation: () => print('buyPro'),
                onReport: (reportDataList, otherReason) {},
                onSelectAnswer: (isCorrect) => _handleOnSelectAnswer(isCorrect),
                onToggleLike: (isSelected) => print('Like $isSelected'),
                onToggleDislike: (isSelected) => print('Dislike $isSelected'),
                onToggleBookmark: (isSelected) => print('Bookmark $isSelected'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleOnSelectAnswer(bool isCorrect) {
    final tmpQuestionList = questionValueNotifier.value;
    tmpQuestionList[currentIndex].isCorrectlyChosen = isCorrect;
    questionValueNotifier.value = tmpQuestionList
        .map((e) => QuestionData(e.question, e.answers, e.explanation,
            bookmarked: e.bookmarked,
            liked: e.liked,
            disliked: e.disliked,
            isCorrectlyChosen: e.isCorrectlyChosen))
        .toList();
  }

  _handleContinue() {
    if (currentIndex < questionValueNotifier.value.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
