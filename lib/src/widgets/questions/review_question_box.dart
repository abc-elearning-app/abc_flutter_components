import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';

class QuestionData {
  final String longId;
  final int questionId;
  final String question;
  final String image;
  final List<AnswerData> answers;
  final String explanation;
  final bool? selectionStatus;
  final String topicName;
  final String topicIcon;
  bool bookmarked;
  bool liked;
  bool disliked;

  QuestionData({
    required this.longId,
    required this.questionId,
    required this.question,
    required this.image,
    required this.answers,
    required this.explanation,
    required this.topicName,
    required this.topicIcon,
    this.selectionStatus,
    this.bookmarked = false,
    this.liked = false,
    this.disliked = false,
  });
}

class AnswerData {
  final String content;
  final bool? isCorrect;

  AnswerData(this.content, {this.isCorrect});
}

class ReviewQuestionBox extends StatefulWidget {
  final int index;
  final QuestionData questionData;

  final bool showResultLabel;
  final bool isPro;
  final bool isDarkMode;
  final bool isTester;
  final String proIcon;

  final Color mainColor;
  final String mainColorHex;
  final Color secondaryColor;
  final String secondaryColorHex;
  final Color correctColor;
  final Color incorrectColor;
  final Color explanationColor;
  final Color topBackgroundColor;

  final Widget Function(BuildContext context, String text, TextStyle textStyle)? renderTextBuilder;
  final Widget Function(BuildContext context, String image)? renderImageBuilder;
  final Widget Function(BuildContext context, TextStyle textStyle)? paragraphBuilder;

  // Callbacks
  final void Function(bool isSelected) onBookmark;
  final void Function(bool isSelected) onLike;
  final void Function(bool isSelected) onDislike;
  final void Function() onProClick;
  final void Function() onReportTest;

  const ReviewQuestionBox({
    super.key,
    required this.index,
    required this.questionData,
    required this.onBookmark,
    required this.onLike,
    required this.onDislike,
    required this.onProClick,
    required this.isPro,
    required this.isDarkMode,
    required this.mainColor,
    required this.mainColorHex,
    required this.secondaryColor,
    required this.secondaryColorHex,
    required this.correctColor,
    required this.incorrectColor,
    required this.proIcon,
    required this.isTester,
    required this.onReportTest,
    this.explanationColor = const Color(0xFF5497FF),
    this.topBackgroundColor = const Color(0xFFFFFDF1),
    this.renderTextBuilder,
    this.renderImageBuilder,
    this.paragraphBuilder,
    required this.showResultLabel,
  });

  @override
  State<ReviewQuestionBox> createState() => _ReviewQuestionBoxState();
}

class _ReviewQuestionBoxState extends State<ReviewQuestionBox> {
  bool isShowExplanation = false;

  bool get isBookmarked => widget.questionData.bookmarked;

  bool get isLiked => widget.questionData.liked;

  bool get isDisliked => widget.questionData.disliked;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: widget.isDarkMode ? Colors.white : Colors.black);
    TextStyle explanationTextStyle =
        TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, fontSize: 14, color: widget.isDarkMode ? Colors.white : Colors.grey.shade600);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, spreadRadius: 2, offset: const Offset(0, 2))] : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic name and icon
          Container(
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.grey.shade800 : widget.topBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                IconBox(
                  padding: const EdgeInsets.all(5),
                  size: 35,
                  icon: widget.questionData.topicIcon,
                  iconColor: Colors.white,
                  backgroundColor: widget.secondaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  widget.questionData.topicName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 2,
                )),
                if (!widget.showResultLabel) _buildButtons()
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and action buttons
                if (widget.showResultLabel)
                  Row(
                    children: [
                      Expanded(child: _buildStatus()),
                      _buildButtons(),
                    ],
                  ),

                const SizedBox(height: 5),

                // Question and answers
                if (widget.renderTextBuilder != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.index + 1}. ',
                        style: textStyle,
                      ),
                      Expanded(child: widget.renderTextBuilder!.call(context, widget.questionData.question, textStyle)),
                      if (widget.renderImageBuilder != null && widget.questionData.image.isNotEmpty)
                        widget.renderImageBuilder!.call(context, widget.questionData.image)
                    ],
                  )
                else
                  Text(
                    '${widget.index + 1}. ${widget.questionData.question}',
                    style: textStyle,
                  ),
                if (widget.paragraphBuilder != null) widget.paragraphBuilder!.call(context, textStyle),
                Column(
                  children: List.generate(widget.questionData.answers.length,
                      (index) => _buildAnswer(widget.questionData.answers[index].content, isCorrect: widget.questionData.answers[index].isCorrect)),
                )
              ],
            ),
          ),

          // Show explanation
          StatefulBuilder(
              builder: (_, setState) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explanation',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                              ),
                              if (widget.renderTextBuilder != null)
                                widget.renderTextBuilder!.call(context, widget.questionData.explanation, explanationTextStyle)
                              else
                                Text(
                                  widget.questionData.explanation,
                                  style: explanationTextStyle,
                                )
                            ],
                          ),
                        ),
                        secondChild: const SizedBox(),
                        crossFadeState: isShowExplanation ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 200),
                      ),
                      _explanationSection(setState)
                    ],
                  )),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    final selectionStatus = widget.questionData.selectionStatus;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
            radius: 7,
            backgroundColor: selectionStatus == true
                ? widget.correctColor
                : selectionStatus == false
                    ? widget.incorrectColor
                    : const Color(0xFFBFBFBF),
            child: Icon(
              selectionStatus == true
                  ? Icons.check
                  : selectionStatus == false
                      ? Icons.close
                      : Icons.horizontal_rule_rounded,
              size: 12,
              color: Colors.white,
            )),
        const SizedBox(width: 6),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              selectionStatus == true
                  ? 'CORRECT'
                  : selectionStatus == false
                      ? 'INCORRECT'
                      : 'UNANSWERED',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selectionStatus == true
                    ? widget.correctColor
                    : selectionStatus == false
                        ? widget.incorrectColor
                        : const Color(0xFFBFBFBF),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButtons() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ActionButtons(
        bookmarked: isBookmarked,
        liked: isLiked,
        disliked: isDisliked,
        color: widget.mainColorHex,
        onBookmark: widget.onBookmark,
        onLike: widget.onLike,
        onDislike: widget.onDislike,
        isTester: widget.isTester,
        onReportTest: widget.onReportTest,
      ));

  Widget _buildAnswer(String content, {bool? isCorrect}) {
    late IconData icon;
    switch (isCorrect) {
      case null:
        icon = Icons.horizontal_rule_rounded;
        break;
      case true:
        icon = Icons.check;
        break;
      case false:
        icon = Icons.close;
        break;
    }

    Color? iconColor;
    if (isCorrect == true) {
      iconColor = widget.correctColor;
    } else if (isCorrect == false) {
      iconColor = widget.incorrectColor;
    }
    TextStyle textStyle = TextStyle(
      fontSize: 14,
      color: widget.isDarkMode ? Colors.white : Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
              width: 20,
              child: Icon(
                icon,
                color: iconColor,
                size: isCorrect != null ? 20 : 15,
              )),
          const SizedBox(width: 15),
          if (widget.renderTextBuilder != null)
            Expanded(child: widget.renderTextBuilder!.call(context, content, textStyle))
          else
            Text(content, style: textStyle),
        ],
      ),
    );
  }

  Widget _explanationSection(void Function(void Function() action) setState) => GestureDetector(
        onTap: () => _handleToggleExplanation(setState),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.white.withOpacity(0.08) : widget.explanationColor.withOpacity(0.2),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Opacity(
                opacity: widget.isPro ? 1 : 0.7,
                child: Text(
                  'Show Explanation',
                  style: TextStyle(fontSize: 16, color: widget.explanationColor, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Transform.flip(flipY: isShowExplanation, child: const IconWidget(icon: 'assets/static/images/chevron_down.svg')),
              ),

              // Pro icon
              if (!widget.isPro)
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: GetProIcon(darkMode: widget.isDarkMode, proIcon: widget.proIcon),
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
