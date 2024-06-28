import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/blur_effect.dart';
import 'package:flutter_abc_jsc_components/src/widgets/buttons/toggle_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../flutter_abc_jsc_components.dart';

enum ButtonType { bookmark, like, dislike }

class MainQuestionPage extends StatefulWidget {
  final int questionIndex;
  final QuestionData questionData;
  final bool isPro;
  final bool isDarkMode;

  // Colors
  final Color mainColor;
  final Color secondaryColor;
  final Color correctColor;
  final Color incorrectColor;
  final String? correctIcon;
  final String? incorrectIcon;

  // Callbacks
  final void Function(bool isCorrect)? onSelectAnswer;
  final void Function()? onClickExplanation;
  final void Function(bool isSelected)? onToggleBookmark;
  final void Function(bool isSelected)? onToggleLike;
  final void Function(bool isSelected)? onToggleDislike;

  const MainQuestionPage(
      {super.key,
      required this.questionIndex,
      required this.questionData,
      required this.isDarkMode,
      this.isPro = false,
      this.correctColor = const Color(0xFF07C58C),
      this.incorrectColor = const Color(0xFFFF746D),
      this.mainColor = const Color(0xFFE3A651),
      this.secondaryColor = const Color(0xFF7C6F5B),
      this.onSelectAnswer,
      this.onClickExplanation,
      this.onToggleBookmark,
      this.onToggleLike,
      this.onToggleDislike,
      this.correctIcon,
      this.incorrectIcon});

  @override
  State<MainQuestionPage> createState() => _MainQuestionPageState();
}

class _MainQuestionPageState extends State<MainQuestionPage> {
  late ValueNotifier<int> _selectedAnswerIndex;

  @override
  void initState() {
    _selectedAnswerIndex = ValueNotifier(-1);
    super.initState();
  }

  @override
  void dispose() {
    _selectedAnswerIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Question
                _buildQuestionBox(widget.isDarkMode),

                // Answers
                ValueListenableBuilder(
                    valueListenable: _selectedAnswerIndex,
                    builder: (_, value, __) => Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top: 15),
                                itemCount: widget.questionData.answers.length,
                                itemBuilder: (_, index) => _buildAnswer(
                                      index,
                                      widget.isDarkMode,
                                    )),

                            // Explanation
                            _buildExplanation(value)
                          ],
                        )),
              ],
            ),
          ),
        ),

        // Bookmark, like and dislike buttons
        ValueListenableBuilder(
            valueListenable: _selectedAnswerIndex,
            builder: (_, value, __) => Visibility(
                  visible: value != -1,
                  child: _buildOptions(
                      padding: const EdgeInsets.symmetric(vertical: 10)),
                ))
      ],
    );
  }

  Widget _buildQuestionBox(bool isDarkMode) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.16) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: !isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                        blurRadius: 5)
                  ]
                : null),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('NEW QUESTION',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.5))),
                ValueListenableBuilder(
                  valueListenable: _selectedAnswerIndex,
                  builder: (_, value, __) => Opacity(
                      opacity: value == -1 ? 1 : 0,
                      child:
                          Transform.scale(scale: 0.8, child: _buildOptions())),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.questionData.question,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ))
          ],
        ),
      );

  Widget _buildAnswer(
    int answerIndex,
    bool isDarkMode,
  ) {
    final currentAnswer = widget.questionData.answers[answerIndex];
    return GestureDetector(
      // Handle select answer
      onTap: () {
        // Only allow to select answer once
        if (_selectedAnswerIndex.value == -1) {
          _selectedAnswerIndex.value = answerIndex;
          if (widget.onSelectAnswer != null) {
            widget.onSelectAnswer!(currentAnswer.isCorrect == true);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _answerBackgroundColor(
              isDarkMode,
              answerIndex,
              currentAnswer.isCorrect,
            ),
            border: _answerBorder(answerIndex, currentAnswer.isCorrect)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentAnswer.content,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: _answerTextColor(
                    isDarkMode,
                    answerIndex,
                    currentAnswer.isCorrect,
                  )),
            ),

            // Icon (after selected)
            _buildIcon(answerIndex, currentAnswer.isCorrect)
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(int selectedIndex) => AnimatedCrossFade(
      firstChild: GestureDetector(
        onTap: !widget.isPro ? widget.onClickExplanation : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Explanation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  if (!widget.isPro)
                    SvgPicture.asset(
                      'assets/images/pro_content.svg',
                      height: 25,
                    )
                ],
              ),
              const SizedBox(height: 10),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    widget.questionData.explanation,
                    style: TextStyle(
                        fontSize: 15,
                        color: (widget.isDarkMode ? Colors.white : Colors.black)
                            .withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                if (!widget.isPro) const BlurEffect()
              ])
            ],
          ),
        ),
      ),
      secondChild: const SizedBox(),
      crossFadeState: selectedIndex == -1
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200));

  Widget _buildOptions({EdgeInsetsGeometry? padding}) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButton(
                iconSize: 30,
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'bookmark',
                selectedIcon: 'bookmarked',
                isSelected: widget.questionData.bookmarked,
                onToggle: (isSelected) => widget.onToggleBookmark != null
                    ? widget.onToggleBookmark!(isSelected)
                    : null),
            ToggleButton(
                iconSize: 30,
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'like',
                selectedIcon: 'liked',
                isSelected: widget.questionData.liked,
                onToggle: (isSelected) => widget.onToggleLike != null
                    ? widget.onToggleLike!(isSelected)
                    : null),
            ToggleButton(
                iconSize: 30,
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'dislike',
                selectedIcon: 'disliked',
                isSelected: widget.questionData.disliked,
                onToggle: (isSelected) => widget.onToggleDislike != null
                    ? widget.onToggleDislike!(isSelected)
                    : null),
          ],
        ),
      );

  _answerBackgroundColor(bool isDarkMode, int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return isDarkMode ? Colors.white.withOpacity(0.24) : Colors.white;
      case 1:
        return const Color(0xFFDCFDF3);
      case 2:
        return const Color(0xFFFFD1CF);
    }
  }

  _answerTextColor(bool isDarkMode, int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return isDarkMode ? Colors.white : Colors.black;
      default:
        return Colors.black;
    }
  }

  _answerBorder(int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return null;
      case 1:
        return Border.all(color: widget.correctColor, width: 1);
      case 2:
        return Border.all(color: widget.incorrectColor, width: 1);
    }
  }

  _buildIcon(int answerIndex, bool? isCorrect) {
    switch (_checkAnswer(answerIndex, isCorrect)) {
      case 0:
        return const SizedBox();
      case 1:
        return SvgPicture.asset(
            'assets/images/${widget.correctIcon ?? 'correct'}.svg');
      case 2:
        return SvgPicture.asset(
            'assets/images/${widget.incorrectIcon ?? 'incorrect'}.svg');
    }
  }

  /// 0 - default,  1 - correct,  2 - incorrect
  int _checkAnswer(int answerIndex, bool? isCorrect) {
    // If not select any answer yet
    if (_selectedAnswerIndex.value == -1) return 0;

    // Display correct answer
    if (isCorrect == true) return 1;

    // Display incorrect answer (if choose wrong)
    if (_selectedAnswerIndex.value == answerIndex) return 2;

    return 0;
  }
}
