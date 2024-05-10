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
  final bool isCorrect;

  AnswerData(this.content, this.isCorrect);
}

class DiagnosticQuestionProvider extends ChangeNotifier {
  QuestionData? prevQuestion;
  QuestionData? nextQuestion;

  int correctAnswerIndex = -1;
  int selectedAnswerIndex = -1;

  void init(
      {required QuestionData? prevQuestion,
      required QuestionData nextQuestion}) {
    this.prevQuestion = prevQuestion;
    this.nextQuestion = nextQuestion;

    // setup correct index
    correctAnswerIndex =
        nextQuestion.answers.indexWhere((answer) => answer.isCorrect);
  }

  ButtonStatus getButtonStatus() {
    if (selectedAnswerIndex == -1) {
      return ButtonStatus.disabled;
    } else if (selectedAnswerIndex == correctAnswerIndex) {
      return ButtonStatus.correct;
    } else {
      return ButtonStatus.incorrect;
    }
  }

// void toggleBookmark(int questionIndex) {
//   _questions[questionIndex].bookmarked =
//   !_questions[questionIndex].bookmarked;
//   _updateQuestionList();
// }
//
// void toggleLike(int questionIndex) {
//   _questions[questionIndex].liked = !_questions[questionIndex].liked;
//   _updateQuestionList();
// }
//
// void toggleDislike(int questionIndex) {
//   _questions[questionIndex].disliked = !_questions[questionIndex].disliked;
//   _updateQuestionList();
// }
}
