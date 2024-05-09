import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/progress_line.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/question_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionData {
  final String question;
  final List<AnswerData> answers;
  bool? isCorrect;

  QuestionData(
    this.question,
    this.answers,
  );
}

class AnswerData {
  final String content;
  final bool isCorrect;

  AnswerData(this.content, this.isCorrect);
}

class DiagnosticTestQuestions extends StatefulWidget {
  final Color backgroundColor;
  final List<QuestionData> questions;

  const DiagnosticTestQuestions({
    super.key,
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.questions,
  });

  @override
  State<DiagnosticTestQuestions> createState() =>
      _DiagnosticTestQuestionsState();
}

class _DiagnosticTestQuestionsState extends State<DiagnosticTestQuestions> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.questions[0].isCorrect = true;
    widget.questions[1].isCorrect = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Diagnostic Test',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: widget.backgroundColor,
      ),
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProgressLine(
              lineHeight: 4,
              totalQuestions: widget.questions.length,
              correctQuestions: widget.questions
                  .where((e) => e.isCorrect != null && e.isCorrect!)
                  .length,
              incorrectQuestions: widget.questions
                  .where((e) => e.isCorrect != null && !e.isCorrect!)
                  .length,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Question 2/50',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: widget.questions.length,
                    itemBuilder: (_, index) => QuestionPage(
                          questionData: widget.questions[index],
                        ))),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton('bookmark', () {}),
                      _buildIconButton('like', () {}),
                      _buildIconButton('dislike', () {}),
                    ],
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: MainButton(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        title: 'Continue',
                        textStyle: const TextStyle(fontSize: 18),
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        backgroundColor: const Color(0xFFFF746D),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String iconName, void Function() action) => GestureDetector(
    onTap: action,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SvgPicture.asset('assets/images/$iconName.svg', width: 30),
    ),
  );
}
