import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestGroupQuestionList extends StatelessWidget {
  const TestGroupQuestionList({super.key});

  @override
  Widget build(BuildContext context) {
    final questionList = <QuestionData>[
      QuestionData(
          question:
              "When transporting chlorine in cargo tanks, what must you have?",
          answers: <AnswerData>[
            AnswerData('Pipe wrench'),
            AnswerData('Socket wrench', isCorrect: false),
            AnswerData('Alien wrench', isCorrect: true),
            AnswerData('Pipe wrench'),
          ],
          explanation:
              'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.',
          bookmarked: true),
      QuestionData(
          question:
              "When transporting chlorine in cargo tanks, what must you have?",
          answers: <AnswerData>[
            AnswerData('Pipe wrench'),
            AnswerData('Socket wrench'),
            AnswerData('Alien wrench', isCorrect: true),
            AnswerData('Pipe wrench', isCorrect: false),
          ],
          explanation:
              'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.',
          bookmarked: true),
      QuestionData(
          question:
              "When transporting chlorine in cargo tanks, what must you have?",
          answers: <AnswerData>[
            AnswerData('Pipe wrench', isCorrect: false),
            AnswerData('Socket wrench'),
            AnswerData('Alien wrench', isCorrect: true),
            AnswerData('Pipe wrench'),
          ],
          explanation:
              'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.',
          bookmarked: true),
    ];

    return Scaffold(
        backgroundColor:
            AppTheme.isDarkMode ? Colors.black : const Color(0xFFF5F4EE),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Saved Questions',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.isDarkMode ? Colors.white : Colors.black),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ListView.builder(
            itemCount: questionList.length,
            itemBuilder: (_, index) => ReviewQuestionBox(
                isDarkMode: AppTheme.isDarkMode,
                isPro: true,
                index: index,
                questionData: questionList[index],
                onBookmarkClick: (bookmarked) =>
                    debugPrint(bookmarked.toString()),
                onLikeClick: (liked) => debugPrint(liked.toString()),
                onDislikeClick: (disliked) => debugPrint(disliked.toString()),
                onProClick: () => debugPrint("buy pro"))));
  }
}
