import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:provider/provider.dart';

class TestDiagnosticQuestionsPage extends StatelessWidget {
  const TestDiagnosticQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = <QuestionData>[
      QuestionData(
          'Some city transit buses may have a brake-door interlock system, this system _____.',
          <AnswerData>[
            AnswerData('An incorrect answer', false),
            AnswerData('A correct answer', true),
            AnswerData('An incorrect answer', false),
            AnswerData('An incorrect answer', false),
          ],
          "There are four pieces in the assembled puzzle, two of which are triangles and the other pieces are 2 rectangles with different length."),
      QuestionData(
          'Who was in Paris ?',
          <AnswerData>[
            AnswerData('Joe Cinema', false),
            AnswerData('Kayne West', true),
            AnswerData('Mickey Trump', false),
            AnswerData('Charles Dicken', false),
          ],
          "Anyone could be in Paris !!!"),
      QuestionData(
          'Who is Kim Jisoo ?',
          <AnswerData>[
            AnswerData('Kpop Idol', true),
            AnswerData("Korean's president", false),
            AnswerData('Vietnamese singer', false),
            AnswerData('Teacher', false),
          ],
          "A member of the South Korean girl group Blackpink, formed by YG Entertainment, in August 2016"),
      QuestionData(
          'Where is ABC ?',
          <AnswerData>[
            AnswerData('Thành Đông kindergarten', true),
            AnswerData("19 Tố Hữu", false),
            AnswerData('Inside the white house', false),
            AnswerData('Inside HUST', false),
          ],
          "Very simple question"),
    ];

    return DiagnosticTestWrapper(
      questions: questions,
      onFinish: () => print('onFinish'),
      onClickExplanation: () => print('buyPro'),
      onReport: (reportDataList, otherReason) {
        for (var element in reportDataList) {
          print('${element.title} - ${element.isSelected}');
        }
        print(otherReason);
      },
    );
  }
}
