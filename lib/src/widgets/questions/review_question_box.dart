import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ReviewQuestionBox extends StatefulWidget {
  final int index;
  final String topicName;
  final QuestionData questionData;
  final bool isPro;
  final bool isDarkMode;

  final Color mainColor;
  final String mainColorHex;
  final Color secondaryColor;
  final String secondaryColorHex;
  final Color explanationColor;

  final Widget Function(BuildContext context, String text, TextStyle textStyle)? renderTextBuilder;

  // Callbacks
  final void Function(bool isSelected) onBookmark;
  final void Function(bool isSelected) onLike;
  final void Function(bool isSelected) onDislike;
  final void Function() onProClick;

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
    required this.topicName,
    required this.mainColor,
    required this.mainColorHex,
    required this.secondaryColor,
    required this.secondaryColorHex,
    this.renderTextBuilder,
    this.explanationColor = const Color(0xFF5497FF),
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
          borderRadius: BorderRadius.circular(15),
          boxShadow: !widget.isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, spreadRadius: 2, offset: const Offset(0, 2))] : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.topicName,
                      overflow: TextOverflow.ellipsis,
                    )),
                    _buildButtons(),
                  ],
                ),

                const SizedBox(height: 5),

                // Question and answers
                if (widget.renderTextBuilder != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.index + 1}. ',
                        style: textStyle,
                      ),
                      Expanded(child: widget.renderTextBuilder!.call(context, widget.questionData.question, textStyle))
                    ],
                  )
                else
                  Text(
                    '${widget.index + 1}. ${widget.questionData.question}',
                    style: textStyle,
                  ),
                Column(
                  children: List.generate(widget.questionData.answers.length,
                      (index) => _buildAnswer(widget.questionData.answers[index].content, isCorrect: widget.questionData.answers[index].isCorrect)),
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
          ActionButtons(
              bookmarked: isBookmarked,
              liked: isLiked,
              disliked: isDisliked,
              color: widget.isDarkMode ? widget.mainColorHex : widget.secondaryColorHex,
              onBookmark: widget.onBookmark,
              onLike: widget.onLike,
              onDislike: widget.onDislike),
        ],
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
      iconColor = Colors.green;
    } else if (isCorrect == false) {
      iconColor = Colors.red;
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
            Text(
              content,
              style: textStyle,
            ),
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
              Text(
                'Show Explanation',
                style: TextStyle(fontSize: 16, color: widget.explanationColor, fontWeight: FontWeight.w500),
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
                  child: GetProIcon(darkMode: widget.isDarkMode),
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
