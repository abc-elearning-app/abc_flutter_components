import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewQuestionBox extends StatefulWidget {
  final int index;
  final QuestionData questionData;
  final void Function(bool isSelected) onBookmarkClick;
  final void Function(bool isSelected) onLikeClick;
  final void Function(bool isSelected) onDislikeClick;

  const ReviewQuestionBox({
    super.key,
    required this.index,
    required this.questionData,
    required this.onBookmarkClick,
    required this.onLikeClick,
    required this.onDislikeClick,
  });

  @override
  State<ReviewQuestionBox> createState() => _ReviewQuestionBoxState();
}

class _ReviewQuestionBoxState extends State<ReviewQuestionBox> {
  final bool isPro = true;

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 3,
                spreadRadius: 2,
                offset: const Offset(0, 2))
          ]),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
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
                              left: 10, right: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explanation',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.questionData.explanation,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600),
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
                      _buildExplanation(setState)
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
            StatefulBuilder(
                builder: (_, setState) => GestureDetector(
                    onTap: () {
                      setState(() => isBookmarked = !isBookmarked);
                      widget.onBookmarkClick(isBookmarked);
                    },
                    child: SvgPicture.asset(
                        'assets/images/${isBookmarked ? 'bookmarked' : 'bookmark'}.svg'))),
            const SizedBox(width: 15),
            StatefulBuilder(
                builder: (_, setState) => GestureDetector(
                    onTap: () {
                      setState(() => isLiked = !isLiked);
                      widget.onLikeClick(isDisliked);
                    },
                    child: SvgPicture.asset(
                        'assets/images/${isLiked ? 'liked' : 'like'}.svg'))),
            const SizedBox(width: 15),
            StatefulBuilder(
                builder: (_, setState) => GestureDetector(
                    onTap: () {
                      setState(() => isDisliked = !isDisliked);
                      widget.onDislikeClick(isDisliked);
                    },
                    child: SvgPicture.asset(
                        'assets/images/${isDisliked ? 'disliked' : 'dislike'}.svg'))),
          ],
        ),
      );

  Widget _buildAnswer(String content, {bool? isCorrect}) {
    String icon = isCorrect == null
        ? 'unselected'
        : isCorrect == true
            ? 'correct'
            : 'incorrect';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/$icon.svg',
            width: 12,
          ),
          const SizedBox(width: 15),
          Text(content, style: const TextStyle(fontSize: 17)),
        ],
      ),
    );
  }

  Widget _buildExplanation(void Function(void Function() action) setState) =>
      GestureDetector(
        onTap: () {
          if (isPro) {
            setState(() => isShowExplanation = !isShowExplanation);
          } else {
            print('Purchasing');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Color(0xFFDEEBFF),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Show Explanation',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF5497FF),
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Transform.flip(
                    flipY: isShowExplanation,
                    child: SvgPicture.asset('assets/images/chevron_down.svg')),
              ),
              if (!isPro)
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    'assets/images/pro_content.svg',
                    height: 25,
                  ),
                ))
            ],
          ),
        ),
      );
}
