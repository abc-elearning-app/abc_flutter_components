import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestGroupQuestionList extends StatelessWidget {
  const TestGroupQuestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReviewQuestionBox(
              onLikeClick: (liked) {},
              onDislikeClick: (disliked) {},
              onBookmarkClick: (bookmarked) {},
              index: 0,
              questionData: QuestionData(
                  "When transporting chlorine in cargo tanks, what must you have?",
                  <AnswerData>[
                    AnswerData('Pipe wrench', isCorrect: false),
                    AnswerData('Socket wrench'),
                    AnswerData('Alien wrench', isCorrect: true),
                    AnswerData('Pipe wrench'),
                  ],
                  'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.'),
            ),
            ReviewQuestionBox(
              onLikeClick: (liked) {},
              onDislikeClick: (disliked) {},
              onBookmarkClick: (bookmarked) {},
              index: 0,
              questionData: QuestionData(
                  "When transporting chlorine in cargo tanks, what must you have?",
                  <AnswerData>[
                    AnswerData('Pipe wrench', isCorrect: false),
                    AnswerData('Socket wrench'),
                    AnswerData('Alien wrench', isCorrect: true),
                    AnswerData('Pipe wrench'),
                  ],
                  'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.'),
            ),
            ReviewQuestionBox(
              onLikeClick: (liked) {},
              onDislikeClick: (disliked) {},
              onBookmarkClick: (bookmarked) {},
              index: 0,
              questionData: QuestionData(
                  "When transporting chlorine in cargo tanks, what must you have?",
                  <AnswerData>[
                    AnswerData('Pipe wrench', isCorrect: false),
                    AnswerData('Socket wrench'),
                    AnswerData('Alien wrench', isCorrect: true),
                    AnswerData('Pipe wrench'),
                  ],
                  'There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length.'),
            ),
          ],
        ),
      ),
    );
  }
}
