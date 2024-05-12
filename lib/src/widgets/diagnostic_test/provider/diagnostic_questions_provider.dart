import 'package:flutter/cupertino.dart';

enum ButtonStatus { disabled, correct, incorrect }

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
  final bool? isCorrect;

  AnswerData(this.content, {this.isCorrect});
}

class DiagnosticQuestionProvider extends ChangeNotifier {
  int correctQuestions = 0;
  int incorrectQuestions = 0;

  int correctAnswerIndex = -1;
  int selectedAnswerIndex = -1;

  ButtonStatus getButtonStatus() {
    if (selectedAnswerIndex == -1) {
      return ButtonStatus.disabled;
    } else if (selectedAnswerIndex == correctAnswerIndex) {
      return ButtonStatus.correct;
    } else {
      return ButtonStatus.incorrect;
    }
  }
}
