import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/progress_line.dart';
import 'package:flutter_abc_jsc_components/src/widgets/diagnostic_test/widgets/question_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionData {
  final String question;
  final List<AnswerData> answers;
  final String explanation;
  bool? isCorrectlyChosen;
  bool saved;
  bool liked;
  bool disliked;

  QuestionData(this.question, this.answers, this.explanation,
      {this.saved = false, this.liked = false, this.disliked = false});
}

class AnswerData {
  final String content;
  final bool isCorrect;

  AnswerData(this.content, this.isCorrect);
}

enum ButtonStatus { disabled, correct, incorrect }

class DiagnosticTestQuestions extends StatefulWidget {
  final List<QuestionData> questions;
  final void Function() onFinish;

  // Custom color
  final Color correctColor;
  final Color incorrectColor;
  final Color backgroundColor;
  final Color progressBackgroundColor;

  const DiagnosticTestQuestions({
    super.key,
    required this.questions,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.correctColor = const Color(0xFF07C58C),
    this.incorrectColor = const Color(0xFFFF746D),
    this.progressBackgroundColor = Colors.white,
    required this.onFinish,
  });

  @override
  State<DiagnosticTestQuestions> createState() =>
      _DiagnosticTestQuestionsState();
}

class ProgressModel {
  final int correctQuestions;
  final int incorrectQuestions;

  ProgressModel(this.correctQuestions, this.incorrectQuestions);
}

class BookmarkModel {
  final bool bookmarked;
  final bool liked;
  final bool disliked;

  BookmarkModel(this.bookmarked, this.liked, this.disliked);
}

class _DiagnosticTestQuestionsState extends State<DiagnosticTestQuestions> {
  final _pageController = PageController();
  final _buttonStatus = ValueNotifier<ButtonStatus>(ButtonStatus.disabled);
  final _questionIndex = ValueNotifier<int>(1);
  final _progressModel = ValueNotifier<ProgressModel>(ProgressModel(0, 0));
  final _bookmarkModel =
      ValueNotifier<BookmarkModel>(BookmarkModel(false, false, false));

  @override
  void dispose() {
    _pageController.dispose();
    _buttonStatus.dispose();
    _questionIndex.dispose();
    _progressModel.dispose();
    _bookmarkModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug
    widget.questions[0].isCorrectlyChosen = true;
    widget.questions[1].isCorrectlyChosen = false;

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
            // Progress line
            ValueListenableBuilder(
              valueListenable: _progressModel,
              builder: (_, value, __) => ProgressLine(
                correctColor: widget.correctColor,
                incorrectColor: widget.incorrectColor,
                backgroundColor: widget.progressBackgroundColor,
                lineHeight: 4,
                totalQuestions: widget.questions.length,
                correctQuestions: value.correctQuestions,
                incorrectQuestions: value.incorrectQuestions,
                // correctQuestions: widget.questions
                //     .where((e) =>
                //         e.isCorrectlyChosen != null && e.isCorrectlyChosen!)
                //     .length,
                // incorrectQuestions: widget.questions
                //     .where((e) =>
                //         e.isCorrectlyChosen != null && !e.isCorrectlyChosen!)
                //     .length,
              ),
            ),

            // Question index
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ValueListenableBuilder(
                valueListenable: _questionIndex,
                builder: (_, value, __) => Text(
                  'Question $value/${widget.questions.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            // Question pages
            Expanded(
                child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: widget.questions.length,
                    itemBuilder: (_, index) => QuestionPage(
                          questionData: widget.questions[index],
                          onSelectAnswer: (bool isCorrect) =>
                              _handleOnSelectAnswer(isCorrect),
                        ))),

            // Buttons
            Column(
              children: [
                _buildIconButtons(),
                _buildContinueButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconButtons() => ValueListenableBuilder(
        valueListenable: _bookmarkModel,
        builder: (_, value, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconButton(value.bookmarked ? 'bookmarked' : 'bookmark', () {
              _bookmarkModel.value = BookmarkModel(
                !_bookmarkModel.value.bookmarked,
                _bookmarkModel.value.liked,
                _bookmarkModel.value.disliked,
              );
            }),
            _iconButton(value.liked ? 'liked' : 'like', () {
              _bookmarkModel.value = BookmarkModel(
                _bookmarkModel.value.bookmarked,
                !_bookmarkModel.value.liked,
                _bookmarkModel.value.disliked,
              );
            }),
            _iconButton(value.disliked ? 'disliked' : 'dislike', () {
              _bookmarkModel.value = BookmarkModel(
                _bookmarkModel.value.bookmarked,
                _bookmarkModel.value.liked,
                !_bookmarkModel.value.disliked,
              );
            }),
          ],
        ),
      );

  Widget _iconButton(String iconName, void Function() action) =>
      GestureDetector(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/$iconName.svg', width: 30),
        ),
      );

  Widget _buildContinueButton() => Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ValueListenableBuilder(
        valueListenable: _buttonStatus,
        builder: (_, value, __) => MainButton(
          disabled: value == ButtonStatus.disabled,
          padding: const EdgeInsets.symmetric(vertical: 15),
          title: 'Continue',
          textStyle: const TextStyle(fontSize: 18),
          onPressed: () {
            if (_pageController.page != widget.questions.length - 1) {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);

              _questionIndex.value++;

              _buttonStatus.value = ButtonStatus.disabled;

              // Reset bookmark
              _bookmarkModel.value = BookmarkModel(false, false, false);
            } else {
              widget.onFinish();
            }
          },
          backgroundColor: value == ButtonStatus.correct
              ? widget.correctColor
              : widget.incorrectColor,
        ),
      ));

  _handleOnSelectAnswer(bool isCorrect) {
    // Update button
    _buttonStatus.value =
        isCorrect ? ButtonStatus.correct : ButtonStatus.incorrect;

    // Update progress
    if (isCorrect) {
      _progressModel.value = ProgressModel(
          _progressModel.value.correctQuestions + 1,
          _progressModel.value.incorrectQuestions);
    } else {
      _progressModel.value = ProgressModel(
          _progressModel.value.correctQuestions,
          _progressModel.value.incorrectQuestions + 1);
    }
  }
}
