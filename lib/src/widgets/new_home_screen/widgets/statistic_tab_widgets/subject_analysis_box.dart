import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum QuestionType { correct, incorrect, unanswered }

class SubjectAnalysisData {
  final String title;
  final String icon;
  final double accuracyRate;
  final int correctQuestions;
  final int incorrectQuestions;
  final int unansweredQuestions;

  SubjectAnalysisData({
    required this.title,
    required this.icon,
    required this.accuracyRate,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.unansweredQuestions,
  });
}

class SubjectAnalysisBox extends StatefulWidget {
  final SubjectAnalysisData subjectAnalysisData;
  final bool isDarkMode;

  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color unansweredColor;

  const SubjectAnalysisBox(
      {super.key,
      this.iconBackgroundColor = const Color(0xFF7C6F5B),
      this.backgroundColor = const Color(0xFFFFFDF1),
      this.correctColor = const Color(0xFF15CB9F),
      this.incorrectColor = const Color(0xFFFC5656),
      this.unansweredColor = const Color(0xFFD9D9D9),
      required this.subjectAnalysisData,
      required this.isDarkMode});

  @override
  State<SubjectAnalysisBox> createState() => _SubjectAnalysisBoxState();
}

class _SubjectAnalysisBoxState extends State<SubjectAnalysisBox>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> _isExpanded;
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _isExpanded = ValueNotifier(false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.3)
              : widget.backgroundColor),
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleToggleExpand,
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    // Icon
                    IconBox(
                        icon: widget.subjectAnalysisData.icon,
                        iconColor: Colors.white,
                        size: 35,
                        backgroundColor: widget.iconBackgroundColor),

                    const SizedBox(width: 15),

                    // Title
                    Expanded(
                        child: Text(
                      widget.subjectAnalysisData.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black),
                    )),

                    // Dropdown button
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _animation.value,
                          child: SvgPicture.asset(
                            'assets/images/chevron_down.svg',
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                            height: 10,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),

          // Main content
          ValueListenableBuilder(
            valueListenable: _isExpanded,
            builder: (_, value, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: value ? 220 : 0,
              decoration: BoxDecoration(
                  color:
                      widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Accuracy Rate',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black)),
                          Text(
                            '${widget.subjectAnalysisData.accuracyRate.toInt()}%',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 10,
                      ),
                      child: LinearPercentIndicator(
                        percent: widget.subjectAnalysisData.accuracyRate / 100,
                        animation: true,
                        progressColor: _getProgressColor(),
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        padding: EdgeInsets.zero,
                        lineHeight: 10,
                        barRadius: const Radius.circular(10),
                      ),
                    ),
                    const Divider(),
                    _buildQuestionInfo(
                      QuestionType.correct,
                      widget.subjectAnalysisData.correctQuestions,
                    ),
                    _buildQuestionInfo(
                      QuestionType.incorrect,
                      widget.subjectAnalysisData.incorrectQuestions,
                    ),
                    _buildQuestionInfo(
                      QuestionType.unanswered,
                      widget.subjectAnalysisData.unansweredQuestions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildQuestionInfo(QuestionType type, int questionCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            'assets/images/dot.png',
            color: _getColor(type),
            height: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _getTitle(type),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Text(
            questionCount.toString(),
            style: TextStyle(
              color: _getColor(type, isText: true),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  _getTitle(QuestionType type) {
    switch (type) {
      case QuestionType.correct:
        return 'Correct Questions';
      case QuestionType.incorrect:
        return 'Incorrect Questions';
      case QuestionType.unanswered:
        return 'Unanswered Questions';
    }
  }

  _getColor(QuestionType type, {bool isText = false}) {
    switch (type) {
      case QuestionType.correct:
        return widget.correctColor;
      case QuestionType.incorrect:
        return widget.incorrectColor;
      case QuestionType.unanswered:
        return isText
            ? widget.isDarkMode
                ? Colors.white
                : Colors.black
            : widget.unansweredColor;
    }
  }

  _getProgressColor() {
    if (widget.subjectAnalysisData.accuracyRate < 10) {
      return widget.incorrectColor;
    }
    return widget.correctColor;
  }

  _handleToggleExpand() {
    if (!_isExpanded.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isExpanded.value = !_isExpanded.value;
  }
}
