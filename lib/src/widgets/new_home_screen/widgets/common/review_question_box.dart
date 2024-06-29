import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/buttons/toggle_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewQuestionBox extends StatefulWidget {
  final int index;
  final QuestionData questionData;
  final bool isPro;
  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color explanationColor;
  final String correctIcon;
  final String incorrectIcon;
  final String unselectedIcon;

  // Callbacks
  final void Function(bool isSelected) onBookmarkClick;
  final void Function(bool isSelected) onLikeClick;
  final void Function(bool isSelected) onDislikeClick;
  final void Function() onProClick;

  const ReviewQuestionBox({
    super.key,
    required this.index,
    required this.questionData,
    required this.onBookmarkClick,
    required this.onLikeClick,
    required this.onDislikeClick,
    required this.onProClick,
    required this.isPro,
    required this.isDarkMode,
    this.explanationColor = const Color(0xFF5497FF),
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.correctIcon = 'assets/images/correct.svg',
    this.incorrectIcon = 'assets/images/incorrect.svg',
    this.unselectedIcon = 'assets/images/unselected.svg',
  });

  @override
  State<ReviewQuestionBox> createState() => _ReviewQuestionBoxState();
}

class _ReviewQuestionBoxState extends State<ReviewQuestionBox> {
  bool isShowExplanation = false;

  late bool isBookmarked;
  late bool isLiked;
  late bool isDisliked;

  @override
  void initState() {
    isBookmarked = widget.questionData.bookmarked;
    isLiked = widget.questionData.liked;
    isDisliked = widget.questionData.disliked;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: !widget.isDarkMode
              ? [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      spreadRadius: 2,
                      offset: const Offset(0, 2))
                ]
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildButtons(),

                // Question and answers
                Text(
                  '${widget.index + 1}. ${widget.questionData.question}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: widget.isDarkMode ? Colors.white : Colors.black),
                ),

                Column(
                  children: List.generate(
                      widget.questionData.answers.length,
                      (index) => _buildAnswer(
                          widget.questionData.answers[index].content,
                          isCorrect:
                              widget.questionData.answers[index].isCorrect)),
                )
              ],
            ),
          ),

          StatefulBuilder(
              builder: (_, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explanation',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              Text(
                                widget.questionData.explanation,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.grey.shade600),
                              )
                            ],
                          ),
                        ),
                        secondChild: const SizedBox(),
                        crossFadeState: isShowExplanation
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                      ),
                      _explanationSection(setState)
                    ],
                  )),

          // Show explanation
        ],
      ),
    );
  }

  Widget _buildButtons() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ToggleButton(
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'assets/images/bookmark.svg',
                selectedIcon: 'assets/images/bookmarked.svg',
                isSelected: isBookmarked,
                onToggle: (isSelected) => widget.onBookmarkClick(isSelected)),
            ToggleButton(
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'assets/images/like.svg',
                selectedIcon: 'assets/images/liked.svg',
                isSelected: isLiked,
                onToggle: (isSelected) => widget.onLikeClick(isSelected)),
            ToggleButton(
                color: widget.isDarkMode
                    ? widget.mainColor
                    : widget.secondaryColor,
                unselectedIcon: 'assets/images/dislike.svg',
                selectedIcon: 'assets/images/disliked.svg',
                isSelected: isDisliked,
                onToggle: (isSelected) => widget.onDislikeClick(isSelected)),
          ],
        ),
      );

  Widget _buildAnswer(String content, {bool? isCorrect}) {
    String icon = '';
    switch (isCorrect) {
      case null:
        icon = widget.unselectedIcon;
        break;
      case true:
        icon = widget.correctIcon;
        break;
      case false:
        icon = widget.incorrectIcon;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 12,
            colorFilter: isCorrect == null ? ColorFilter.mode(widget.isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn) : null
          ),
          const SizedBox(width: 15),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _explanationSection(void Function(void Function() action) setState) =>
      GestureDetector(
        onTap: () => _handleToggleExplanation(setState),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.white.withOpacity(0.08)
                  : widget.explanationColor.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Show Explanation',
                style: TextStyle(
                    fontSize: 18,
                    color: widget.explanationColor,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Transform.flip(
                    flipY: isShowExplanation,
                    child: SvgPicture.asset('assets/images/chevron_down.svg')),
              ),

              // Pro icon
              if (!widget.isPro)
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset('assets/images/pro_content.svg',
                      height: 25),
                ))
            ],
          ),
        ),
      );

  _handleToggleExplanation(void Function(void Function() action) setState) {
    if (widget.isPro) {
      setState(() => isShowExplanation = !isShowExplanation);
    } else {
      widget.onProClick();
    }
  }
}
